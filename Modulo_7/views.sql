-- View que lista os produtos com categoria e preço acima de 200 reais.
-- VIEW SIMPLES
CREATE VIEW vw_produtos_caros AS
SELECT
	p.product_id,
	p.product_name,
	c.category_name,
	p.price
FROM products p
JOIN categories c
	ON p.category_id = c.category_id
WHERE p.price > 200;

SELECT * FROM vw_produtos_caros
ORDER BY price DESC
LIMIT 10;

-- Só funciona se view for simples e não envolver agregações
UPDATE vw_produtos_caros
SET price = price * 0.9
WHERE category_name = 'Categoria 3';

DROP VIEW IF EXISTS vw_produtos_caros;

--
CREATE VIEW vw_pedidos_grandes AS
SELECT
	o.order_id,
	o.total_amount,
	c.first_name || ' ' || c.last_name AS nome_cliente,
	c.city
FROM orders o
JOIN customers c
	ON o.customer_id = c.customer_id
WHERE o.total_amount > 500;

SELECT * FROM vw_pedidos_grandes
ORDER BY total_amount DESC;

--
CREATE VIEW vw_resumo_vendas_mensal AS
SELECT
	date_trunc('month', o.order_date) AS mes,
	count(o.order_id) AS total_pedidos,
	sum(o.total_amount) AS valor_total
FROM orders o
GROUP BY 1;

-- Consultar dados de julho de 2024
SELECT * FROM vw_resumo_vendas_mensal
WHERE mes = '2024-07-01';

--
CREATE VIEW vw_itens_pedido_detalhado AS
SELECT
	o.order_id,
	p.product_name,
	oi.quantity,
	oi.unit_price,
	(oi.quantity * oi.unit_price) AS subtotal,
	o.order_date
FROM order_items oi
JOIN orders o
	ON oi.order_id = o.order_id
JOIN products p
	ON oi.product_id = p.product_id;

-- Mostrar todas as views
SELECT viewname FROM pg_views WHERE schemaname = 'public';

-- MATERIALIZED VIEW - salvas em disco, suportam indices
CREATE MATERIALIZED VIEW mv_resumo_vendas_mensal AS
SELECT 
	date_trunc('month', o.order_date) AS mes,
	count(o.order_id) AS total_pedidos,
	sum(o.total_amount) AS valor_total
FROM orders o
GROUP BY 1;

SELECT * FROM mv_resumo_vendas_mensal WHERE mes = '2024-05-01';

-- Atualiza a materialized view
REFRESH MATERIALIZED VIEW mv_resumo_vendas_mensal;

CREATE INDEX idx_mv_vendas_mes ON mv_resumo_vendas_mensal(mes);

-- Materialized view com clientes do ano de 2024 que tiveram compras acima de 500 reais
CREATE MATERIALIZED VIEW mv_top_clientes_2024 AS
SELECT
	c.customer_id,
	concat(c.first_name, ' ', c.last_name) AS nome_completo,
	sum(o.total_amount) AS total_gasto
FROM customers c
JOIN orders o
	ON c.customer_id = o.customer_id
WHERE o.order_date BETWEEN '2024-01-01' AND '2024-12-31'
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING sum(o.total_amount) > 500;