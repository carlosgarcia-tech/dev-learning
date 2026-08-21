CREATE TABLE productos (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    especificaciones JSONB,
    creado TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO productos (nombre, especificaciones) VALUES
    ('Laptop', '{"procesador": "Intel i7", "ram": 16, "almacenamiento": "512GB SSD"}'),
    ('Telefono', '{"procesador": "Snapdragon", "ram": 8, "almacenamiento": "256GB"}'),
    ('Tablet', '{"procesador": "Apple M1", "ram": 8, "almacenamiento": "128GB"}');

SELECT nombre, especificaciones->>'procesador' AS procesador, especificaciones->>'ram' AS ram
FROM productos;

SELECT * FROM productos WHERE especificaciones @> '{"ram": 8}';
SELECT * FROM productos WHERE (especificaciones->>'ram')::INT > 8;

UPDATE productos
SET especificaciones = jsonb_set(especificaciones, '{precio}', '999.99')
WHERE nombre = 'Laptop';

CREATE INDEX idx_productos_especificaciones ON productos USING GIN (especificaciones);
