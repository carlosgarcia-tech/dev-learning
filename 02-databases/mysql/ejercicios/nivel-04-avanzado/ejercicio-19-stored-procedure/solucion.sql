-- MYSQL-ONLY START
DELIMITER //
CREATE PROCEDURE sp_productos_por_categoria(IN p_categoria VARCHAR(50))
BEGIN
    SELECT id, nombre, precio
    FROM productos
    WHERE categoria = p_categoria
    ORDER BY precio DESC;
END //
DELIMITER ;

CALL sp_productos_por_categoria('electronica');
-- MYSQL-ONLY END

-- Fallback SQLite: consulta equivalente (para validación sin MySQL)
-- Esta parte se ejecuta solo si MySQL no está disponible
-- MYSQL-ONLY START
SELECT id, nombre, precio FROM productos WHERE categoria = 'electronica' ORDER BY precio DESC;
-- MYSQL-ONLY END
