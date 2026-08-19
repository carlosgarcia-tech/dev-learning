-- SQLite no tiene PROCEDURE/FUNCTION como PostgreSQL. Recreamos los mismos
-- tres conceptos (actualizar stock con validación, calcular total de pedido
-- y reporte mensual) con sentencias SQL directas sobre un pedido real.

-- 1) Crear un pedido real
INSERT INTO pedidos (id, cliente_id, fecha, total, estado)
VALUES (5, 2, '2024-01-15', 0, 'pendiente');

-- 2) Añadir su detalle
INSERT INTO detalle_pedido (pedido_id, producto_id, cantidad, precio_unitario)
VALUES (5, 1, 2, 999.99);

-- 3) Actualizar stock con validación (equivalente al procedimiento
--    actualizar_stock): solo descuenta si hay stock suficiente.
SELECT CASE WHEN stock >= 2 THEN 'ok' ELSE 'insuficiente' END AS validacion_stock
FROM productos WHERE id = 1;

UPDATE productos
SET stock = stock - 2
WHERE id = 1 AND stock >= 2;

-- 4) Calcular el total del pedido (equivalente a la función
--    calcular_total_pedido).
UPDATE pedidos
SET total = (SELECT COALESCE(SUM(cantidad * precio_unitario), 0)
             FROM detalle_pedido
             WHERE pedido_id = 5)
WHERE id = 5;

-- 5) Resultado del pedido creado
SELECT p.id, p.cliente_id, p.fecha, p.total, p.estado,
       (SELECT COUNT(*) FROM detalle_pedido dp WHERE dp.pedido_id = p.id) AS lineas
FROM pedidos p
WHERE p.id = 5;

SELECT id, nombre, stock FROM productos WHERE id = 1;

-- 6) Reporte mensual (equivalente al procedimiento generar_reporte_mensual):
--    ventas por cliente en enero de 2024.
SELECT
    c.nombre AS cliente,
    COUNT(p.id) AS total_pedidos,
    COALESCE(SUM(p.total), 0) AS total_gastado
FROM clientes c
INNER JOIN pedidos p ON c.id = p.cliente_id
WHERE strftime('%m', p.fecha) = '01'
  AND strftime('%Y', p.fecha) = '2024'
GROUP BY c.id, c.nombre
ORDER BY total_gastado DESC;