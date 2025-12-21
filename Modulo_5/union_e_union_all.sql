-- Uso de UNION
-- Clientes que já compraram OU que ainda não compraram (sem duplicar)
SELECT customer_id, first_name, last_name
FROM customers
WHERE customer_id IN (SELECT customer_id FROM orders)

UNION 

SELECT customer_id, first_name, last_name
FROM customers
WHERE customer_id NOT IN (SELECT customer_id FROM orders);

-- Clientes com pedidos
SELECT customer_id, first_name, last_name
FROM customers
WHERE customer_id IN (
	SELECT DISTINCT customer_id FROM orders
)

UNION

-- Clientes que ainda não compraram 
SELECT customer_id, first_name, last_name
FROM customers
WHERE customer_id NOT IN (
	SELECT customer_id FROM orders
);

-- Uso de UNION ALL
-- Produtos vendidos + não vendidos (com repetição permitida)
SELECT product_id, product_name
FROM products
WHERE product_id IN (SELECT product_id FROM order_items)

UNION ALL

SELECT product_id, product_name
FROM products
WHERE product_id NOT IN (SELECT product_id FROM order_items);


WITH uniao_teste AS (
	SELECT 'SP' AS origem, email FROM customers WHERE city = 'Sao Paulo'
	UNION ALL
	SELECT 'RJ' AS origem, email FROM customers WHERE city = 'Rio de Janeiro'
)
SELECT email, COUNT(*) AS ocorrencias
FROM uniao_teste
GROUP BY email
HAVING COUNT(*) > 1;