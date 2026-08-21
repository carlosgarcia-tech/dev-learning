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

CREATE OR REPLACE FUNCTION obtener_estadisticas_libro(p_libro_id INT)
RETURNS TABLE(
    titulo VARCHAR,
    total_prestamos BIGINT,
    promedio_duracion NUMERIC,
    total_multa NUMERIC
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT
        l.titulo,
        COUNT(p.id) AS total_prestamos,
        COALESCE(AVG(COALESCE(p.fecha_devolucion, CURRENT_DATE) - p.fecha_prestamo::DATE), 0)::NUMERIC AS promedio_duracion,
        COALESCE(SUM(calcular_multa(p.id)), 0)::NUMERIC AS total_multa
    FROM libros l
    LEFT JOIN prestamos p ON l.id = p.libro_id
    WHERE l.id = p_libro_id
    GROUP BY l.id, l.titulo;
END;
$$;

SELECT calcular_multa(1);
SELECT * FROM obtener_estadisticas_libro(1);
