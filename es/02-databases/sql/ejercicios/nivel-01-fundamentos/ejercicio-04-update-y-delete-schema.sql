CREATE TABLE pedidos (
    id INTEGER PRIMARY KEY,
    cliente_id INTEGER,
    producto TEXT NOT NULL,
    categoria TEXT,
    total REAL,
    estado TEXT
);

INSERT INTO pedidos (id, cliente_id, producto, categoria, total, estado) VALUES
    (1, 1, 'Libro', 'lectura', 25.00, 'entregado'),
    (2, 2, 'Tablet', 'electronica', 300.00, 'pendiente'),
    (3, 3, 'Auriculares', 'electronica', 80.00, 'enviado'),
    (4, 2, 'Teclado', 'informatica', 45.00, 'pendiente'),
    (5, 1, 'Monitor', 'electronica', 150.00, 'enviado'),
    (6, 4, 'Cable USB', 'informatica', 10.00, 'cancelado');