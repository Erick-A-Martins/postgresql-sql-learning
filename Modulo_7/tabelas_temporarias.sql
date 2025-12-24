-- Cria tabela temporária de vendas do mes de junho/2024
CREATE TEMPORARY TABLE tmp_pedidos_junho AS
SELECT * FROM orders
WHERE order_date BETWEEN '2024-06-01' AND '2024-06-30';

-- Cálculos agregados com base na tabela temporária
SELECT 
	count(*) AS qtd_pedidos,
	sum(total_amount) AS soma_total,
	avg(total_amount) AS media_valor
FROM tmp_pedidos_junho;

--
CREATE TEMPORARY TABLE tmp_clientes_ativos AS
SELECT DISTINCT
	c.customer_id,
	c.first_name || ' ' || c.last_name AS nome_completo
FROM customers c
JOIN orders o
	ON c.customer_id = o.customer_id
WHERE o.order_date BETWEEN '2024-04-01' AND '2024-06-30';

SELECT
	t.nome_completo,
	count(o.order_id) AS total_pedidos
FROM tmp_clientes_ativos t
JOIN orders o
	ON t.customer_id = o.customer_id
GROUP BY t.nome_completo
ORDER BY total_pedidos DESC;

--
CREATE TEMPORARY TABLE tmp_vendas_2024 AS
SELECT * FROM orders
WHERE order_date >= '2024-01-01';

CREATE VIEW vw_summary_2024 AS
SELECT
	date_trunc('quarter', order_date) AS trimestre,
	count(*) AS qtd_pedidos,
	sum(total_amount) AS total_vendas
FROM tmp_vendas_2024
GROUP BY 1;

SELECT * FROM vw_summary_2024
ORDER BY trimestre;