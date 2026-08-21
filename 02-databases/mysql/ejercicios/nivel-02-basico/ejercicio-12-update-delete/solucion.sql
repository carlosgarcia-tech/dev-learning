UPDATE productos SET precio = precio * 1.10 WHERE categoria = 'electronica';
DELETE FROM productos WHERE stock = 0;
SELECT id, nombre, precio, stock FROM productos ORDER BY id;
