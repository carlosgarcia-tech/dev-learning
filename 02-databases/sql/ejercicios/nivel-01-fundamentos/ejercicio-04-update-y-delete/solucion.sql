-- Actualizar un producto
UPDATE productos
SET precio = 320.00
WHERE nombre = 'Monitor';

-- Incrementar precio 10% (solo productos con stock)
UPDATE productos
SET precio = ROUND(precio * 1.1, 2)
WHERE stock > 0;

SELECT * FROM productos;

-- Eliminar producto específico
DELETE FROM productos WHERE id = 5;

-- Eliminar productos sin stock
DELETE FROM productos WHERE stock = 0;

SELECT * FROM productos;
