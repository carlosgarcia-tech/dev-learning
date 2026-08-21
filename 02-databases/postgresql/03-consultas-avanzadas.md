# 03 — Consultas Avanzadas en PostgreSQL

## Objetivos

- [ ] Usar Window Functions
- [ ] Trabajar con Common Table Expressions (CTEs)
- [ ] Usar CTEs recursivas
- [ ] Consultas con JSONB
- [ ] Full-Text Search
- [ ] Usar LATERAL joins
- [ ] Consultas con DISTINCT ON

## Apuntes

### Window Functions

```sql
SELECT nombre, precio, ROW_NUMBER() OVER (ORDER BY precio DESC) AS ranking
FROM productos
LIMIT 10;

SELECT
    nombre, categoria, precio,
    RANK() OVER (PARTITION BY categoria ORDER BY precio DESC) AS rank_categoria,
    DENSE_RANK() OVER (PARTITION BY categoria ORDER BY precio DESC) AS dense_rank_categoria
FROM productos;

SELECT
    fecha, total,
    LAG(total) OVER (ORDER BY fecha) AS total_anterior,
    LEAD(total) OVER (ORDER BY fecha) AS total_siguiente,
    total - LAG(total) OVER (ORDER BY fecha) AS diferencia
FROM pedidos;

SELECT
    fecha, total,
    SUM(total) OVER (ORDER BY fecha) AS total_acumulado,
    AVG(total) OVER (ORDER BY fecha ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS promedio_movil_7d
FROM pedidos;

SELECT nombre, precio, NTILE(4) OVER (ORDER BY precio) AS cuartil FROM productos;

SELECT
    categoria, nombre, precio,
    FIRST_VALUE(nombre) OVER (PARTITION BY categoria ORDER BY precio DESC) AS mas_caro
FROM productos;
```

### CTEs (Common Table Expressions)

```sql
WITH productos_caros AS (
    SELECT * FROM productos WHERE precio > 1000
)
SELECT * FROM productos_caros ORDER BY precio DESC;

WITH
ventas_por_mes AS (
    SELECT DATE_TRUNC('month', fecha) AS mes, SUM(total) AS total_ventas, COUNT(*) AS total_pedidos
    FROM pedidos
    GROUP BY DATE_TRUNC('month', fecha)
),
ventas_ordenadas AS (
    SELECT mes, total_ventas, total_pedidos,
           LAG(total_ventas) OVER (ORDER BY mes) AS mes_anterior
    FROM ventas_por_mes
)
SELECT mes, total_ventas, total_pedidos, mes_anterior,
       ROUND(((total_ventas - mes_anterior) / NULLIF(mes_anterior, 0) * 100)::NUMERIC, 2) AS crecimiento_pct
FROM ventas_ordenadas
WHERE mes_anterior IS NOT NULL;

-- CTE recursiva (jerarquías)
WITH RECURSIVE empleados_jerarquia AS (
    SELECT id, nombre, jefe_id, 1 AS nivel, nombre AS ruta
    FROM empleados
    WHERE jefe_id IS NULL

    UNION ALL

    SELECT e.id, e.nombre, e.jefe_id, ej.nivel + 1, ej.ruta || ' > ' || e.nombre
    FROM empleados e
    INNER JOIN empleados_jerarquia ej ON e.jefe_id = ej.id
)
SELECT * FROM empleados_jerarquia ORDER BY nivel, nombre;
```

> Nota: `crecimiento_pct` usa `NULLIF(mes_anterior, 0)` para evitar una
> división por cero si algún mes anterior tuvo ventas totales de 0.

### LATERAL joins

```sql
SELECT c.nombre, ultimos_pedidos.*
FROM clientes c
LEFT JOIN LATERAL (
    SELECT * FROM pedidos p
    WHERE p.cliente_id = c.id
    ORDER BY p.fecha DESC
    LIMIT 3
) ultimos_pedidos ON TRUE;
```

### DISTINCT ON

```sql
SELECT DISTINCT ON (categoria_id)
    categoria_id, nombre, precio, fecha_creacion
FROM productos
ORDER BY categoria_id, precio DESC, fecha_creacion;

-- Último pedido por cliente
SELECT DISTINCT ON (cliente_id)
    cliente_id, id AS pedido_id, fecha, total
FROM pedidos
ORDER BY cliente_id, fecha DESC;
```

### Full-Text Search

```sql
CREATE TABLE articulos (
    id SERIAL PRIMARY KEY,
    titulo TEXT,
    contenido TEXT,
    documento TSVECTOR
);

INSERT INTO articulos (titulo, contenido)
VALUES ('PostgreSQL y Full-Text Search', 'PostgreSQL ofrece potentes capacidades de búsqueda de texto completo.');

UPDATE articulos
SET documento = setweight(to_tsvector('spanish', titulo), 'A') ||
                setweight(to_tsvector('spanish', contenido), 'B');

CREATE INDEX idx_articulos_documento ON articulos USING GIN (documento);

SELECT * FROM articulos WHERE documento @@ to_tsquery('spanish', 'PostgreSQL');

SELECT titulo, ts_rank(documento, query) AS relevancia
FROM articulos, to_tsquery('spanish', 'PostgreSQL & SQL') AS query
WHERE documento @@ query
ORDER BY relevancia DESC;

SELECT titulo, ts_headline('spanish', contenido, query) AS extracto
FROM articulos, to_tsquery('spanish', 'PostgreSQL') AS query
WHERE documento @@ query;
```

> En producción, mantén `documento` sincronizado con un trigger
> (`tsvector_update_trigger` o uno propio) en lugar de un `UPDATE` manual
> después de cada `INSERT`, para que no quede desincronizado.

### Búsqueda con JSONB

```sql
SELECT * FROM productos WHERE especificaciones @> '{"ram": 16}';
SELECT * FROM productos WHERE especificaciones ? 'procesador';
SELECT * FROM productos WHERE especificaciones ->> 'ram' = '16';

CREATE INDEX idx_productos_especificaciones_gin ON productos USING GIN (especificaciones);
CREATE INDEX idx_productos_ram ON productos USING BTREE ((especificaciones->>'ram'));
```

## Ejercicios relacionados

- [Ejercicio 13: Window Functions](./ejercicios/nivel-03-intermedio/ejercicio-01-window-functions/)
- [Ejercicio 14: CTEs](./ejercicios/nivel-03-intermedio/ejercicio-02-ctes/)
- [Ejercicio 15: JSONB](./ejercicios/nivel-03-intermedio/ejercicio-03-jsonb/)
- [Ejercicio 16: Full-Text Search](./ejercicios/nivel-03-intermedio/ejercicio-04-full-text-search/)
