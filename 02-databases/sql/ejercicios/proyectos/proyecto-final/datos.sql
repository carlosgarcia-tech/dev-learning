-- ============================================================
-- PROYECTO FINAL — Sistema de e-commerce (SQLite)
-- datos.sql: carga inicial de datos realistas
-- ============================================================

-- Clientes ------------------------------------------------------
INSERT INTO clientes (id, nombre, email, telefono, ciudad, fecha_registro) VALUES
    (1, 'Ana Gómez',    'ana@example.com',    '600111222', 'Madrid',    '2023-11-03'),
    (2, 'Luis Pérez',   'luis@example.com',   '600333444', 'Barcelona', '2023-11-20'),
    (3, 'Marta Ruiz',   'marta@example.com',  '600555666', 'Valencia',  '2023-12-01'),
    (4, 'Carlos Díaz',  'carlos@example.com', '600777888', 'Sevilla',   '2024-01-10'),
    (5, 'Lucía Torres', 'lucia@example.com',  '600999000', 'Madrid',    '2024-01-25'),
    (6, 'Pedro Sánchez','pedro@example.com',  '600222333', 'Bilbao',    '2024-02-05');

-- Productos ------------------------------------------------------
INSERT INTO productos (id, nombre, categoria, precio, stock, activo) VALUES
    (1,  'Teclado Mecánico',  'informatica', 89.99,  25, 1),
    (2,  'Mouse Inalámbrico', 'informatica', 24.50,  40, 1),
    (3,  'Monitor 24"',       'informatica', 149.00, 12, 1),
    (4,  'Silla Ergonómica',  'mobiliario',  199.90, 5,  1),
    (5,  'Escritorio',        'mobiliario',  129.00, 8,  1),
    (6,  'Auriculares',       'electronica', 79.90,  30, 1),
    (7,  'Webcam HD',         'electronica', 59.50,  20, 1),
    (8,  'Libro de SQL',      'libros',      29.99,  50, 1),
    (9,  'Libro de Python',   'libros',      34.50,  45, 1),
    (10, 'Taza Oficina',      'hogar',       12.00,  60, 1);

-- Pedidos (el total es la suma de sus líneas de detalle) ----------
INSERT INTO pedidos (id, cliente_id, fecha, estado, total) VALUES
    (1,  1, '2024-01-05', 'entregado',  138.99),
    (2,  2, '2024-01-12', 'entregado',  238.99),
    (3,  3, '2024-01-20', 'pagado',     199.90),
    (4,  4, '2024-02-02', 'entregado',  163.40),
    (5,  5, '2024-02-10', 'entregado',  94.48),
    (6,  1, '2024-02-15', 'pagado',     161.00),
    (7,  6, '2024-02-18', 'cancelado',  328.90),
    (8,  2, '2024-02-25', 'entregado',  328.90),
    (9,  3, '2024-03-01', 'enviado',    169.89),
    (10, 5, '2024-03-05', 'pagado',     192.50),
    (11, 4, '2024-03-12', 'pendiente',  346.00),
    (12, 6, '2024-03-15', 'pendiente',  103.50);

-- Líneas de pedido -------------------------------------------------
INSERT INTO detalle_pedidos (pedido_id, producto_id, cantidad, precio_unitario) VALUES
    (1,  1,  1, 89.99),
    (1,  2,  2, 24.50),
    (2,  3,  1, 149.00),
    (2,  1,  1, 89.99),
    (3,  4,  1, 199.90),
    (4,  6,  1, 79.90),
    (4,  7,  1, 59.50),
    (4,  10, 2, 12.00),
    (5,  8,  2, 29.99),
    (5,  9,  1, 34.50),
    (6,  3,  1, 149.00),
    (6,  10, 1, 12.00),
    (7,  5,  1, 129.00),
    (7,  4,  1, 199.90),
    (8,  4,  1, 199.90),
    (8,  5,  1, 129.00),
    (9,  1,  1, 89.99),
    (9,  6,  1, 79.90),
    (10, 7,  2, 59.50),
    (10, 2,  3, 24.50),
    (11, 3,  2, 149.00),
    (11, 10, 4, 12.00),
    (12, 9,  3, 34.50);

-- Pagos (los pedidos pendientes o cancelados no tienen pagos) ------
INSERT INTO pagos (id, pedido_id, metodo, monto, fecha) VALUES
    (1, 1,  'tarjeta',       138.99, '2024-01-05'),
    (2, 2,  'tarjeta',       238.99, '2024-01-12'),
    (3, 3,  'transferencia', 199.90, '2024-01-20'),
    (4, 4,  'paypal',        163.40, '2024-02-02'),
    (5, 5,  'tarjeta',       94.48,  '2024-02-10'),
    (6, 6,  'tarjeta',       161.00, '2024-02-15'),
    (7, 8,  'transferencia', 328.90, '2024-02-25'),
    (8, 9,  'tarjeta',       169.89, '2024-03-01'),
    (9, 10, 'paypal',        192.50, '2024-03-05');

-- Movimientos de inventario inicial --------------------------------
INSERT INTO inventario_movimientos (producto_id, tipo, cantidad, fecha, motivo) VALUES
    (1,  'entrada', 25, '2024-01-01 08:00:00', 'stock inicial'),
    (2,  'entrada', 40, '2024-01-01 08:00:00', 'stock inicial'),
    (3,  'entrada', 12, '2024-01-01 08:00:00', 'stock inicial'),
    (4,  'entrada', 5,  '2024-01-01 08:00:00', 'stock inicial'),
    (5,  'entrada', 8,  '2024-01-01 08:00:00', 'stock inicial'),
    (6,  'entrada', 30, '2024-01-01 08:00:00', 'stock inicial'),
    (7,  'entrada', 20, '2024-01-01 08:00:00', 'stock inicial'),
    (8,  'entrada', 50, '2024-01-01 08:00:00', 'stock inicial'),
    (9,  'entrada', 45, '2024-01-01 08:00:00', 'stock inicial'),
    (10, 'entrada', 60, '2024-01-01 08:00:00', 'stock inicial');
