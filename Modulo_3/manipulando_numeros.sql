-- Uso de ROUND
SELECT product_id,
       price,
       ROUND(price, 0) AS price_arredondado_inteiro,
       ROUND(price, 1) AS price_arredondado_1_casa,
       ROUND(price, 2) AS price_arredondado_2_casas
  FROM products
  LIMIT 5;

-- Uso de TRUNCATE (PostgreSQL usa TRUNC)
SELECT product_id,
       price,
       TRUNC(price, 0) AS price_truncado_inteiro,
       TRUNC(price, 1) AS price_truncado_1_casa
  FROM products
  LIMIT 5;

-- Uso de CEIL e FLOOR
SELECT product_id,
       price,
       CEIL(price) AS price_ceil,   -- menor inteiro >= price
       FLOOR(price) AS price_floor  -- maior inteiro <= price
  FROM products
  LIMIT 10;

-- Uso de ABS, POWER, SQRT para operações matemáticas
SELECT product_id,
       price,
       ABS(price * -1)  AS valor_absoluto,  -- Valor absoluto
       POWER(price, 2)  AS price_quadrado,  -- Elevado ao quadrado
       SQRT(price)      AS raiz_price       -- Raiz quadrada
  FROM products
  LIMIT 5;

-- Uso de MOD - resto da divisão
SELECT product_id,
       price,
       MOD(CAST(price AS INT), 7) AS resto_divisao_por_7 -- Casting com CAST(colunas AS tipo) é o mesmo que valor::CASTING
  FROM products
  LIMIT 5;

-- Uso de CAST
SELECT product_id,
       price,
       CAST(price AS INT) AS price_inteiro
  FROM products
  LIMIT 10;

SELECT customer_id,
       created_at,
       CAST(created_at AS VARCHAR(20)) AS created_at_text -- Conversão de data para texto
  FROM customers
  LIMIT 5;

SELECT '123' AS texto_base,
  CAST('123' AS INT) + 10 AS soma_exemplo;
