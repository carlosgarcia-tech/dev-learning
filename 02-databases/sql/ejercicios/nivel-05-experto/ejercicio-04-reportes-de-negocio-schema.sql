CREATE TABLE vendedores (
    id INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL
);

CREATE TABLE productos (
    id INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL,
    precio REAL NOT NULL
);

CREATE TABLE ventas (
    id INTEGER PRIMARY KEY,
    producto_id INTEGER,
    vendedor_id INTEGER,
    cantidad INTEGER NOT NULL,
    fecha DATE NOT NULL,
    FOREIGN KEY (producto_id) REFERENCES productos(id),
    FOREIGN KEY (vendedor_id) REFERENCES vendedores(id)
);

INSERT INTO vendedores (id, nombre) VALUES (1, 'Ana'), (2, 'Luis'), (3, 'Marta');

INSERT INTO productos (id, nombre, precio) VALUES
    (1, 'Teclado', 45.00),
    (2, 'Mouse', 19.90),
    (3, 'Monitor', 149.00);

INSERT INTO ventas (id, producto_id, vendedor_id, cantidad, fecha) VALUES
    (1, 1, 1, 2, '2024-01-05'),
    (2, 2, 1, 5, '2024-01-05'),
    (3, 3, 2, 1, '2024-01-06'),
    (4, 1, 2, 1, '2024-02-10'),
    (5, 2, 3, 3, '2024-02-11'),
    (6, 3, 1, 2, '2024-02-12'),
    (7, 1, 3, 1, '2024-03-01'),
    (8, 3, 2, 1, '2024-03-02');