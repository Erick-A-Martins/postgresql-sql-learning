CREATE OR REPLACE FUNCTION fn_fullname(c_id INT)
RETURNS TEXT AS $$
DECLARE
	v_first VARCHAR;
	v_last VARCHAR;
BEGIN
	SELECT first_name, last_name
		INTO v_first, v_last
	FROM customers
	WHERE customer_id = c_id;

	RETURN v_first || ' ' || v_last;
END;
$$ LANGUAGE plpgsql;

SELECT 
	customer_id,
	fn_fullname(customer_id) AS nome_completo
FROM customers;

--
CREATE OR REPLACE FUNCTION fn_order_total(o_id INT)
RETURNS NUMERIC AS $$
DECLARE
	v_total NUMERIC;
BEGIN
	SELECT SUM(quantity * unit_price)
		INTO v_total
	FROM order_items
	WHERE order_id = o_id;

	RETURN COALESCE(v_total, 0); -- se não houver itens, retorna 0
END;
$$ LANGUAGE plpgsql;

SELECT fn_order_total(497) AS total_pedido;

-- Retorno composto, retorna multiplas colunas
CREATE OR REPLACE FUNCTION fn_order_items(o_id INT)
RETURNS TABLE (
	product_name VARCHAR,
	qty INT,
	subtotal NUMERIC
) AS $$
BEGIN
	RETURN QUERY
	SELECT
		p.product_name,
		oi.quantity,
		oi.quantity * oi.unit_price AS subtotal
	FROM order_items oi
	JOIN products p
		ON p.product_id = oi.product_id
	WHERE oi.order_id = o_id;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM fn_order_items(496);

-- Tratamento de exceções em funções
CREATE OR REPLACE FUNCTION fn_get_customer_email(c_id INT)
RETURNS TEXT AS $$
DECLARE
	v_email TEXT;
BEGIN
	SELECT email INTO v_email
	FROM customers
	WHERE customer_id = c_id;

	IF v_email IS NULL THEN
		RAISE EXCEPTION 'Cliente % não foi encontrado ou sem e-mail', c_id;
	END IF;
	
	RETURN v_email;

--EXCEPTION
--	WHEN OTHERS THEN
--		RETURN 'no_reply@exemplo.com';
END;
$$ LANGUAGE plpgsql SECURITY DEFINER; -- Executa somente com os direitos do usuario que criou a função, acesso restrito

SELECT fn_get_customer_email(333) AS email_customer;

-- Funções que modificam dados e controle de transações
-- Função com INSERT
CREATE OR REPLACE FUNCTION fn_add_customer(
	p_first VARCHAR,
	p_last VARCHAR,
	p_email VARCHAR,
	p_city VARCHAR
)
RETURNS INT AS $$
DECLARE
	v_id INT;
BEGIN
	INSERT INTO customers (first_name, last_name, email, city, created_at)
	VALUES (p_first, p_last, p_email, p_city, NOW())
	RETURNING customer_id INTO v_id;

	RETURN v_id;		
END;
$$ LANGUAGE plpgsql;

SELECT fn_add_customer('Ana', 'Silva', 'ana@exemplo.com', 'Porto Alegre');

-- Função com UPDATE
CREATE OR REPLACE FUNCTION fn_update_email(c_id INT, novo_email TEXT)
RETURNS BOOLEAN AS $$
BEGIN
	UPDATE customers
	SET email = novo_email
	WHERE customer_id = c_id;

	IF FOUND THEN
		RETURN TRUE; -- Atualiza com sucesso
	ELSE
		RETURN FALSE; -- Não achou nenhum cliente com o ID
	END IF;
END;
$$ LANGUAGE plpgsql;

SELECT fn_update_email(206, 'super@email.com') AS resultado;

-- Função com DELETE
CREATE OR REPLACE FUNCTION fn_delete_customer(c_id INT)
RETURNS TEXT AS $$
BEGIN
	IF EXISTS (
		SELECT 1 FROM orders WHERE customer_id = c_id
	) THEN
	RETURN 'Erro: Cliente possuí pedidos.';
	ELSE
		DELETE FROM customers WHERE customer_id = c_id;
		RETURN 'Cliente excluído com sucesso.';
	END IF;
END;
$$ LANGUAGE plpgsql;

SELECT fn_delete_customer (2202) AS resultado;

-- Mais de uma operação na função
CREATE OR REPLACE FUNCTION fn_create_order(
	p_customer_id INT,
	p_items JSON
)
RETURNS TEXT AS $$
DECLARE 
	v_order_id INT;
	v_item JSON;
BEGIN
	-- Cria o pedido
	INSERT INTO orders (customer_id, order_date, status, total_amount)
	VALUES (p_customer_id, NOW(), 'PENDING', 0)
	RETURNING order_id INTO v_order_id;

	-- Insere os itens
	FOR v_item IN SELECT * FROM json_array_elements(p_items)
	LOOP
		INSERT INTO order_items (order_id, product_id, quantity, unit_price)
		VALUES (
			v_order_id,
			(v_item->>'product_id')::INT,
			(v_item->>'quantity')::INT,
			(v_item->>'unit_price')::NUMERIC
		);
	END LOOP;
		
	RETURN FORMAT('Pedido %s criado com sucesso.', v_order_id);

EXCEPTION
	WHEN OTHERS THEN
		RAISE NOTICE 'Erro ao criar pedido. Revertendo...';
		RAISE;
END;
$$ LANGUAGE plpgsql;

SELECT fn_create_order(
	2,
	'[
		{"product_id": 97, "quantity": 2, "unit_price": 10.50},
		{"product_id": 98, "quantity": 1, "unit_price": 5.00},
		{"product_id": 99, "quantity": 4, "unit_price": 2.50}
	]'::JSON
) AS resultado;