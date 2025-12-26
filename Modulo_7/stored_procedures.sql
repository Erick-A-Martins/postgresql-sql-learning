CREATE OR REPLACE PROCEDURE sp_update_product_price(
	p_product_id INT,
	p_new_price NUMERIC
)
LANGUAGE plpgsql AS $$
BEGIN
	UPDATE products
		SET price = p_new_price
	WHERE product_id = p_product_id;

	IF NOT FOUND THEN
		RAISE EXCEPTION 'Produto % não existe', p_product_id;
	END IF;
END;
$$;

CALL sp_update_product_price(3, 199.90);

--------
CREATE OR REPLACE PROCEDURE sp_cancel_order (
	p_order_id INT
)
LANGUAGE plpgsql AS $$
BEGIN
	DELETE FROM order_items WHERE order_id = p_order_id;
	DELETE FROM orders WHERE order_id = p_order_id;

	IF NOT FOUND THEN	
		RAISE NOTICE 'Pedido % não encontrado', p_order_id;
	ELSE
		RAISE NOTICE 'Pedido % e itens removidos', p_order_id;
	END IF;
END;
$$;

CALL sp_cancel_order(4);

-- Uso de parametros (IN, OUT E INOUT)
CREATE OR REPLACE PROCEDURE sp_order_summary(
	IN p_order_id INT,
	OUT p_customer_id INT,
	OUT p_total_amount NUMERIC
)
LANGUAGE plpgsql AS $$
BEGIN
	SELECT customer_id, total_amount
		INTO p_customer_id, p_total_amount
	FROM orders
	WHERE order_id = p_order_id;
END;
$$;

DO $$
DECLARE
	cust_id INT;
	tot NUMERIC;
BEGIN
	CALL sp_order_summary(5, cust_id, tot);
	RAISE NOTICE 'Cliente: %, Total: %', cust_id, tot;
END;
$$;

--
CREATE OR REPLACE PROCEDURE sp_increment_counter(INOUT ct INT)
LANGUAGE plpgsql AS $$
BEGIN
	ct := ct + 1;
END;
$$;

DO $$
DECLARE
	valor INT := 10;
BEGIN
	CALL  sp_increment_counter(valor);
	RAISE NOTICE 'Novo valor: %', valor;
END;
$$;