# Guía 03 — MySQL Avanzado

## Objetivos

- [ ] Crear y gestionar índices: B-Tree, Hash, FULLTEXT y SPATIAL
- [ ] Analizar planes de ejecución con EXPLAIN
- [ ] Crear y usar vistas (views)
- [ ] Escribir stored procedures y funciones definidas por usuario
- [ ] Implementar triggers y eventos programados
- [ ] Dominar transacciones y niveles de aislamiento
- [ ] Entender locks y foreign keys

---

## 1. Índices

Los índices son estructuras de datos que aceleran las consultas a cambio de
ralentizar las escrituras y ocupar espacio adicional. Son esenciales para el
rendimiento en tablas grandes.

### ¿Por qué usar índices?

Sin índice, MySQL debe hacer un **full table scan** (leer todas las filas).
Con un índice, MySQL puede localizar las filas en O(log n) en lugar de O(n).

### Crear índices

```sql
-- Índice simple
CREATE INDEX idx_nombre ON productos (nombre);

-- Índice único (no permite duplicados)
CREATE UNIQUE INDEX idx_email ON clientes (email);

-- Índice compuesto (múltiples columnas)
CREATE INDEX idx_cat_precio ON productos (categoria, precio);

-- Índice al crear la tabla
CREATE TABLE ventas (
    id INT PRIMARY KEY AUTO_INCREMENT,
    producto_id INT NOT NULL,
    cliente_id INT NOT NULL,
    fecha DATETIME NOT NULL,
    cantidad INT NOT NULL,
    INDEX idx_producto (producto_id),
    INDEX idx_cliente (cliente_id),
    INDEX idx_fecha (fecha),
    INDEX idx_prod_fecha (producto_id, fecha)
) ENGINE=InnoDB;

-- Índice con ALTER TABLE
ALTER TABLE productos ADD INDEX idx_marca (marca);
ALTER TABLE productos ADD UNIQUE INDEX idx_sku (sku);

-- Eliminar índice
DROP INDEX idx_nombre ON productos;
ALTER TABLE productos DROP INDEX idx_marca;

-- Ver índices de una tabla
SHOW INDEX FROM productos;
```

### Tipos de índices

#### B-Tree (default)

El índice por defecto en InnoDB. Estructura de árbol balanceado que permite
búsquedas rápidas, rangos y ordenamiento.

```sql
-- B-Tree funciona bien con: =, >, <, BETWEEN, LIKE 'prefix%', IN, ORDER BY
SELECT * FROM productos WHERE nombre LIKE 'Lap%';     -- ✅ usa índice
SELECT * FROM productos WHERE nombre LIKE '%top';      -- ❌ NO usa índice
SELECT * FROM productos WHERE precio BETWEEN 100 AND 500; -- ✅ usa índice
```

#### Hash (solo MEMORY engine y InnoDB adaptive hash)

```sql
-- El motor MEMORY soporta índices Hash explícitos
CREATE TABLE cache_memoria (
    id INT PRIMARY KEY,
    clave VARCHAR(100),
    valor TEXT,
    INDEX idx_clave (clave) USING HASH
) ENGINE=MEMORY;

-- Hash solo sirve para búsquedas exactas (=, !=), no para rangos u ordenamiento
```

#### FULLTEXT

Índice especializado para búsqueda de texto completo en campos de texto.

```sql
CREATE TABLE articulos (
    id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    titulo VARCHAR(200),
    contenido TEXT,
    FULLTEXT INDEX ft_titulo_contenido (titulo, contenido)
) ENGINE=InnoDB;

INSERT INTO articulos (titulo, contenido) VALUES
    ('MySQL avanzado', 'Aprende sobre índices y optimización en MySQL'),
    ('PostgreSQL vs MySQL', 'Comparación de los dos motores de bases de datos'),
    ('PHP y MySQL', 'Desarrollo web con PHP y MySQL desde cero');

-- Búsqueda de texto completo con MATCH ... AGAINST
-- Modo natural (por defecto)
SELECT * FROM articulos
WHERE MATCH(titulo, contenido) AGAINST('MySQL');

-- Modo booleano: operadores +, -, *, etc.
SELECT * FROM articulos
WHERE MATCH(titulo, contenido) AGAINST('+MySQL -PHP' IN BOOLEAN MODE);

-- Con score de relevancia
SELECT titulo,
    MATCH(titulo, contenido) AGAINST('MySQL optimización') AS relevancia
FROM articulos
WHERE MATCH(titulo, contenido) AGAINST('MySQL optimización')
ORDER BY relevancia DESC;
```

#### SPATIAL (datos geoespaciales)

