-- Consulta optimizada con CTE
WITH disponibles AS (
    SELECT p.id, p.nombre, p.precio, p.categoria_id
    FROM productos p
    WHERE p.activo = TRUE AND p.stock_actual > 0
)
SELECT d.*, c.nombre AS categoria
FROM disponibles d
INNER JOIN categorias c ON d.categoria_id = c.id
ORDER BY d.precio DESC
LIMIT 100;

CREATE INDEX IF NOT EXISTS idx_productos_activo_stock ON productos(activo, stock_actual);

-- Materialized view para dashboard
CREATE MATERIALIZED VIEW mv_ventas_diarias AS
SELECT DATE_TRUNC('day', fecha) AS dia, COUNT(*) AS total_pedidos, SUM(total) AS total_ventas
FROM pedidos
WHERE estado = 'pagado'
GROUP BY DATE_TRUNC('day', fecha);

CREATE OR REPLACE FUNCTION refresh_ventas_diarias()
RETURNS VOID
LANGUAGE plpgsql
AS $$
BEGIN
    REFRESH MATERIALIZED VIEW mv_ventas_diarias;
END;
$$;

-- Monitoreo basico
CREATE OR REPLACE FUNCTION monitoreo_rendimiento()
RETURNS TABLE(parametro VARCHAR, valor TEXT)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT 'Conexiones activas'::VARCHAR, (SELECT COUNT(*) FROM pg_stat_activity)::TEXT
    UNION ALL
    SELECT 'Tamano DB', pg_size_pretty(pg_database_size(current_database()))
    UNION ALL
    SELECT 'Indices no usados', (SELECT COUNT(*) FROM pg_stat_user_indexes WHERE idx_scan = 0)::TEXT;
END;
$$;

SELECT * FROM mv_ventas_diarias;
SELECT * FROM monitoreo_rendimiento();
