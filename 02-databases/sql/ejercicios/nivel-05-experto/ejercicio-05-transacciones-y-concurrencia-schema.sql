CREATE TABLE inventario (
    id INTEGER PRIMARY KEY,
    producto TEXT NOT NULL,
    stock INTEGER NOT NULL
);

INSERT INTO inventario (id, producto, stock) VALUES
    (1, 'Camiseta', 100),
    (2, 'Pantalon', 50);