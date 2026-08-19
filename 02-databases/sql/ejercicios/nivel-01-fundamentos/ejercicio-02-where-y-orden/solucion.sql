-- Precio > 100
SELECT * FROM productos WHERE precio > 100;

-- Stock > 0
SELECT * FROM productos WHERE stock > 0;

-- Rango de precio
SELECT * FROM productos
WHERE precio BETWEEN 100 AND 500;

-- Ordenar por precio DESC
SELECT * FROM productos ORDER BY precio DESC;
