-- Concurrencia en SQLite (compatible con SQLite).
-- SQLite no tiene SELECT ... FOR UPDATE ni niveles de aislamiento
-- SERIALIZABLE explícitos: usa un candado de escritura a nivel de base.
-- La tabla productos_version incorpora la columna version para el patrón
-- de optimistic locking.

CREATE TABLE productos (
    id INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL,
    stock INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE productos_version (
    id INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL,
    stock INTEGER NOT NULL DEFAULT 0,
    version INTEGER NOT NULL DEFAULT 1
);

INSERT INTO productos (id, nombre, stock) VALUES
    (1, 'Portátil', 10),
    (2, 'Monitor', 5);

INSERT INTO productos_version (id, nombre, stock, version) VALUES
    (1, 'Portátil', 10, 1);