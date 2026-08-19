-- Insertar 3 productos
INSERT INTO productos (nombre, precio, stock) VALUES
    ('Monitor 27"', 349.99, 15),
    ('Teclado mecánico', 59.99, 30),
    ('Ratón inalámbrico', 34.99, 45);

SELECT * FROM productos ORDER BY id DESC LIMIT 3;

-- Producto con precio negativo (debe fallar: CHECK constraint)
-- INSERT INTO productos (nombre, precio, stock) VALUES ('Test', -10, 1);
-- Error esperado: CHECK constraint failed: precio >= 0

-- Producto sin nombre (debe fallar: NOT NULL constraint)
-- INSERT INTO productos (precio, stock) VALUES (100, 1);
-- Error esperado: NOT NULL constraint failed: productos.nombre
