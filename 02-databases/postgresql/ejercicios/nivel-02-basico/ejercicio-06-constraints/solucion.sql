ALTER TABLE libros DROP CONSTRAINT IF EXISTS libros_anio_check;
ALTER TABLE libros
ADD CONSTRAINT libros_anio_check
CHECK (anio >= 1900 AND anio <= EXTRACT(YEAR FROM CURRENT_DATE));

ALTER TABLE prestamos
ADD CONSTRAINT prestamos_libro_usuario_fecha_unique
UNIQUE (libro_id, usuario_id, fecha_prestamo);

ALTER TABLE usuarios
ALTER COLUMN fecha_registro SET DEFAULT CURRENT_TIMESTAMP;
