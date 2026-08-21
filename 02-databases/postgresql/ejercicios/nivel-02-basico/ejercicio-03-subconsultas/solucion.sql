SELECT * FROM libros WHERE anio = (SELECT MAX(anio) FROM libros);

SELECT * FROM autores
WHERE id IN (SELECT autor_id FROM libros WHERE anio > 2000);

SELECT * FROM usuarios u
WHERE EXISTS (
    SELECT 1 FROM prestamos p
    WHERE p.usuario_id = u.id AND p.fecha_devolucion IS NULL
);
