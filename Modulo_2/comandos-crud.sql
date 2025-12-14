INSERT INTO cliente (cpf, nome, ds_nasc, email)
VALUES
  ('11122233344', 'João Silva', '1980-06-14', 'joaozinho@gmail.com'),
  ('55544477722', 'Maria Souza', '1992-10-30', 'maria@mail.com');

SELECT * FROM cliente

UPDATE cliente
  SET email = 'maria.souza@gmail.com'
WHERE cpf = '55544477722';

DELETE FROM cliente
WHERE cpf = '55544477722';

INSERT INTO endereco (rua, cep, cidade, estado, cpf)
VALUES
  ('Av. Paulista', '00034-919', 'São Paulo', 'SP', '11122233344');