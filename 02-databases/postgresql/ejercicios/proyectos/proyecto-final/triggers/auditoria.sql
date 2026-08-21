CREATE OR REPLACE FUNCTION tr_auditar_cambios()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO auditoria (tabla, operacion, registro_id, datos_viejos, datos_nuevos, usuario)
    VALUES (
        TG_TABLE_NAME,
        TG_OP,
        COALESCE(NEW.id, OLD.id),
        CASE WHEN TG_OP IN ('UPDATE', 'DELETE') THEN row_to_json(OLD) END,
        CASE WHEN TG_OP IN ('INSERT', 'UPDATE') THEN row_to_json(NEW) END,
        CURRENT_USER
    );
    RETURN COALESCE(NEW, OLD);
END;
$$;

DROP TRIGGER IF EXISTS trigger_auditar_prestamos ON prestamos;
CREATE TRIGGER trigger_auditar_prestamos
AFTER INSERT OR UPDATE OR DELETE ON prestamos
FOR EACH ROW
EXECUTE FUNCTION tr_auditar_cambios();

DROP TRIGGER IF EXISTS trigger_auditar_libros ON libros;
CREATE TRIGGER trigger_auditar_libros
AFTER INSERT OR UPDATE OR DELETE ON libros
FOR EACH ROW
EXECUTE FUNCTION tr_auditar_cambios();
