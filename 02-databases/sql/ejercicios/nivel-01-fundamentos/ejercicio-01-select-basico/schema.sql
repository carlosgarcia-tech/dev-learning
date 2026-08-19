CREATE TABLE clientes (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nombre TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    ciudad TEXT,
    fecha_registro TEXT DEFAULT CURRENT_DATE
);

INSERT INTO clientes (nombre, email, ciudad) VALUES
    ('Ana Pérez', 'ana@email.com', 'Madrid'),
    ('Juan García', 'juan@email.com', 'Barcelona'),
    ('María López', 'maria@email.com', 'Madrid'),
    ('Carlos Ruiz', 'carlos@email.com', 'Valencia'),
    ('Laura Martínez', 'laura@email.com', 'Barcelona');
