# Ejercicio 01 — SELECT básico

- **Nivel:** 1/5
- **Tema:** SELECT, columnas, `*`, DISTINCT
- **Tiempo estimado:** 15 min

## Enunciado

Dada la tabla `usuarios`, escribe las siguientes consultas:

1. Selecciona **todas las columnas** de la tabla `usuarios`.
2. Selecciona solo las columnas `nombre` y `email`.
3. Selecciona la columna `ciudad` **sin duplicados** (usa `DISTINCT`).

El resultado esperado de la consulta 3 debe tener 4 filas: las ciudades únicas del dataset.

## Schema inicial

```sql
CREATE TABLE usuarios (
    id INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL,
    email TEXT NOT NULL,
    edad INTEGER,
    ciudad TEXT
);

INSERT INTO usuarios (id, nombre, email, edad, ciudad) VALUES
    (1, 'Ana', 'ana@example.com', 28, 'Madrid'),
    (2, 'Luis', 'luis@example.com', 34, 'Barcelona'),
    (3, 'Marta', 'marta@example.com', 22, 'Madrid'),
    (4, 'Carlos', 'carlos@example.com', 41, 'Valencia'),
    (5, 'Lucia', 'lucia@example.com', 29, 'Barcelona'),
    (6, 'Pedro', 'pedro@example.com', 30, 'Sevilla');
```

## Requisitos

- [ ] La consulta devuelve el resultado esperado
- [ ] Ejecutarlo localmente (SQLite o PostgreSQL) y verificar

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Pista 1: Para todas las columnas se usa `*`.
- Pista 2: Las columnas se separan con comas en el `SELECT`.
- Pista 3: `SELECT DISTINCT` elimina valores repetidos de una columna.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````sql
-- 1. Todas las columnas
SELECT * FROM usuarios;

-- 2. Solo nombre y email
SELECT nombre, email FROM usuarios;

-- 3. Ciudades únicas
SELECT DISTINCT ciudad FROM usuarios;
````

</details>