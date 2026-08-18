CREATE TABLE productos (
    id INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL,
    categoria TEXT,
    precio REAL NOT NULL
);

INSERT INTO productos (id, nombre, categoria, precio) VALUES
    (1, 'Cuaderno A5', 'papeleria', 2.50),
    (2, 'Boligrafo azul', 'papeleria', 1.20),
    (3, 'Libro de SQL', 'libros', 29.99),
    (4, 'Teclado mecanico', 'informatica', 85.00),
    (5, 'Mouse inalambrico', 'informatica', 19.90),
    (6, 'Libro de Python', 'libros', 39.50),
    (7, 'Monitor 24 pulgadas', 'informatica', 149.00),
    (8, 'Carpeta de archivo', 'papeleria', 5.75);