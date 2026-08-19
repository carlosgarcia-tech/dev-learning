-- Habilita el enforcement de claves foráneas (por defecto SQLite no lo aplica)
PRAGMA foreign_keys = ON;

-- Verificación de que las constraints están aplicadas y se cumplen.
-- (En SQLite las restricciones viven en el CREATE TABLE, no hay
--  ALTER TABLE ADD CONSTRAINT como en PostgreSQL.)

-- 1. Estructura: PK, FK, UNIQUE, CHECK, DEFAULT y UNIQUE compuesto
SELECT sql FROM sqlite_master
WHERE type = 'table' AND name IN ('clientes', 'pedidos')
ORDER BY name;

-- 2. Datos insertados: DEFAULT activo = 1 en Pedro Test (id 5)
SELECT id, nombre, email, telefono, edad, estado, activo
FROM clientes
ORDER BY id;

-- 3. Datos válidos según FK, CHECK (total >= 0) y UNIQUE (cliente_id, fecha)
SELECT id, cliente_id, fecha, total, estado
FROM pedidos
ORDER BY id;

-- 4. Integridad: ninguna restricción se ha violado
SELECT
    (SELECT COUNT(*) FROM (SELECT email FROM clientes GROUP BY email HAVING COUNT(*) > 1)) AS emails_duplicados,
    (SELECT COUNT(*) FROM (SELECT cliente_id, fecha FROM pedidos GROUP BY cliente_id, fecha HAVING COUNT(*) > 1)) AS pedidos_duplicados,
    (SELECT COUNT(*) FROM clientes WHERE edad < 18 OR edad > 150) AS edades_invalidas,
    (SELECT COUNT(*) FROM pedidos p LEFT JOIN clientes c ON c.id = p.cliente_id WHERE c.id IS NULL) AS pedidos_sin_cliente;

-- 5. FK con ON DELETE CASCADE: al borrar el cliente 5 se borran sus pedidos
DELETE FROM clientes WHERE id = 5;

SELECT COUNT(*) AS pedidos_restantes FROM pedidos;

SELECT id, cliente_id, total, estado
FROM pedidos
ORDER BY id;