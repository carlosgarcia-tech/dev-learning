-- Pedidos con clientes
SELECT
    p.id AS pedido_id,
    c.nombre AS cliente,
    p.fecha,
    p.total
FROM pedidos p
INNER JOIN clientes c ON p.cliente_id = c.id;

-- Detalle completo
SELECT
    c.nombre AS cliente,
    pr.nombre AS producto,
    dp.cantidad,
    pr.precio,
    dp.cantidad * pr.precio AS subtotal
FROM pedidos p
INNER JOIN clientes c ON p.cliente_id = c.id
INNER JOIN detalle_pedido dp ON p.id = dp.pedido_id
INNER JOIN productos pr ON dp.producto_id = pr.id;
