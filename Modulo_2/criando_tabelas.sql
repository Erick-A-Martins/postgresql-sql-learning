CREATE DATABASE erp;

CREATE TABLE cliente (
  cpf          VARCHAR(20) PRIMARY KEY,
  nome         VARCHAR(100) NOT NULL,
  ds_nasc      DATE,
  email        VARCHAR(50) UNIQUE, -- Cada e-mail só pode aparecer uma vez
  criado_em    TIMESTAMP NOT NULL DEFAULT now(),
  atualiado_em TIMESTAMP NOT NULL DEFAULT now()
);

CREATE TABLE produto (
  codigo         SERIAL PRIMARY KEY,
  nome           VARCHAR(50) NOT NULL UNIQUE,
  descricao      TEXT NOT NULL,
  preco_unitario DECIMAL(10, 2) NOT NULL DEFAULT 0.00
);

CREATE TABLE categoria (
  codigo SERIAL PRIMARY KEY,
  nome   VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE endereco (
  codigo SERIAL PRIMARY KEY,
  rua    VARCHAR(50) NOT NULL,
  cep    VARCHAR(9) NOT NULL,
  cidade VARCHAR(100) NOT NULL,
  estado VARCHAR(2) NOT NULL DEFAULT 'SP',
  cpf    VARCHAR(20) NOT NULL,
  CONSTRAINT fl_endereco_cliente
    FOREIGN KEY(cpf) REFERENCES cliente(cpf)
);

CREATE TABLE pedido (
  numero  SERIAL       PRIMARY KEY,
  data    DATE         NOT NULL DEFAULT CURRENT_DATE,
  status  VARCHAR(20)  NOT NULL DEFAULT 'PENDENTE',
  cpf     VARCHAR(20)  NOT NULL,
  CONSTRAINT fk_pedido_cliente
    FOREIGN KEY (cpf) REFERENCES cliente(cpf) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE item_pedido (
  codigo         SERIAL PRIMARY KEY,
  qtd            INT NOT NULL DEFAULT 1,
  total          DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
  codigo_produto INT NOT NULL,
  codigo_pedido  INT NOT NULL,
  CONSTRAINT fk_itempedido_produto
    FOREIGN KEY(codigo_produto) REFERENCES produto(codigo),
  CONSTRAINT fk_itempedido_pedido
    FOREIGN KEY(codigo_pedido) REFERENCES pedido(numero)
);

CREATE TABLE produto_categoria (
  codigo         SERIAL PRIMARY KEY,
  codigo_produto INT NOT NULL,
  codigo_pedido  INT NOT NULL,
  CONSTRAINT fk_prodcat_produto
    FOREIGN KEY (codigo_produto) REFERENCES produto(codigo),
  CONSTRAINT fk_prodcat_pedido
    FOREIGN KEY (codigo_pedido) REFERENCES pedido(numero),
  CONSTRAINT uq_produto_categoria UNIQUE(codigo_produto, codigo_pedido)
);
