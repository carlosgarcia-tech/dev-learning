CREATE TABLE clientes (
    id INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL,
    email TEXT NOT NULL
);

INSERT INTO clientes (id, nombre, email) VALUES
    (1, 'Ana', 'ana@example.com'),
    (2, 'Luis', 'luis@example.com'),
    (3, 'Marta', 'marta@example.com');