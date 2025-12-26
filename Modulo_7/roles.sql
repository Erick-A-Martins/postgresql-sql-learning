-- Criar papel de leitura (grupo)
CREATE ROLE reader NOLOGIN;

-- Criar papel de escrita
CREATE ROLE writer NOLOGIN;

-- Criar usario com senha
CREATE ROLE app_user LOGIN PASSWORD 'senha123';

GRANT reader TO app_user;
GRANT writer TO app_user;

--
CREATE ROLE reporting LOGIN PASSWORD 'relat0r10!';
CREATE ROLE ingestion LOGIN PASSWORD 'ingest2024!';

-- Permissoes
CREATE ROLE data_reader NOLOGIN;
CREATE ROLE data_writer NOLOGIN;

GRANT SELECT ON ALL TABLES IN SCHEMA public TO data_reader;
GRANT INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO data_writer;

GRANT data_reader TO reporting;
GRANT data_writer TO ingestion;

-- BACKUP banco aulas (DUMP)
pg_dump -U postgres -h localhost -p 5432 -Fc -f "path_aqui\backup_full_aulas.dump" aulas
createdb -U postgres aulas_restore
pg_restore -U postgres -h localhost -p 5432 -d aulas_restore backup_full_aulas.dump
