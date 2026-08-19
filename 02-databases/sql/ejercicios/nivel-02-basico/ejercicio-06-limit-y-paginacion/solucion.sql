-- 3 productos más caros
SELECT * FROM productos
ORDER BY precio DESC
LIMIT 3;

-- Página 2 (2 por página)
SELECT * FROM productos
ORDER BY id
LIMIT 2 OFFSET 2;

-- Cliente con más pedidos
SELECT
    c.nombre,
    COUNT(p.id) AS total_pedidos
FROM clientes c
INNER JOIN pedidos p ON c.id = p.cliente_id
GROUP BY c.id, c.nombre
ORDER BY total_pedidos DESC
LIMIT 1;
