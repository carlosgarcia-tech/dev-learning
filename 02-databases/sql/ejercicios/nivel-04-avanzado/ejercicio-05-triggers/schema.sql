-- Esquema de datos para el ejercicio de Triggers (compatible con SQLite).

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

CREATE TABLE auditoria (
    id INTEGER PRIMARY KEY,
    tabla TEXT,
    accion TEXT,
    datos TEXT,
    fecha TEXT
);

INSERT INTO clientes (id, nombre, email) VALUES
    (1, 'Ana Pérez', 'ana@email.com'),
    (2, 'Juan García', 'juan@email.com');

INSERT INTO productos (id, nombre, precio, stock) VALUES
    (1, 'Laptop', 999.99, 10),
    (2, 'Teléfono', 599.99, 25);

-- Pedidos sin detalle para que los triggers de ejemplo recalculen su total.
INSERT INTO pedidos (id, cliente_id, fecha, total, estado) VALUES
    (1, 1, '2024-01-05', 0, 'pendiente'),
    (2, 2, '2024-02-01', 0, 'pendiente');