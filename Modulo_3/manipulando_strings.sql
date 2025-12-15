-- Uso de CONCAT
SELECT customer_id,
       CONCAT(first_name, ' ', last_name) AS nome_concatenado1,
       first_name || ' ' || last_name AS nome_concatenado2
  FROM customers
  LIMIT 5;

-- Uso de CHAR_LENGTH e LENGTH
SELECT customer_id,
       last_name,
       LENGTH(last_name) AS tamanho_sobrenome
  FROM customers
  LIMIT 5;

SELECT customer_id,
       first_name,
       LENGTH(first_name) AS tamanho_nome
  FROM customers
  LIMIT 5;

-- Uso de UPPER e LOWER
SELECT customer_id,
       UPPER(first_name) AS nome_maiusculo,
       LOWER(last_name) AS sobrenome_minusculo
  FROM customers
  LIMIT 10;

-- Uso de TRIM, LTRIM e RTRIM
SELECT 'l.   ERICK   .r' AS texto_base,
  TRIM('   ERICK   ') AS texto_trim,
  LTRIM('   ERICK   ') AS texto_ltrim,
  RTRIM('ERICK   ') AS texto_rtrim;

-- Uso de SUBSTRING
SELECT product_id,
       product_name,
       SUBSTRING(product_name FROM 1 FOR 4) AS primeiros_4_caracteres
  FROM products
  LIMIT 10;

-- Uso de POSITION
SELECT customer_id,
       last_name,
       POSITION('Silva' IN last_name) AS posicao_silva
  FROM customers
  WHERE last_name LIKE '%Silva%';

-- Uso de REPLACE
SELECT customer_id,
       last_name,
       REPLACE(last_name, 'Silva', 'S.') AS sobrenome_abreviado
  FROM customers
  WHERE last_name LIKE '%Silva%';
