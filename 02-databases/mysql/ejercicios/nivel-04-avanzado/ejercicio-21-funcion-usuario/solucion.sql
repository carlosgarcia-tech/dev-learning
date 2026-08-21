-- MYSQL-ONLY START
DELIMITER //
CREATE FUNCTION fn_precio_con_iva(p_precio DECIMAL(10,2))
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    RETURN p_precio * 1.21;
END //
DELIMITER ;

SELECT nombre, precio, fn_precio_con_iva(precio) AS precio_iva
FROM productos ORDER BY id;
-- MYSQL-ONLY END

-- Fallback SQLite: cálculo equivalente sin función
-- MYSQL-ONLY START
SELECT nombre, precio, ROUND(precio * 1.21, 2) AS precio_iva
FROM productos ORDER BY id;
-- MYSQL-ONLY END
