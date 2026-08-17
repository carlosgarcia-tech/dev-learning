PRAGMA foreign_keys = ON;
BEGIN;
INSERT INTO pedidos (id, cliente_id, fecha, estado, total)
VALUES (14, 3, '2024-03-21', 'pagado', 100.00);
INSERT INTO detalle_pedidos (pedido_id, producto_id, cantidad, precio_unitario)
VALUES (14, 999, 1, 100.00);
ROLLBACK;
SELECT COUNT(*) AS pedido_14 FROM pedidos WHERE id = 14;
SELECT nombre, stock FROM productos WHERE id = 1;