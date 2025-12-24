-- Particionamento por RANGE
CREATE TABLE orders_part (
	order_id INT NOT NULL,
	customer_id INT, 
	order_date DATE NOT NULL,
	status VARCHAR(20),
	total_amount NUMERIC(12, 2),
	PRIMARY KEY (order_date, order_id) -- Chave primária composta
) PARTITION BY RANGE (order_date);

CREATE TABLE orders_2024_01 PARTITION OF orders_part
 	FOR VALUES FROM ('2024-01-01') TO ('2024-02-01');
 
CREATE TABLE orders_2024_02 PARTITION OF orders_part
	FOR VALUES FROM ('2024-02-01') TO ('2024-03-01');
 
INSERT INTO orders_part (order_id, customer_id, order_date, status, total_amount)
VALUES (351, 124, '2024-01-15', 'SHIPPED', 450.00);
 
-- Acessa a partição de Janeiro e não a tabela inteira
SELECT * FROM orders_part
WHERE order_date BETWEEN '2024-01-01' AND '2024-01-31'; 
 
-- Acessa a partição de Fevereiro e não a tabela inteira
SELECT * FROM orders_part
WHERE order_date BETWEEN '2024-02-01' AND '2024-02-28';

-- LIST
CREATE TABLE orders_part (
	order_id INT GENERATED ALWAYS AS IDENTITY,
	customer_id INT,
	status VARCHAR(20),
	order_date DATE,
	total_amount NUMERIC(12, 2)
) PARTITION BY LIST (status);

CREATE TABLE orders_shipped PARTITION OF orders_part
 	FOR VALUES IN ('SHIPPED');
 
CREATE TABLE orders_delivered PARTITION OF orders_part
	FOR VALUES IN ('DELIVERED');

INSERT INTO orders_part (customer_id, order_date, status, total_amount)
VALUES (124, '2024-01-15', 'SHIPPED', 450.00);

SELECT * FROM orders_part
WHERE status = 'SHIPPED'; 

-- HASH
CREATE TABLE customers_part (
	customer_id INT PRIMARY KEY,
	name TEXT
) PARTITION BY HASH (customer_id);

CREATE TABLE customers_part_0 PARTITION OF customers_part FOR VALUES WITH (MODULUS 4, REMAINDER 0);
CREATE TABLE customers_part_1 PARTITION OF customers_part FOR VALUES WITH (MODULUS 4, REMAINDER 1);
CREATE TABLE customers_part_2 PARTITION OF customers_part FOR VALUES WITH (MODULUS 4, REMAINDER 2);
CREATE TABLE customers_part_3 PARTITION OF customers_part FOR VALUES WITH (MODULUS 4, REMAINDER 3);

INSERT INTO customers_part (customer_id, name)
VALUES (101, 'Alice');

SELECT * FROM customers_part_0;

-- DEFAULT
CREATE TABLE orders_part (
	order_id INT GENERATED ALWAYS AS IDENTITY,
	status VARCHAR(20),
	customer_id INT
) PARTITION BY LIST (status);

CREATE TABLE orders_pending PARTITION OF orders_part FOR VALUES IN ('PENDING');
CREATE TABLE orders_failed PARTITION OF orders_part FOR VALUES IN ('FAILED');

-- Captura qualquer valor não mapeado
CREATE TABLE orders_default PARTITION OF orders_part DEFAULT;

INSERT INTO orders_part (status, customer_id)
VALUES ('CANCELLED', 321);

SELECT * FROM orders_default;
