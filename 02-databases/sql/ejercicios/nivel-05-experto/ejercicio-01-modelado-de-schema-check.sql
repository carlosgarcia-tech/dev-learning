-- Libros actualmente prestados (sin fecha de devolución) con su socio
SELECT l.titulo, s.nombre AS socio, p.fecha_prestamo
FROM prestamos p
INNER JOIN libros l ON l.id = p.libro_id
INNER JOIN socios s ON s.id = p.socio_id
WHERE p.fecha_devolucion IS NULL
ORDER BY p.id;