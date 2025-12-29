-- Selecionar livros que ja foram emprestados mais de 10 vezes
SELECT *
FROM books b
WHERE (
	SELECT count(*)
	FROM loans l
	JOIN book_copies bc ON l.copy_id = bc.copy_id
	WHERE bc.book_id = b.book_id
) > 10;

-- Listar membros que NUNCA fizeram emprestimo
SELECT *
FROM members m
WHERE NOT EXISTS (
	SELECT 1
	FROM loans l
	WHERE l.member_id = m.member_id
);

-- Mostrar copias cuja ultima movimentacao foi ha mais de 60 dias
SELECT *
FROM book_copies bc
WHERE GREATEST(
	COALESCE((SELECT MAX(loan_date) FROM loans WHERE copy_id = bc.book_id), '1900-01-01'),
	COALESCE((SELECT MAX(reservation_date) FROM reservations WHERE copy_id = bc.book_id), '1900-01-01')
) < CURRENT_DATE - INTERVAL '60 days';

-- CTE aninhada: primeiro filtra reservas ativas, depois conta por membro
WITH active_res AS (
	SELECT member_id
	FROM reservations 
	WHERE status = 'active'
),
res_counts AS (
	SELECT member_id, count(*) AS cnt
	FROM active_res
	GROUP BY  member_id
)
SELECT m.full_name, rc.cnt
FROM res_counts rc
JOIN  members m ON m.member_id = rc.member_id
ORDER BY rc.cnt DESC;

-- UNION, INTERSECT e EXCEPT
-- UNION: todos os membros que tem emprestimos ou reservas
SELECT member_id, full_name, 'loan' AS activity
FROM members WHERE member_id IN (SELECT DISTINCT member_id FROM loans)
UNION
SELECT member_id, full_name, 'reservation' AS activity
FROM members WHERE member_id IN (SELECT DISTINCT member_id FROM reservations);

-- INTERSECT: membros que fizeram emprestimos E tambem reserva
SELECT member_id
FROM loans
INTERSECT
SELECT member_id
FROM reservations;

-- EXCEPT: membros que reservaram MAS nao emprestaram
SELECT member_id
FROM reservations
EXCEPT
SELECT member_id
FROM loans;

-- WINDOW FUNCTIONS (ROW NUMBER, RANK)
-- Numeracao dos emprestimos por membro (ordem cronologica)
SELECT
	l.loan_id,
	l.member_id,
	l.loan_date,
	row_number() OVER (PARTITION BY l.member_id ORDER BY l.loan_date) rn
FROM loans l;

-- Ranking de livros por total de emprestimos
SELECT
	b.book_id,
	b.title,
	count(*) AS total_loans,
	rank() OVER (ORDER BY count(*) DESC) AS loan_rank
FROM loans l
JOIN book_copies bc ON l.copy_id = bc.copy_id
JOIN books b ON bc.book_id = b.book_id
GROUP BY b.book_id, b.title;

-- LAG e LEAD: analisando dados sequenciais
-- Para cada emprestimo, mostrar data do emprestimo anterior do mesmo membro
SELECT
	loan_id,
	member_id,
	loan_date,
	LAG(loan_date) OVER (PARTITION BY member_id ORDER BY loan_date) AS prev_loan_date
FROM loans;

-- Para cada livro emprestado, mostrar qual sera a proxima data de devolucao prevista
SELECT
	l.loan_id,
	bc.book_id,
	l.loan_date,
	l.due_date,
	LEAD(due_date) OVER (PARTITION BY bc.book_id ORDER BY l.loan_date) AS next_due_date
FROM loans l
JOIN book_copies bc ON l.copy_id = bc.copy_id;