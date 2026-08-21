CREATE TABLE productos (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  categoria VARCHAR(50) NOT NULL,
  precio DECIMAL(10,2) NOT NULL,
  INDEX idx_categoria (categoria)
) ENGINE=InnoDB;

INSERT INTO productos (nombre, categoria, precio) VALUES
  ('Mouse',    'electronica', 25.00),
  ('Teclado',  'electronica', 45.00),
  ('Monitor',  'electronica', 300.00),
  ('Camiseta', 'ropa',         15.00),
  ('Pantalon', 'ropa',         30.00);
