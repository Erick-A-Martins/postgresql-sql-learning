-- Criação de índice com padrão B-TREE
CREATE INDEX idx_products_price
	ON products(price);

EXPLAIN ANALYZE
SELECT * FROM products
WHERE price BETWEEN 100 AND 500;

-- Suporta apenas =, não BETWEEN
CREATE INDEX idx_products_price_hash
 ON products USING HASH(price);

EXPLAIN ANALYZE
SELECT * FROM products
WHERE price = 38.1;

-- Busca produtos com tag 'promo'
ALTER TABLE products
	ADD COLUMN tags TEXT[];
UPDATE products
	SET tags = ARRAY['promo', 'novo']
	WHERE product_id % 5 = 0;

CREATE INDEX idx_products_tags_gin
	ON products USING GIN(tags);

EXPLAIN ANALYZE
SELECT * FROM products
WHERE tags @> ARRAY['promo']

-- UNIQUE INDEX
CREATE UNIQUE INDEX idx_department_name_unq
	ON departments(department_name);

-- Índice parcial
CREATE INDEX idx_orders_pending
	ON orders(order_date)
	WHERE status = 'PENDING';

-- Busca case-insensitive em email
CREATE INDEX idx_customers_lower_email
	ON customers (LOWER(email));

-- Índices concorrentes
CREATE INDEX CONCURRENTLY index_name
	ON table_name USING GIN(column);

-- Índices com mais de uma coluna
CREATE INDEX index_name
	ON table_name(column1, column2);

CREATE INDEX idx_product_name_price
	ON products (product_name, price);

SELECT COUNT(*) FROM products
WHERE product_name LIKE '%P%' AND price > 100;

-- Reindexação
REINDEX INDEX idx_products_price;

-- Atualiza estatisticas, limpa espaços mortos nos indexes
-- Analisa e atualiza as estatisticas dos índices usados na tabela
VACUUM (ANALYZE) products;