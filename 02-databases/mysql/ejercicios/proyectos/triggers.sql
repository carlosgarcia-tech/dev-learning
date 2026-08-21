-- ============================================================
-- Proyecto Final: Sistema de Inventario y Ventas (MySQL)
-- triggers.sql — Triggers de auditoría y validación
-- ============================================================

DELIMITER //

-- ============================================================
-- trg_audit_producto_update: audita cambios de precio en productos
-- ============================================================
CREATE TRIGGER trg_audit_producto_update
BEFORE UPDATE ON productos
FOR EACH ROW
BEGIN
  IF OLD.precio <> NEW.precio THEN
    INSERT INTO auditoria (tabla, registro_id, accion, descripcion, usuario)
    VALUES ('productos', NEW.id, 'UPDATE',
            CONCAT('Precio cambiado de ', OLD.precio, ' a ', NEW.precio),
            CURRENT_USER());
  END IF;

  IF OLD.stock <> NEW.stock THEN
    INSERT INTO auditoria (tabla, registro_id, accion, descripcion, usuario)
    VALUES ('productos', NEW.id, 'UPDATE',
            CONCAT('Stock cambiado de ', OLD.stock, ' a ', NEW.stock),
            CURRENT_USER());
  END IF;
END //

-- ============================================================
-- trg_audit_producto_insert: audita inserciones de productos
-- ============================================================
CREATE TRIGGER trg_audit_producto_insert
AFTER INSERT ON productos
FOR EACH ROW
BEGIN
  INSERT INTO auditoria (tabla, registro_id, accion, descripcion, usuario)
  VALUES ('productos', NEW.id, 'INSERT',
          CONCAT('Producto creado: ', NEW.nombre, ' (stock=', NEW.stock, ')'),
          CURRENT_USER());
END //

-- ============================================================
-- trg_audit_producto_delete: audita eliminaciones de productos
-- ============================================================
CREATE TRIGGER trg_audit_producto_delete
AFTER DELETE ON productos
FOR EACH ROW
BEGIN
  INSERT INTO auditoria (tabla, registro_id, accion, descripcion, usuario)
  VALUES ('productos', OLD.id, 'DELETE',
          CONCAT('Producto eliminado: ', OLD.nombre),
          CURRENT_USER());
END //

-- ============================================================
-- trg_verificar_stock: valida stock en cada detalle de venta
-- ============================================================
CREATE TRIGGER trg_verificar_stock
BEFORE INSERT ON detalle_ventas
FOR EACH ROW
BEGIN
  DECLARE v_stock_disponible INT;

  SELECT stock INTO v_stock_disponible
  FROM productos WHERE id = NEW.producto_id;

  IF v_stock_disponible < NEW.cantidad THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Stock insuficiente para completar la venta';
  END IF;

  -- Calcular subtotal automáticamente si no viene
  IF NEW.subtotal IS NULL OR NEW.subtotal = 0 THEN
    SET NEW.subtotal = NEW.cantidad * NEW.precio_unitario;
  END IF;
END //

DELIMITER ;
