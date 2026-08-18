CREATE TABLE clientes (
    id INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL
);

CREATE TABLE pedidos (
    id INTEGER PRIMARY KEY,
    cliente_id INTEGER,
    total REAL,
    FOREIGN KEY (cliente_id) REFERENCES clientes(id)
);

INSERT INTO clientes (id, nombre) VALUES
    (1, 'Ana'),
    (2, 'Luis'),
    (3, 'Marta');

INSERT INTO pedidos (id, cliente_id, total) VALUES
    (101, 1, 120.00),
    (102, 2, 250.00),
    (103, 3, 90.00),
    (104, 1, 210.00),
    (105, 2, 160.00),
    (106, 3, 75.00);