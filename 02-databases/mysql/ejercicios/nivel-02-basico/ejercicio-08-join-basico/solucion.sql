SELECT c.nombre AS cliente, p.id AS pedido_id, p.total
FROM clientes c
INNER JOIN pedidos p ON c.id = p.cliente_id
ORDER BY p.id;
