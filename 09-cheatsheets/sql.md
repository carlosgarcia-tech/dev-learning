# Chuleta de SQL

Referencia rápida de SQL estándar (ANSI), válida en su mayoría para PostgreSQL, MySQL, SQLite y otros. Se indican variaciones cuando es relevante.

## Índice

- [SELECT](#select)
- [WHERE](#where)
- [JOIN](#join)
- [GROUP BY](#group-by)
- [HAVING](#having)
- [Subconsultas](#subconsultas)
- [Funciones](#funciones)
- [DDL (CREATE, ALTER, DROP)](#ddl-create-alter-drop)
- [DML (INSERT, UPDATE, DELETE)](#dml-insert-update-delete)
- [TCL (Transacciones)](#tcl-transacciones)
- [Índices](#índices)
- [Vistas](#vistas)
- [Stored procedures y funciones](#stored-procedures-y-funciones)
- [Transacciones](#transacciones)
- [Normalización](#normalización)

---

## SELECT

```sql
SELECT columna1, columna2
FROM tabla
WHERE condicion
GROUP BY columna
HAVING condicion_grupo
ORDER BY columna ASC|DESC
LIMIT n OFFSET m;
```

| Cláusula | Descripción |
|---|---|
| `SELECT` | Columnas a devolver |
| `DISTINCT` | Elimina duplicados |
| `FROM` | Tabla origen |
| `WHERE` | Filtro por fila (antes de agrupar) |
| `GROUP BY` | Agrupa filas |
| `HAVING` | Filtro por grupo (después de agrupar) |
| `ORDER BY` | Ordenación |
| `LIMIT` / `OFFSET` | Paginación |
| `AS` | Alias |

```sql
-- Todos los campos
SELECT * FROM usuarios;

-- Alias de columnas y tablas
SELECT u.nombre AS nombre_usuario, u.email
FROM usuarios AS u;

-- Eliminar duplicados
SELECT DISTINCT pais FROM usuarios;

-- Paginación (10 por página, página 3)
SELECT * FROM productos
ORDER BY id
LIMIT 10 OFFSET 20;

-- MySQL/PostgreSQL: FETCH (estándar SQL)
SELECT * FROM productos
ORDER BY id
FETCH FIRST 10 ROWS ONLY;
```

---

## WHERE

Operadores de comparación y lógicos.

| Operador | Significado |
|---|---|
| `=` | Igual |
| `<>` o `!=` | Distinto |
| `<`, `>`, `<=`, `>=` | Comparación |
| `BETWEEN x AND y` | Rango inclusive |
| `NOT BETWEEN x AND y` | Fuera de rango |
| `IN (a, b, c)` | Está en la lista |
| `NOT IN (a, b, c)` | No está en la lista |
| `LIKE 'A%'` | Empieza por A (`%` cualquier, `_` uno) |
| `ILIKE 'a%'` | LIKE sin mayúsculas (PostgreSQL) |
| `IS NULL` | Es nulo |
| `IS NOT NULL` | No es nulo |
| `AND` / `OR` / `NOT` | Lógicos |
| `EXISTS (subquery)` | Existe fila |

```sql
SELECT * FROM productos
WHERE precio BETWEEN 10 AND 50
  AND categoria IN ('electrónica', 'hogar')
  AND nombre LIKE 'USB%'
  AND stock IS NOT NULL;

-- Búsqueda con comodines
SELECT * FROM usuarios WHERE email LIKE '%@gmail.com';
SELECT * FROM usuarios WHERE nombre LIKE 'Mar_a';   -- Maria, Marta...

-- IS NULL vs = NULL (¡importante!)
SELECT * FROM pedidos WHERE fecha_envio IS NULL;     -- correcto
SELECT * FROM pedidos WHERE fecha_envio = NULL;     -- NUNCA funciona
```

---

## JOIN

Combinar filas de dos o más tablas.

| Tipo | Devuelve |
|---|---|
| `INNER JOIN` | Solo filas que coinciden en ambas |
| `LEFT JOIN` | Todas de la izquierda + coincidencias |
| `RIGHT JOIN` | Todas de la derecha + coincidencias |
| `FULL OUTER JOIN` | Todas de ambas (null donde no coincide) |
| `CROSS JOIN` | Producto cartesiano |
| `SELF JOIN` | JOIN de una tabla consigo misma |

```sql
-- INNER JOIN: pedidos con su usuario
SELECT u.nombre, p.fecha, p.total
FROM pedidos p
INNER JOIN usuarios u ON p.usuario_id = u.id;

-- LEFT JOIN: todos los usuarios, tengan o no pedidos
SELECT u.nombre, COUNT(p.id) AS num_pedidos
FROM usuarios u
LEFT JOIN pedidos p ON p.usuario_id = u.id
GROUP BY u.id, u.nombre;

-- Solo usuarios SIN pedidos
SELECT u.*
FROM usuarios u
LEFT JOIN pedidos p ON p.usuario_id = u.id
WHERE p.id IS NULL;

-- JOIN de tres tablas
SELECT u.nombre, p.fecha, pr.nombre
FROM usuarios u
JOIN pedidos p ON p.usuario_id = u.id
JOIN items i ON i.pedido_id = p.id
JOIN productos pr ON pr.id = i.producto_id;

-- SELF JOIN: empleados y su jefe
SELECT e.nombre AS empleado, j.nombre AS jefe
FROM empleados e
LEFT JOIN empleados j ON e.jefe_id = j.id;

-- CROSS JOIN (cuidado: N×M filas)
SELECT t.talla, c.color
FROM tallas t CROSS JOIN colores c;
```

### Diagrama mental de JOINs

```
  INNER          LEFT          RIGHT          FULL
  A∩B            A∪(A∩B)       B∪(A∩B)        A∪B∪(A∩B)
  ⬤⬤              ⬤⬤⬤           ⬤⬤⬤            ⬤⬤⬤⬤
```

---

## GROUP BY

Agrupa filas para aplicar funciones de agregación.

| Función | Descripción |
|---|---|
| `COUNT(*)` | Número de filas |
| `COUNT(columna)` | Nº de no-nulos |
| `COUNT(DISTINCT col)` | Nº de valores distintos |
| `SUM(col)` | Suma |
| `AVG(col)` | Media |
| `MIN(col)` / `MAX(col)` | Mínimo / Máximo |
| `STRING_AGG(col, ',')` | Concatena (PostgreSQL) |
| `GROUP_CONCAT(col)` | Concatena (MySQL/SQLite) |

```sql
-- Nº de pedidos por usuario
SELECT usuario_id, COUNT(*) AS num_pedidos, SUM(total) AS gastado
FROM pedidos
GROUP BY usuario_id;

-- Promedio de precio por categoría
SELECT categoria, AVG(precio) AS precio_medio
FROM productos
GROUP BY categoria;

-- Varios niveles de agrupación
SELECT pais, ciudad, COUNT(*) AS habitantes
FROM usuarios
GROUP BY pais, ciudad;
```

---

## HAVING

Filtra grupos (no se puede usar WHERE con agregados).

```sql
-- Categorías con precio medio > 100
SELECT categoria, AVG(precio) AS media
FROM productos
GROUP BY categoria
HAVING AVG(precio) > 100
ORDER BY media DESC;

-- Usuarios con más de 5 pedidos
SELECT usuario_id, COUNT(*) AS total
FROM pedidos
GROUP BY usuario_id
HAVING COUNT(*) > 5;
```

### Orden de ejecución lógico

```
1. FROM + JOIN     (se unen tablas)
2. WHERE           (se filtran filas)
3. GROUP BY        (se agrupan)
4. HAVING          (se filtran grupos)
5. SELECT          (se calculan columnas)
6. DISTINCT        (se eliminan duplicados)
7. ORDER BY        (se ordena)
8. LIMIT/OFFSET    (se pagina)
```

---

## Subconsultas

Consultas dentro de otras consultas.

```sql
-- Productos más caros que la media
SELECT nombre, precio
FROM productos
WHERE precio > (SELECT AVG(precio) FROM productos);

-- Usuarios que han hecho algún pedido (EXISTS)
SELECT u.nombre
FROM usuarios u
WHERE EXISTS (SELECT 1 FROM pedidos p WHERE p.usuario_id = u.id);

-- Usuarios que NO han pedido nada (NOT IN)
SELECT nombre FROM usuarios
WHERE id NOT IN (SELECT usuario_id FROM pedidos WHERE usuario_id IS NOT NULL);

-- Subconsulta en FROM (tabla derivada)
SELECT categoria, media
FROM (
  SELECT categoria, AVG(precio) AS media
  FROM productos
  GROUP BY categoria
) AS sub
WHERE media > 100;

-- Subconsulta escalar en SELECT
SELECT nombre,
       precio,
       (SELECT MAX(precio) FROM productos) AS maximo,
       precio / (SELECT MAX(precio) FROM productos) AS ratio
FROM productos;
```

### CTE (Common Table Expression): subconsultas con nombre

```sql
WITH pedidos_por_mes AS (
  SELECT DATE_TRUNC('month', fecha) AS mes, COUNT(*) AS total
  FROM pedidos
  GROUP BY mes
),
meses_top AS (
  SELECT mes FROM pedidos_por_mes ORDER BY total DESC LIMIT 3
)
SELECT * FROM pedidos_por_mes WHERE mes IN (SELECT mes FROM meses_top);

-- CTE recursiva: jerarquía de empleados
WITH RECURSIVE jerarquia AS (
  SELECT id, nombre, jefe_id, 0 AS nivel
  FROM empleados WHERE jefe_id IS NULL
  UNION ALL
  SELECT e.id, e.nombre, e.jefe_id, j.nivel + 1
  FROM empleados e
  JOIN jerarquia j ON e.jefe_id = j.id
)
SELECT nombre, nivel FROM jerarquia;
```

---

## Funciones

### Texto

| Función | Descripción |
|---|---|
| `LENGTH(s)` / `CHAR_LENGTH(s)` | Longitud |
| `UPPER(s)` / `LOWER(s)` | Mayúsculas / minúsculas |
| `SUBSTRING(s, inicio, longitud)` | Subcadena |
| `TRIM(s)` | Quita espacios |
| `LTRIM` / `RTRIM` | Izquierda / derecha |
| `REPLACE(s, a, b)` | Reemplaza |
| `CONCAT(a, b)` | Concatena |
| `CONCAT_WS(sep, a, b)` | Concatena con separador |
| `LEFT(s, n)` / `RIGHT(s, n)` | Primeros/últimos n |
| `POSITION('a' IN s)` | Posición |
| `COALESCE(a, b, c)` | Primer no-nulo |
| `NULLIF(a, b)` | NULL si a=b |

### Numéricas

| Función | Descripción |
|---|---|
| `ROUND(n, decimales)` | Redondear |
| `FLOOR(n)` / `CEIL(n)` | Abajo / arriba |
| `ABS(n)` | Valor absoluto |
| `MOD(a, b)` | Módulo |
| `POWER(a, b)` | Potencia |
| `SQRT(n)` | Raíz cuadrada |
| `RANDOM()` | Nº aleatorio (PostgreSQL) |
| `GREATEST(a, b, c)` | El mayor |
| `LEAST(a, b, c)` | El menor |

### Fechas

| Función | Descripción |
|---|---|
| `CURRENT_DATE` | Fecha actual |
| `CURRENT_TIMESTAMP` / `NOW()` | Fecha y hora |
| `EXTRACT(MONTH FROM fecha)` | Extraer parte |
| `DATE_TRUNC('month', fecha)` | Truncar (PostgreSQL) |
| `AGE(fecha)` / `AGE(a, b)` | Diferencia (PostgreSQL) |
| `fecha + INTERVAL '1 day'` | Sumar intervalo |
| `DATE_ADD(fecha, INTERVAL 1 DAY)` | MySQL |
| `DATE_FORMAT(fecha, '%Y-%m')` | MySQL |
| `TO_CHAR(fecha, 'YYYY-MM-DD')` | PostgreSQL |

```sql
SELECT
  nombre,
  fecha_registro,
  EXTRACT(YEAR FROM fecha_registro) AS anio,
  CURRENT_DATE - fecha_registro::date AS dias_alta
FROM usuarios
WHERE fecha_registro >= CURRENT_DATE - INTERVAL '30 days';
```

### Conversión de tipos

```sql
CAST(precio AS INTEGER);     -- estándar
precio::INTEGER;             -- PostgreSQL
CAST(fecha AS DATE);
texto::DATE;
```

---

## DDL (CREATE, ALTER, DROP)

Definición de estructura de la base de datos.

### CREATE TABLE

```sql
CREATE TABLE usuarios (
  id           SERIAL PRIMARY KEY,           -- PostgreSQL (AUTO_INCREMENT en MySQL)
  nombre       VARCHAR(100) NOT NULL,
  email        VARCHAR(255) UNIQUE NOT NULL,
  edad         INTEGER CHECK (edad >= 0),
  rol          VARCHAR(20) DEFAULT 'user',
  creado_en    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  activo       BOOLEAN DEFAULT TRUE
);
```

Tipos comunes:

| Tipo | Uso |
|---|---|
| `INT` / `BIGINT` / `SMALLINT` | Enteros |
| `SERIAL` / `BIGSERIAL` | Entero autoincremental (PostgreSQL) |
| `DECIMAL(p, s)` / `NUMERIC` | Decimales exactos (dinero) |
| `VARCHAR(n)` / `TEXT` | Texto |
| `CHAR(n)` | Texto fijo |
| `BOOLEAN` | true/false |
| `DATE` | Solo fecha |
| `TIME` | Solo hora |
| `TIMESTAMP` | Fecha y hora |
| `JSON` / `JSONB` | JSON (PostgreSQL) |
| `UUID` | Identificador único (PostgreSQL) |
| `BLOB` / `BYTEA` | Binario |

### Constraints

| Restricción | Descripción |
|---|---|
| `PRIMARY KEY` | Clave principal (única + no nula) |
| `FOREIGN KEY` | Clave foránea |
| `UNIQUE` | Valor único |
| `NOT NULL` | No puede ser nulo |
| `CHECK (expr)` | Condición personalizada |
| `DEFAULT valor` | Valor por defecto |

### ALTER TABLE

```sql
-- Añadir columna
ALTER TABLE usuarios ADD COLUMN telefono VARCHAR(20);

-- Borrar columna
ALTER TABLE usuarios DROP COLUMN telefono;

-- Modificar tipo
ALTER TABLE usuarios ALTER COLUMN edad TYPE BIGINT;        -- PostgreSQL
ALTER TABLE usuarios MODIFY edad BIGINT;                   -- MySQL

-- Renombrar columna
ALTER TABLE usuarios RENAME COLUMN nombre TO nombre_completo;

-- Añadir constraint
ALTER TABLE usuarios ADD CONSTRAINT email_unico UNIQUE (email);

-- Clave foránea
ALTER TABLE pedidos
  ADD COLUMN usuario_id INTEGER REFERENCES usuarios(id)
  ON DELETE CASCADE;

-- Borrar constraint
ALTER TABLE usuarios DROP CONSTRAINT email_unico;
```

Acciones referenciales (ON DELETE / ON UPDATE):

| Acción | Comportamiento |
|---|---|
| `CASCADE` | Propaga el borrado/cambio |
| `SET NULL` | Pone a NULL las referenciadas |
| `SET DEFAULT` | Pone el valor por defecto |
| `RESTRICT` | Impide la acción (inmediato) |
| `NO ACTION` | Igual que RESTRICT (por defecto) |

### DROP / TRUNCATE

```sql
DROP TABLE usuarios;                    -- borra la tabla
DROP TABLE IF EXISTS usuarios;          -- no falla si no existe
DROP TABLE usuarios CASCADE;            -- borra dependientes
TRUNCATE TABLE pedidos;                 -- vacía sin log de filas (rápido)
TRUNCATE TABLE pedidos RESTART IDENTITY; -- reinicia SERIAL
```

### CREATE DATABASE / SCHEMA

```sql
CREATE DATABASE mi_app;
CREATE SCHEMA ventas;
DROP DATABASE mi_app;
```

---

## DML (INSERT, UPDATE, DELETE)

### INSERT

```sql
INSERT INTO usuarios (nombre, email, edad)
VALUES ('Ana', 'ana@x.com', 30);

-- Múltiples filas
INSERT INTO productos (nombre, precio)
VALUES ('A', 10), ('B', 20), ('C', 30);

-- INSERT desde SELECT
INSERT INTO usuarios_backup (nombre, email)
SELECT nombre, email FROM usuarios WHERE activo = TRUE;

-- Devolver datos (PostgreSQL)
INSERT INTO usuarios (nombre) VALUES ('Ana') RETURNING id, creado_en;

-- Upsert (PostgreSQL)
INSERT INTO usuarios (id, nombre) VALUES (1, 'Ana')
ON CONFLICT (id) DO UPDATE SET nombre = EXCLUDED.nombre;

-- Upsert MySQL
INSERT INTO usuarios (id, nombre) VALUES (1, 'Ana')
ON DUPLICATE KEY UPDATE nombre = VALUES(nombre);
```

### UPDATE

```sql
UPDATE productos SET precio = precio * 1.1 WHERE categoria = 'electronica';

-- Múltiples columnas
UPDATE usuarios SET nombre = 'Ana2', edad = 31 WHERE id = 1;

-- Con subconsulta
UPDATE empleados e
SET salario = salario * 1.05
WHERE e.departamento_id = (SELECT id FROM departamentos WHERE nombre = 'IT');

-- UPDATE con JOIN (MySQL)
UPDATE productos p
JOIN categorias c ON p.categoria_id = c.id
SET p.precio = p.precio * 0.9
WHERE c.nombre = 'liquidacion';

-- UPDATE con FROM (PostgreSQL)
UPDATE empleados e
SET salario = n.nuevo
FROM nominas n
WHERE e.id = n.empleado_id;
```

### DELETE

```sql
DELETE FROM usuarios WHERE activo = FALSE;

-- DELETE con subconsulta
DELETE FROM pedidos
WHERE usuario_id IN (SELECT id FROM usuarios WHERE borrado = TRUE);

-- Borrar todo (¡cuidado!)
DELETE FROM pedidos;
```

> `DELETE` registra cada fila borrada (lento, reversible). `TRUNCATE` es más rápido pero no se puede rollback parcial en algunos motores.

---

## TCL (Transacciones)

| Comando | Descripción |
|---|---|
| `BEGIN` / `START TRANSACTION` | Inicia transacción |
| `COMMIT` | Confirma los cambios |
| `ROLLBACK` | Deshace todo desde BEGIN |
| `SAVEPOINT nombre` | Punto de guardado parcial |
| `ROLLBACK TO nombre` | Deshace hasta un savepoint |
| `RELEASE SAVEPOINT nombre` | Elimina un savepoint |
| `SET TRANSACTION ISOLATION LEVEL` | Nivel de aislamiento |

```sql
BEGIN;

  UPDATE cuentas SET saldo = saldo - 100 WHERE id = 1;
  UPDATE cuentas SET saldo = saldo + 100 WHERE id = 2;

  -- Si algo falla, ROLLBACK deshace ambas
  SAVEPOINT sp1;

  INSERT INTO movimientos (cuenta, monto) VALUES (1, -100);
  INSERT INTO movimientos (cuenta, monto) VALUES (2, 100);

COMMIT;
```

Niveles de aislamiento:

| Nivel | Problemas que evita |
|---|---|
| `READ UNCOMMITTED` | Ninguno (lecturas sucias) |
| `READ COMMITTED` | Evita lecturas sucias |
| `REPEATABLE READ` | + Evita lecturas no repetibles |
| `SERIALIZABLE` | + Evita lecturas fantasma (más restrictivo) |

---

## Índices

Mejoran la velocidad de lectura a costa de escritura y espacio.

```sql
CREATE INDEX idx_email ON usuarios(email);
CREATE INDEX idx_nombre_apellido ON usuarios(nombre, apellido);  -- compuesto
CREATE UNIQUE INDEX idx_unico ON usuarios(email);
CREATE INDEX idx_fecha ON pedidos(fecha DESC);

-- Índices especiales (PostgreSQL)
CREATE INDEX idx_gin ON posts USING GIN (etiquetas);        -- JSONB/array
CREATE INDEX idx_gist ON lugares USING GIST (geom);          -- espacial
CREATE INDEX idx_part ON logs(mensaje) WHERE tipo = 'error'; -- parcial

DROP INDEX idx_email;
DROP INDEX IF EXISTS idx_email;
```

| Tipo | Cuándo |
|---|---|
| B-Tree (por defecto) | Igualdad y rangos |
| Hash | Solo igualdad |
| GIN | Arrays, JSONB, búsqueda de texto |
| GiST | Datos geométricos/espaciales |
| Índice parcial | Subconjunto frecuente |
| Índice compuesto | Consultas por varias columnas |

```sql
-- Ver plan de ejecución
EXPLAIN SELECT * FROM usuarios WHERE email = 'a@b.com';
EXPLAIN ANALYZE SELECT * FROM usuarios WHERE email = 'a@b.com';
```

---

## Vistas

Consultas guardadas como tablas virtuales.

```sql
CREATE VIEW pedidos_resumen AS
SELECT u.nombre, COUNT(p.id) AS num_pedidos, COALESCE(SUM(p.total), 0) AS total
FROM usuarios u
LEFT JOIN pedidos p ON p.usuario_id = u.id
GROUP BY u.id, u.nombre;

SELECT * FROM pedidos_resumen WHERE num_pedidos > 0;

CREATE OR REPLACE VIEW pedidos_resumen AS SELECT ...;
DROP VIEW pedidos_resumen;
```

### Vistas materializadas (PostgreSQL)

```sql
CREATE MATERIALIZED VIEW ventas_mensuales AS
SELECT DATE_TRUNC('month', fecha) AS mes, SUM(total) AS total
FROM pedidos GROUP BY mes;

REFRESH MATERIALIZED VIEW ventas_mensuales;
REFRESH MATERIALIZED VIEW CONCURRENTLY ventas_mensuales;  -- necesita índice único
```

---

## Stored procedures y funciones

### PostgreSQL: funciones (PL/pgSQL)

```sql
CREATE OR REPLACE FUNCTION precio_con_iva(precio NUMERIC)
RETURNS NUMERIC AS $$
BEGIN
  RETURN precio * 1.21;
END;
$$ LANGUAGE plpgsql;

SELECT precio_con_iva(100);   -- 121

-- Procedimiento con OUT
CREATE OR REPLACE FUNCTION crear_usuario(
  nombre VARCHAR, email VARCHAR, OUT nuevo_id INTEGER
) AS $$
BEGIN
  INSERT INTO usuarios (nombre, email) VALUES (nombre, email)
  RETURNING id INTO nuevo_id;
END;
$$ LANGUAGE plpgsql;

CALL crear_usuario('Ana', 'ana@x.com', NULL);  -- o SELECT
```

### MySQL: procedures y functions

```sql
DELIMITER //
CREATE PROCEDURE total_pedidos(IN uid INT, OUT total DECIMAL(10,2))
BEGIN
  SELECT SUM(total) INTO total FROM pedidos WHERE usuario_id = uid;
END //
DELIMITER ;

CALL total_pedidos(1, @t);
SELECT @t;
```

### Triggers

```sql
-- PostgreSQL
CREATE OR REPLACE FUNCTION actualizar_actualizado_en()
RETURNS TRIGGER AS $$
BEGIN
  NEW.actualizado_en = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_usuarios_actualizado
  BEFORE UPDATE ON usuarios
  FOR EACH ROW EXECUTE FUNCTION actualizar_actualizado_en();
```

---

## Transacciones

Conceptos clave de ACID:

| Propiedad | Significado |
|---|---|
| **A**tomicity | Todo o nada |
| **C**onsistency | Estado válido antes y después |
| **I**solation | Transacciones concurrentes no se interfieren |
| **D**urability | Tras COMMIT, los datos sobreviven a caídas |

```sql
-- Transacción explícita con manejo (PostgreSQL)
DO $$
BEGIN
  BEGIN
    UPDATE cuentas SET saldo = saldo - 100 WHERE id = 1;
    UPDATE cuentas SET saldo = saldo + 100 WHERE id = 2;
  EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE 'Error: %', SQLERRM;
    RAISE;  -- relanza y hace ROLLBACK automático
  END;
END;
$$;
```

Bloqueos:

```sql
SELECT * FROM productos WHERE id = 1 FOR UPDATE;          -- bloquea fila
SELECT * FROM productos WHERE id = 1 FOR UPDATE NOWAIT;    -- no espera
SELECT * FROM productos WHERE id = 1 FOR SHARE;            -- bloqueo compartido
```

---

## Normalización

Formas normales para reducir redundancia y evitar anomalías.

| Forma | Regla |
|---|---|
| **1FN** | Campos atómicos (un valor por celda), sin grupos repetitivos |
| **2FN** | 1FN + atributos no-clave dependen de toda la clave (no de parte) |
| **3FN** | 2FN + atributos no-clave no dependen de otros atributos no-clave |
| **BCNF** | 3FN + toda dependencia funcional tiene como determinante una superclave |
| **4FN** | No dependencias multivaluadas |
| **5FN** | No dependencias de proyección/unión |

### Ejemplo de normalización

**No normalizado** (todo en una tabla):

```
pedido: id | cliente | productos (varios separados por coma) | total
```

No cumple 1FN: campo `productos` no es atómico.

**1FN**: un producto por fila.

```
pedido: id | cliente | producto | cantidad | total
```

**2FN y 3FN**: separar entidades.

```
clientes   (id, nombre, email)
productos  (id, nombre, precio)
pedidos    (id, cliente_id, fecha, total)
items      (pedido_id, producto_id, cantidad, subtotal)
```

### Desnormalización

A veces se rompe la normalización deliberadamente para mejorar rendimiento de lectura (data warehouses, cachés, agregados precalculados). Es una decisión consciente de trade-off.

```sql
-- Tabla desnormalizada de ejemplo: contador en la tabla padre
ALTER TABLE categorias ADD COLUMN num_productos INTEGER DEFAULT 0;
-- Se mantiene con triggers o en batch
```

### Claves

| Tipo | Descripción |
|---|---|
| Clave primaria (PK) | Identifica unívocamente una fila |
| Clave foránea (FK) | Referencia la PK de otra tabla |
| Clave candidata | Columna(s) que podrían ser PK |
| Clave alternativa | Candidata no elegida como PK (se marca UNIQUE) |
| Clave compuesta | PK formada por varias columnas |
| Clave sustituta (surrogate) | Artificial (id autoincremental) |
| Clave natural | De dominio (DNI, ISBN) |
