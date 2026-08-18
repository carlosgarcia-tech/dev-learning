SELECT id, cliente_id, estado, total FROM pedidos WHERE id = 13;
SELECT producto_id, cantidad FROM detalle_pedidos WHERE pedido_id = 13 ORDER BY producto_id;
SELECT nombre, stock FROM productos WHERE id IN (1, 3) ORDER BY id;
SELECT id, pedido_id, metodo, monto FROM pagos WHERE pedido_id = 13;