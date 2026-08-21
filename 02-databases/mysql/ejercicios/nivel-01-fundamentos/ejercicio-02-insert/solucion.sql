INSERT INTO productos (nombre, precio, stock) VALUES
  ('Mouse',   25.50, 100),
  ('Teclado', 45.00,  50),
  ('Monitor', 300.00, 20);

SELECT id, nombre, precio, stock FROM productos ORDER BY id;
