SELECT 'clientes' AS tabla, COUNT(*) AS filas FROM clientes
UNION ALL SELECT 'productos', COUNT(*) FROM productos
UNION ALL SELECT 'pedidos', COUNT(*) FROM pedidos
UNION ALL SELECT 'pedidos_productos', COUNT(*) FROM pedidos_productos
ORDER BY tabla;

SELECT COUNT(*) AS fk_pedidos_productos FROM pragma_foreign_key_list('pedidos_productos');