CREATE TABLE pedidos (
    id INTEGER PRIMARY KEY,
    referencia TEXT NOT NULL,
    cliente_id INTEGER NOT NULL,
    fecha DATE,
    total REAL
);

INSERT INTO pedidos (id, referencia, cliente_id, fecha, total) VALUES
    (1, 'REF-001', 10, '2024-01-05', 120.00),
    (2, 'REF-002', 20, '2024-01-05', 250.00),
    (3, 'REF-003', 10, '2024-01-06', 80.00),
    (4, 'REF-004', 30, '2024-01-07', 340.00),
    (5, 'REF-005', 20, '2024-01-08', 90.00);