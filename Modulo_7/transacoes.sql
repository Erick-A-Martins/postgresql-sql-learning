-- Transactions
BEGIN;

	UPDATE products
	SET price = price * 0.9
	WHERE category_id = 1;
	
	UPDATE orders
	SET total_amount = total_amount + 50
	WHERE order_id = 650;
	
COMMIT;

-- Savepoint
BEGIN;
	INSERT INTO orders(customer_id, order_date, status, total_amount)
		VALUES(2, CURRENT_DATE, 'PENDING', 200.00);
	SAVEPOINT my_savepoint;

	INSERT INTO orders(customer_id, order_date, status, total_amount)
		VALUES(3, CURRENT_DATE, 'PENDING', 200.00);
	ROLLBACK TO my_savepoint;
	
	INSERT INTO orders(customer_id, order_date, status, total_amount)
		VALUES(2, CURRENT_DATE, 'PENDING', 200.00);
COMMIT;

-- A - Atomicidade (rollback)
DO $$
DECLARE
	v_order_id INTEGER;
BEGIN
	-- Bloco aninhado, se qualquer insert falhar faz rollback
	BEGIN
		INSERT INTO orders(customer_id, order_date, status, total_amount)
			VALUES(2, CURRENT_DATE, 'PENDING', 200.00)
			RETURNING order_id INTO v_order_id;
		RAISE NOTICE 'Pedido 1 inserido com ID %', v_order_id;

		INSERT INTO orders(customer_id, order_date, status, total_amount)
			VALUES(2, CURRENT_DATE, 'PENDING', 200.00);
		
		INSERT INTO orders(customer_id, order_date, status, total_amount)
			VALUES(4, CURRENT_DATE, 'PENDING', 200.00);
		
		RAISE NOTICE 'Todos os pedidos inseridos com sucesso.';
	EXCEPTION WHEN OTHERS THEN
		RAISE WARNING 'Erro ao isnerir pedidos: %, revertendo todos os INSERTs', SQLERRM;
		RETURN;
	END;
END;
$$ LANGUAGE plpgsql;

-- Util para detectar deadlocks ou transações travadas
SELECT * FROM pg_locks WHERE NOT GRANTED;

--
SELECT pid, relation::regclass, MODE, GRANTED
FROM pg_locks
WHERE NOT GRANTED;

-- Transações em aberto
SELECT pid, xact_start, query
FROM pg_stat_activity
WHERE state = 'active';

-- Trava escrita de outras sessões até o COMMIT
BEGIN;
LOCK TABLE orders IN SHARE ROW EXCLUSIVE MODE;
COMMIT;