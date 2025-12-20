-- LEFT JOIN - todos os registros da tabela da esquerda e da intersecção
SELECT
  p.product_id,
  p.product_name,
  oi.order_id
FROM products AS p
LEFT JOIN order_items oi
  ON p.product_id = oi.product_id
ORDER BY p.product_id;

SELECT
  p.product_id,
  p.product_name,
  oi.order_id,
  COUNT(oi.order_item_id) AS total_vendas
FROM products AS p
LEFT JOIN order_items oi
  ON p.product_id = oi.product_id
GROUP BY p.product_id, p.product_name, oi.order_id
ORDER BY total_vendas DESC;

SELECT
  p.product_id,
  p.product_name,
  oi.order_id
FROM products AS p
LEFT JOIN order_items AS oi
  ON p.product_id = oi.product_id
WHERE oi.order_item_id IS NULL
ORDER BY p.product_name;

-- RIGHT JOIN - todos os registros da tabela da direita e da intersecção
SELECT
  c.customer_id,
  c.first_name,
  c.last_name,
  o.order_id
FROM orders AS o
RIGHT JOIN customers AS c
  ON o.customer_id = c.customer_id;

-- FULL JOIN - Lista todos  os registros da tabela da esquerda, direita e intersecção
SELECT
  p.product_id,
  p.product_name,
  c.category_id,
  c.category_name
FROM products AS p
FULL JOIN categories AS c
  ON p.category_id = c.category_id
ORDER BY c.category_id, p.product_id;

SELECT
  o.order_id,
  o.customer_id AS pedido_customer_id,
  o.order_date,
  o.status,
  c.customer_id AS cliente_customer_id,
  c.first_name || ' ' || c.last_name AS cliente,
  c.city
FROM orders AS o
FULL JOIN customers AS c
  ON o.customer_id = c.customer_id
ORDER BY o.order_date DESC;
ORDER BY

-- Uso de COALESCE
SELECT
  COALESCE(c.first_name, 'SEM NOME') AS primeiro_nome,
  COALESCE(c.last_name, 'DESCONHECIDO') AS sobrenome
FROM customers AS c;

SELECT
  c.customer_id,
  COALESCE(c.first_name, 'SEM NOME') AS primeiro_nome,
  COALESCE(c.last_name, 'DECONHECIDO') AS sobrenome,
  COALESCE(o.total_amount, 0) AS total_ultimo_pedido
FROM customers AS c
LEFT JOIN (
  SELECT 
    customer_id,
    SUM(total_amount) AS total_amount
  FROM orders
  WHERE order_date >= '2024-01-01'
  GROUP BY customer_id
) AS o
  ON c.customer_id = o.customer_id;