```sql
CREATE TABLE ubicaciones (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100),
    coords POINT NOT NULL SRID 4326,
    SPATIAL INDEX idx_coords (coords)
) ENGINE=InnoDB;

INSERT INTO ubicaciones (nombre, coords)
VALUES ('Madrid', ST_GeomFromText('POINT(-3.7038 40.4168)', 4326));

-- Buscar puntos dentro de un radio
SELECT nombre, ST_Distance_Sphere(coords, ST_GeomFromText('POINT(-3.7038 40.4168)', 4326)) AS distancia_metros
FROM ubicaciones
WHERE ST_Within(coords, ST_GeomFromText('POLYGON((-4 40, -3 40, -3 41, -4 41, -4 40))', 4326));
```

### Índices compuestos: orden de columnas

```sql
-- Índice compuesto (categoria, marca, precio)
CREATE INDEX idx_comp ON productos (categoria, marca, precio);

-- ✅ Usa el índice (prefix match)
SELECT * FROM productos WHERE categoria = 'electronica';
SELECT * FROM productos WHERE categoria = 'electronica' AND marca = 'Sony';
SELECT * FROM productos WHERE categoria = 'electronica' AND marca = 'Sony' AND precio > 100;

-- ❌ NO usa el índice (no empieza por la primera columna)
SELECT * FROM productos WHERE marca = 'Sony';
SELECT * FROM productos WHERE precio > 100;

-- ⚠️ Usa parcialmente el índice (solo la parte de categoria)
SELECT * FROM productos WHERE categoria = 'electronica' AND precio > 100;
```

> **Regla del prefijo más a la izquierda**: un índice compuesto (A, B, C) se usa
> para búsquedas en A, (A,B) y (A,B,C). No para B, C o (B,C) solos.

### Índices funcionales (MySQL 8.0+)

```sql
-- Índice sobre una expresión
CREATE INDEX idx_email_lower ON clientes ((LOWER(email)));

-- Índice sobre parte de una fecha
CREATE INDEX idx_venta_anio_mes ON ventas ((YEAR(fecha)), (MONTH(fecha)));

-- Índice sobre JSON
CREATE INDEX idx_pref_tema ON usuarios ((CAST(preferencias->>'$.tema' AS CHAR(20))));
```

---

## 2. EXPLAIN

`EXPLAIN` muestra cómo MySQL ejecuta una consulta: qué índices usa, cuántas
filas estima leer, si hay filesort, etc.

```sql
EXPLAIN SELECT * FROM productos WHERE categoria = 'electronica';

-- Formato vertical (más legible)
EXPLAIN SELECT * FROM productos WHERE categoria = 'electronica'\G

-- Formato de árbol (MySQL 8.0+)
EXPLAIN FORMAT=TREE SELECT * FROM productos WHERE categoria = 'electronica';
```

### Columnas importantes de EXPLAIN

| Columna | Significado |
|---|---|
| `id` | Identificador de la consulta (1, 2, ... para subconsultas) |
| `select_type` | SIMPLE, PRIMARY, SUBQUERY, DERIVED, UNION |
| `table` | Tabla afectada |
| `type` | Tipo de acceso (ver tabla abajo) |
| `possible_keys` | Índices que MySQL podría usar |
| `key` | Índice realmente usado (NULL = no usa índice) |
| `key_len` | Longitud del índice usado |
| `ref` | Columnas/constantes comparadas con el índice |
| `rows` | Filas estimadas que MySQL leerá |
| `filtered` | Porcentaje de filas que pasarán el WHERE |
| `Extra` | Info adicional (ver tabla abajo) |

### Valores de `type` (de mejor a peor)

| `type` | Descripción | Rendimiento |
|---|---|---|
| `system` | Tabla de una sola fila | 🟢 Óptimo |
| `const` | Una sola fila por clave primaria/única | 🟢 Excelente |
| `eq_ref` | JOIN con clave única, una fila | 🟢 Excelente |
| `ref` | Búsqueda por índice no único, puede haber varias filas | 🟢 Bueno |
| `range` | Búsqueda por rango (BETWEEN, >, <, IN) | 🟡 Aceptable |
| `index` | Escanea todo el índice | 🟠 Regular |
| `ALL` | Full table scan (lee toda la tabla) | 🔴 Malo |

### Valores importantes de `Extra`

| `Extra` | Significado |
|---|---|
| `Using index` | Índice covering (no lee la tabla, solo el índice) 🟢 |
| `Using where` | Filtra con WHERE después de leer |
| `Using filesort` | Ordena fuera del índice (lento) 🟠 |
| `Using temporary` | Crea tabla temporal (lento) 🟠 |
| `Using join buffer` | JOIN sin índice, usa buffer en memoria |
| `Impossible WHERE` | La condición nunca es verdadera |

