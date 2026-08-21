CREATE TABLE clientes_backup LIKE clientes;
INSERT INTO clientes_backup SELECT * FROM clientes;
SELECT id, nombre, email FROM clientes_backup ORDER BY id;
