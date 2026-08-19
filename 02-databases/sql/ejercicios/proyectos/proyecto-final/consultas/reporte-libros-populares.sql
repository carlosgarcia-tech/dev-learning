-- Libros más prestados
SELECT
    l.titulo,
    a.nombre AS autor,
    COUNT(p.id) AS total_prestamos
FROM libros l
JOIN autores a ON l.autor_id = a.id
LEFT JOIN prestamos p ON l.id = p.libro_id
GROUP BY l.id, l.titulo, a.nombre
ORDER BY total_prestamos DESC, l.titulo
LIMIT 10;
