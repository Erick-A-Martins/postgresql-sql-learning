-- Uso de INNER JOIN
SELECT
  p.product_id,
  p.product_name,
  c.category_id,
  c.category_name
FROM products AS p
INNER JOIN categories AS c
  ON p.category_id = c.category_id
ORDER BY p.product_id

SELECT
  p.product_id AS pid,
  p.product_name AS nome_produto,
  c.category_id,
  c.category_name
FROM products AS p
INNER JOIN categories AS c
  ON p.category_id = c.category_id
WHERE p.price > 100
ORDER BY pid;

-- Junção com mais de uma coluna
SELECT ...
  FROM tabela_a AS a
  INNER JOIN tabela_b AS b
    ON a.id = b.id
    AND a.data = b.data;

SELECT
  o.order_id,
  o.customer_id,
  c.first_name || ' ' || c.last_name AS cliente,
  o.order_date,
  o.status,
  o.total_amount
FROM orders AS o
INNER JOIN customers AS c
  ON o.customer_id = c.customer_id
  AND o.order_date >= c.created_at
ORDER BY o.order_date ASC
LIMIT 20;

-- INNER JOIN aninhados
SELECT
  o.order_id,
  o.order_date,
  c.first_name || ' ' || c.last_name AS cliente,
  p.product_name,
  oi.quantity,
  oi.unit_price,
  (oi.quantity * oi.unit_price) AS subtotal
FROM orders AS o
INNER JOIN customers AS c
  ON o.customer_id = c.customer_id
INNER JOIN order_items AS oi
  ON o.order_id = oi.order_id
INNER JOIN products AS p
  ON oi.product_id = p.product_id
WHERE o.status = 'DELIVERED';

-- CONCAT e TO_CHAR
SELECT
  CONCAT(c.first_name, ' ', c.last_name) AS nome_completo,
  TO_CHAR(o.order_date, 'DD/MM/YYYY') AS data_formatada
FROM customers AS c
INNER JOIN orders AS o
  ON c.customer_id = o.customer_id;

-- Listar nome completo de cada cliente e quantos pedidos ele fez (sem duplicar linhas do cliente)
SELECT
  c.customer_id,
  CONCAT(c.first_name, ' ', c.last_name) AS cliente,
  COUNT(o.order_id) AS total_pedidos
FROM public.customers AS c
INNER JOIN public.orders AS o
  ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_pedidos DESC;

-- Listar todas as cidades distintas de clientes que já fizeram pedidos.
SELECT DISTINCT c.city
FROM customers AS c
INNER JOIN orders AS o
  ON c.customer_id = o.customer_id
ORDER BY c.city;

-- Mostrar dados de pedido com nome completo do cliente e data formatada
SELECT
  o.order_id,
  CONCAT(c.first_name, ' ', c.last_name) AS clientes,
  TO_CHAR(o.order_date, 'DD-Mon-YYYY') AS data_legivel
FROM orders AS o
INNER JOIN customers AS c
  ON o.customer_id = c.customer_id
ORDER BY o.order_id ASC;