CREATE TABLE clientes (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE pedidos (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  cliente_id INT UNSIGNED,
  total DECIMAL(10,2) NOT NULL
) ENGINE=InnoDB;

INSERT INTO clientes (nombre) VALUES
  ('Ana Perez'),
  ('Juan Lopez'),
  ('Maria Ruiz'),
  ('Carlos Soto');

-- Ana tiene 2 pedidos, Juan tiene 1, Maria 0, Carlos 0
INSERT INTO pedidos (cliente_id, total) VALUES
  (1, 150.00),
  (1, 75.50),
  (2, 300.00),
  (NULL, 999.00);  -- pedido sin cliente
