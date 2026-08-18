CREATE TABLE ventas (
    id INTEGER PRIMARY KEY,
    producto TEXT NOT NULL,
    total REAL NOT NULL,
    fecha DATE
);

INSERT INTO ventas (id, producto, total, fecha) VALUES
    (1, 'Teclado', 45.00, '2024-01-05'),
    (2, 'Mouse', 19.90, '2024-01-05'),
    (3, 'Monitor', 149.00, '2024-01-06'),
    (4, 'Teclado', 45.00, '2024-01-07'),
    (5, 'Webcam', 89.00, '2024-01-07'),
    (6, 'Mouse', 19.90, '2024-01-08'),
    (7, 'Auriculares', 80.00, '2024-01-08'),
    (8, 'Monitor', 149.00, '2024-01-09');