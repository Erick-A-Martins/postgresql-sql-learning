-- Má pratica com LEFT JOIN
SELECT *
  FROM products AS p
  LEFT JOIN order_items AS oi
    ON p.product_id = oi.product_id
  WHERE oi.quantity > 0;

-- Opcao 1
SELECT *
  FROM products AS p
  LEFT JOIN order_items AS oi
    ON p.product_id = oi.product_id
  AND oi.quantity > 0;

-- Opcao 2
SELECT * 
FROM (
  SELECT
    p.product_id,
    p.product_name,
    oi.order_id,
    oi.quantity
  FROM products AS p
  LEFT JOIN order_items AS oi
    ON p.product_id = oi.product_id
) AS subq
WHERE subq.quantity > 0 OR subq.quantity IS NULL;

-- SUBCONSULTA NÃO CORRELACIONADA
SELECT product_id, product_name
  FROM products
  WHERE price > (
    SELECT AVG(price) FROM products  
  );

-- SUBCONSULTA CORRELACIONADA
SELECT
  c.customer_id,
  c.first_name,
  c.last_name,
  (SELECT COUNT(*)
    FROM orders o
    WHERE o.customer_id = c.customer_id
  ) AS total_pedidos
FROM customers AS c;

-- Exemplo 1
SELECT
  c.customer_id,
  c.first_name,
  (SELECT COUNT(*) FROM orders o WHERE o.customer_id = c.customer_id) AS total_pedidos
FROM customers AS c;

-- Reescrita com JOIN + GROUP BY
SELECT
  c.customer_id,
  c.first_name,
  COUNT(o.order_id) AS total_pedidos
FROM customers AS c
LEFT JOIN orders AS o
  ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name