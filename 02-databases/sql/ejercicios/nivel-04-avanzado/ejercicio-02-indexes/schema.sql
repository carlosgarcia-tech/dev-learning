-- Esquema de datos para el ejercicio de Índices (compatible con SQLite).

CREATE TABLE clientes (
    id INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    telefono TEXT UNIQUE,
    edad INTEGER,
    estado TEXT,
    creado TEXT,
    activo INTEGER DEFAULT 1
);

CREATE TABLE pedidos (
    id INTEGER PRIMARY KEY,
    cliente_id INTEGER NOT NULL REFERENCES clientes(id),
    fecha TEXT,
    total REAL,
    estado TEXT
);

CREATE TABLE productos (
    id INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL,
    descripcion TEXT,
    precio REAL NOT NULL,
    stock INTEGER NOT NULL DEFAULT 0
);

INSERT INTO clientes (id, nombre, email, telefono, edad, estado, creado, activo) VALUES
    (1, 'Ana Pérez', 'ana@email.com', '600111222', 30, 'activo', '2024-01-01', 1),
    (2, 'Juan García', 'juan@email.com', '600333444', 25, 'activo', '2024-01-02', 1),
    (3, 'María López', 'maria@email.com', '600555666', 40, 'activo', '2024-01-03', 1),
    (4, 'Carlos Ruiz', 'carlos@email.com', '600777888', 22, 'inactivo', '2024-01-04', 0),
    (5, 'Laura Martínez', 'laura@email.com', '600999000', 35, 'activo', '2024-01-05', 1);

INSERT INTO pedidos (id, cliente_id, fecha, total, estado) VALUES
    (1, 1, '2024-01-05', 999.99, 'pagado'),
    (2, 1, '2024-02-10', 79.99, 'pagado'),
    (3, 2, '2024-01-20', 329.98, 'pagado'),
    (4, 3, '2024-03-01', 599.99, 'pendiente'),
    (5, 4, '2024-04-15', 49.99, 'cancelado'),
    (6, 5, '2024-05-01', 199.99, 'pagado');

INSERT INTO productos (id, nombre, descripcion, precio, stock) VALUES
    (1, 'Laptop', 'Portátil de 14 pulgadas', 999.99, 10),
    (2, 'Teléfono', 'Smartphone Android', 599.99, 25),
    (3, 'Monitor', 'Monitor 24 pulgadas', 299.99, 15),
    (4, 'Teclado', 'Teclado mecánico', 49.99, 30),
    (5, 'Ratón', 'Ratón inalámbrico', 29.99, 45),
    (6, 'Auriculares', 'Auriculares Bluetooth', 79.99, 20);