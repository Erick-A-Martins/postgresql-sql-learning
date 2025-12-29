-- Total de emprestimos por livro
SELECT b.title,
		COUNT(*) AS total_loans
FROM loans l
JOIN book_copies bc USING (copy_id)
JOIN books b USING (book_id)
GROUP BY b.title
ORDER BY total_loans;

-- Data mais antiga e mais recente de emprestimo
SELECT
	MIN(loan_date) AS first_loan,
	MAX(loan_date) AS last_loan
FROM loans;

-- Duracao media de um emprestimo (em dias)
SELECT 
	AVG((due_date - loan_date)) AS avg_loan_duration_days
FROM loans
WHERE return_date IS NOT NULL;

-- Soma total de reservas 'active'
SELECT SUM(
		CASE WHEN status = 'active' THEN 1 ELSE 0 END
		) AS total_active_reservations
FROM reservations;

-- Top 5 livros mais emprestados
SELECT b.title,
		COUNT(*) AS time_loaned
FROM loans l
JOIN book_copies bc USING (copy_id)
JOIN books b USING (book_id)
GROUP BY b.title
ORDER BY time_loaned DESC
LIMIT 5;

-- Numero de reservas por membro, em ordem decrescente
SELECT m.full_name,
		COUNT(r.*) AS reservations_count
FROM members m
LEFT JOIN reservations r USING(member_id)
GROUP BY m.full_name
ORDER BY reservations_count DESC;

-- Filiais com mais copias disponiveis
SELECT lb.name, COUNT(*) AS available_copies
FROM book_copies bc
JOIN library_branches lb USING(branch_id)
WHERE bc.status = 'available'
GROUP BY lb.name
ORDER BY available_copies DESC;