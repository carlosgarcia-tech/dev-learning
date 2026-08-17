# Ejercicio 05 — Agregaciones avanzadas

- **Nivel:** 3/5
- **Tema:** GROUP BY con varias columnas, combinación de agregados, ORDER BY sobre agregados
- **Tiempo estimado:** 20 min

## Enunciado

Dada la tabla `ventas` (cada venta tiene región y vendedor):

1. Calcula **por región y por vendedor**: número de ventas, importe total y media. Agrupa por ambas columnas a la vez.
2. Muestra el **mejor vendedor de cada región** (el de mayor total), usando `ROW_NUMBER` sobre un agregado.

Resultado esperado: en la consulta 2, en `Norte` gana `Laura` (450), en `Sur` gana `Carlos` (330).

## Schema inicial

```sql
CREATE TABLE ventas (
    id INTEGER PRIMARY KEY,
    region TEXT NOT NULL,
    vendedor TEXT NOT NULL,
    importe REAL NOT NULL
);

INSERT INTO ventas (id, region, vendedor, importe) VALUES
    (1, 'Norte', 'Ana', 200),
    (2, 'Norte', 'Laura', 250),
    (3, 'Sur', 'Carlos', 180),
    (4, 'Norte', 'Ana', 150),
    (5, 'Sur', 'Marta', 120),
    (6, 'Norte', 'Laura', 200),
    (7, 'Sur', 'Carlos', 150),
    (8, 'Sur', 'Marta', 90);
```

## Requisitos

- [ ] La consulta devuelve el resultado esperado
- [ ] Ejecutarlo localmente (SQLite o PostgreSQL) y verificar

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Pista 1: `GROUP BY region, vendedor` — puedes usar `COUNT(*)`, `SUM(importe)` y `AVG(importe)`.
- Pista 2: Primero agrupa en una CTE por vendedor/región y luego aplica `ROW_NUMBER() OVER (PARTITION BY region ORDER BY total DESC)`. Puedes envolverlo en una segunda consulta que filtre `rango = 1`.
- Pista 3: En SQLite necesitas la versión 3.25+ para window functions.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````sql
-- 1. Agregados por región y vendedor
SELECT
    region,
    vendedor,
    COUNT(*) AS num_ventas,
    SUM(importe) AS total,
    ROUND(AVG(importe), 2) AS media
FROM ventas
GROUP BY region, vendedor
ORDER BY region, total DESC;

-- 2. Mejor vendedor por región
WITH ventas_vendedor AS (
    SELECT region, vendedor, SUM(importe) AS total
    FROM ventas
    GROUP BY region, vendedor
),
ranked AS (
    SELECT
        region,
        vendedor,
        total,
        ROW_NUMBER() OVER (PARTITION BY region ORDER BY total DESC) AS rango
    FROM ventas_vendedor
)
SELECT region, vendedor, total
FROM ranked
WHERE rango = 1
ORDER BY region;
````

</details>