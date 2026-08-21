CREATE TABLE productos (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  precio DECIMAL(10,2) NOT NULL,
  stock INT NOT NULL
) ENGINE=InnoDB;

INSERT INTO productos (nombre, precio, stock) VALUES
  ('Mouse',     25.50, 100),
  ('Teclado',   45.00,  50),
  ('Monitor',  300.00,  20),
  ('Webcam',    60.00,   5),
  ('Audifonos', 80.00,  15),
  ('USB 16GB',  15.00, 200);
