-- Ranking de productos
SELECT
    nombre,
    precio,
    RANK() OVER (ORDER BY precio DESC) AS ranking
FROM productos;

-- Total acumulado de ventas
SELECT
    fecha,
    total,
    SUM(total) OVER (ORDER BY fecha) AS total_acumulado
FROM pedidos;

-- Promedio móvil de los últimos 3 pedidos
SELECT
    fecha,
    total,
    AVG(total) OVER (
        ORDER BY fecha
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS promedio_movil_3
FROM pedidos;

-- Producto más caro por categoría (forma correcta, con CTE)
WITH productos_rankeados AS (
    SELECT
        nombre,
        categoria_id,
        precio,
        ROW_NUMBER() OVER (PARTITION BY categoria_id ORDER BY precio DESC) AS posicion
    FROM productos
)
SELECT nombre, categoria_id, precio
FROM productos_rankeados
WHERE posicion = 1;
