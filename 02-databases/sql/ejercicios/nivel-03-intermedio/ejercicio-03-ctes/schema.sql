-- Esquema de datos de ejemplo (compatible con SQLite) usado en los
-- ejercicios de los niveles 1 a 3. Cada ejercicio puede usar sólo una
-- parte de estas tablas según lo que necesite.

CREATE TABLE clientes (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nombre TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    ciudad TEXT,
    activo INTEGER DEFAULT 1,
    fecha_registro TEXT DEFAULT CURRENT_DATE
);

CREATE TABLE categorias (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nombre TEXT NOT NULL,
    parent_id INTEGER REFERENCES categorias(id)
);

CREATE TABLE productos (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nombre TEXT NOT NULL,
    precio REAL NOT NULL CHECK (precio >= 0),
    stock INTEGER NOT NULL DEFAULT 0,
    categoria_id INTEGER REFERENCES categorias(id),
    descripcion TEXT
);

CREATE TABLE pedidos (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    cliente_id INTEGER NOT NULL REFERENCES clientes(id),
    fecha TEXT DEFAULT CURRENT_TIMESTAMP,
    total REAL DEFAULT 0,
    estado TEXT DEFAULT 'pendiente'
);

CREATE TABLE detalle_pedido (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    pedido_id INTEGER NOT NULL REFERENCES pedidos(id),
    producto_id INTEGER NOT NULL REFERENCES productos(id),
    cantidad INTEGER NOT NULL,
    precio_unitario REAL NOT NULL
);

CREATE TABLE empleados (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nombre TEXT NOT NULL,
    jefe_id INTEGER REFERENCES empleados(id)
);

-- Datos de ejemplo
INSERT INTO clientes (nombre, email, ciudad) VALUES
    ('Ana Pérez', 'ana@email.com', 'Madrid'),
    ('Juan García', 'juan@email.com', 'Barcelona'),
    ('María López', 'maria@email.com', 'Madrid'),
    ('Carlos Ruiz', 'carlos@email.com', 'Valencia'),
    ('Laura Martínez', 'laura@email.com', 'Barcelona');

INSERT INTO categorias (nombre, parent_id) VALUES
    ('Electrónica', NULL),
    ('Computadoras', 1),
    ('Accesorios', 1);

INSERT INTO productos (nombre, precio, stock, categoria_id) VALUES
    ('Laptop', 999.99, 10, 2),
    ('Teléfono', 599.99, 25, 1),
    ('Monitor', 299.99, 15, 2),
    ('Teclado', 49.99, 30, 3),
    ('Ratón', 29.99, 45, 3),
    ('Auriculares', 79.99, 0, 3);

INSERT INTO pedidos (cliente_id, fecha, total, estado) VALUES
    (1, '2024-01-05', 999.99, 'pagado'),
    (1, '2024-02-10', 79.99, 'pagado'),
    (2, '2024-01-20', 329.98, 'pagado'),
    (3, '2024-03-01', 599.99, 'pendiente');

INSERT INTO detalle_pedido (pedido_id, producto_id, cantidad, precio_unitario) VALUES
    (1, 1, 1, 999.99),
    (2, 6, 1, 79.99),
    (3, 3, 1, 299.99),
    (3, 5, 1, 29.99),
    (4, 2, 1, 599.99);

INSERT INTO empleados (nombre, jefe_id) VALUES
    ('Elena Sánchez', NULL),
    ('Pedro Gómez', 1),
    ('Sofía Díaz', 1),
    ('Marcos Ibáñez', 2);

-- Este ejercicio usa strftime() (la forma equivalente en SQLite a
-- DATE_TRUNC() de PostgreSQL) para agrupar las ventas por mes.
