CREATE TABLE pedidos_planos (
    pedido_id INTEGER,
    cliente_nombre TEXT,
    cliente_email TEXT,
    producto TEXT,
    cantidad INTEGER,
    precio_unitario REAL,
    categoria TEXT
);

INSERT INTO pedidos_planos VALUES
    (1, 'Ana', 'ana@example.com', 'Teclado', 2, 45.00, 'informatica'),
    (1, 'Ana', 'ana@example.com', 'Mouse', 1, 19.90, 'informatica'),
    (2, 'Luis', 'luis@example.com', 'Monitor', 1, 149.00, 'informatica');