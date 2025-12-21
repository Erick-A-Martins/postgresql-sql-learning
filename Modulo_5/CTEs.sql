-- Uso de CTEs - Common Table Expressions
WITH pedidos_por_cliente AS (
	SELECT 
		customer_id,
		COUNT(*) AS total_pedidos,
		SUM(total_amount) AS valor_total
	FROM orders
	GROUP BY customer_id
)
SELECT
	c.first_name,
	c.last_name,
	p.total_pedidos,
	ROUND(p.valor_total / p.total_pedidos, 2) AS ticket_medio
FROM pedidos_por_cliente p
JOIN customers c
	ON c.customer_id = p.customer_id
ORDER BY ticket_medio DESC;

-- CTE não recursiva
WITH vendas_por_cidade AS (
	SELECT
		c.city,
		SUM(o.total_amount) AS total_vendas
	FROM customers c
	JOIN orders o
		ON c.customer_id = o.customer_id
	GROUP BY c.city
)
SELECT *
FROM vendas_por_cidade
WHERE total_vendas > 500
ORDER BY total_vendas DESC;

WITH vendas_produto AS (
	SELECT
		p.product_name,
		SUM(oi.quantity) AS total_vendido
	FROM products p 
	JOIN order_items oi
		ON p.product_id = oi.product_id
	GROUP BY p.product_name
)
SELECT *
FROM vendas_produto
ORDER BY total_vendido DESC
LIMIT 10;

-- CTE recursiva
WITH RECURSIVE numeros AS (
	SELECT 1 AS n
	UNION ALL
	SELECT n + 1
	FROM numeros
	WHERE n < 10
)
SELECT * FROM numeros;