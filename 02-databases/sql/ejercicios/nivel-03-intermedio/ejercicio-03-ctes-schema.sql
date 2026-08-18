CREATE TABLE pedidos (
    id INTEGER PRIMARY KEY,
    cliente_id INTEGER NOT NULL,
    importe REAL NOT NULL
);

INSERT INTO pedidos (id, cliente_id, importe) VALUES
    (1, 1, 120.00),
    (2, 2, 250.00),
    (3, 3, 90.00),
    (4, 1, 170.00),
    (5, 2, 160.00),
    (6, 3, 75.00);