```sql
-- Ejemplo de diagnóstico
EXPLAIN SELECT categoria, COUNT(*) FROM productos GROUP BY categoria;
-- Si Extra dice "Using temporary; Using filesort", considera añadir un índice

-- Forzar el uso de un índice
SELECT * FROM productos USE INDEX (idx_categoria) WHERE categoria = 'electronica';

-- Ignorar índices
SELECT * FROM productos IGNORE INDEX (idx_precio) WHERE categoria = 'electronica';

-- Forzar un JOIN order
SELECT * FROM productos p FORCE INDEX (idx_categoria)
JOIN categorias c ON p.categoria_id = c.id
WHERE c.nombre = 'electronica';
```

---

## 3. Vistas (Views)

Una vista es una consulta guardada como si fuera una tabla virtual. No almacena
datos (excepto views materializadas, que MySQL no soporta nativamente).

```sql
-- Crear vista simple
CREATE VIEW vw_productos_activos AS
SELECT id, nombre, precio, stock FROM productos WHERE stock > 0;

-- Usar la vista
SELECT * FROM vw_productos_activos;
SELECT * FROM vw_productos_activos WHERE precio < 100;

-- Vista con JOIN
CREATE VIEW vw_detalle_ventas AS
SELECT
    v.id AS venta_id,
    v.fecha,
    c.nombre AS cliente,
    p.nombre AS producto,
    dv.cantidad,
    dv.precio_unitario,
    dv.cantidad * dv.precio_unitario AS subtotal
FROM ventas v
JOIN clientes c ON v.cliente_id = c.id
JOIN detalle_ventas dv ON dv.venta_id = v.id
JOIN productos p ON dv.producto_id = p.id;

SELECT * FROM vw_detalle_ventas WHERE cliente = 'Ana Perez';

-- Vista con agregación
CREATE VIEW vw_resumen_categoria AS
SELECT
    categoria,
    COUNT(*) AS total_productos,
    AVG(precio) AS precio_promedio,
    SUM(precio * stock) AS valor_inventario
FROM productos
GROUP BY categoria;

-- Ver vistas
SHOW FULL TABLES WHERE Table_type = 'VIEW';
SHOW CREATE VIEW vw_productos_activos\G

-- Modificar vista
CREATE OR REPLACE VIEW vw_productos_activos AS
SELECT id, nombre, precio, stock, categoria FROM productos WHERE stock > 0;

-- Eliminar vista
DROP VIEW IF EXISTS vw_productos_activos;
```

### Vistas actualizables

Una vista es actualizable si hay una relación 1:1 entre las filas de la vista
y la tabla subyacente (sin JOINs, sin GROUP BY, sin DISTINCT, sin funciones
de agregación).

```sql
-- Esta vista es actualizable
CREATE VIEW vw_productos_electronicos AS
SELECT id, nombre, precio FROM productos WHERE categoria = 'electronica';

-- INSERT a través de la vista
INSERT INTO vw_productos_electronicos (id, nombre, precio) VALUES (1, 'Mouse', 25.00);

-- UPDATE a través de la vista
UPDATE vw_productos_electronicos SET precio = 30.00 WHERE id = 1;

-- Con CHECK OPTION: evita insertar filas que no cumplan el WHERE
CREATE VIEW vw_productos_baratos AS
SELECT id, nombre, precio FROM productos WHERE precio < 100
WITH CHECK OPTION;

-- INSERT fallará porque el precio no cumple la condición
-- INSERT INTO vw_productos_baratos VALUES (10, 'Tablet', 150); -- Error
```

---

## 4. Stored Procedures

Un stored procedure es un conjunto de instrucciones SQL almacenado en la base
de datos que se ejecuta como una unidad.

### Sintaxis básica

```sql
DELIMITER //

CREATE PROCEDURE sp_obtener_productos()
BEGIN
    SELECT id, nombre, precio, stock FROM productos ORDER BY nombre;
END //

DELIMITER ;

-- Llamar al procedure
CALL sp_obtener_productos();
```

> `DELIMITER //` cambia el separador de sentencias de `;` a `//` para poder
> escribir múltiples sentencias dentro del BEGIN...END. Al final se restaura.

### Parámetros: IN, OUT, INOUT

```sql
DELIMITER //

-- IN: valor de entrada (por defecto)
CREATE PROCEDURE sp_productos_por_categoria(IN p_categoria VARCHAR(50))
BEGIN
    SELECT id, nombre, precio FROM productos WHERE categoria = p_categoria;
END //

-- OUT: valor de salida
CREATE PROCEDURE sp_total_stock(OUT p_total INT)
BEGIN
    SELECT SUM(stock) INTO p_total FROM productos;
END //

-- INOUT: entrada y salida
CREATE PROCEDURE sp_duplicar_precio(INOUT p_precio DECIMAL(10,2))
BEGIN
    SET p_precio = p_precio * 2;
END //

DELIMITER ;

-- Usar
CALL sp_productos_por_categoria('electronica');

CALL sp_total_stock(@total);
SELECT @total AS total_stock;

SET @precio = 100.00;
CALL sp_duplicar_precio(@precio);
SELECT @precio AS precio_duplicado;
```

