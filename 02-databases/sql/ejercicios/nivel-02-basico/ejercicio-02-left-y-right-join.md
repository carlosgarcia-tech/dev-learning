# Ejercicio 02 — LEFT y RIGHT JOIN

- **Nivel:** 2/5
- **Tema:** LEFT JOIN, RIGHT JOIN
- **Tiempo estimado:** 15 min

## Enunciado

Dadas las tablas `departamentos` y `empleados`:

1. Escribe una consulta que muestre **todos los departamentos** con el nombre de sus empleados. Los departamentos sin empleados deben aparecer igualmente (con `NULL` en la columna de empleado). Usa `LEFT JOIN`.
2. Escribe una consulta que muestre **todos los empleados**, tengan o no departamento (los huérfanos deben aparecer). En SQLite, simula el `RIGHT JOIN` invirtiendo las tablas.

Resultado esperado: la consulta 1 devuelve 6 filas (solo el departamento `RRHH` queda sin empleados) y la consulta 2 devuelve 6 filas (1 empleado, `Pedro`, sin departamento).

## Schema inicial

```sql
CREATE TABLE departamentos (
    id INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL
);

CREATE TABLE empleados (
    id INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL,
    dept_id INTEGER,
    FOREIGN KEY (dept_id) REFERENCES departamentos(id)
);

INSERT INTO departamentos (id, nombre) VALUES
    (1, 'Ventas'),
    (2, 'Marketing'),
    (3, 'RRHH'),
    (4, 'TI');

INSERT INTO empleados (id, nombre, dept_id) VALUES
    (1, 'Ana', 1),
    (2, 'Luis', 1),
    (3, 'Marta', 2),
    (4, 'Carlos', 4),
    (5, 'Lucia', 4),
    (6, 'Pedro', NULL);
```

## Requisitos

- [ ] La consulta devuelve el resultado esperado
- [ ] Ejecutarlo localmente (SQLite o PostgreSQL) y verificar
- [ ] Los tests pasan: `bash ejercicio-02-left-y-right-join-test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Pista 1: `FROM departamentos d LEFT JOIN empleados e ON e.dept_id = d.id`.
- Pista 2: Invierte: `FROM empleados e LEFT JOIN departamentos d ON d.id = e.dept_id`.
- Pista 3: La consulta 2 en PostgreSQL se puede escribir directamente con `RIGHT JOIN empleados`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````sql
-- 1. Todos los departamentos, con o sin empleados (LEFT JOIN)
SELECT d.nombre AS departamento, e.nombre AS empleado
FROM departamentos d
LEFT JOIN empleados e ON e.dept_id = d.id
ORDER BY d.nombre, empleado;

-- 2. Todos los empleados, con o sin departamento
-- SQLite (simulando RIGHT JOIN invirtiendo las tablas):
SELECT e.nombre AS empleado, d.nombre AS departamento
FROM empleados e
LEFT JOIN departamentos d ON d.id = e.dept_id
ORDER BY e.nombre;

-- PostgreSQL admite RIGHT JOIN directamente:
-- SELECT e.nombre AS empleado, d.nombre AS departamento
-- FROM departamentos d
-- RIGHT JOIN empleados e ON e.dept_id = d.id
-- ORDER BY e.nombre;
````

</details>