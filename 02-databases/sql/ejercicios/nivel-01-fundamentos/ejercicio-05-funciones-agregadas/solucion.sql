SELECT COUNT(*) AS total_productos FROM productos;
SELECT ROUND(AVG(precio), 2) AS precio_promedio FROM productos;
SELECT MAX(precio) AS maximo, MIN(precio) AS minimo FROM productos;
SELECT SUM(precio) AS suma_total FROM productos;
SELECT COUNT(*) AS con_stock FROM productos WHERE stock > 0;
