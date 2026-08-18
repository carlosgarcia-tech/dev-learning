CREATE TABLE pedidos (
    id INTEGER PRIMARY KEY,
    producto TEXT NOT NULL,
    total REAL NOT NULL
);

INSERT INTO pedidos (id, producto, total) VALUES
    (1, 'Cuaderno', 12.50),
    (2, 'Teclado', 65.00),
    (3, 'Monitor', 149.00),
    (4, 'Boligrafo', 3.20),
    (5, 'Auriculares', 45.00),
    (6, 'Webcam', 89.00);