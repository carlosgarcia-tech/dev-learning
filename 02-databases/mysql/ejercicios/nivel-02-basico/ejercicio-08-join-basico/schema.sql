CREATE TABLE clientes (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE pedidos (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  cliente_id INT UNSIGNED NOT NULL,
  total DECIMAL(10,2) NOT NULL
) ENGINE=InnoDB;

INSERT INTO clientes (nombre) VALUES
  ('Ana Perez'),
  ('Juan Lopez'),
  ('Maria Ruiz');

INSERT INTO pedidos (cliente_id, total) VALUES
  (1, 150.00),
  (2, 300.00),
  (1, 75.50),
  (3, 200.00);
