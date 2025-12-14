SELECT * FROM customers WHERE first_name = 'Pedro'
SELECT * FROM customers WHERE email = 'ana.oliveira4@exemplo.com'
SELECT * FROM customers WHERE city = 'Porto Alegre'

SELECT product_id, product_name, price
  FROM products
WHERE price > 100;

SELECT customer_id, first_name || ' ' || last_name AS full_name, city -- || concatenação
  FROM customers
WHERE city = 'Porto Alegre';

SELECT product_id, product_name, category_id
  FROM products
WHERE category_id = 3;

SELECT order_id, status
  FROM orders
WHERE status <> 'DELIVERED'; -- diferente de (<>) 'DELIVERED'

SELECT customer_id, created_at
  FROM customers
WHERE created_at < '2024-06-01'; -- data de cadastro antes de junho/2024

SELECT product_id, price
  FROM products
WHERE price <= 25.50; -- preço menor ou igual a 25.50

SELECT * FROM customers;

INSERT INTO customers(customer_id, first_name, last_name, email, city, created_at)
VALUES (201, 'Erick', NULL, 'erick@mail.com', 'Brasília', '2025-12-14')

SELECT * FROM customers WHERE last_name IS NULL; -- condições de null
SELECT * FROM customers WHERE last_name IS NOT NULL; -- condições de não null

-- Uso de OR e AND
SELECT customer_id, first_name, last_name, city
  FROM customers
WHERE city = 'Brasilia'
  AND created_at >= '2024-01-01'; -- Uso AND em conjunto com WHERE, ambas precisam ser true

SELECT product_id, product_name, price
  FROM products
WHERE price < 50
  OR price > 400; -- Uso de OR com WHERE, apenas uma precisa ser true

SELECT order_id, total_amount, status
  FROM orders
WHERE (status = 'DELIVERED' OR status = 'SHIPPED')
  AND total_amount > 600;

-- Uso do IN
SELECT order_id, status
  FROM orders
WHERE status IN ('PENDING', 'SHIPPED'); -- Mesma ideia de vários ORs em conjunto

SELECT product_id, category_id
  FROM products
WHERE category_id IN (1, 3 , 5); -- Categorias 1, 3 e 5

SELECT product_id, product_name, category_id
  FROM products
WHERE category_id NOT IN (4, 5, 6, 7, 999);

SELECT product_id, product_name
  FROM products
WHERE category_id IS NOT NULL
  AND category_id NOT IN (1, 2, 3);

-- Uso do BETWEEN
SELECT product_id, price
  FROM products
WHERE price BETWEEN 200 AND 300;

SELECT order_id, order_date
  FROM orders
WHERE order_date BETWEEN '2024-05-01' AND '2024-05-31'; -- Pedidos em maio/2024

-- Uso de LIKE
SELECT customer_id, first_name
  FROM customers
WHERE first_name LIKE 'Eri%'; -- Todos os nomes que começam com 'Ju' e terminam com qualquer coisa (%)

SELECT customer_id, first_name, last_name
  FROM customers
WHERE last_name LIKE '%ia%';

SELECT product_id, product_name
  FROM products
WHERE product_name LIKE '_roduto 1%'; -- '_' representa qualquer caractere
