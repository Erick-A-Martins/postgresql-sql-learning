-- Uso de Window Function
SELECT
	o.customer_id,
	CONCAT(c.first_name, ' ', c.last_name),
	o.order_id,
	o.order_date,
	o.total_amount,
	SUM(o.total_amount) OVER ( -- SUM como função de janela, outros exemplos como (ROUND, AVG...)
		PARTITION BY o.customer_id
		ORDER BY o.order_date
	) AS total_acumulado
FROM orders o
JOIN customers c
	ON c.customer_id = o.customer_id
ORDER BY o.customer_id, o.order_date;

SELECT
	o.customer_id,
	CONCAT(c.first_name, ' ', c.last_name),
	o.order_id,
	o.total_amount,
	ROUND (
		100.0 * o.total_amount / SUM(o.total_amount) OVER (PARTITION BY o.customer_id),
		2
	) AS percentual_sobre_total
FROM orders o
JOIN customers c
	ON c.customer_id = o.customer_id
ORDER BY o.customer_id, o.order_date;


-- Uso de ROW_NUMBER()
SELECT
	customer_id,
	order_id,
	order_date,
	total_amount,
	ROW_NUMBER() OVER(
		PARTITION BY customer_id
		ORDER BY total_amount DESC
	) AS row_num 
FROM orders

-- Uso de RANK() - Se duas linhas estão empatadas a próxima será a 3
SELECT
	customer_id,
	order_id,
	order_date,
	total_amount,
	RANK() OVER(
		PARTITION BY customer_id
		ORDER BY total_amount DESC
	) AS rank
FROM orders;

-- Uso de DENSE_RANK() - Se duas linhas estão empatadas a próxima será a 2
SELECT
	customer_id,
	order_id,
	total_amount,
	DENSE_RANK() OVER(
		PARTITION BY customer_id
		ORDER BY total_amount DESC
	) AS posicao
FROM orders;

-- Funções de Deslocamento
-- Uso de LAG
WITH vendas_mensais AS (
	SELECT
		DATE_TRUNC('month', order_date) AS mes,
		SUM(total_amount) AS total_vendas
	FROM orders
	GROUP BY mes
)

SELECT
	mes,
	total_vendas,
	LAG(total_vendas) OVER(ORDER BY mes) AS vendas_anterior,
	total_vendas - LAG(total_vendas) OVER(ORDER BY mes) AS diferenca
FROM vendas_mensais
ORDER BY mes;

-- Uso de LEAD
WITH vendas_mensais AS (
	SELECT
		DATE_TRUNC('month', order_date) AS mes,
		SUM(total_amount) AS total_vendas
	FROM orders
	GROUP BY mes
)

SELECT
	mes,
	total_vendas,
	LEAD(total_vendas) OVER(ORDER BY mes) AS vendas_proximo_mes
FROM vendas_mensais
ORDER BY mes;
