-- Uso do INTERSECT
SELECT email FROM customers
WHERE city = 'Sao Paulo'

INTERSECT

SELECT email FROM customers
WHERE city = 'Rio de Janeiro'

-- Uso de EXCEPT
SELECT product_id, product_name
FROM products

EXCEPT

SELECT DISTINCT p.product_id, p.product_name
FROM products p
JOIN order_items oi
	ON oi.product_id = p.product_id
