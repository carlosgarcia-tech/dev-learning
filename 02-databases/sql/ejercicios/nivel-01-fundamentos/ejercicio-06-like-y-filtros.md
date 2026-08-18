# Ejercicio 06 — LIKE y filtros

- **Nivel:** 1/5
- **Tema:** LIKE, IN, BETWEEN, NULL
- **Tiempo estimado:** 15 min

## Enunciado

Dada la tabla `clientes`, escribe las siguientes consultas:

1. Clientes cuyo **nombre empiece por 'A'** (`LIKE 'A%'`).
2. Clientes cuyo **email contenga 'gmail'**.
3. Clientes de las ciudades `'Madrid'` o `'Valencia'` (usa `IN`).
4. Clientes con edad **entre 25 y 35** (usa `BETWEEN`).
5. Clientes que **no tienen teléfono** (`telefono IS NULL`).

Resultado esperado: la consulta 5 devuelve 3 clientes.

## Schema inicial

```sql
CREATE TABLE clientes (
    id INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL,
    email TEXT,
    telefono TEXT,
    ciudad TEXT,
    edad INTEGER
);

INSERT INTO clientes (id, nombre, email, telefono, ciudad, edad) VALUES
    (1, 'Andres', 'andres@gmail.com', '600111222', 'Madrid', 30),
    (2, 'Beatriz', 'beatriz@yahoo.com', NULL, 'Madrid', 27),
    (3, 'Carmen', 'carmen@gmail.com', '600333444', 'Valencia', 40),
    (4, 'David', 'david@outlook.com', NULL, 'Barcelona', 33),
    (5, 'Elena', 'elena@gmail.com', '600555666', 'Sevilla', 22),
    (6, 'Alberto', 'alberto@hotmail.com', NULL, 'Valencia', 29),
    (7, 'Sofia', 'sofia@empresa.com', '600777888', 'Barcelona', 38);
```

## Requisitos

- [ ] La consulta devuelve el resultado esperado
- [ ] Ejecutarlo localmente (SQLite o PostgreSQL) y verificar
- [ ] Los tests pasan: `bash ejercicio-06-like-y-filtros-test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Pista 1: `LIKE 'A%'` — el `%` significa "cualquier número de caracteres".
- Pista 2: `LIKE '%gmail%'` busca en cualquier posición.
- Pista 3: `WHERE ciudad IN ('Madrid', 'Valencia')`.
- Pista 4: `WHERE edad BETWEEN 25 AND 35` (inclusive).
- Pista 5: `NULL` se compara con `IS NULL`, nunca con `= NULL`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````sql
-- 1. Nombre empieza por A
SELECT nombre FROM clientes WHERE nombre LIKE 'A%';

-- 2. Email contiene gmail
SELECT nombre, email FROM clientes WHERE email LIKE '%gmail%';

-- 3. Ciudades Madrid o Valencia
SELECT nombre, ciudad FROM clientes WHERE ciudad IN ('Madrid', 'Valencia');

-- 4. Edad entre 25 y 35
SELECT nombre, edad FROM clientes WHERE edad BETWEEN 25 AND 35;

-- 5. Sin telefono
SELECT nombre FROM clientes WHERE telefono IS NULL;
````

</details>