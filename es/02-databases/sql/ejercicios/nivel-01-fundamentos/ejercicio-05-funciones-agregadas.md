# Ejercicio 05 — Funciones agregadas

- **Nivel:** 1/5
- **Tema:** COUNT, SUM, AVG, MIN, MAX
- **Tiempo estimado:** 15 min

## Enunciado

Dada la tabla `ventas`, escribe una consulta por cada métrica:

1. `COUNT`: número total de ventas.
2. `SUM`: ingresos totales (suma de `total`).
3. `AVG`: importe medio por venta (redondeado a 2 decimales).
4. `MIN` y `MAX`: venta mínima y máxima en una sola consulta.

Puedes usar alias con `AS` para nombrar las columnas de salida. Resultado esperado: 8 ventas, ingresos totales de `1214.00`.

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
    (4, 'Teclado', 45.00, '2024-01-07'),
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

- Pista 1: `SELECT COUNT(*) FROM ventas;` cuenta todas las filas.
- Pista 2: `SELECT SUM(total) FROM ventas;`
- Pista 3: `SELECT AVG(total) FROM ventas;` — puedes envolverlo con `ROUND(valor, 2)`.
- Pista 4: `SELECT MIN(total), MAX(total) FROM ventas;`
- Recuerda: las funciones agregadas **no** necesitan `GROUP BY` cuando aplican a toda la tabla.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````sql
-- 1. Total de ventas
SELECT COUNT(*) AS total_ventas FROM ventas;

-- 2. Ingresos totales
SELECT SUM(total) AS ingresos_totales FROM ventas;

-- 3. Importe medio (2 decimales)
SELECT ROUND(AVG(total), 2) AS importe_medio FROM ventas;

-- 4. Venta mínima y máxima
SELECT MIN(total) AS venta_minima, MAX(total) AS venta_maxima FROM ventas;
````

</details>