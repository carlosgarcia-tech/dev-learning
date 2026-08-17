CREATE TABLE ventas (
    id INTEGER PRIMARY KEY,
    region TEXT NOT NULL,
    vendedor TEXT NOT NULL,
    importe REAL NOT NULL
);

INSERT INTO ventas (id, region, vendedor, importe) VALUES
    (1, 'Norte', 'Ana', 200),
    (2, 'Norte', 'Laura', 250),
    (3, 'Sur', 'Carlos', 180),
    (4, 'Norte', 'Ana', 150),
    (5, 'Sur', 'Marta', 120),
    (6, 'Norte', 'Laura', 200),
    (7, 'Sur', 'Carlos', 150),
    (8, 'Sur', 'Marta', 90);