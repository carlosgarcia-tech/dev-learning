BEGIN;
INSERT INTO detalle_pedidos (pedido_id, producto_id, cantidad, precio_unitario)
VALUES (12, 1, 2, 89.99);
SELECT nombre, stock FROM productos WHERE id = 1;
SELECT tipo, cantidad, motivo FROM inventario_movimientos
WHERE producto_id = 1 AND tipo = 'salida' ORDER BY id;
ROLLBACK;