CREATE TABLE usuarios (
    id INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL,
    email TEXT NOT NULL,
    edad INTEGER,
    ciudad TEXT
);

INSERT INTO usuarios (id, nombre, email, edad, ciudad) VALUES
    (1, 'Ana', 'ana@example.com', 28, 'Madrid'),
    (2, 'Luis', 'luis@example.com', 34, 'Barcelona'),
    (3, 'Marta', 'marta@example.com', 22, 'Madrid'),
    (4, 'Carlos', 'carlos@example.com', 41, 'Valencia'),
    (5, 'Lucia', 'lucia@example.com', 29, 'Barcelona'),
    (6, 'Pedro', 'pedro@example.com', 30, 'Sevilla');