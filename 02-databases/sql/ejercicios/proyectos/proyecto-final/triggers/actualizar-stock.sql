-- ============================================================
-- Gestión de stock (cantidad_disponible) en libros.
--
-- En PostgreSQL esta lógica vivía en funciones plpgsql + triggers;
-- en SQLite se resuelve con triggers inline:
--   - AFTER INSERT: decrementa el stock al crear el préstamo.
--   - AFTER UPDATE de fecha_devolucion: incrementa el stock al
--     devolver el préstamo.
-- ============================================================

DROP TRIGGER IF EXISTS tr_stock_decrementar;
CREATE TRIGGER tr_stock_decrementar
AFTER INSERT ON prestamos
FOR EACH ROW
BEGIN
    UPDATE libros
    SET cantidad_disponible = cantidad_disponible - 1
    WHERE id = NEW.libro_id;
END;

DROP TRIGGER IF EXISTS tr_stock_incrementar;
CREATE TRIGGER tr_stock_incrementar
AFTER UPDATE OF fecha_devolucion ON prestamos
FOR EACH ROW
WHEN NEW.fecha_devolucion IS NOT NULL AND OLD.fecha_devolucion IS NULL
BEGIN
    UPDATE libros
    SET cantidad_disponible = cantidad_disponible + 1
    WHERE id = NEW.libro_id;
END;