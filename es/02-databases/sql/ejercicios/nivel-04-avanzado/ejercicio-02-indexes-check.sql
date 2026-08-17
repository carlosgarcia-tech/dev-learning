SELECT name FROM sqlite_master
WHERE type = 'index' AND name IN ('idx_pedidos_cliente_fecha', 'idx_pedidos_referencia')
ORDER BY name;

EXPLAIN QUERY PLAN
SELECT * FROM pedidos WHERE cliente_id = 10;