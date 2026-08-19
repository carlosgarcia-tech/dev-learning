-- Esquema de datos para el ejercicio de Stored Procedures (compatible con SQLite).
-- SQLite no tiene PROCEDURE/FUNCTION: los mismos conceptos se resuelven con
-- sentencias SQL directas (o triggers, ver ejercicio 23).

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
    fecha TEXT,
    total REAL DEFAULT 0,
    estado TEXT DEFAULT 'pendiente'
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
    (3, 'María López', 'maria@email.com');

INSERT INTO productos (id, nombre, precio, stock) VALUES
    (1, 'Laptop', 999.99, 10),
    (2, 'Teléfono', 599.99, 25),
    (3, 'Monitor', 299.99, 15),
    (4, 'Teclado', 49.99, 30),
    (5, 'Ratón', 29.99, 45),
    (6, 'Auriculares', 79.99, 20);

INSERT INTO pedidos (id, cliente_id, fecha, total, estado) VALUES
    (1, 1, '2024-01-05', 999.99, 'pagado'),
    (2, 1, '2024-02-10', 79.99, 'pagado'),
    (3, 2, '2024-01-20', 329.98, 'pagado'),
    (4, 3, '2024-01-05', 599.99, 'pendiente');

INSERT INTO detalle_pedido (id, pedido_id, producto_id, cantidad, precio_unitario) VALUES
    (1, 1, 1, 1, 999.99),
    (2, 2, 6, 1, 79.99),
    (3, 3, 3, 1, 299.99),
    (4, 3, 5, 1, 29.99),
    (5, 4, 2, 1, 599.99);