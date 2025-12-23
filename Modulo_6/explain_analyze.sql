-- Apenas mostra o plano estimado (sem executar)
EXPLAIN
SELECT * FROM products
WHERE price > 300;

-- Executa a consulta e exibe tempo real + plano
EXPLAIN ANALYZE
SELECT * FROM products
WHERE price > 300;

-- Index Scan
CREATE INDEX idx_price ON products(price);

EXPLAIN ANALYZE
SELECT  * FROM products WHERE price > 300;

SET enable_seqscan = OFF;

EXPLAIN ANALYZE
SELECT * FROM products WHERE price > 300;

-- Reativar Depois
SET enable_seqscan = ON;

-- Com join
EXPLAIN ANALYZE
SELECT
	o.order_id,
	c.first_name,
	c.last_name
FROM orders o
JOIN customers c
	ON o.customer_id = c.customer_id
WHERE o.status = 'SHIPPED';