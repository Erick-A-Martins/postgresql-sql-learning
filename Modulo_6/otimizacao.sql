-- Otimização de querys
SELECT
	o.order_id,
	(SELECT count(*)
	FROM order_items oi
	WHERE oi.order_id = o.order_id) AS itens
FROM orders o
WHERE o.status = 'DELIVERED';

SELECT
	o.order_id,
	count(oi.order_id) AS itens
FROM orders o
LEFT JOIN order_items oi
	ON o.order_id = oi.order_id
WHERE o.status = 'DELIVERED'
GROUP BY o.order_id;

-- Otimização com pré-agregação
WITH soma_itens AS (
	SELECT
		order_id,
		SUM(quantity * unit_price) AS subtotal
	FROM order_items
	GROUP BY order_id
)
SELECT
	o.order_id,
	o.total_amount,
	si.subtotal
FROM orders o
JOIN soma_itens si
	ON o.order_id = si.order_id
WHERE o.status = 'DELIVERED';