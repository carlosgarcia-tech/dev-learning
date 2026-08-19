-- Esquema de datos para el ejercicio de Constraints (compatible con SQLite).
-- Las restricciones se definen directamente en el CREATE TABLE:
--   PRIMARY KEY, FOREIGN KEY, UNIQUE, CHECK, DEFAULT y UNIQUE compuesto.

CREATE TABLE clientes (
    id INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    telefono TEXT UNIQUE,
    edad INTEGER CHECK (edad >= 18 AND edad <= 150),
    estado TEXT CHECK (estado IN ('activo', 'inactivo', 'suspendido')),
    creado TEXT,
    activo INTEGER DEFAULT 1
);

CREATE TABLE pedidos (
    id INTEGER PRIMARY KEY,
    cliente_id INTEGER NOT NULL REFERENCES clientes(id) ON DELETE CASCADE,
    fecha TEXT,
    total REAL CHECK (total >= 0),
    estado TEXT CHECK (estado IN ('pendiente', 'pagado', 'entregado', 'cancelado')),
    UNIQUE (cliente_id, fecha)
);

-- Datos de ejemplo (todos cumplen las restricciones)
INSERT INTO clientes (id, nombre, email, telefono, edad, estado, creado) VALUES
    (1, 'Ana Pérez', 'ana@email.com', '600111222', 30, 'activo', '2024-01-01'),
    (2, 'Juan García', 'juan@email.com', '600333444', 25, 'activo', '2024-01-02'),
    (3, 'María López', 'maria@email.com', '600555666', 40, 'activo', '2024-01-03'),
    (4, 'Carlos Ruiz', 'carlos@email.com', '600777888', 22, 'inactivo', '2024-01-04');

-- Pedro Test se inserta sin 'activo': se aplica el DEFAULT (1 = activo)
INSERT INTO clientes (id, nombre, email, edad, estado, creado)
VALUES (5, 'Pedro Test', 'pedro@test.com', 19, 'activo', '2024-01-05');

INSERT INTO pedidos (id, cliente_id, fecha, total, estado) VALUES
    (1, 1, '2024-01-05', 999.99, 'pagado'),
    (2, 1, '2024-02-10', 79.99, 'pagado'),
    (3, 2, '2024-01-20', 329.98, 'pagado'),
    (4, 3, '2024-03-01', 599.99, 'pendiente'),
    (5, 5, '2024-04-02', 49.99, 'entregado');