CREATE TABLE productos (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  categoria VARCHAR(50) NOT NULL,
  precio DECIMAL(10,2) NOT NULL,
  stock INT NOT NULL
) ENGINE=InnoDB;

INSERT INTO productos (nombre, categoria, precio, stock) VALUES
  ('Mouse',    'electronica', 25.00, 100),
  ('Teclado',  'electronica', 45.00,  50),
  ('Camiseta', 'ropa',        15.00,   0),
  ('Pantalon', 'ropa',        30.00,  20),
  ('Monitor',  'electronica', 300.00, 10);
