-- Empréstimos atrasados: sem data de devolucao e data de vencimento passada
SELECT * FROM loans
WHERE return_date IS NULL
	AND due_date < CURRENT_DATE;

-- Livros de generos especificos
SELECT
	b.title,
	g.name AS genre
FROM books b
JOIN genres g USING(genre_id)
WHERE b.genre_id IN (3, 4, 5);

-- Reservas em junho de 2025 ou ainda ativas
SELECT * FROM reservations r
WHERE r.reservation_date BETWEEN '2025-06-01' AND '2025-06-30'
	OR status = 'active';

-- Membros cujo nome contenha 'Ana' ou email termine com '@uni.edu', mas que tenha telefone cadastrado
SELECT *
FROM members
WHERE (full_name ILIKE '%aNa%' OR email LIKE '%@uni.edu') -- ILIKE não diferencia UPPER de LOWER case, LIKE diferencia
	AND phone IS NOT NULL;

-- Livros que não sao de fiction e foram publicados entre 1990 e 2000
SELECT *
FROM books
WHERE genre_id <> 1 -- Diferente de (<>)
	AND pub_year BETWEEN 1990 AND 2000;

-- Autores cujo sobrenome começa com 'Pe' (case-insensitive) e com data de nascimento conhecida
SELECT *
FROM authors a
WHERE a.last_name ILIKE 'Pe%'
	AND a.birth_date IS NOT NULL;

-- Membros com assinatura ativa ou sem data de termino definida
SELECT *
FROM members m
WHERE m.membership_end > CURRENT_DATE
	OR m.membership_end IS NULL;

-- Copias que estao em determinadas filiais e que nao estao disponiveis
SELECT *
FROM book_copies
WHERE branch_id IN (1, 3)
	AND status <> 'available';

-- Emprestimos sem devolucao que venceram ha mais de 7 dias
SELECT *
FROM loans
WHERE return_date IS NULL
	AND due_date < CURRENT_DATE - INTERVAL '7 days';

-- Livros cujo titulo contem 'Data' ou 'Science' (qualquer captalizacao)
SELECT *
FROM books
WHERE title ILIKE '%data%'
	OR title ILIKE '%science%';

-- Reservas cujo status nao esta em 'fulfilled' ou 'cancelled' - usando NOT IN
SELECT *
FROM reservations r 
WHERE status NOT IN ('fulfilled', 'cancelled');

-- Livros que possuem ao menos 1 copia perdida - usando EXISTS
SELECT
	b.*
FROM books b
WHERE EXISTS (
	SELECT 1
	FROM book_copies bc
	WHERE bc.book_id = b.book_id
		AND bc.status = 'lost'
);

-- Membros que ja pegaram emprestado TODOS os livros de um autor especifico
SELECT m.*
FROM members m
WHERE NOT EXISTS (
	SELECT 1
	FROM books b
	WHERE b.author_id = 5
		AND NOT EXISTS (
			SELECT 1
			FROM loans l
			JOIN book_copies bc
				ON bc.copy_id  = l.copy_id
			WHERE bc.book_id  = b.book_id
				AND l.member_id = m.member_id
		)
);

-- Bibliotecarios alocados em qualquer uma das filiais 2, 3 ou 4 - usando ANY
SELECT *
FROM librarians l 
WHERE l.branch_id = ANY(ARRAY[2, 3, 4]);

-- Livros cujo ISBN começa com '7917' e publicados depois de 2010
SELECT *
FROM books b
WHERE b.isbn LIKE '7917%'
	AND b.pub_year > 2010;

-- Publicadoras cujo endereco contenha 'Av.' mas que NAO tenham sido deletadas logicamente
SELECT *
FROM publishers p
WHERE p.address LIKE '%Av.%'
	AND (p.is_active IS TRUE OR is_active IS null);

-- Emprestimos feitos em fins de semana
SELECT *
FROM loans
WHERE EXTRACT(DOW FROM loan_date) IN (0, 6); -- Sabado ou Domingo

-- Reservas feitas no ultimos mes, mas apenas de membros cujo email termina em '.edu'
SELECT r.*
FROM reservations r 
JOIN members m USING (member_id)
WHERE r.reservation_date >= (CURRENT_DATE - INTERVAL '1 month')
	AND m.email LIKE '%.edu';

-- Livros cujo titulo NAO contenha espaços - usando NOT LIKE
SELECT *
FROM books b
WHERE b.title NOT LIKE '% %';