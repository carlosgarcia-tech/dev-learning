CREATE OR REPLACE FUNCTION tr_validar_stock_prestamo()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_stock INT;
BEGIN
    SELECT cantidad INTO v_stock FROM libros WHERE id = NEW.libro_id;

    IF v_stock < 1 THEN
        RAISE EXCEPTION 'No hay ejemplares disponibles de este libro';
    END IF;

    UPDATE libros SET cantidad = cantidad - 1 WHERE id = NEW.libro_id;

    RETURN NEW;
END;
$$;

CREATE TRIGGER trigger_validar_stock
BEFORE INSERT ON prestamos
FOR EACH ROW
EXECUTE FUNCTION tr_validar_stock_prestamo();

CREATE TABLE auditoria (
    id SERIAL PRIMARY KEY,
    tabla VARCHAR(50),
    operacion VARCHAR(10),
    datos JSONB,
    usuario VARCHAR(50),
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE OR REPLACE FUNCTION tr_auditar_cambios()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO auditoria (tabla, operacion, datos, usuario)
    VALUES (
        TG_TABLE_NAME,
        TG_OP,
        CASE WHEN TG_OP = 'DELETE' THEN row_to_json(OLD) ELSE row_to_json(NEW) END,
        CURRENT_USER
    );
    RETURN COALESCE(NEW, OLD);
END;
$$;

CREATE TRIGGER trigger_auditar_prestamos
AFTER INSERT OR UPDATE OR DELETE ON prestamos
FOR EACH ROW
EXECUTE FUNCTION tr_auditar_cambios();

-- Prueba: esto debe descontar stock y generar una fila de auditoria
INSERT INTO prestamos (libro_id, usuario_id) VALUES (1, 1);
