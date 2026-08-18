CREATE TABLE clientes (
    id INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL,
    email TEXT,
    telefono TEXT,
    ciudad TEXT,
    edad INTEGER
);

INSERT INTO clientes (id, nombre, email, telefono, ciudad, edad) VALUES
    (1, 'Andres', 'andres@gmail.com', '600111222', 'Madrid', 30),
    (2, 'Beatriz', 'beatriz@yahoo.com', NULL, 'Madrid', 27),
    (3, 'Carmen', 'carmen@gmail.com', '600333444', 'Valencia', 40),
    (4, 'David', 'david@outlook.com', NULL, 'Barcelona', 33),
    (5, 'Elena', 'elena@gmail.com', '600555666', 'Sevilla', 22),
    (6, 'Alberto', 'alberto@hotmail.com', NULL, 'Valencia', 29),
    (7, 'Sofia', 'sofia@empresa.com', '600777888', 'Barcelona', 38);