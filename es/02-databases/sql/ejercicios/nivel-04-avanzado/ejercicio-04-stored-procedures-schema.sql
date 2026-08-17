CREATE TABLE productos (
    id INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL,
    categoria TEXT,
    precio REAL NOT NULL
);

INSERT INTO productos (id, nombre, categoria, precio) VALUES
    (1, 'Camiseta', 'ropa', 20.00),
    (2, 'Pantalon', 'ropa', 35.00),
    (3, 'Zapatillas', 'calzado', 60.00);