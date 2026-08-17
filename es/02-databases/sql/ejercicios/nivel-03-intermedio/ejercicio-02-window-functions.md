# Ejercicio 02 — Window functions

- **Nivel:** 3/5
- **Tema:** ROW_NUMBER, RANK, LAG/LEAD, OVER, PARTITION BY
- **Tiempo estimado:** 25 min

## Enunciado

Dada la tabla `empleados`, escribe las siguientes consultas con **window functions**:

1. Numera los empleados **por salario descendente** dentro de cada departamento (usa `ROW_NUMBER` con `PARTITION BY dept_id`). Debe aparecer el `rango` de cada empleado en su departamento.
2. Usa `RANK` para rankear por salario **sin particionar** (global).
3. Muestra, junto a cada salario, el salario del empleado **anterior** y el del **siguiente** en el orden por id (usa `LAG` y `LEAD`).

Nota: SQLite soporta window functions desde la versión 3.25. En PostgreSQL funcionan directamente.

## Schema inicial

```sql
CREATE TABLE empleados (
    id INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL,
    dept_id INTEGER,
    salario REAL NOT NULL
);

INSERT INTO empleados (id, nombre, dept_id, salario) VALUES
    (1, 'Ana', 1, 2500),
    (2, 'Luis', 1, 3000),
    (3, 'Marta', 2, 2800),
    (4, 'Carlos', 1, 3000),
    (5, 'Lucia', 2, 3200),
    (6, 'Pedro', 2, 2200);
```

## Requisitos

- [ ] La consulta devuelve el resultado esperado
- [ ] Ejecutarlo localmente (SQLite o PostgreSQL) y verificar

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Pista 1: `ROW_NUMBER() OVER (PARTITION BY dept_id ORDER BY salario DESC) AS rango`.
- Pista 2: `RANK() OVER (ORDER BY salario DESC)` — nota que `RANK` deja huecos entre empates, `ROW_NUMBER` no.
- Pista 3: `LAG(salario) OVER (ORDER BY id)` y `LEAD(salario) OVER (ORDER BY id)`. La primera fila no tiene anterior (NULL).
- Las funciones ventana no colapsan filas (a diferencia de `GROUP BY`).

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````sql
-- 1. Rango por salario dentro de cada departamento
SELECT
    nombre,
    dept_id,
    salario,
    ROW_NUMBER() OVER (PARTITION BY dept_id ORDER BY salario DESC) AS rango_dept
FROM empleados
ORDER BY dept_id, rango_dept;

-- 2. RANK global por salario
SELECT
    nombre,
    salario,
    RANK() OVER (ORDER BY salario DESC) AS rango_global
FROM empleados
ORDER BY rango_global;

-- 3. Salario anterior y siguiente
SELECT
    id,
    nombre,
    salario,
    LAG(salario)  OVER (ORDER BY id) AS salario_anterior,
    LEAD(salario) OVER (ORDER BY id) AS salario_siguiente
FROM empleados
ORDER BY id;
````

</details>