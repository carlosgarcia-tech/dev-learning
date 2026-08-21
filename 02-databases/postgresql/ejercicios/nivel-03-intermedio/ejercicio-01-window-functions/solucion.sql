SELECT titulo, anio, RANK() OVER (ORDER BY anio DESC) AS ranking
FROM libros;

SELECT
    titulo, genero, anio,
    RANK() OVER (PARTITION BY genero ORDER BY anio DESC) AS ranking_genero
FROM libros
ORDER BY genero, ranking_genero;

SELECT
    u.nombre, l.titulo, p.fecha_prestamo,
    ROW_NUMBER() OVER (PARTITION BY u.id ORDER BY p.fecha_prestamo DESC) AS orden
FROM prestamos p
INNER JOIN usuarios u ON p.usuario_id = u.id
INNER JOIN libros l ON p.libro_id = l.id;
