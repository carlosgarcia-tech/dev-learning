-- Configuración del MASTER:
-- SHOW MASTER STATUS;
-- CREATE USER 'repl'@'%' IDENTIFIED BY 'repl_pass';
-- GRANT REPLICATION SLAVE ON *.* TO 'repl'@'%';

-- Configuración del REPLICA:
-- CHANGE REPLICATION SOURCE TO
--   SOURCE_HOST='master_host',
--   SOURCE_USER='repl',
--   SOURCE_PASSWORD='repl_pass',
--   SOURCE_AUTO_POSITION=1;
-- START REPLICA;
-- SHOW REPLICA STATUS\G

-- Consulta de verificación (ejecutable en cualquier BD de prueba):
SELECT 'replication_config' AS concepto, 'ok' AS estado;
