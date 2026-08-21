CREATE TABLE categorias (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL
);

CREATE TABLE productos (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    precio DECIMAL(10,2) NOT NULL,
    categoria_id INT REFERENCES categorias(id),
    activo BOOLEAN DEFAULT TRUE,
    stock_actual INT DEFAULT 0
);

CREATE TABLE pedidos (
    id SERIAL PRIMARY KEY,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    estado VARCHAR(20) DEFAULT 'pagado',
    total DECIMAL(10,2) DEFAULT 0
);

INSERT INTO categorias (nombre) VALUES ('Electronica'), ('Hogar');
INSERT INTO productos (nombre, precio, categoria_id, stock_actual) VALUES
    ('Laptop', 1200.00, 1, 5),
    ('Silla', 89.90, 2, 20);
INSERT INTO pedidos (fecha, estado, total) VALUES
    (CURRENT_DATE, 'pagado', 1200.00),
    (CURRENT_DATE - 1, 'pagado', 89.90);