### Control de flujo en procedures

```sql
DELIMITER //

CREATE PROCEDURE sp_clasificar_producto(IN p_id INT)
BEGIN
    DECLARE v_precio DECIMAL(10,2);
    DECLARE v_stock INT;
    DECLARE v_clasificacion VARCHAR(50);

    -- Variables locales
    SELECT precio, stock INTO v_precio, v_stock
    FROM productos WHERE id = p_id;

    -- IF ... ELSEIF ... ELSE
    IF v_stock = 0 THEN
        SET v_clasificacion = 'Agotado';
    ELSEIF v_precio > 1000 THEN
        SET v_clasificacion = 'Premium disponible';
    ELSEIF v_precio > 100 THEN
        SET v_clasificacion = 'Estándar disponible';
    ELSE
        SET v_clasificacion = 'Económico disponible';
    END IF;

    SELECT p_id AS producto_id, v_precio AS precio, v_stock AS stock,
           v_clasificacion AS clasificacion;
END //

-- WHILE loop
CREATE PROCEDURE sp_contador(IN limite INT)
BEGIN
    DECLARE i INT DEFAULT 1;
    WHILE i <= limite DO
        SELECT i AS numero;
        SET i = i + 1;
    END WHILE;
END //

-- LOOP con LEAVE (break)
CREATE PROCEDURE sp_bucle(IN limite INT)
BEGIN
    DECLARE i INT DEFAULT 1;
    bucle: LOOP
        IF i > limite THEN
            LEAVE bucle;
        END IF;
        SELECT i AS iteracion;
        SET i = i + 1;
    END LOOP;
END //

-- REPEAT ... UNTIL (do-while)
CREATE PROCEDURE sp_repeat(IN limite INT)
BEGIN
    DECLARE i INT DEFAULT 1;
    REPEAT
        SELECT i AS iteracion;
        SET i = i + 1;
    UNTIL i > limite
    END REPEAT;
END //

-- CASE
CREATE PROCEDURE sp_estado_producto(IN p_id INT)
BEGIN
    DECLARE v_stock INT;
    SELECT stock INTO v_stock FROM productos WHERE id = p_id;

    CASE
        WHEN v_stock = 0 THEN SELECT 'Agotado' AS estado;
        WHEN v_stock < 10 THEN SELECT 'Stock bajo' AS estado;
        WHEN v_stock < 50 THEN SELECT 'Stock medio' AS estado;
        ELSE SELECT 'Stock alto' AS estado;
    END CASE;
END //

DELIMITER ;

-- Llamar
CALL sp_clasificar_producto(5);
CALL sp_contador(3);
CALL sp_bucle(3);
CALL sp_repeat(3);
CALL sp_estado_producto(5);
```

### Cursores

```sql
DELIMITER //

CREATE PROCEDURE sp_informe_inventario()
BEGIN
    DECLARE v_id INT;
    DECLARE v_nombre VARCHAR(100);
    DECLARE v_precio DECIMAL(10,2);
    DECLARE v_stock INT;
    DECLARE v_valor_total DECIMAL(15,2) DEFAULT 0;
    DECLARE done INT DEFAULT 0;

    -- Declarar cursor
    DECLARE cur_productos CURSOR FOR
        SELECT id, nombre, precio, stock FROM productos WHERE stock > 0;

    -- Handler para fin de cursor
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    -- Tabla temporal para resultados
    CREATE TEMPORARY TABLE IF NOT EXISTS tmp_informe (
        producto VARCHAR(100),
        valor DECIMAL(15,2)
    );

    OPEN cur_productos;

    read_loop: LOOP
        FETCH cur_productos INTO v_id, v_nombre, v_precio, v_stock;
        IF done THEN
            LEAVE read_loop;
        END IF;

        INSERT INTO tmp_informe VALUES (v_nombre, v_precio * v_stock);
        SET v_valor_total = v_valor_total + (v_precio * v_stock);
    END LOOP;

    CLOSE cur_productos;

    SELECT * FROM tmp_informe;
    SELECT v_valor_total AS valor_total_inventario;

    DROP TEMPORARY TABLE tmp_informe;
END //

DELIMITER ;

CALL sp_informe_inventario();
```

### Gestión de procedures

```sql
-- Ver procedures
SHOW PROCEDURE STATUS WHERE Db = 'mi_db';

-- Ver código de un procedure
SHOW CREATE PROCEDURE sp_obtener_productos\G

-- Eliminar
DROP PROCEDURE IF EXISTS sp_obtener_productos;
```

