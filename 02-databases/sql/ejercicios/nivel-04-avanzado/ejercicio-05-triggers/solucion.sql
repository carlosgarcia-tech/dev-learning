-- Trigger 1: recalcular el total del pedido al insertar un detalle.
CREATE TRIGGER tr_actualizar_total_insert
AFTER INSERT ON detalle_pedido
BEGIN
    UPDATE pedidos
    SET total = COALESCE(
        (SELECT SUM(cantidad * precio_unitario)
         FROM detalle_pedido
         WHERE pedido_id = NEW.pedido_id),
        0)
    WHERE id = NEW.pedido_id;
END;

-- Trigger 1b: recalcular el total al actualizar un detalle.
CREATE TRIGGER tr_actualizar_total_update
AFTER UPDATE ON detalle_pedido
BEGIN
    UPDATE pedidos
    SET total = COALESCE(
        (SELECT SUM(cantidad * precio_unitario)
         FROM detalle_pedido
         WHERE pedido_id = NEW.pedido_id),
        0)
    WHERE id = NEW.pedido_id;
END;

-- Trigger 1c: recalcular el total al borrar un detalle.
CREATE TRIGGER tr_actualizar_total_delete
AFTER DELETE ON detalle_pedido
BEGIN
    UPDATE pedidos
    SET total = COALESCE(
        (SELECT SUM(cantidad * precio_unitario)
         FROM detalle_pedido
         WHERE pedido_id = OLD.pedido_id),
        0)
    WHERE id = OLD.pedido_id;
END;

-- Trigger 2: auditoría de pedidos (SQLite no tiene TG_OP ni row_to_json;
-- guardamos la acción y una representación de texto del registro).
CREATE TRIGGER tr_auditar_pedido
AFTER INSERT ON pedidos
BEGIN
    INSERT INTO auditoria (tabla, accion, datos, fecha)
    VALUES (
        'pedidos',
        'INSERT',
        'id=' || NEW.id || ', cliente_id=' || NEW.cliente_id || ', total=' || NEW.total,
        NEW.fecha
    );
END;

-- Demo: al insertar el primer detalle el trigger recalcula el total (2 * 999.99)
INSERT INTO detalle_pedido (pedido_id, producto_id, cantidad, precio_unitario)
VALUES (1, 1, 2, 999.99);

SELECT id, cliente_id, fecha, total, estado FROM pedidos WHERE id = 1;

-- Demo: un segundo detalle suma al total (999.99 * 2 + 599.99)
INSERT INTO detalle_pedido (pedido_id, producto_id, cantidad, precio_unitario)
VALUES (1, 2, 1, 599.99);

-- Demo: actualizar una línea recalcula el total (999.99 + 599.99)
UPDATE detalle_pedido SET cantidad = 1 WHERE id = 1;

SELECT id, cliente_id, fecha, total, estado FROM pedidos WHERE id = 1;

-- Demo: borrar una línea recalcula el total (queda 999.99)
DELETE FROM detalle_pedido WHERE id = 2;

SELECT id, cliente_id, fecha, total, estado FROM pedidos WHERE id = 1;

-- Demo: al insertar un pedido la auditoría registra el evento
INSERT INTO pedidos (id, cliente_id, fecha, total, estado)
VALUES (3, 2, '2024-02-01', 0, 'pendiente');

SELECT tabla, accion, datos, fecha FROM auditoria ORDER BY id;