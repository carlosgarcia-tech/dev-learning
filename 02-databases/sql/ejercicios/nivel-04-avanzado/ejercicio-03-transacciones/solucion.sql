-- Habilita el enforcement de claves foráneas (por defecto SQLite no lo aplica)
PRAGMA foreign_keys = ON;

-- Transacción completa: crear pedido, insertar detalle, descontar stock
-- y calcular el total. Todo se confirma junta con COMMIT.
BEGIN;

INSERT INTO pedidos (cliente_id, fecha, total, estado)
VALUES (1, '2024-01-10', 0, 'pendiente');

INSERT INTO detalle_pedido (pedido_id, producto_id, cantidad, precio_unitario)
VALUES (1, 1, 2, 299.99);

UPDATE productos SET stock = stock - 2 WHERE id = 1;

UPDATE pedidos
SET total = (SELECT SUM(cantidad * precio_unitario)
             FROM detalle_pedido
             WHERE pedido_id = 1)
WHERE id = 1;

COMMIT;

-- Resultado de la transacción
SELECT id, cliente_id, fecha, total, estado FROM pedidos WHERE id = 1;

SELECT id, pedido_id, producto_id, cantidad, precio_unitario
FROM detalle_pedido WHERE pedido_id = 1;

SELECT id, nombre, stock FROM productos WHERE id = 1;

-- Con SAVEPOINT: se inserta un detalle tras el punto de guardado y luego
-- se revierte. El pedido queda sin líneas de detalle.
BEGIN;

INSERT INTO pedidos (cliente_id, fecha, total, estado)
VALUES (2, '2024-01-12', 0, 'pendiente');

SAVEPOINT antes_detalle;

INSERT INTO detalle_pedido (pedido_id, producto_id, cantidad, precio_unitario)
VALUES (2, 1, 1, 299.99);

ROLLBACK TO SAVEPOINT antes_detalle;

COMMIT;

-- El pedido 2 existe pero su detalle fue descartado por el SAVEPOINT
SELECT id, cliente_id, fecha, total, estado FROM pedidos WHERE id = 2;

SELECT COUNT(*) AS lineas_pedido_2 FROM detalle_pedido WHERE pedido_id = 2;