---

## 5. Funciones definidas por usuario (UDF)

A diferencia de los procedures, las funciones devuelven un valor y se usan
dentro de SELECT, WHERE, etc.

```sql
DELIMITER //

-- Función básica
CREATE FUNCTION fn_precio_con_iva(p_precio DECIMAL(10,2))
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    RETURN p_precio * 1.21;
END //

-- Función con lógica condicional
CREATE FUNCTION fn_clasificar_stock(p_stock INT)
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    DECLARE v_resultado VARCHAR(20);

    IF p_stock = 0 THEN
        SET v_resultado = 'Agotado';
    ELSEIF p_stock < 10 THEN
        SET v_resultado = 'Bajo';
    ELSEIF p_stock < 50 THEN
        SET v_resultado = 'Medio';
    ELSE
        SET v_resultado = 'Alto';
    END IF;

    RETURN v_resultado;
END //

-- Función que calcula edad
CREATE FUNCTION fn_calcular_edad(p_fecha_nacimiento DATE)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN TIMESTAMPDIFF(YEAR, p_fecha_nacimiento, CURDATE());
END //

DELIMITER ;

-- Usar funciones en consultas
SELECT nombre, precio, fn_precio_con_iva(precio) AS precio_iva FROM productos;

SELECT nombre, stock, fn_clasificar_stock(stock) AS estado FROM productos;

SELECT nombre, fn_calcular_edad(fecha_nacimiento) AS edad FROM clientes;
```

### DETERMINISTIC vs NOT DETERMINISTIC

- **DETERMINISTIC**: para los mismos parámetros siempre devuelve el mismo
  resultado (ej: cálculos matemáticos). MySQL puede cachear el resultado.
- **NOT DETERMINISTIC**: el resultado puede variar (usa NOW(), RAND(), datos
  de tablas). Se ejecuta cada vez.

```sql
SHOW FUNCTION STATUS WHERE Db = 'mi_db';
SHOW CREATE FUNCTION fn_precio_con_iva\G
DROP FUNCTION IF EXISTS fn_precio_con_iva;
```

> ⚠️ En MySQL 8.0, `log_bin_trust_function_creators` debe estar en 1 o el
> usuario debe tener el privilegio SUPER para crear funciones.
> `SET GLOBAL log_bin_trust_function_creators = 1;`

---

## 6. Triggers

Un trigger es código que se ejecuta automáticamente cuando ocurre un evento
(INSERT, UPDATE, DELETE) en una tabla.

### Tipos y momentos

| Momento | Evento | Nombre |
|---|---|---|
| BEFORE | INSERT | BEFORE INSERT |
| AFTER | INSERT | AFTER INSERT |
| BEFORE | UPDATE | BEFORE UPDATE |
| AFTER | UPDATE | AFTER UPDATE |
| BEFORE | DELETE | BEFORE DELETE |
| AFTER | DELETE | AFTER DELETE |

### Sintaxis

```sql
DELIMITER //

-- Trigger BEFORE INSERT: validar o modificar datos antes de insertar
CREATE TRIGGER trg_before_insert_producto
BEFORE INSERT ON productos
FOR EACH ROW
BEGIN
    IF NEW.precio < 0 THEN
        SET NEW.precio = 0;
    END IF;
    IF NEW.stock < 0 THEN
        SET NEW.stock = 0;
    END IF;
END //

-- Trigger AFTER INSERT: registrar en auditoría
CREATE TRIGGER trg_after_insert_producto
AFTER INSERT ON productos
FOR EACH ROW
BEGIN
    INSERT INTO auditoria_productos (producto_id, accion, fecha)
    VALUES (NEW.id, 'INSERT', NOW());
END //

-- Trigger BEFORE UPDATE: capturar valor anterior
CREATE TRIGGER trg_before_update_precio
BEFORE UPDATE ON productos
FOR EACH ROW
BEGIN
    IF NEW.precio <> OLD.precio THEN
        INSERT INTO historial_precios (producto_id, precio_anterior, precio_nuevo, fecha)
        VALUES (OLD.id, OLD.precio, NEW.precio, NOW());
    END IF;
END //

-- Trigger AFTER DELETE: registrar eliminación
CREATE TRIGGER trg_after_delete_producto
AFTER DELETE ON productos
FOR EACH ROW
BEGIN
    INSERT INTO auditoria_productos (producto_id, accion, datos, fecha)
    VALUES (OLD.id, 'DELETE', CONCAT(OLD.nombre, ' ($', OLD.precio, ')'), NOW());
END //

DELIMITER ;
```

### Variables NEW y OLD

| Evento | NEW | OLD |
|---|---|---|
| INSERT | ✅ Valores que se van a insertar | — |
| UPDATE | ✅ Nuevos valores | ✅ Valores anteriores |
| DELETE | — | ✅ Valores que se van a borrar |

