SELECT 'tablas' AS indicador, COUNT(*) AS valor
FROM sqlite_master
WHERE type = 'table' AND name NOT LIKE 'sqlite_%'
UNION ALL
SELECT 'tablas_objetivo', COUNT(*)
FROM sqlite_master
WHERE type = 'table'
  AND name IN ('clientes', 'productos', 'pedidos', 'detalle_pedidos', 'pagos', 'inventario_movimientos')
UNION ALL
SELECT 'fk_pedidos', COUNT(*)
FROM pragma_foreign_key_list('pedidos')
UNION ALL
SELECT 'fk_detalle', COUNT(*)
FROM pragma_foreign_key_list('detalle_pedidos')
UNION ALL
SELECT 'pk_detalle', COUNT(*)
FROM pragma_table_info('detalle_pedidos')
WHERE pk > 0
UNION ALL
SELECT 'check_pedidos',
       (SELECT (length(sql) - length(replace(sql, 'CHECK (', ''))) / 7
        FROM sqlite_master WHERE type = 'table' AND name = 'pedidos');