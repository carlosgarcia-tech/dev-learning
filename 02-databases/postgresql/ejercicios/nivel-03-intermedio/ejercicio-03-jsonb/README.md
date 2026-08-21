# Ejercicio 03 — JSONB

- **Nivel:** 3/5
- **Tema:** Intermedio de PostgreSQL
- **Tiempo estimado:** 30 minutos

## Enunciado

1. Crear tabla con columna JSONB
2. Insertar datos JSON
3. Consultar y filtrar por campos JSON
4. Actualizar un campo JSON
5. Crear índice GIN sobre JSONB

## Requisitos

- [ ] El script `init.sql` crea el esquema necesario
- [ ] `solucion.sql` resuelve el enunciado
- [ ] Los tests pasan: `bash test.sh`

## Solución

<details>
<summary>Mostrar solución</summary>

```sql
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
```

</details>

## Ejecutar localmente

```bash
cd ejercicios/nivel-03-intermedio/ejercicio-03-jsonb
bash test.sh
```