### Ejemplo: mantener stock actualizado

```sql
DELIMITER //

-- Cuando se inserta un detalle de venta, restar stock
CREATE TRIGGER trg_restar_stock
AFTER INSERT ON detalle_ventas
FOR EACH ROW
BEGIN
    UPDATE productos
    SET stock = stock - NEW.cantidad
    WHERE id = NEW.producto_id;

    -- Alertar si el stock baja de cero
    IF (SELECT stock FROM productos WHERE id = NEW.producto_id) < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Stock insuficiente para el producto';
    END IF;
END //

-- Cuando se elimina un detalle de venta, restaurar stock
CREATE TRIGGER trg_restaurar_stock
AFTER DELETE ON detalle_ventas
FOR EACH ROW
BEGIN
    UPDATE productos
    SET stock = stock + OLD.cantidad
    WHERE id = OLD.producto_id;
END //

DELIMITER ;
```

### Gestión de triggers

```sql
-- Ver triggers
SHOW TRIGGERS;

-- Ver triggers de una base de datos específica
SHOW TRIGGERS WHERE `Trigger` LIKE 'trg_%';

-- Ver código de un trigger
SHOW CREATE TRIGGER trg_before_insert_producto\G

-- Eliminar trigger
DROP TRIGGER IF EXISTS trg_before_insert_producto;
```

---

## 7. Eventos (Event Scheduler)

Los eventos son tareas programadas que se ejecutan automáticamente en el
servidor MySQL, como cron jobs pero dentro de MySQL.

```sql
-- Activar el event scheduler (necesario)
SET GLOBAL event_scheduler = ON;

-- Verificar
SHOW VARIABLES LIKE 'event_scheduler';

-- Evento que se ejecuta una vez
CREATE EVENT ev_limpieza_temporal
ON SCHEDULE AT NOW() + INTERVAL 1 HOUR
DO
    DROP TABLE IF EXISTS tmp_datos_import;

-- Evento recurrente: cada hora
CREATE EVENT ev_actualizar_estados
ON SCHEDULE EVERY 1 HOUR
DO
    UPDATE pedidos SET estado = 'cancelado'
    WHERE estado = 'pendiente' AND fecha < DATE_SUB(NOW(), INTERVAL 24 HOUR);

-- Evento recurrente: cada día a las 2:00 AM
CREATE EVENT ev_backup_diario
ON SCHEDULE EVERY 1 DAY STARTS '2024-01-01 02:00:00'
DO
    CALL sp_generar_backup();

-- Evento recurrente con cuerpo BEGIN...END
DELIMITER //
CREATE EVENT ev_resumen_diario
ON SCHEDULE EVERY 1 DAY STARTS '2024-01-01 23:59:00'
ON COMPLETION NOT PRESERVE
DO
BEGIN
    INSERT INTO resumen_ventas (fecha, total_ventas, total_productos)
    SELECT CURDATE(), COUNT(*), SUM(cantidad)
    FROM ventas WHERE DATE(fecha) = CURDATE();
END //
DELIMITER ;

-- Gestionar eventos
SHOW EVENTS;
ALTER EVENT ev_resumen_diario DISABLE;   -- desactivar
ALTER EVENT ev_resumen_diario ENABLE;    -- activar
DROP EVENT IF EXISTS ev_resumen_diario;
```

---

## 8. Transacciones

Una transacción es un conjunto de operaciones que se ejecutan como una unidad:
o todas se completan (COMMIT) o ninguna (ROLLBACK).

### ACID

| Propiedad | Significado |
|---|---|
| **A**tomicity | Todo o nada: si una operación falla, toda la transacción falla |
| **C**onsistency | La BD pasa de un estado válido a otro estado válido |
| **I**solation | Las transacciones concurrentes no se interfieren |
| **D**urability | Una vez hecho COMMIT, los cambios son permanentes |

```sql
-- Iniciar transacción
START TRANSACTION;
-- o: BEGIN;
-- o: BEGIN WORK;

UPDATE productos SET stock = stock - 5 WHERE id = 1;
INSERT INTO ventas (producto_id, cantidad, fecha) VALUES (1, 5, NOW());

-- Confirmar cambios
COMMIT;

-- O deshacer cambios
ROLLBACK;
```

### Ejemplo: transferencia entre cuentas

```sql
START TRANSACTION;

-- Restar de cuenta origen
UPDATE cuentas SET saldo = saldo - 100 WHERE id = 1;
-- Si la cuenta no existe o no hay saldo, ROLLBACK

-- Sumar a cuenta destino
UPDATE cuentas SET saldo = saldo + 100 WHERE id = 2;

-- Verificar que ambas operaciones tuvieron efecto
SELECT ROW_COUNT() AS filas_afectadas;

COMMIT;
-- o: ROLLBACK; si algo salió mal
```

