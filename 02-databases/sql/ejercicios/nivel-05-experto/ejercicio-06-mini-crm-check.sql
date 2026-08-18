-- a) Oportunidades abiertas por cliente
SELECT c.nombre, o.nombre_oportunidad, o.valor
FROM oportunidades o
INNER JOIN clientes c ON c.id = o.cliente_id
WHERE o.estado = 'abierta'
ORDER BY c.nombre;

-- b) Valor total ganado por cliente
SELECT c.nombre, SUM(o.valor) AS valor_ganado
FROM clientes c
INNER JOIN oportunidades o ON o.cliente_id = c.id
WHERE o.estado = 'ganada'
GROUP BY c.nombre
ORDER BY valor_ganado DESC;

-- c) Número de oportunidades por estado
SELECT estado, COUNT(*) AS cantidad
FROM oportunidades
GROUP BY estado
ORDER BY cantidad DESC;

-- d) Clientes sin oportunidades
SELECT c.nombre, c.email
FROM clientes c
LEFT JOIN oportunidades o ON o.cliente_id = c.id
WHERE o.id IS NULL;