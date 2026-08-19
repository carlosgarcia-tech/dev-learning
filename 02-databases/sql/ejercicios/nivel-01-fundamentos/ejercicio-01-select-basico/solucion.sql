-- Todos los clientes
SELECT * FROM clientes;

-- Nombre y email
SELECT nombre, email FROM clientes;

-- Clientes de Madrid
SELECT * FROM clientes WHERE ciudad = 'Madrid';
