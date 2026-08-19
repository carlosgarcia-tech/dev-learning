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

SELECT 'estado_tras_migracion_002' AS paso;
PRAGMA table_info(usuarios);

-- Migración 003: Modificar columna (equivalente a ALTER COLUMN TYPE).
-- SQLite no cambia el tipo de una columna existente; se reconstruye la tabla.
-- Insertamos un usuario real para que la copia de datos sea significativa.
INSERT INTO usuarios (id, nombre, email) VALUES (1, 'Ana Pérez', 'ana@email.com');

CREATE TABLE usuarios_nueva (
    id INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL,
    email TEXT
);

INSERT INTO usuarios_nueva (id, nombre, email)
    SELECT id, nombre, email FROM usuarios;

DROP TABLE usuarios;
ALTER TABLE usuarios_nueva RENAME TO usuarios;

SELECT 'estado_tras_migracion_003' AS paso;
SELECT id, nombre, email FROM usuarios ORDER BY id;

-- Migración 004: Agregar constraint UNIQUE (equivalente a ADD CONSTRAINT).
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

SELECT 'estado_tras_migracion_004' AS paso;
PRAGMA index_list(usuarios);

-- Migración 005: Crear tabla perfiles
CREATE TABLE perfiles (
    id INTEGER PRIMARY KEY,
    usuario_id INTEGER REFERENCES usuarios(id),
    bio TEXT
);

-- Migración 006: Eliminar columna email.
-- DROP COLUMN de SQLite (3.35+) no admite columnas que formen parte de un
-- índice UNIQUE, así que de nuevo se usa el patrón de reconstrucción.
CREATE TABLE usuarios_nueva (
    id INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL
);

INSERT INTO usuarios_nueva (id, nombre)
    SELECT id, nombre FROM usuarios;

DROP TABLE usuarios;
ALTER TABLE usuarios_nueva RENAME TO usuarios;

SELECT 'estado_tras_migracion_006' AS paso;
PRAGMA table_info(usuarios);

-- Tablas creadas por las migraciones
SELECT name AS tabla FROM sqlite_master
WHERE type = 'table' AND name IN ('usuarios', 'perfiles')
ORDER BY name;

-- Versiones de migración registradas en la tabla de control
SELECT version FROM migraciones ORDER BY version;