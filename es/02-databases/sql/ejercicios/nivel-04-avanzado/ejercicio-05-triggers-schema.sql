CREATE TABLE productos (
    id INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL,
    stock INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE stock_log (
    id INTEGER PRIMARY KEY,
    producto_id INTEGER,
    fecha TEXT DEFAULT (datetime('now')),
    accion TEXT
);

INSERT INTO productos (id, nombre, stock) VALUES
    (1, 'Camiseta', 20),
    (2, 'Pantalon', 15);