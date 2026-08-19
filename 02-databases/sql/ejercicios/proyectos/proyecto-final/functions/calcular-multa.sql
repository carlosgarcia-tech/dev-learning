-- ============================================================
-- Cálculo de multa: 0.50 € por día de retraso.
--
-- SQLite no tiene procedimientos almacenados (CREATE FUNCTION /
-- CREATE PROCEDURE). La regla de negocio que antes vivía en la
-- función plpgsql calcular_multa() se implementa ahora con un
-- trigger AFTER UPDATE que recalcula la multa cada vez que se
-- fija fecha_devolucion. Es determinista: no usa la fecha actual,
-- solo las fechas del propio préstamo.
-- ============================================================

DROP TRIGGER IF EXISTS tr_calcular_multa;
CREATE TRIGGER tr_calcular_multa
AFTER UPDATE OF fecha_devolucion ON prestamos
FOR EACH ROW
WHEN NEW.fecha_devolucion IS NOT NULL
BEGIN
    UPDATE prestamos
    SET multa = MAX(0, (julianday(NEW.fecha_devolucion) - julianday(NEW.fecha_limite)) * 0.50)
    WHERE id = NEW.id;
END;