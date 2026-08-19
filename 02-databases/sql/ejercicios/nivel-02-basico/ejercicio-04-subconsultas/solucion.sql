-- Productos con precio mayor al promedio
SELECT * FROM productos
WHERE precio > (SELECT AVG(precio) FROM productos);

-- Pedidos mayores al promedio
SELECT * FROM pedidos
WHERE total > (SELECT AVG(total) FROM pedidos);

-- Producto más caro por categoría
SELECT
    p.nombre,
    p.precio,
    p.categoria_id
FROM productos p
WHERE p.precio = (
    SELECT MAX(precio)
    FROM productos
    WHERE categoria_id = p.categoria_id
);
