-- ============================================================
-- Proyecto Final: Sistema de Inventario y Ventas (MySQL)
-- procedures.sql — Stored procedures
-- ============================================================

-- ============================================================
-- sp_registrar_venta: registra una venta completa con su detalle
-- Parámetros:
--   p_cliente_id  → ID del cliente
--   p_productos   → cadena con IDs y cantidades: "id1:cant1,id2:cant2,..."
--                  (formato simple para demostración)
-- ============================================================
DELIMITER //

CREATE PROCEDURE sp_registrar_venta(
  IN p_cliente_id INT UNSIGNED,
  IN p_productos VARCHAR(1000)
)
BEGIN
  DECLARE v_venta_id INT UNSIGNED;
  DECLARE v_total DECIMAL(10,2) DEFAULT 0.00;
  DECLARE v_producto_id INT UNSIGNED;
  DECLARE v_cantidad INT;
  DECLARE v_precio DECIMAL(10,2);
  DECLARE v_subtotal DECIMAL(10,2);
  DECLARE v_stock INT;

  -- Crear la cabecera de la venta
  INSERT INTO ventas (cliente_id, fecha, total, estado)
  VALUES (p_cliente_id, NOW(), 0.00, 'pendiente');

  SET v_venta_id = LAST_INSERT_ID();

  -- Procesar cada par id:cantidad (formato simplificado: un solo producto por llamada de demo)
  -- En producción se usaría un cursor o JSON_TABLE; aquí procesamos el primer par.
  SET v_producto_id = CAST(SUBSTRING_INDEX(p_productos, ':', 1) AS UNSIGNED);
  SET v_cantidad = CAST(
    SUBSTRING_INDEX(SUBSTRING_INDEX(p_productos, ',', 1), ':', -1)
    AS UNSIGNED
  );

  -- Verificar stock
  SELECT stock, precio INTO v_stock, v_precio
  FROM productos WHERE id = v_producto_id;

  IF v_stock < v_cantidad THEN
    -- Stock insuficiente: cancelar
    UPDATE ventas SET estado = 'cancelada', notas = 'Stock insuficiente'
    WHERE id = v_venta_id;
    SELECT v_venta_id AS venta_id, 'cancelada' AS estado, 'Stock insuficiente' AS mensaje;
  ELSE
    -- Calcular subtotal
    SET v_subtotal = v_precio * v_cantidad;
    SET v_total = v_total + v_subtotal;

    -- Insertar detalle
    INSERT INTO detalle_ventas (venta_id, producto_id, cantidad, precio_unitario, subtotal)
    VALUES (v_venta_id, v_producto_id, v_cantidad, v_precio, v_subtotal);

    -- Restar stock
    UPDATE productos SET stock = stock - v_cantidad WHERE id = v_producto_id;

    -- Registrar movimiento de inventario
    INSERT INTO movimientos_inventario (producto_id, tipo, cantidad, motivo, referencia)
    VALUES (v_producto_id, 'salida', v_cantidad, 'Venta', CONCAT('VENTA-', v_venta_id));

    -- Actualizar total de la venta
    UPDATE ventas SET total = v_total, estado = 'pagada' WHERE id = v_venta_id;

    SELECT v_venta_id AS venta_id, 'pagada' AS estado, 'Venta registrada' AS mensaje;
  END IF;
END //

-- ============================================================
-- sp_actualizar_stock: ajusta el stock de un producto manualmente
-- ============================================================
CREATE PROCEDURE sp_actualizar_stock(
  IN p_producto_id INT UNSIGNED,
  IN p_cantidad INT,
  IN p_motivo VARCHAR(200)
)
BEGIN
  UPDATE productos
  SET stock = stock + p_cantidad
  WHERE id = p_producto_id;

  INSERT INTO movimientos_inventario (producto_id, tipo, cantidad, motivo)
  VALUES (p_producto_id,
    IF(p_cantidad >= 0, 'entrada', 'salida'),
    ABS(p_cantidad),
    p_motivo);

  SELECT p_producto_id AS producto_id, stock AS nuevo_stock
  FROM productos WHERE id = p_producto_id;
END //

-- ============================================================
-- sp_reabastecer: marca productos con stock bajo para reabastecer
-- ============================================================
CREATE PROCEDURE sp_reabastecer()
BEGIN
  SELECT p.id, p.nombre, p.stock, p.stock_minimo,
         (p.stock_minimo - p.stock) AS cantidad_recomendada
  FROM productos p
  WHERE p.stock < p.stock_minimo
  ORDER BY cantidad_recomendada DESC;
END //

DELIMITER ;
