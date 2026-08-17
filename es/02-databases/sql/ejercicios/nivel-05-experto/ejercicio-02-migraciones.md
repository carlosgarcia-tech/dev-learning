# Ejercicio 02 — Migraciones

- **Nivel:** 5/5
- **Tema:** ALTER TABLE, ADD/DROP COLUMN, migración de datos
- **Tiempo estimado:** 30 min

## Enunciado

Partes de una tabla `clientes` sin columna de teléfono y con datos que no cumplen `NOT NULL`:

1. **Migración 1**: añade una columna `telefono TEXT` con `ALTER TABLE ... ADD COLUMN`.
2. **Migración 2**: crea una tabla nueva `clientes_v2` que copie los datos de `clientes` añadiendo una columna `activo` (booleano) por defecto `1` para todos, e inserta desde la tabla antigua con `INSERT INTO ... SELECT`.
3. **Migración 3**: renombra la tabla nueva para quedarse solo con `clientes` (en SQLite renombra con `ALTER TABLE clientes RENAME TO clientes_old` y luego `ALTER TABLE clientes_v2 RENAME TO clientes`). En PostgreSQL puedes usar `ALTER TABLE ... RENAME`.
4. Verifica que `clientes` final tiene la columna `telefono` y `activo`.

## Schema inicial

```sql
CREATE TABLE clientes (
    id INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL,
    email TEXT NOT NULL
);

INSERT INTO clientes (id, nombre, email) VALUES
    (1, 'Ana', 'ana@example.com'),
    (2, 'Luis', 'luis@example.com'),
    (3, 'Marta', 'marta@example.com');
```

## Requisitos

- [ ] La consulta devuelve el resultado esperado
- [ ] Ejecutarlo localmente (SQLite o PostgreSQL) y verificar

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Pista 1: `ALTER TABLE clientes ADD COLUMN telefono TEXT;`
- Pista 2: SQLite no permite modificar columnas; la técnica de **crear nueva + copiar + renombrar** es el patrón estándar.
- Pista 3: `INSERT INTO clientes_v2 (id, nombre, email, telefono, activo) SELECT id, nombre, email, NULL, 1 FROM clientes;`
- Pista 4: En PostgreSQL puedes usar `ALTER TABLE ... ADD COLUMN ... DEFAULT 1` directamente sin recrear la tabla.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````sql
-- 1. Añadir columna telefono
ALTER TABLE clientes ADD COLUMN telefono TEXT;

-- 2. Crear v2 con columna activo y copiar datos
CREATE TABLE clientes_v2 (
    id INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL,
    email TEXT NOT NULL,
    telefono TEXT,
    activo INTEGER NOT NULL DEFAULT 1
);

INSERT INTO clientes_v2 (id, nombre, email, telefono, activo)
SELECT id, nombre, email, NULL, 1 FROM clientes;

-- 3. Reemplazar la tabla original
ALTER TABLE clientes RENAME TO clientes_old;
ALTER TABLE clientes_v2 RENAME TO clientes;
DROP TABLE clientes_old;

-- 4. Verificación
SELECT * FROM clientes;
````

</details>