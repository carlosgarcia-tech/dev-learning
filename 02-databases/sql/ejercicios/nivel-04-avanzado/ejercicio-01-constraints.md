# Ejercicio 01 — Constraints

- **Nivel:** 4/5
- **Tema:** PRIMARY KEY, FOREIGN KEY, UNIQUE, CHECK, NOT NULL
- **Tiempo estimado:** 20 min

## Enunciado

Crea una tabla `empleados` con **todas las restricciones** de integridad:

1. `id`: `INTEGER PRIMARY KEY` (autoincremental).
2. `email`: `NOT NULL` y **único** (`UNIQUE`).
3. `salario`: `NOT NULL` y con `CHECK` de que sea **mayor que 0**.
4. `edad`: con `CHECK` de que esté **entre 18 y 65**.
5. `dept_id`: `FOREIGN KEY` que referencia `departamentos(id)`.

Después, escribe tres `INSERT` de prueba: uno válido, y dos que fallen (uno por email duplicado y otro por salario negativo). Comprueba que los inválidos lanzan error.

## Schema inicial

```sql
CREATE TABLE departamentos (
    id INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL
);

INSERT INTO departamentos (id, nombre) VALUES
    (1, 'TI'),
    (2, 'Ventas');
```

## Requisitos

- [ ] La consulta devuelve el resultado esperado
- [ ] Ejecutarlo localmente (SQLite o PostgreSQL) y verificar
- [ ] Los tests pasan: `bash ejercicio-01-constraints-test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Pista 1: El `CHECK` va a nivel de columna: `salario REAL NOT NULL CHECK (salario > 0)`.
- Pista 2: `edad INTEGER CHECK (edad BETWEEN 18 AND 65)`.
- Pista 3: La `FOREIGN KEY` puede ir a nivel de tabla: `FOREIGN KEY (dept_id) REFERENCES departamentos(id)`.
- Pista 4: Para probar el fallo por email duplicado inserta dos filas con el mismo email.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````sql
-- 1. Tabla con constraints completos
CREATE TABLE empleados (
    id INTEGER PRIMARY KEY,
    email TEXT NOT NULL UNIQUE,
    salario REAL NOT NULL CHECK (salario > 0),
    edad INTEGER CHECK (edad BETWEEN 18 AND 65),
    dept_id INTEGER,
    FOREIGN KEY (dept_id) REFERENCES departamentos(id)
);

-- Insert válido
INSERT INTO empleados (id, email, salario, edad, dept_id)
VALUES (1, 'ana@empresa.com', 2500, 30, 1);

-- Insert inválido: email duplicado (FALLA)
INSERT INTO empleados (id, email, salario, edad, dept_id)
VALUES (2, 'ana@empresa.com', 2000, 28, 2);

-- Insert inválido: salario negativo (FALLA)
INSERT INTO empleados (id, email, salario, edad, dept_id)
VALUES (3, 'luis@empresa.com', -100, 28, 2);

-- Verificación: solo debe quedar el empleado 1
SELECT * FROM empleados;
````

</details>