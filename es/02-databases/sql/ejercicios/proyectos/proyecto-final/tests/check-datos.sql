SELECT 'pedidos_coherentes' AS indicador, COUNT(*) AS valor
FROM pedidos p
WHERE ABS(p.total - COALESCE(
    (SELECT SUM(d.cantidad * d.precio_unitario)
     FROM detalle_pedidos d WHERE d.pedido_id = p.id), 0)) < 0.01
UNION ALL
SELECT 'pedidos_sin_lineas', COUNT(*)
FROM pedidos p
WHERE NOT EXISTS (SELECT 1 FROM detalle_pedidos d WHERE d.pedido_id = p.id)
UNION ALL
SELECT 'emails_duplicados', COUNT(*)
FROM (SELECT email FROM clientes GROUP BY email HAVING COUNT(*) > 1)
UNION ALL
SELECT 'pagos_en_pendientes_o_cancelados', COUNT(*)
FROM pagos pg
INNER JOIN pedidos p ON p.id = pg.pedido_id
WHERE p.estado IN ('pendiente', 'cancelado')
UNION ALL
SELECT 'stock_desajustado', COUNT(*)
FROM productos pr
WHERE pr.stock <> COALESCE(
    (SELECT SUM(m.cantidad) FROM inventario_movimientos m
     WHERE m.producto_id = pr.id), 0);