(SELECT c.nombre AS cliente, p.id AS pedido_id, p.total
 FROM clientes c
 LEFT JOIN pedidos p ON c.id = p.cliente_id
 ORDER BY c.id, p.id)
UNION ALL
(SELECT c.nombre AS cliente, p.id AS pedido_id, p.total
 FROM clientes c
 RIGHT JOIN pedidos p ON c.id = p.cliente_id
 ORDER BY p.id);
