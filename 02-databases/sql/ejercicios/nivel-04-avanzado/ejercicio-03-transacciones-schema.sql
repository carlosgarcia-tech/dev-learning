CREATE TABLE cuentas (
    id INTEGER PRIMARY KEY,
    titular TEXT NOT NULL,
    saldo REAL NOT NULL
);

INSERT INTO cuentas (id, titular, saldo) VALUES
    (1, 'Ana', 1000.00),
    (2, 'Luis', 500.00);