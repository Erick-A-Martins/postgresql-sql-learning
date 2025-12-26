CREATE TABLE orders_audit (
	audit_id 	SERIAL PRIMARY KEY,
	order_id 	INT,
	action 		VARCHAR(10),
	action_time TIMESTAMP
);

-- Função para trigger
CREATE OR REPLACE FUNCTION tg_audit_order()
RETURNS TRIGGER AS $$
BEGIN
	INSERT INTO orders_audit(order_id, action, action_time)
	VALUES(
		COALESCE(NEW.order_id, OLD.order_id),	
		TG_OP,
		NOW()		
	);
	RETURN NEW;	
END;
$$ LANGUAGE plpgsql;

-- Criação do trigger
CREATE TRIGGER trg_order_audit
AFTER INSERT OR UPDATE OR DELETE
ON orders
FOR EACH ROW
EXECUTE FUNCTION tg_audit_order();

-- Fazendo uma alteração para testar
DELETE FROM orders
--SET status = 'SHIPPED'
WHERE order_id = 2;

-- Verificando o log da auditoria
SELECT * FROM orders_audit WHERE order_id = 2;

------------------
CREATE OR REPLACE FUNCTION tg_validacao_product_price()
RETURNS TRIGGER AS $$
BEGIN
	IF NEW.price < 0 THEN
		RAISE EXCEPTION 'Preço não pode ser negativo. Valor informado: %', NEW.price;
	END IF;
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_validate_price
BEFORE INSERT OR UPDATE ON products
FOR EACH ROW
EXECUTE FUNCTION tg_validacao_product_price();

INSERT INTO products (product_name, category_id, price) VALUES ('Teste Trigger 2', 9, -20);

-- Corrige ID quebrado da tabela products
SELECT setval(
	pg_get_serial_sequence('products', 'product_id'),
	(SELECT COALESCE(MAX(product_id), 0) FROM products) + 1
);

-- Trigger que chama duas funções
CREATE TABLE products_audit(
	product_audit_id SERIAL PRIMARY KEY,
	product_id INTEGER,
	ACTION VARCHAR(10),
	action_time TIMESTAMP
);

CREATE OR REPLACE FUNCTION fn_log_product_change(p_id INT, action TEXT) RETURNS VOID AS $$
BEGIN
	INSERT INTO products_audit(product_id, action, action_time)
	VALUES(p_id, action, NOW());
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION fn_notify_change() RETURNS VOID AS $$
BEGIN
	RAISE NOTICE 'Notificação: produto alterado.';
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION tg_product_chain()
RETURNS TRIGGER AS $$
BEGIN
	PERFORM fn_log_product_change(NEW.product_id, TG_OP);
	PERFORM fn_notify_change();
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_product_chain
AFTER UPDATE ON products
FOR EACH ROW
EXECUTE FUNCTION tg_product_chain();

--
UPDATE products
SET product_name = 'Teste trigger com 2 funções' 
WHERE product_id = 102;

-- Auditoria com TRIGGER
CREATE TABLE customers_audit (
	audit_id SERIAL PRIMARY KEY,
	customer_id INT,
	changed_by TEXT,
	changed_at TIMESTAMP,
	action TEXT,
	field_name TEXT,
	old_value TEXT,
	new_value TEXT
);

-- Função de trigger
CREATE OR REPLACE FUNCTION tg_audit_customer_changes()
RETURNS TRIGGER AS $$
BEGIN
	IF TG_OP = 'UPDATE'D THEN
		IF OLD.first_name IS DISTINCT FROM NEW.first_name THEN
			INSERT INTO customers_audit(customer_id, changed_by, changed_at, ACTION, field_name, old_value, new_value)
			VALUES (OLD.customer_id, current_user, NOW(), TG_OP, 'first_name', OLD.first_name, NEW.first_name);
		END IF;

		IF OLD.city IS DISTINCT FROM NEW.city THEN
			INSERT INTO customers_audit(customer_id, changed_by, changed_at, ACTION, field_name, old_value, new_value)
			VALUES (OLD.customer_id, current_user, NOW(), TG_OP, 'city', OLD.city, NEW.city);
		END IF;
	END IF;
		
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger
CREATE TRIGGER trg_customer_audit
AFTER UPDATE ON customers
FOR EACH ROW
EXECUTE FUNCTION tg_audit_customer_changes();

-- Disparo do trigger
UPDATE customers SET first_name = 'Erick', city = 'Brasília' WHERE customer_id = 2;