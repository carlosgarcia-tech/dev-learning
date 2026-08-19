-- Datos relacionales para el dashboard de ventas (compatible con SQLite).
-- Relaciones: clientes 1:N pedidos, pedidos 1:N detalle_pedido,
-- productos 1:N detalle_pedido. Dos clientes no tienen pedidos (Carlos y Laura).

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
    (4, 'Ratón', 49.99, 60);

INSERT INTO pedidos (id, cliente_id, fecha, total, estado) VALUES
    (1, 1, '2024-01-10', 1049.98, 'pagado'),
    (2, 1, '2024-02-15', 299.99, 'entregado'),
    (3, 1, '2024-02-28', 89.99, 'enviado'),
    (4, 2, '2024-01-20', 349.98, 'pagado'),
    (5, 2, '2024-03-01', 49.99, 'pendiente'),
    (6, 2, '2024-03-10', 299.99, 'entregado'),
    (7, 3, '2024-02-05', 999.99, 'pagado');

INSERT INTO detalle_pedido (id, pedido_id, producto_id, cantidad, precio_unitario) VALUES
    (1, 1, 1, 1, 999.99),
    (2, 1, 4, 1, 49.99),
    (3, 2, 2, 1, 299.99),
    (4, 3, 3, 1, 89.99),
    (5, 4, 2, 1, 299.99),
    (6, 4, 4, 1, 49.99),
    (7, 5, 4, 1, 49.99),
    (8, 6, 2, 1, 299.99),
    (9, 7, 1, 1, 999.99);