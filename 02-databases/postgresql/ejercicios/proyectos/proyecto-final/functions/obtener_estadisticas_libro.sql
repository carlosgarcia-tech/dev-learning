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
