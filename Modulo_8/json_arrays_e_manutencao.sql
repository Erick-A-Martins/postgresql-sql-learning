CREATE TABLE eventos (
	id SERIAL PRIMARY KEY,
	data jsonb
);

INSERT INTO eventos (data)
VALUES ('{"user": "alive", "action": "login", "meta": {"ip":"10.0.0.1"}}');

-- -> retorna o valor em JSON
-- ->> retorna o valor em texto
SELECT DATA->>'user' FROM eventos;

-- Extrair campo
SELECT data->>'action' AS acao FROM eventos;

-- Adicionar novo campo
UPDATE eventos
SET data = jsonb_set(data, '{meta, device}', '"mobile"');

-- Explodir array em linhas
WITH docs AS (
	SELECT '{"tags":["banco", "nosql", "pgsql"]}'::jsonb AS d
)
SELECT tag
FROM docs, jsonb_array_elements(d->'tags') AS arr(tag);

-- Indice padrao GIN
CREATE INDEX idx_eventos_data_gin ON eventos USING GIN (data);

-- GIN otimiado para caminhos
CREATE INDEX idx_eventos_data_path ON eventos USING GIN (data jsonb_path_ops);

-- Consulta com filtro interno
EXPLAIN ANALYZE
SELECT * FROM eventos WHERE DATA @> '{"action":"login"}';

-- Arrays
CREATE TABLE pesquisa (
	id SERIAL PRIMARY KEY,
	respostas text[]
);

INSERT INTO pesquisa(respostas)
VALUES (ARRAY['sim', 'nao', 'talvez']);

-- Explodir array
SELECT id, unnest(respostas) AS resposta FROM pesquisa

--hstore
CREATE EXTENSION IF NOT EXISTS hstore;

CREATE TABLE configs (
	id SERIAL PRIMARY KEY,
	props hstore
);

INSERT INTO configs(props)
VALUES ('theme => "dark", notifications => "on"');

SELECT props->'notifications' AS tema FROM configs;

-- VACUUM
-- VACUUM FULL
-- ANALYZE

SELECT relname, n_dead_tup
FROM pg_stat_user_tables
ORDER BY n_dead_tup DESC;

VACUUM VERBOSE eventos;

SELECT date_trunc('month', now()) AS referencia,
	pg_total_relation_size('loans')/1024/1024 AS tamanho_mb;