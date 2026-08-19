-- Todos los clientes con pedidos (o sin)
SELECT
    c.nombre,
    c.email,
    p.id AS pedido_id,
    p.total
FROM clientes c
LEFT JOIN pedidos p ON c.id = p.cliente_id;

-- Clientes sin pedidos
SELECT
    c.nombre,
    c.email
FROM clientes c
LEFT JOIN pedidos p ON c.id = p.cliente_id
WHERE p.id IS NULL;

-- Todos los pedidos con clientes (equivalente sin RIGHT JOIN)
SELECT
    p.id AS pedido_id,
    c.nombre AS cliente,
    p.total
FROM pedidos p
LEFT JOIN clientes c ON p.cliente_id = c.id;
