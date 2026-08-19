-- El modelo se define en schema.sql. Estas consultas demuestran que las
-- relaciones del modelo funcionan: N:1 (producto->categoría/proveedor),
-- 1:N (pedido->detalle, cliente->direcciones) y N:N (carrito).

PRAGMA foreign_keys = ON;

-- 1. Productos con su categoría y proveedor (relación N:1)
SELECT
    p.nombre,
    p.sku,
    p.precio,
    p.stock,
    c.nombre AS categoria,
    pr.nombre AS proveedor
FROM productos p
INNER JOIN categorias c ON c.id = p.categoria_id
INNER JOIN proveedores pr ON pr.id = p.proveedor_id
ORDER BY p.id;

-- 2. Pedidos con cliente, dirección y método de pago (relaciones 1:N)
SELECT
    pd.id,
    cl.nombre AS cliente,
    d.ciudad,
    mp.tipo AS metodo_pago,
    pd.fecha,
    pd.total,
    pd.estado
FROM pedidos pd
INNER JOIN clientes cl ON cl.id = pd.cliente_id
INNER JOIN direcciones d ON d.id = pd.direccion_id
INNER JOIN metodos_pago mp ON mp.id = pd.metodo_pago_id
ORDER BY pd.id;

-- 3. Líneas de detalle del pedido 1 (relación 1:N pedido->detalle)
SELECT
    dp.pedido_id,
    pr.nombre AS producto,
    dp.cantidad,
    dp.precio_unitario,
    ROUND(dp.cantidad * dp.precio_unitario, 2) AS subtotal
FROM detalle_pedido dp
INNER JOIN productos pr ON pr.id = dp.producto_id
WHERE dp.pedido_id = 1
ORDER BY dp.id;

-- 4. Carrito de compra (relación N:N clientes-productos)
SELECT
    c.nombre AS cliente,
    pr.nombre AS producto,
    cr.cantidad,
    cr.fecha_agregado
FROM carrito cr
INNER JOIN clientes c ON c.id = cr.cliente_id
INNER JOIN productos pr ON pr.id = cr.producto_id
ORDER BY cr.id;

-- 5. Seguimiento de pedidos (historial de estados de un pedido)
SELECT
    sp.pedido_id,
    sp.estado,
    sp.fecha,
    sp.notas
FROM seguimiento_pedido sp
ORDER BY sp.pedido_id, sp.id;