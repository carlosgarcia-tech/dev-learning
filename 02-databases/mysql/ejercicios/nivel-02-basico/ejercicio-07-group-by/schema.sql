CREATE TABLE ventas (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  categoria VARCHAR(50) NOT NULL,
  producto VARCHAR(100) NOT NULL,
  precio DECIMAL(10,2) NOT NULL,
  total DECIMAL(10,2) NOT NULL
) ENGINE=InnoDB;

INSERT INTO ventas (categoria, producto, precio, total) VALUES
  ('electronica', 'Mouse',    25.50,  255.00),
  ('electronica', 'Teclado',  45.00,  225.00),
  ('ropa',        'Camiseta', 15.00,  150.00),
  ('ropa',        'Pantalon', 30.00,   90.00),
  ('hogar',       'Lampara',  50.00,  100.00);
