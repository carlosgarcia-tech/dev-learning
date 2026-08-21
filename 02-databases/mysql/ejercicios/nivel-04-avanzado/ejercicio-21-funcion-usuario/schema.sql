CREATE TABLE productos (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  precio DECIMAL(10,2) NOT NULL
) ENGINE=InnoDB;

INSERT INTO productos (nombre, precio) VALUES
  ('Mouse',    25.00),
  ('Teclado',  45.00),
  ('Monitor',  300.00);
