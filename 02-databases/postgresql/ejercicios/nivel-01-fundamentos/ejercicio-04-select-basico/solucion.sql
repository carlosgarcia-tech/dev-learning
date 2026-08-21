-- Todos los libros
SELECT * FROM libros;

-- Titulo y autor
SELECT l.titulo, a.nombre AS autor
FROM libros l
INNER JOIN autores a ON l.autor_id = a.id;

-- Libros de fantasia
SELECT * FROM libros WHERE genero = 'Fantasia';

-- Autores colombianos
SELECT * FROM autores WHERE nacionalidad = 'Colombiana';

-- Prestamos activos
SELECT * FROM prestamos WHERE fecha_devolucion IS NULL;
