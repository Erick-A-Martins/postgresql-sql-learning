CREATE DATABASE agenda;

CREATE TABLE contatos (
  id SERIAL PRIMARY KEY,
  nome VARCHAR(100),
  telefone VARCHAR(20)
);

CREATE TABLE clientes (
  id SERIAL PRIMARY KEY,
  nome VARCHAR(100) NOT NULL,
  email VARCHAR(150) UNIQUE NOT NULL,
  data_nascimento DATE,
  saldo NUMERIC(10, 2),
  ativo BOOLEAN DEFAULT TRUE,
  criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- Exemplo de Tipos de Dados Númericos em PostgreSQL
-- SMALLINT -> int2
-- INT ou INTEGER -> int4
-- BIGINT -> int8

DROP TABLE clientes;

-- Função pra gerar UUID
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Comando CREATE
CREATE TABLE clientes (
  id SERIAL PRIMARY KEY,
  codigo_uuid UUID DEFAULT uuid_generate_v4(),
  idade SMALLINT,
  quantidade_compras INTEGER,
  pontos_acumulados BIGINT,
  ticket_medio NUMERIC(10, 2),
  desconto_medio DECIMAL(5, 2),
  estado CHAR(2),
  nome VARCHAR(100),
  observacoes TEXT,
  ativo BOOLEAN,
  data_nascimento DATE,
  hora_cadastro TIME,
  criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  atualiado_em TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
  notas INTEGER[],
  tags TEXT[],
  informacoes_extras JSONB
);

-- Comando INSERT
INSERT INTO clientes (
  idade, 
  quantidade_compras, 
  pontos_acumulados, 
  ticket_medio, 
  desconto_medio,
  estado,
  nome,
  observacoes,
  ativo,
  data_nascimento,
  hora_cadastro,
  notas,
  tags,
  informacoes_extras
) VALUES (
  23,
  123,
  1500,
  200.75,
  10.50,
  'DF',
  'Erick Alves',
  'Cliente frequente com histórico de boas compras.',
  TRUE,
  '2002-07-20',
  '14:30:00',
  ARRAY[8, 9, 10],
  ARRAY['vip', 'newsletter'],
  '{"preferencias": "email", "idioma": "pt-BR", "aceita_promocoes": true}'
);

-- Comando SELECT
SELECT codigo_uuid, nome, estado FROM clientes ORDER BY id;

-- Comando UPDATE
UPDATE clientes
SET idade = 17
WHERE id = 2 OR id = 5

-- Comando DELETE
DELETE FROM clientes WHERE idade < 18;