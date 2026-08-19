-- Vista de clientes activos
CREATE VIEW vista_clientes_activos AS
SELECT * FROM clientes WHERE activo = true;

-- Vista de productos disponibles
CREATE VIEW vista_productos_disponibles AS
SELECT * FROM productos WHERE stock > 0;

-- Vista de ventas por mes
CREATE VIEW vista_ventas_mes AS
SELECT
    strftime('%Y-%m', fecha) AS mes,
    COUNT(*) AS total_pedidos,
    SUM(total) AS total_ventas
FROM pedidos
GROUP BY strftime('%Y-%m', fecha)
ORDER BY mes;

-- Usar vistas
SELECT * FROM vista_clientes_activos;
SELECT * FROM vista_productos_disponibles ORDER BY precio DESC;
SELECT * FROM vista_ventas_mes;