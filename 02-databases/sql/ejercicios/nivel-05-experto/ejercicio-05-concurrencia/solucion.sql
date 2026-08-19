-- Concurrencia en SQLite.
-- SQLite NO soporta SELECT ... FOR UPDATE ni BEGIN TRANSACTION
-- ISOLATION LEVEL SERIALIZABLE. En su lugar usa bloqueo de escritura a
-- nivel de base de datos y tres niveles de transacción: DEFERRED (por
-- defecto), IMMEDIATE y EXCLUSIVE. Estos ejemplos enseñan los mismos
-- conceptos con lo que SQLite sí ofrece.

-- 1) PRAGMA busy_timeout: cuánto tiempo espera una conexión si otra
--    mantiene el candado de escritura antes de devolver "database is locked".
PRAGMA busy_timeout = 5000;

-- 2) BEGIN IMMEDIATE obtiene el candado de escritura al empezar, de forma
--    que ningún otro escritor puede interferir hasta el COMMIT. Es el
--    equivalente práctico al bloqueo de fila de SELECT ... FOR UPDATE.
BEGIN IMMEDIATE;
UPDATE productos SET stock = stock - 1 WHERE id = 1;
SELECT changes() AS filas_afectadas;
COMMIT;

-- Estado tras la transacción
SELECT id, nombre, stock FROM productos WHERE id = 1;

-- 3) Optimistic locking con columna version.
--    La actualización solo tiene efecto si la versión leída sigue intacta;
--    si otro proceso la modificó, la fila no se actualiza y changes() = 0.
UPDATE productos_version
SET stock = stock - 1, version = version + 1
WHERE id = 1 AND version = 1;

SELECT
    changes() AS filas_afectadas,
    (SELECT stock FROM productos_version WHERE id = 1) AS stock,
    (SELECT version FROM productos_version WHERE id = 1) AS version;

-- 4) Segundo intento con la versión ANTIGUA (1): ya no coincide con la
--    versión actual (2), así que no afecta a ninguna fila. La aplicación
--    detecta el conflicto vía changes() y debe reintentar releyendo la
--    versión más reciente.
UPDATE productos_version
SET stock = stock - 1, version = version + 1
WHERE id = 1 AND version = 1;

SELECT
    changes() AS filas_afectadas,
    (SELECT stock FROM productos_version WHERE id = 1) AS stock,
    (SELECT version FROM productos_version WHERE id = 1) AS version;

-- 5) Transacción DEFERRED: el candado de escritura se adquiere solo en la
--    primera sentencia de escritura, no al abrir la transacción. Es el modo
--    por defecto de SQLite y maximiza la concurrencia de lecturas.
BEGIN;
UPDATE productos SET stock = stock - 1 WHERE id = 2;
COMMIT;

SELECT id, nombre, stock FROM productos ORDER BY id;