-- ============================================================
-- Proyecto Final: Sistema de Inventario y Ventas (MySQL)
-- datos-iniciales.sql — Datos de ejemplo
-- ============================================================

-- Categorías
INSERT INTO categorias (nombre, descripcion) VALUES
  ('Electronica', 'Dispositivos electronicos y accesorios'),
  ('Computacion', 'Equipos de computo y perifericos'),
  ('Oficina',     'Suministros de oficina'),
  ('Audio',       'Equipos de audio y musica');

-- Productos
INSERT INTO productos (codigo, nombre, descripcion, categoria_id, precio, costo, stock, stock_minimo) VALUES
  ('P001', 'Mouse Inalambrico',   'Mouse optical 2.4GHz',       2, 25.50,  12.00, 100, 10),
  ('P002', 'Teclado Mecanico',    'Teclado RGB switches blue', 2, 65.00,  30.00,  50, 10),
  ('P003', 'Monitor 24"',         'Monitor Full HD IPS',       2, 180.00, 110.00, 20,  5),
  ('P004', 'Audifonos Bluetooth', 'Audifonos over-ear ANC',    4, 95.00,  45.00,  30,  5),
  ('P005', 'Cable USB-C',         'Cable USB-C 2m',            1, 12.00,   3.00, 200, 20),
  ('P006', 'Webcam HD',           'Webcam 1080p',             2, 45.00,  20.00,   3,  5),
  ('P007', 'Papel A4',            'Resma 500 hojas',           3,  5.50,   2.00, 150, 20),
  ('P008', 'Lapiceros',           'Caja de 50 lapiceros',     3,  8.00,   3.50,  80, 10);

-- Clientes
INSERT INTO clientes (nombre, email, telefono, direccion) VALUES
  ('Ana Perez',     'ana@mail.com',     '555-0101', 'Calle Mayor 1, Madrid'),
  ('Juan Lopez',    'juan@mail.com',    '555-0102', 'Av. Principal 45, Barcelona'),
  ('Maria Ruiz',    'maria@mail.com',   '555-0103', 'Plaza Centro 8, Valencia'),
  ('Carlos Soto',   'carlos@mail.com',  '555-0104', 'Calle Sol 12, Sevilla'),
  ('Lucia Diaz',    'lucia@mail.com',   '555-0105', 'Av. Mar 30, Malaga');

-- Ventas de ejemplo
INSERT INTO ventas (cliente_id, fecha, total, estado) VALUES
  (1, '2024-01-15 10:30:00',  91.00,  'pagada'),
  (2, '2024-01-20 14:15:00', 245.00,  'pagada'),
  (3, '2024-02-01 09:45:00',  25.50,  'pagada'),
  (1, '2024-02-10 16:20:00', 190.00,  'enviada'),
  (5, '2024-02-15 11:00:00',  16.50,  'pagada');

-- Detalle de ventas
INSERT INTO detalle_ventas (venta_id, producto_id, cantidad, precio_unitario, subtotal) VALUES
  (1, 1, 2, 25.50, 51.00),
  (1, 5, 2, 12.00, 24.00),
  (1, 7, 3,  5.50, 16.50),
  (2, 3, 1, 180.00, 180.00),
  (2, 4, 1, 65.00, 65.00),
  (3, 1, 1, 25.50, 25.50),
  (4, 3, 1, 180.00, 180.00),
  (4, 5, 1, 12.00, 12.00),
  (5, 7, 3, 5.50, 16.50);

-- Ajustar stock según las ventas realizadas (simular movimientos)
UPDATE productos SET stock = stock - 2 WHERE id = 1; -- Mouse: 100-2=98 (resta venta 1)
UPDATE productos SET stock = stock - 1 WHERE id = 3; -- Monitor: 20-1=19 (resta venta 2)
