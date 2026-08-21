(SELECT nombre, precio FROM productos ORDER BY precio DESC LIMIT 3)
UNION ALL
(SELECT nombre, stock FROM productos ORDER BY stock ASC LIMIT 2)
UNION ALL
(SELECT id, nombre FROM productos ORDER BY id LIMIT 1);
