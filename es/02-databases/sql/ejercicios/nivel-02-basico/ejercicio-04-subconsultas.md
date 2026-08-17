# Ejercicio 04 — Subconsultas

- **Nivel:** 2/5
- **Tema:** Subconsultas en WHERE, IN, comparaciones
- **Tiempo estimado:** 15 min

## Enunciado

Dadas las tablas `empleados` y `departamentos`:

1. Muestra los empleados que pertenecen a **departamentos de la ciudad 'Madrid'**, usando una subconsulta con `IN`.
2. Muestra el **empleado con el mayor salario** usando una subconsulta con `=`.
3. Muestra los empleados cuyo salario es **mayor que el salario medio de todos los empleados**.

Resultado esperado: la consulta 2 devuelve solo a `Carlos` (5000) y la consulta 3 devuelve a `Carlos` y `Lucia`.

## Schema inicial

```sql
CREATE TABLE departamentos (
    id INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL,
    ciudad TEXT
);

CREATE TABLE empleados (
    id INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL,
    dept_id INTEGER,
    salario REAL NOT NULL,
    FOREIGN KEY (dept_id) REFERENCES departamentos(id)
);

INSERT INTO departamentos (id, nombre, ciudad) VALUES
    (1, 'Ventas', 'Madrid'),
    (2, 'Marketing', 'Barcelona'),
    (3, 'TI', 'Madrid');

INSERT INTO empleados (id, nombre, dept_id, salario) VALUES
    (1, 'Ana', 1, 2500),
    (2, 'Luis', 2, 2200),
    (3, 'Marta', 1, 2800),
    (4, 'Carlos', 3, 5000),
    (5, 'Lucia', 3, 3200),
    (6, 'Pedro', 2, 1800);
```

## Requisitos

- [ ] La consulta devuelve el resultado esperado
- [ ] Ejecutarlo localmente (SQLite o PostgreSQL) y verificar
- [ ] Los tests pasan: `bash ejercicio-04-subconsultas-test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Pista 1: `WHERE dept_id IN (SELECT id FROM departamentos WHERE ciudad = 'Madrid')`.
- Pista 2: `WHERE salario = (SELECT MAX(salario) FROM empleados)`.
- Pista 3: `WHERE salario > (SELECT AVG(salario) FROM empleados)`.
- Las subconsultas van entre paréntesis y devuelven un solo valor o una lista.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````sql
-- 1. Empleados en departamentos de Madrid
SELECT nombre
FROM empleados
WHERE dept_id IN (
    SELECT id FROM departamentos WHERE ciudad = 'Madrid'
);

-- 2. Empleado con mayor salario
SELECT nombre, salario
FROM empleados
WHERE salario = (SELECT MAX(salario) FROM empleados);

-- 3. Salario mayor que la media
SELECT nombre, salario
FROM empleados
WHERE salario > (SELECT AVG(salario) FROM empleados)
ORDER BY salario DESC;
````

</details>