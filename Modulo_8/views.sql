-- View de livros disponiveis por filial
CREATE VIEW available_copies_per_branchs AS
SELECT
	lb.name AS branch,
	b.title,
	count(*) AS available_count
FROM book_copies bc
JOIN books b using(book_id)
JOIN library_branches lb using(branch_id)
WHERE bc.status = 'available'
GROUP BY lb.name, b.title;

-- Uso da view
SELECT * FROM available_copies_per_branchs
WHERE available_count > 1
ORDER BY branch, available_count DESC;

-- Tabela temporaria para estatisticas de emprestimo do dia
CREATE TEMP TABLE today_loan_stats AS
SELECT
	COUNT(*) AS total_loans,
	COUNT(DISTINCT member_id) AS distinct_members,
	MIN(loan_date) AS first_loan,
	MAX(loan_date) AS last_loan
FROM loans
WHERE loan_date::date = CURRENT_DATE;

-- Uso da temp table
SELECT * FROM today_loan_stats;