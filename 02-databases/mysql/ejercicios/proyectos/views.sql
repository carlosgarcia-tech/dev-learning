-- ============================================================
-- Proyecto Final: Sistema de Inventario y Ventas (MySQL)
-- views.sql — Vistas de reportes
-- ============================================================

-- ============================================================
-- vw_inventario_actual: estado actual del inventario con valor
-- ============================================================
CREATE OR REPLACE VIEW vw_inventario_actual AS
SELECT
    p.id,
    p.codigo,
    p.nombre,
    c.nombre AS categoria,
    p.precio,
    p.costo,
    p.stock,
    p.stock_minimo,
    (p.precio * p.stock) AS valor_venta,
    (p.costo * p.stock) AS valor_costo,
    (p.precio - p.costo) * p.stock AS margen_potencial,
    CASE
      WHEN p.stock = 0 THEN 'Agotado'
      WHEN p.stock < p.stock_minimo THEN 'Stock bajo'
      ELSE 'Normal'
    END AS estado_stock
FROM productos p
INNER JOIN categorias c ON p.categoria_id = c.id
WHERE p.activo = 1;

-- ============================================================
-- vw_ventas_por_cliente: total y número de ventas por cliente
-- ============================================================
CREATE OR REPLACE VIEW vw_ventas_por_cliente AS
SELECT
    cl.id AS cliente_id,
    cl.nombre AS cliente,
    COUNT(v.id) AS total_ventas,
    COALESCE(SUM(v.total), 0) AS monto_total,
    MAX(v.fecha) AS ultima_compra
FROM clientes cl
LEFT JOIN ventas v ON cl.id = v.cliente_id
GROUP BY cl.id, cl.nombre;

-- ============================================================
-- vw_productos_mas_vendidos: ranking de productos por cantidad
-- ============================================================
CREATE OR REPLACE VIEW vw_productos_mas_vendidos AS
SELECT
    p.id,
    p.nombre,
    c.nombre AS categoria,
    COALESCE(SUM(dv.cantidad), 0) AS unidades_vendidas,
    COALESCE(SUM(dv.subtotal), 0) AS ingresos_totales
FROM productos p
INNER JOIN categorias c ON p.categoria_id = c.id
LEFT JOIN detalle_ventas dv ON p.id = dv.producto_id
GROUP BY p.id, p.nombre, c.nombre;

-- ============================================================
-- vw_stock_bajo: productos que necesitan reabastecimiento
-- ============================================================
CREATE OR REPLACE VIEW vw_stock_bajo AS
SELECT
    p.id,
    p.codigo,
    p.nombre,
    c.nombre AS categoria,
    p.stock,
    p.stock_minimo,
    (p.stock_minimo - p.stock) AS deficit,
    p.precio
FROM productos p
INNER JOIN categorias c ON p.categoria_id = c.id
WHERE p.stock < p.stock_minimo
ORDER BY deficit DESC;

-- ============================================================
-- vw_resumen_diario_ventas: totales de ventas por día
-- ============================================================
CREATE OR REPLACE VIEW vw_resumen_diario_ventas AS
SELECT
    DATE(v.fecha) AS fecha,
    COUNT(*) AS numero_ventas,
    SUM(v.total) AS total_ventas,
    AVG(v.total) AS promedio_venta
FROM ventas v
WHERE v.estado IN ('pagada', 'enviada')
GROUP BY DATE(v.fecha)
ORDER BY fecha DESC;
