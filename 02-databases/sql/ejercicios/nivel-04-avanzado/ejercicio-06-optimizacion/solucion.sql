-- SQLite no tiene EXPLAIN ANALYZE; el equivalente para ver el plan de
-- ejecución es EXPLAIN QUERY PLAN.

-- 1) Plan de ejecución SIN índice: recorrido completo (SCAN)
EXPLAIN QUERY PLAN
SELECT * FROM pedidos
WHERE cliente_id = 1
  AND fecha > '2024-01-01';

-- 2) Crear índice optimizado
CREATE INDEX idx_pedidos_cliente_fecha
ON pedidos(cliente_id, fecha);

-- 3) Plan de ejecución CON índice: búsqueda por índice (SEARCH)
EXPLAIN QUERY PLAN
SELECT * FROM pedidos
WHERE cliente_id = 1
  AND fecha > '2024-01-01';

-- 4) Optimizar con CTE
WITH pedidos_filtrados AS (
    SELECT * FROM pedidos
    WHERE fecha > '2024-01-01'
)
SELECT
    c.nombre,
    pf.id,
    pf.fecha,
    pf.total
FROM clientes c
INNER JOIN pedidos_filtrados pf ON c.id = pf.cliente_id
ORDER BY pf.id;

-- 5) IN
SELECT * FROM clientes
WHERE id IN (SELECT DISTINCT cliente_id FROM pedidos)
ORDER BY id;

-- 6) EXISTS (normalmente más rápido)
SELECT * FROM clientes c
WHERE EXISTS (SELECT 1 FROM pedidos p WHERE p.cliente_id = c.id)
ORDER BY id;