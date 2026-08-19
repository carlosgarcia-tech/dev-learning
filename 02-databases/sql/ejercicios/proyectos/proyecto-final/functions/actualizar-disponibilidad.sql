-- ============================================================
-- Disponibilidad y reglas de negocio de préstamos.
--
-- SQLite no tiene procedimientos almacenados. Las reglas que
-- implementaban crear_prestamo() y devolver_prestamo() se
-- preservan aquí con triggers:
--   1. Máximo 3 préstamos activos por usuario.
--   2. No se puede prestar un libro sin ejemplares disponibles.
--   3. Al devolver (fijar fecha_devolucion) el préstamo pasa a
--      estado 'devuelto' (el incremento de stock está en
--      triggers/actualizar-stock.sql).
-- ============================================================

DROP TRIGGER IF EXISTS tr_validar_prestamo;
CREATE TRIGGER tr_validar_prestamo
BEFORE INSERT ON prestamos
FOR EACH ROW
BEGIN
    SELECT RAISE(ABORT, 'El usuario ya tiene 3 préstamos activos')
    WHERE (SELECT COUNT(*) FROM prestamos
           WHERE usuario_id = NEW.usuario_id
             AND estado IN ('activo', 'retrasado')) >= 3;

    SELECT RAISE(ABORT, 'No hay ejemplares disponibles del libro')
    WHERE (SELECT cantidad_disponible FROM libros WHERE id = NEW.libro_id) <= 0;
END;

DROP TRIGGER IF EXISTS tr_marcar_devuelto;
CREATE TRIGGER tr_marcar_devuelto
AFTER UPDATE OF fecha_devolucion ON prestamos
FOR EACH ROW
WHEN NEW.fecha_devolucion IS NOT NULL AND OLD.fecha_devolucion IS NULL
BEGIN
    UPDATE prestamos
    SET estado = 'devuelto'
    WHERE id = NEW.id;
END;