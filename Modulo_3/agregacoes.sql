-- Uso de COUNT
SELECT COUNT(*) AS total_pedidos -- Astericos traz a contagem de todas as tuplas mesmo que com registros null
  FROM orders;

SELECT COUNT(orders.total_amount) AS total_amount_nao_nulos -- Count por coluna traz apenas os nao null
  FROM orders;

SELECT COUNT(price) AS produtos_com_preco
  FROM products.

-- Uso de DISTINCT
SELECT DISTINCT customers.last_name
  FROM customers;

SELECT COUNT(DISTINCT o.customer_id) AS clientes_unicos
  FROM orders o;

-- Uso de SUM
SELECT SUM(total_amount) AS faturamnento_geral
  FROM orders;

-- Uso de AVG - average(média)
SELECT AVG(total_amount) AS media_pedidos
  FROM orders;

SELECT COUNT (total_amount), SUM(total_amount), AVG(total_amount) AS media_pedidos
  FROM orders;

-- Uso de MAX e MIN
SELECT MAX(price) AS preco_maximo,
       MIN(price) AS preco_minimo
  FROM products;

SELECT MIN(created_at) AS primeiro_cadastro
  FROM customers;

SELECT MAX(created_at) AS ultimo_cadastro
  FROM customers;

-- Uso de ORDER BY
SELECT product_id, product_name, price
  FROM products
ORDER BY price ASC;

SELECT product_id, product_name, price
  FROM products
ORDER BY price DESC;

SELECT * 
  FROM customers
ORDER BY first_name; -- Padrão por ordem alfabetica ou ASC

SELECT * 
  FROM customers
ORDER BY first_name DESC;

SELECT order_id, status, order_date
  FROM orders
ORDER BY status ASC, order_date ASC; -- Primeiro ordena por status depois por data

-- Uso de GROUP BY
-- Coluna associada precisa estar no select para fazer sentido
SELECT product_id, COUNT(*) AS total_vendas
  FROM order_items
GROUP BY product_id; -- agrupa com base na quantidade do count por id de produto

SELECT product_id,
       SUM(quantity) AS total_quantidade
  FROM order_items
GROUP BY product_id;

SELECT status,
       COUNT(*) AS qtd_pedidos
  FROM orders
GROUP BY status;

SELECT city,
       COUNT(*) AS total_clientes
 FROM customers
GROUP BY city;

-- Uso do HAVING
SELECT category_id,
      COUNT(*) AS qtd_produtos
  FROM products
  GROUP BY category_id
HAVING COUNT(*) > 5;
