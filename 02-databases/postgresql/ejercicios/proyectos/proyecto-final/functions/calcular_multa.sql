CREATE OR REPLACE FUNCTION calcular_multa(p_prestamo_id INT)
RETURNS DECIMAL
LANGUAGE plpgsql
AS $$
DECLARE
    v_fecha_devolucion DATE;
    v_fecha_prestamo TIMESTAMP;
    v_dias INT;
    v_multa DECIMAL := 0;
BEGIN
    SELECT fecha_prestamo, fecha_devolucion
    INTO v_fecha_prestamo, v_fecha_devolucion
    FROM prestamos
    WHERE id = p_prestamo_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Prestamo % no existe', p_prestamo_id;
    END IF;

    IF v_fecha_devolucion IS NULL THEN
        v_dias := CURRENT_DATE - v_fecha_prestamo::DATE;
    ELSE
        v_dias := v_fecha_devolucion - v_fecha_prestamo::DATE;
    END IF;

    IF v_dias > 14 THEN
        v_multa := (v_dias - 14) * 0.50;
    END IF;

    RETURN v_multa;
END;
$$;
