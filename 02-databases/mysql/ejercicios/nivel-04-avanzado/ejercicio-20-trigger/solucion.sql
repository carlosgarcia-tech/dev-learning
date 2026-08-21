-- MYSQL-ONLY START
DELIMITER //
CREATE TRIGGER trg_auditar_insert
AFTER INSERT ON productos
FOR EACH ROW
BEGIN
    INSERT INTO auditoria (producto_id, accion, nombre) VALUES (NEW.id, 'INSERT', NEW.nombre);
END //
DELIMITER ;

INSERT INTO productos (nombre, precio) VALUES ('Webcam', 60.00);
SELECT producto_id, accion, nombre FROM auditoria ORDER BY id;
-- MYSQL-ONLY END

-- Fallback SQLite: equivalente manual (sin trigger, simulando el resultado)
-- MYSQL-ONLY START
INSERT INTO productos (nombre, precio) VALUES ('Webcam', 60.00);
INSERT INTO auditoria (producto_id, accion, nombre)
  SELECT id, 'INSERT', nombre FROM productos WHERE nombre = 'Webcam';
SELECT producto_id, accion, nombre FROM auditoria ORDER BY id;
-- MYSQL-ONLY END
