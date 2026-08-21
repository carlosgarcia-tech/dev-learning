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

DROP TRIGGER IF EXISTS trigger_validar_stock ON prestamos;
CREATE TRIGGER trigger_validar_stock
BEFORE INSERT ON prestamos
FOR EACH ROW
EXECUTE FUNCTION tr_validar_stock_prestamo();
