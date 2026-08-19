-- Esquema de datos para el ejercicio de Optimización (compatible con SQLite).
-- No se crea ningún índice sobre pedidos: se hace en solucion.sql para
-- comparar el plan de ejecución antes y después.

CREATE TABLE clientes (
    id INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL
);

CREATE TABLE pedidos (
    id INTEGER PRIMARY KEY,
    cliente_id INTEGER NOT NULL REFERENCES clientes(id),
    fecha TEXT,
    total REAL,
    estado TEXT
);

INSERT INTO clientes (id, nombre, email) VALUES
    (1, 'Ana Pérez', 'ana@email.com'),
    (2, 'Juan García', 'juan@email.com'),
    (3, 'María López', 'maria@email.com'),
    (4, 'Carlos Ruiz', 'carlos@email.com'),
    (5, 'Laura Martínez', 'laura@email.com');

INSERT INTO pedidos (id, cliente_id, fecha, total, estado) VALUES
    (1, 1, '2023-11-05', 499.99, 'pagado'),
    (2, 1, '2024-01-05', 999.99, 'pagado'),
    (3, 1, '2024-01-20', 79.99, 'pagado'),
    (4, 2, '2023-12-10', 329.98, 'pagado'),
    (5, 2, '2024-02-15', 599.99, 'pagado'),
    (6, 3, '2024-01-25', 299.99, 'pendiente'),
    (7, 4, '2024-03-01', 49.99, 'pagado'),
    (8, 5, '2023-09-01', 149.99, 'cancelado');