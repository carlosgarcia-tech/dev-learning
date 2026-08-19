-- Dashboard de ventas: CTEs, agregaciones y window functions.
-- DATE_TRUNC('month', ...) de PostgreSQL se sustituye por strftime('%Y-%m', ...).

WITH
ventas_por_cliente AS (
    SELECT
        c.id AS cliente_id,
        c.nombre,
        COUNT(p.id) AS total_pedidos,
        ROUND(COALESCE(SUM(p.total), 0), 2) AS total_gastado,
        ROUND(AVG(p.total), 2) AS promedio_pedido
    FROM clientes c
    LEFT JOIN pedidos p ON c.id = p.cliente_id
    GROUP BY c.id, c.nombre
),
ranking_clientes AS (
    SELECT
        *,
        RANK() OVER (ORDER BY total_gastado DESC, total_pedidos DESC, cliente_id) AS ranking_gasto,
        RANK() OVER (ORDER BY total_pedidos DESC, total_gastado DESC, cliente_id) AS ranking_pedidos
    FROM ventas_por_cliente
),
ventas_por_mes AS (
    SELECT
        strftime('%Y-%m', fecha) AS mes,
        ROUND(SUM(total), 2) AS total_ventas,
        COUNT(*) AS total_pedidos,
        COUNT(DISTINCT cliente_id) AS clientes_unicos
    FROM pedidos
    GROUP BY strftime('%Y-%m', fecha)
)
SELECT
    rc.cliente_id,
    rc.nombre,
    rc.total_pedidos,
    rc.total_gastado,
    rc.promedio_pedido,
    rc.ranking_gasto,
    rc.ranking_pedidos,
    vm.mes,
    vm.total_ventas AS ventas_mes,
    vm.total_pedidos AS pedidos_mes
FROM ranking_clientes rc
CROSS JOIN ventas_por_mes vm
ORDER BY rc.ranking_gasto, rc.cliente_id, vm.mes;