UPDATE libros SET cantidad = cantidad + 2 WHERE id = 1;

UPDATE libros SET cantidad = cantidad + 1;

UPDATE prestamos SET fecha_devolucion = CURRENT_DATE WHERE id = 2;

-- Antes de borrar el libro 5, sus prestamos se eliminan en cascada
-- (ON DELETE CASCADE en la FK de prestamos.libro_id)
DELETE FROM libros WHERE id = 5;