### SAVEPOINT: rollback parcial

```sql
START TRANSACTION;

INSERT INTO logs (mensaje) VALUES ('Inicio');
SAVEPOINT sp1;

INSERT INTO productos (nombre, precio) VALUES ('Mouse', 25);
SAVEPOINT sp2;

INSERT INTO productos (nombre, precio) VALUES ('Teclado', 50);
-- Si esto falla, puedo volver al savepoint anterior
ROLLBACK TO SAVEPOINT sp2;

-- El INSERT del Mouse sigue, pero el del Teclado se deshace
COMMIT;
```

### Autocommit

```sql
-- Por defecto, MySQL tiene autocommit activado
-- Cada sentencia se confirma automáticamente

-- Desactivar autocommit para la sesión
SET autocommit = 0;
-- Ahora debes hacer COMMIT o ROLLBACK manualmente

-- Reactivar
SET autocommit = 1;
```

### Niveles de aislamiento

| Nivel | Dirty Read | Non-Repeatable Read | Phantom Read |
|---|---|---|---|
| READ UNCOMMITTED | ✅ Sí | ✅ Sí | ✅ Sí |
| READ COMMITTED | ❌ No | ✅ Sí | ✅ Sí |
| REPEATABLE READ (default) | ❌ No | ❌ No | ❌ No* |
| SERIALIZABLE | ❌ No | ❌ No | ❌ No |

> *MySQL InnoDB con REPEATABLE READ usa Next-Key Locking, que evita phantom reads
> (algo único de InnoDB, no garantizado por el estándar SQL).

```sql
-- Ver nivel actual
SELECT @@transaction_isolation;

-- Cambiar nivel de aislamiento
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

-- Para la sesión completa
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

-- Global (afecta nuevas conexiones)
SET GLOBAL TRANSACTION ISOLATION LEVEL READ COMMITTED;
```

### Problemas de concurrencia

- **Dirty Read**: la transacción A lee datos no confirmados de la transacción B.
- **Non-Repeatable Read**: la transacción A lee la misma fila dos veces y obtiene valores distintos porque B la modificó.
- **Phantom Read**: la transacción A ejecuta la misma consulta y obtiene filas nuevas porque B insertó datos.

---

## 9. Locks (Bloqueos)

### Locks a nivel de tabla

```sql
-- Bloquear tabla en lectura (otros pueden leer, nadie puede escribir)
LOCK TABLES productos READ;
-- ... operaciones ...
UNLOCK TABLES;

-- Bloquear en escritura (nadie más puede leer ni escribir)
LOCK TABLES productos WRITE;
-- ... operaciones ...
UNLOCK TABLES;
```

### Locks a nivel de fila (InnoDB)

InnoDB usa row-level locking con **two-phase locking**. Los locks se liberan
al hacer COMMIT o ROLLBACK.

```sql
-- SELECT ... FOR UPDATE: bloquea filas para escritura
START TRANSACTION;
SELECT * FROM productos WHERE id = 1 FOR UPDATE;
-- Otras transacciones deben esperar para modificar esta fila
UPDATE productos SET stock = stock - 1 WHERE id = 1;
COMMIT;

-- SELECT ... FOR SHARE: bloquea filas para lectura (compartido)
START TRANSACTION;
SELECT * FROM productos WHERE id = 1 FOR SHARE;
-- Otras transacciones pueden leer pero no modificar
COMMIT;
```

### Deadlocks

```sql
-- Transacción 1
START TRANSACTION;
UPDATE cuentas SET saldo = saldo - 100 WHERE id = 1;  -- lock en fila 1
UPDATE cuentas SET saldo = saldo + 100 WHERE id = 2;  -- espera lock en fila 2

-- Transacción 2 (concurrente)
START TRANSACTION;
UPDATE cuentas SET saldo = saldo - 50 WHERE id = 2;   -- lock en fila 2
UPDATE cuentas SET saldo = saldo + 50 WHERE id = 1;   -- espera lock en fila 1
-- DEADLOCK: MySQL detecta el deadlock y mata una transacción
```

> InnoDB detecta deadlocks automáticamente y deshace una de las transacciones.
> Para evitarlos: siempre accede a las tablas/filas en el mismo orden en todas
> las transacciones.

---

## 10. Foreign Keys (Claves foráneas)

Las foreign keys garantizan la integridad referencial: no puedes insertar un
registro hijo sin que exista el padre.

