# Ejercicio 03 — GROUP BY y HAVING

- **Nivel:** 2/5
- **Tema:** GROUP BY, HAVING, funciones agregadas
- **Tiempo estimado:** 15 min

## Enunciado

Dada la tabla `ventas`:

1. Calcula **el total de ventas por día**, ordenado por fecha.
2. Calcula **el total de ventas por producto**, pero mostrando **solo los productos que hayan superado 100 en total**.

Resultado esperado: en la consulta 2 solo aparecen `Monitor` (298.00) y `Teclado` (135.00).

## Schema inicial

```sql
CREATE TABLE ventas (
    id INTEGER PRIMARY KEY,
    producto TEXT NOT NULL,
    total REAL NOT NULL,
    fecha DATE
);

INSERT INTO ventas (id, producto, total, fecha) VALUES
    (1, 'Teclado', 45.00, '2024-01-05'),
    (2, 'Mouse', 19.90, '2024-01-05'),
    (3, 'Monitor', 149.00, '2024-01-06'),
    (4, 'Teclado', 90.00, '2024-01-07'),
    (5, 'Webcam', 89.00, '2024-01-07'),
    (6, 'Mouse', 19.90, '2024-01-08'),
    (7, 'Auriculares', 80.00, '2024-01-08'),
    (8, 'Monitor', 149.00, '2024-01-09');
```

## Requisitos

- [ ] La consulta devuelve el resultado esperado
- [ ] Ejecutarlo localmente (SQLite o PostgreSQL) y verificar

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Pista 1: `GROUP BY fecha` con `SUM(total)`. Puedes usar `ORDER BY fecha`.
- Pista 2: `GROUP BY producto` y filtrar el grupo con `HAVING SUM(total) > 100`.
- Recuerda la diferencia: `WHERE` filtra filas **antes** de agrupar, `HAVING` filtra **grupos**.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````sql
-- 1. Total de ventas por día
SELECT fecha, SUM(total) AS total_dia
FROM ventas
GROUP BY fecha
ORDER BY fecha;

-- 2. Productos con más de 100 de ventas totales
SELECT producto, SUM(total) AS total_producto
FROM ventas
GROUP BY producto
HAVING SUM(total) > 100
ORDER BY total_producto DESC;
````

</details>