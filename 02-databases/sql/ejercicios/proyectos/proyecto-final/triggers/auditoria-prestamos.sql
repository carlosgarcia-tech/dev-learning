-- ============================================================
-- Auditoría de préstamos.
--
-- En PostgreSQL se usaba una única función plpgsql con TG_OP y
-- row_to_json(). SQLite no tiene TG_OP: se define un trigger por
-- evento, cada uno con su literal 'INSERT' / 'UPDATE' / 'DELETE'.
-- El campo datos es TEXT (equivalente al JSONB de PostgreSQL).
-- ============================================================

DROP TRIGGER IF EXISTS tr_auditar_prestamo_insert;
CREATE TRIGGER tr_auditar_prestamo_insert
AFTER INSERT ON prestamos
FOR EACH ROW
BEGIN
    INSERT INTO auditoria_prestamos (prestamo_id, accion, datos)
    VALUES (
        NEW.id,
        'INSERT',
        '{"id":' || NEW.id ||
        ',"libro_id":' || NEW.libro_id ||
        ',"usuario_id":' || NEW.usuario_id ||
        ',"fecha_prestamo":"' || NEW.fecha_prestamo || '"' ||
        ',"fecha_limite":"' || NEW.fecha_limite || '"' ||
        ',"fecha_devolucion":"' || COALESCE(NEW.fecha_devolucion, '') || '"' ||
        ',"multa":' || COALESCE(NEW.multa, 0) ||
        ',"estado":"' || NEW.estado || '"}'
    );
END;

DROP TRIGGER IF EXISTS tr_auditar_prestamo_update;
CREATE TRIGGER tr_auditar_prestamo_update
AFTER UPDATE ON prestamos
FOR EACH ROW
BEGIN
    INSERT INTO auditoria_prestamos (prestamo_id, accion, datos)
    VALUES (
        NEW.id,
        'UPDATE',
        '{"old":{"fecha_devolucion":"' || COALESCE(OLD.fecha_devolucion, '') ||
        '","estado":"' || OLD.estado ||
        '"},"new":{"fecha_devolucion":"' || COALESCE(NEW.fecha_devolucion, '') ||
        '","estado":"' || NEW.estado ||
        '","multa":' || COALESCE(NEW.multa, 0) || '}}'
    );
END;

DROP TRIGGER IF EXISTS tr_auditar_prestamo_delete;
CREATE TRIGGER tr_auditar_prestamo_delete
AFTER DELETE ON prestamos
FOR EACH ROW
BEGIN
    INSERT INTO auditoria_prestamos (prestamo_id, accion, datos)
    VALUES (
        OLD.id,
        'DELETE',
        '{"id":' || OLD.id ||
        ',"libro_id":' || OLD.libro_id ||
        ',"usuario_id":' || OLD.usuario_id ||
        ',"estado":"' || OLD.estado || '"}'
    );
END;