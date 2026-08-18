CREATE TABLE articulos (
    id INTEGER PRIMARY KEY,
    titulo TEXT NOT NULL,
    autor TEXT
);

INSERT INTO articulos (id, titulo, autor) VALUES
    (1, 'Introducción a SQL', 'Ana'),
    (2, 'Joins explicados', 'Luis'),
    (3, 'Índices en la práctica', 'Marta'),
    (4, 'Transacciones y ACID', 'Carlos'),
    (5, 'Window functions', 'Lucia'),
    (6, 'CTEs en profundidad', 'Pedro'),
    (7, 'Normalización', 'Ana'),
    (8, 'Optimización de queries', 'Luis');