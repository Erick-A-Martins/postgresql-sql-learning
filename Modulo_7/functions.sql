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