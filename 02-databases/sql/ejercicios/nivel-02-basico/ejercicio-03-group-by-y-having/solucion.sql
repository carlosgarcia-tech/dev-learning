-- Pedidos por cliente
SELECT
    cliente_id,
    COUNT(*) AS total_pedidos
FROM pedidos
GROUP BY cliente_id;

-- Total gastado por cliente
SELECT
    c.nombre,
    COUNT(p.id) AS total_pedidos,
    COALESCE(SUM(p.total), 0) AS total_gastado
FROM clientes c
LEFT JOIN pedidos p ON c.id = p.cliente_id
GROUP BY c.id, c.nombre;

-- Clientes con más de 1 pedido
SELECT
    c.nombre,
    COUNT(p.id) AS total_pedidos
FROM clientes c
INNER JOIN pedidos p ON c.id = p.cliente_id
GROUP BY c.id, c.nombre
HAVING COUNT(p.id) > 1;

-- Clientes que han gastado más de 500
SELECT
    c.nombre,
    SUM(p.total) AS total_gastado
FROM clientes c
INNER JOIN pedidos p ON c.id = p.cliente_id
GROUP BY c.id, c.nombre
HAVING SUM(p.total) > 500;
