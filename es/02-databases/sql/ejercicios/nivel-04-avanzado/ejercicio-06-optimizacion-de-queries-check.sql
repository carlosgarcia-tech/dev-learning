SELECT name FROM sqlite_master
WHERE type = 'index' AND name = 'idx_trans_cliente_fecha';

EXPLAIN QUERY PLAN
SELECT id, importe, fecha
FROM transacciones
WHERE cliente_id = 4242 AND fecha >= '2024-01-01';