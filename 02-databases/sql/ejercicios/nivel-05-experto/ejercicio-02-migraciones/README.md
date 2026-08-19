# Ejercicio 26 — Migraciones

- **Nivel:** 5/5
- **Tema:** Experto en SQL
- **Tiempo estimado:** 40 minutos

## Enunciado

1. Crea migración inicial
2. Crea migración para agregar columna
3. Crea migración para modificar columna
4. Crea migración para eliminar columna

## Requisitos

- [ ] La tabla/consulta se ajusta a lo pedido en el enunciado
- [ ] Las consultas devuelven los resultados esperados
- [ ] Los tests pasan: `bash test.sh`

## Solución

<details>
<summary>Mostrar solución</summary>

```sql
-- Migraciones 001-006 en SQLite.
-- SQLite no soporta ALTER COLUMN ... TYPE ni ADD CONSTRAINT ... UNIQUE.
-- Esas dos operaciones se resuelven con el patrón estándar de
-- reconstrucción de tabla: crear la nueva, copiar los datos, borrar la
-- antigua y renombrar.

-- Migración 001: Crear tabla usuarios
CREATE TABLE usuarios (
    id INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL
);

-- Migración 002: Agregar columna email (ALTER TABLE ... ADD COLUMN)
ALTER TABLE usuarios ADD COLUMN email TEXT;

-- Migración 003: Modificar columna (equivale a ALTER COLUMN TYPE).
-- SQLite no cambia el tipo de una columna existente; se reconstruye la tabla.
CREATE TABLE usuarios_nueva (
    id INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL,
    email TEXT
);

INSERT INTO usuarios_nueva (id, nombre, email)
    SELECT id, nombre, email FROM usuarios;

DROP TABLE usuarios;
ALTER TABLE usuarios_nueva RENAME TO usuarios;

-- Migración 004: Agregar constraint UNIQUE (equivale a ADD CONSTRAINT).
-- SQLite tampoco añade restricciones a una tabla existente; se reconstruye.
CREATE TABLE usuarios_nueva (
    id INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL,
    email TEXT UNIQUE
);

INSERT INTO usuarios_nueva (id, nombre, email)
    SELECT id, nombre, email FROM usuarios;

DROP TABLE usuarios;
ALTER TABLE usuarios_nueva RENAME TO usuarios;

-- Migración 005: Crear tabla perfiles
CREATE TABLE perfiles (
    id INTEGER PRIMARY KEY,
    usuario_id INTEGER REFERENCES usuarios(id),
    bio TEXT
);

-- Migración 006: Eliminar columna email.
-- DROP COLUMN de SQLite (3.35+) no admite columnas con índice UNIQUE,
-- así que de nuevo se usa el patrón de reconstrucción.
CREATE TABLE usuarios_nueva (
    id INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL
);

INSERT INTO usuarios_nueva (id, nombre)
    SELECT id, nombre FROM usuarios;

DROP TABLE usuarios;
ALTER TABLE usuarios_nueva RENAME TO usuarios;
```

</details>
