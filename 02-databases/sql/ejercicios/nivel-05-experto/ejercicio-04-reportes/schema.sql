-- Datos para los reportes de negocio (compatible con SQLite).
-- Hay clientes VIP, Premium, Regular y dos sin compras válidas.
-- Ana: 7 pedidos / 1460.00  → VIP
-- Juan: 3 pedidos / 750.00  → Premium
-- María: 1 pedido / 120.00  → Regular
-- Laura y Carlos: sin pedidos en estado pagado/entregado → Nuevo

CREATE TABLE clientes (
    id INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL
);

CREATE TABLE productos (
    id INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL,
    precio REAL NOT NULL,
    stock INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE pedidos (
    id INTEGER PRIMARY KEY,
    cliente_id INTEGER NOT NULL REFERENCES clientes(id),
    fecha TEXT NOT NULL,
    total REAL NOT NULL,
    estado TEXT NOT NULL
);

CREATE TABLE detalle_pedido (
    id INTEGER PRIMARY KEY,
    pedido_id INTEGER NOT NULL REFERENCES pedidos(id),
    producto_id INTEGER NOT NULL REFERENCES productos(id),
    cantidad INTEGER NOT NULL,
    precio_unitario REAL NOT NULL
);

INSERT INTO clientes (id, nombre, email) VALUES
    (1, 'Ana Pérez', 'ana@email.com'),
    (2, 'Juan García', 'juan@email.com'),
    (3, 'María López', 'maria@email.com'),
    (4, 'Carlos Ruiz', 'carlos@email.com'),
    (5, 'Laura Gómez', 'laura@email.com');

INSERT INTO productos (id, nombre, precio, stock) VALUES
    (1, 'Portátil', 999.99, 10),
    (2, 'Monitor', 299.99, 20),
    (3, 'Teclado', 89.99, 40),
    (4, 'Ratón', 49.99, 60),
    (5, 'Auriculares', 79.99, 35);

INSERT INTO pedidos (id, cliente_id, fecha, total, estado) VALUES
    (1, 1, '2024-01-05', 150.00, 'pagado'),
    (2, 1, '2024-01-20', 200.00, 'pagado'),
    (3, 1, '2024-02-01', 250.00, 'entregado'),
    (4, 1, '2024-02-15', 180.00, 'pagado'),
    (5, 1, '2024-03-02', 220.00, 'entregado'),
    (6, 1, '2024-03-18', 160.00, 'pagado'),
    (7, 1, '2024-04-05', 300.00, 'pagado'),
    (8, 2, '2024-01-10', 200.00, 'pagado'),
    (9, 2, '2024-02-10', 250.00, 'entregado'),
    (10, 2, '2024-03-10', 300.00, 'pagado'),
    (11, 3, '2024-03-25', 120.00, 'pagado'),
    (12, 5, '2024-04-01', 90.00, 'pendiente'),
    (13, 5, '2024-04-02', 45.00, 'cancelado');

INSERT INTO detalle_pedido (id, pedido_id, producto_id, cantidad, precio_unitario) VALUES
    (1, 1, 4, 2, 49.99),
    (2, 2, 3, 3, 89.99),
    (3, 3, 2, 1, 299.99),
    (4, 4, 5, 2, 79.99),
    (5, 5, 3, 2, 89.99),
    (6, 6, 4, 3, 49.99),
    (7, 7, 1, 1, 999.99),
    (8, 8, 3, 1, 89.99),
    (9, 9, 2, 1, 299.99),
    (10, 10, 5, 1, 79.99),
    (11, 11, 4, 1, 49.99),
    (12, 12, 3, 1, 89.99),
    (13, 13, 5, 1, 79.99);