```sql
-- Crear con la tabla
CREATE TABLE pedidos (
    id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    cliente_id INT UNSIGNED NOT NULL,
    fecha DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_pedido_cliente FOREIGN KEY (cliente_id)
        REFERENCES clientes(id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Añadir FK a tabla existente
ALTER TABLE pedidos
ADD CONSTRAINT fk_pedido_cliente
FOREIGN KEY (cliente_id) REFERENCES clientes(id);

-- Eliminar FK
ALTER TABLE pedidos DROP FOREIGN KEY fk_pedido_cliente;
```

### Acciones ON DELETE / ON UPDATE

| Acción | Comportamiento |
|---|---|
| `RESTRICT` | Impide borrar/modificar el padre (default) |
| `NO ACTION` | Igual que RESTRICT |
| `CASCADE` | Borra/actualiza los hijos automáticamente |
| `SET NULL` | Pone NULL en la FK del hijo (la columna debe permitir NULL) |
| `SET DEFAULT` | Pone el valor DEFAULT (solo MyISAM, raramente usado) |

```sql
-- Ejemplo: si se borra un cliente, sus pedidos se borran en cascada
FOREIGN KEY (cliente_id) REFERENCES clientes(id) ON DELETE CASCADE

-- Si se borra un cliente, sus pedidos quedan con cliente_id = NULL
FOREIGN KEY (cliente_id) REFERENCES clientes(id) ON DELETE SET NULL

-- Si se actualiza el ID del cliente, se propaga a los pedidos
FOREIGN KEY (cliente_id) REFERENCES clientes(id) ON UPDATE CASCADE
```

### Verificar foreign keys

```sql
-- Ver constraints de FK
SELECT
    TABLE_NAME, CONSTRAINT_NAME, COLUMN_NAME,
    REFERENCED_TABLE_NAME, REFERENCED_COLUMN_NAME
FROM information_schema.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA = 'mi_db'
  AND REFERENCED_TABLE_NAME IS NOT NULL;

-- Ver errores de FK
SHOW ENGINE INNODB STATUS\G
```

---

## Conceptos clave

| Concepto | Definición |
|---|---|
| **Índice** | Estructura que acelera búsquedas a costa de espacio y escritura |
| **Índice compuesto** | Índice sobre múltiples columnas con regla del prefijo izquierdo |
| **Covering index** | Índice que contiene todas las columnas de la consulta (no lee la tabla) |
| **EXPLAIN** | Herramienta que muestra el plan de ejecución de una consulta |
| **Vista** | Consulta guardada como tabla virtual |
| **Stored procedure** | Código SQL almacenado en la BD, ejecutado con CALL |
| **Trigger** | Código que se ejecuta automáticamente ante un evento DML |
| **Transacción** | Unidad atómica de operaciones: COMMIT o ROLLBACK |
| **ACID** | Atomicity, Consistency, Isolation, Durability |
| **Deadlock** | Dos transacciones se esperan mutuamente; MySQL mata una |
| **Foreign Key** | Restricción que garantiza integridad referencial entre tablas |

---

## Errores comunes

### 1. Crear índices innecesarios

Cada índice ralentiza INSERTs, UPDATEs y DELETEs. Solo crea índices para
columnas usadas en WHERE, JOIN, ORDER BY y GROUP BY.

### 2. No respetar el orden del prefijo izquierdo

```sql
-- Índice (categoria, marca, precio)
-- ❌ Esto NO usa el índice
SELECT * FROM productos WHERE marca = 'Sony';
```

### 3. Usar LIKE con wildcard inicial

```sql
-- ❌ No usa índice (full scan)
SELECT * FROM productos WHERE nombre LIKE '%laptop%';
-- ✅ Usa índice (prefix)
SELECT * FROM productos WHERE nombre LIKE 'laptop%';
```

### 4. Olvidar activar el event_scheduler

```sql
-- Si los eventos no se ejecutan, verifica:
SET GLOBAL event_scheduler = ON;
```

### 5. No usar DETERMINISTIC en funciones

MySQL requiere que las funciones especifiquen si son DETERMINISTIC o no.
Sin esto y con binlog activado, no se pueden crear funciones.

### 6. Olvidar DELIMITER al crear procedures/triggers

```sql
-- ❌ Error de sintaxis: el ; termina el CREATE PROCEDURE prematuramente
CREATE PROCEDURE test() BEGIN SELECT 1; END;

-- ✅ Cambiar el delimitador
DELIMITER //
CREATE PROCEDURE test() BEGIN SELECT 1; END //
DELIMITER ;
```

### 7. Deadlocks por orden inconsistente

```sql
-- ❌ Transacción 1: actualiza A, luego B
-- ❌ Transacción 2: actualiza B, luego A
-- Resultado: deadlock

-- ✅ Siempre actualiza en el mismo orden: A, luego B
```

---

## Siguiente paso

Continúa con la [Guía 04 — Optimización y rendimiento](04-optimizacion-y-rendimiento.md)
para aprender a analizar y mejorar el rendimiento de MySQL.
