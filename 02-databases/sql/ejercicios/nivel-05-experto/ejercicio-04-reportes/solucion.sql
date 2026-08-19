-- Reportes de negocio. SQLite no tiene procedimientos almacenados: cada
-- reporte es una sentencia SQL directa. DATE_TRUNC se sustituye por
-- strftime('%Y-%m', ...) y el filtro de "año actual" por un literal.

-- 1) Ingresos mensuales (todos los estados de pedido)
SELECT
    strftime('%Y-%m', fecha) AS mes,
    ROUND(SUM(total), 2) AS ingresos,
    COUNT(*) AS pedidos,
    ROUND(AVG(total), 2) AS ticket_promedio
FROM pedidos
WHERE fecha >= '2024-01-01'
GROUP BY strftime('%Y-%m', fecha)
ORDER BY mes;

-- 2) Productos más vendidos por unidades e ingresos
SELECT
    pr.nombre,
    SUM(dp.cantidad) AS unidades_vendidas,
    ROUND(SUM(dp.cantidad * pr.precio), 2) AS ingresos,
    pr.precio
FROM productos pr
INNER JOIN detalle_pedido dp ON pr.id = dp.producto_id
GROUP BY pr.id, pr.nombre, pr.precio
ORDER BY ingresos DESC, unidades_vendidas DESC, pr.nombre
LIMIT 10;

-- 3) Clientes por valor (RFM simplificado)
SELECT
    c.nombre,
    COUNT(p.id) AS total_pedidos,
    ROUND(COALESCE(SUM(p.total), 0), 2) AS total_gastado,
    MAX(p.fecha) AS ultima_compra,
    CASE
        WHEN COALESCE(SUM(p.total), 0) > 1000 AND COUNT(p.id) > 5 THEN 'VIP'
        WHEN COALESCE(SUM(p.total), 0) > 500 AND COUNT(p.id) > 2 THEN 'Premium'
        WHEN COUNT(p.id) > 0 THEN 'Regular'
        ELSE 'Nuevo'
    END AS categoria_cliente
FROM clientes c
LEFT JOIN pedidos p ON c.id = p.cliente_id AND p.estado IN ('pagado', 'entregado')
GROUP BY c.id, c.nombre
ORDER BY total_gastado DESC, c.nombre;