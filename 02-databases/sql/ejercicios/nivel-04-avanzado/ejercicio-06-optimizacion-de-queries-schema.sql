CREATE TABLE transacciones (
    id INTEGER PRIMARY KEY,
    cliente_id INTEGER NOT NULL,
    fecha DATE NOT NULL,
    importe REAL NOT NULL,
    detalle TEXT
);