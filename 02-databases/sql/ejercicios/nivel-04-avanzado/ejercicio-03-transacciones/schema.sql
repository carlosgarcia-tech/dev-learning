-- Esquema de datos para el ejercicio de Transacciones (compatible con SQLite).

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
    (2, 'Juan García', 'juan@email.com');

INSERT INTO productos (id, nombre, precio, stock) VALUES
    (1, 'Monitor', 299.99, 15),
    (2, 'Teclado', 49.99, 30);

-- pedidos y detalle_pedido se crean vacíos para que los IDs de la
-- transacción de ejemplo sean predecibles (1 y 2).