# Guía 04 — Optimización y Rendimiento de MySQL

## Objetivos

- [ ] Usar EXPLAIN ANALYZE para medir el rendimiento real de consultas
- [ ] Aplicar hints de optimización (USE INDEX, FORCE INDEX, etc.)
- [ ] Configurar el buffer pool de InnoDB para máxima eficiencia
- [ ] Ajustar parámetros clave en my.cnf
- [ ] Implementar particionamiento de tablas
- [ ] Entender sharding y estrategias de escalado horizontal
- [ ] Usar el slow query log para encontrar consultas lentas
- [ ] Monitorear con Performance Schema

---

## 1. EXPLAIN ANALYZE (MySQL 8.0+)

Mientras que `EXPLAIN` muestra el plan *estimado*, `EXPLAIN ANALYZE` ejecuta
realmente la consulta y muestra tiempos reales de cada operación.

```sql
-- EXPLAIN tradicional: plan estimado
EXPLAIN SELECT p.nombre, c.nombre AS categoria
FROM productos p
JOIN categorias c ON p.categoria_id = c.id
WHERE p.precio > 100;

-- EXPLAIN ANALYZE: ejecuta la consulta y mide tiempos reales
EXPLAIN ANALYZE SELECT p.nombre, c.nombre AS categoria
FROM productos p
JOIN categorias c ON p.categoria_id = c.id
WHERE p.precio > 100;
```

### Salida de EXPLAIN ANALYZE

```
-> Filter: (p.precio > 100)  (cost=2.50 rows=10) (actual time=0.12..0.35 rows=8 loops=1)
    -> Inner hash join (no condition)  (cost=2.50 rows=20) (actual time=0.10..0.30 rows=15 loops=1)
        -> Table scan on c  (cost=0.05 rows=5) (actual time=0.02..0.05 rows=5 loops=1)
        -> Hash  (cost=2.00 rows=10) (actual time=0.05..0.10 rows=10 loops=1)
            -> Table scan on p  (cost=1.00 rows=10) (actual time=0.03..0.08 rows=10 loops=1)
```

| Campo | Significado |
|---|---|
| `cost` | Costo estimado de la operación |
| `rows` | Filas estimadas / filas reales |
| `actual time` | Tiempo real en milisegundos (inicio..fin) |
| `loops` | Número de veces que se ejecutó esta operación |

### Comparar planes con y sin índice

```sql
-- Sin índice (probablemente ALL / full scan)
EXPLAIN ANALYZE SELECT * FROM productos WHERE categoria = 'electronica';

-- Crear índice
CREATE INDEX idx_categoria ON productos (categoria);

-- Con índice (probablemente ref / index lookup)
EXPLAIN ANALYZE SELECT * FROM productos WHERE categoria = 'electronica';
```

---

## 2. Hints de optimización

Los hints son directivas que se añaden a las consultas para influir en el
optimizador de MySQL.

### Index hints

```sql
-- USE INDEX: sugiere un índice (el optimizador puede ignorarlo)
SELECT * FROM productos USE INDEX (idx_categoria)
WHERE categoria = 'electronica';

-- FORCE INDEX: obliga a usar un índice
SELECT * FROM productos FORCE INDEX (idx_categoria)
WHERE categoria = 'electronica';

-- IGNORE INDEX: ignora un índice específico
SELECT * FROM productos IGNORE INDEX (idx_precio)
WHERE categoria = 'electronica' AND precio > 100;

-- Para JOINs
SELECT * FROM productos p
FORCE INDEX FOR JOIN (idx_categoria)
JOIN ventas v FORCE INDEX FOR JOIN (idx_producto) ON p.id = v.producto_id;

-- Diferentes propósitos
-- FOR JOIN: para condiciones de JOIN
-- FOR ORDER BY: para ORDER BY
-- FOR GROUP BY: para GROUP BY
```

### Optimizer hints (MySQL 5.7+, ampliado en 8.0)

Sintaxis `/*+ ... */` más precisa y moderna.

```sql
-- Forzar índice
SELECT /*+ INDEX(p idx_categoria) */ *
FROM productos p
WHERE categoria = 'electronica';

-- No usar índice
SELECT /*+ NO_INDEX(p idx_precio) */ *
FROM productos p
WHERE categoria = 'electronica';

-- Control de JOIN
SELECT /*+ JOIN_ORDER(p, v) */ *
FROM productos p
JOIN ventas v ON p.id = v.producto_id;

-- Forzar tipo de JOIN
SELECT /*+ HASH_JOIN(p, v) */ *
FROM productos p
JOIN ventas v ON p.id = v.producto_id;

-- Configurar timeout de una consulta específica
SELECT /*+ MAX_EXECUTION_TIME(5000) */ *
FROM productos p
JOIN ventas v ON p.id = v.producto_id;
-- Mata la consulta si tarda más de 5000 ms

-- Desactivar optimizaciones
SELECT /*+ NO_RANGE_OPTIMIZATION(p) */ *
FROM productos p WHERE id BETWEEN 1 AND 100;
```

### Hint a nivel de bloque

```sql
SELECT /*+ SET_VAR(sort_buffer_size = 16M) */ *
FROM productos ORDER BY nombre;
```

---

## 3. Buffer Pool de InnoDB

El **buffer pool** es la zona de memoria donde InnoDB guarda las páginas de
datos e índices en RAM. Es el parámetro más importante para rendimiento.

### Cómo funciona

1. Al leer una página, InnoDB la carga en el buffer pool.
2. Las lecturas siguientes de esa página se sirven desde memoria (rápido).
3. Las modificaciones se hacen en memoria (dirty pages) y se escriben a disco
   en segundo plano.

### Configurar el buffer pool

```ini
# my.cnf
[mysqld]
# Tamaño del buffer pool (70-80% de la RAM del servidor en servidor dedicado)
innodb_buffer_pool_size = 4G

# Número de instancias del pool (1 por GB de buffer pool)
innodb_buffer_pool_instances = 4

# Tamaño de cada chunk (debe ser buffer_pool_size / instances)
innodb_buffer_pool_chunk_size = 1G

# Porcentaje del buffer que se puede usar para dirty pages
innodb_max_dirty_pages_pct = 75

# Método de flush (O_DIRECT evita doble buffering del OS)
innodb_flush_method = O_DIRECT
```

### Regla general de tamaño

| RAM del servidor | Buffer Pool |
|---|---|
| 2 GB | 1 GB |
| 4 GB | 2.5 GB |
| 8 GB | 5-6 GB |
| 16 GB | 10-12 GB |
| 32 GB | 24-26 GB |
| 64 GB | 50-54 GB |

### Monitorear el buffer pool

```sql
-- Tasa de hit del buffer pool (debe ser > 95%)
SELECT
    ROUND(
        (1 - Innodb_buffer_pool_reads / Innodb_buffer_pool_read_requests) * 100,
        2
    ) AS hit_rate_pct
FROM (
    SELECT
        VARIABLE_VALUE AS Innodb_buffer_pool_reads
    FROM performance_schema.global_status
    WHERE VARIABLE_NAME = 'Innodb_buffer_pool_reads'
) r,
(
    SELECT
        VARIABLE_VALUE AS Innodb_buffer_pool_read_requests
    FROM performance_schema.global_status
    WHERE VARIABLE_NAME = 'Innodb_buffer_pool_read_requests'
) rr;

-- Estado del buffer pool
SELECT
    POOL_ID,
    POOL_SIZE AS paginas,
    PAGES_DATA AS paginas_datos,
    PAGES_FREE AS paginas_libres,
    PAGES_DIRTY AS paginas_sucias,
    HIT_RATE AS tasa_hit
FROM information_schema.INNODB_BUFFER_POOL_STATS;
```

### Pre-cargar el buffer pool (warmup)

```sql
-- En MySQL 8.0, se puede guardar y restaurar el estado del buffer pool
SET GLOBAL innodb_buffer_pool_dump_at_shutdown = ON;
SET GLOBAL innodb_buffer_pool_load_at_startup = ON;

-- Guardar estado actual manualmente
SET GLOBAL innodb_buffer_pool_dump_now = ON;

-- Cargar estado manualmente (tras reinicio)
SET GLOBAL innodb_buffer_pool_load_now = ON;
```

---

## 4. Configuración my.cnf

El archivo de configuración de MySQL. En Linux suele estar en
`/etc/my.cnf` o `/etc/mysql/my.cnf`.

### Configuración base recomendada

```ini
[mysqld]
# === Identidad ===
server_id = 1
port = 3306
socket = /var/lib/mysql/mysql.sock

# === Charset ===
character-set-server = utf8mb4
collation-server = utf8mb4_unicode_ci

# === InnoDB ===
innodb_buffer_pool_size = 4G
innodb_buffer_pool_instances = 4
innodb_log_file_size = 512M
innodb_log_buffer_size = 64M
innodb_flush_log_at_trx_commit = 1
innodb_flush_method = O_DIRECT
innodb_file_per_table = 1

# === Conexiones ===
max_connections = 200
max_user_connections = 150
wait_timeout = 600
interactive_timeout = 600

# === Buffer de ordenamiento ===
sort_buffer_size = 4M
read_buffer_size = 1M
read_rnd_buffer_size = 2M
join_buffer_size = 2M

# === Tablas temporales en memoria ===
tmp_table_size = 64M
max_heap_table_size = 64M

# === Cache de threads ===
thread_cache_size = 50

# === Cache de query (desactivado en MySQL 8.0) ===
# query_cache_type = 0
# query_cache_size = 0

# === Slow query log ===
slow_query_log = 1
slow_query_log_file = /var/log/mysql/slow.log
long_query_time = 1
log_queries_not_using_indexes = 1

# === Logging binario (para replicación) ===
log_bin = mysql-bin
binlog_format = ROW
expire_logs_days = 7

# === Seguridad ===
sql_mode = STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION
```

### Parámetros críticos explicados

| Parámetro | Default | Recomendado | Descripción |
|---|---|---|---|
| `innodb_buffer_pool_size` | 128M | 70-80% RAM | Memoria para datos e índices |
| `innodb_log_file_size` | 48M | 256M-1G | Tamaño del redo log |
| `innodb_flush_log_at_trx_commit` | 1 | 1 (seguro) / 2 (rápido) | Frecuencia de flush del log |
| `innodb_flush_method` | fsync | O_DIRECT | Método de escritura a disco |
| `max_connections` | 151 | 200-500 | Conexiones concurrentes máximas |
| `sort_buffer_size` | 256K | 2-4M | Buffer para ORDER BY y GROUP BY |
| `tmp_table_size` | 16M | 64-128M | Tablas temporales en memoria |
| `innodb_file_per_table` | ON | ON | Un archivo .ibd por tabla |

### innodb_flush_log_at_trx_commit

| Valor | Comportamiento | Seguridad | Rendimiento |
|---|---|---|---|
| 0 | Escribe/flush cada segundo | Puede perder 1s de datos | Más rápido |
| 1 | Escribe y flush en cada COMMIT | Máxima seguridad | Más lento |
| 2 | Escribe en cada COMMIT, flush cada segundo | Compromiso | Intermedio |

> En producción con datos críticos: **siempre 1**. En entornos de desarrollo
> o caché donde se puede perder 1 segundo de datos: **2** es aceptable.

### Verificar y aplicar cambios

```sql
-- Ver valores actuales
SHOW VARIABLES LIKE 'innodb_buffer_pool_size';
SHOW VARIABLES LIKE 'max_connections';

-- Cambiar en caliente (variables dinámicas)
SET GLOBAL innodb_buffer_pool_size = 5368709120;  -- 5GB
SET GLOBAL max_connections = 300;
SET GLOBAL long_query_time = 0.5;

-- Ver variables no dinámicas (requieren reinicio)
SHOW VARIABLES LIKE 'innodb_log_file_size';
SHOW VARIABLES LIKE 'innodb_flush_method';
```

---

## 5. Particionamiento

El particionamiento divide una tabla grande en piezas más pequeñas
(particiones) que se almacenan físicamente por separado, pero se consultan
como una sola tabla.

### Tipos de particionamiento

#### RANGE: por rango de valores

```sql
CREATE TABLE ventas_particionadas (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    fecha DATE NOT NULL,
    producto_id INT NOT NULL,
    monto DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (id, fecha)
) ENGINE=InnoDB
PARTITION BY RANGE (TO_DAYS(fecha)) (
    PARTITION p2023 VALUES LESS THAN (TO_DAYS('2024-01-01')),
    PARTITION p2024 VALUES LESS THAN (TO_DAYS('2025-01-01')),
    PARTITION p2025 VALUES LESS THAN (TO_DAYS('2026-01-01')),
    PARTITION pmax VALUES LESS THAN MAXVALUE
);
```

#### LIST: por lista de valores

```sql
CREATE TABLE ventas_por_region (
    id INT NOT NULL,
    region_id INT NOT NULL,
    monto DECIMAL(10,2),
    PRIMARY KEY (id, region_id)
) ENGINE=InnoDB
PARTITION BY LIST (region_id) (
    PARTITION p_norte VALUES IN (1, 2, 3),
    PARTITION p_sur VALUES IN (4, 5, 6),
    PARTITION p_este VALUES IN (7, 8, 9),
    PARTITION p_oeste VALUES IN (10, 11, 12)
);
```

#### HASH: distribución uniforme

```sql
CREATE TABLE logs_hash (
    id BIGINT NOT NULL AUTO_INCREMENT,
    mensaje TEXT,
    fecha DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
) ENGINE=InnoDB
PARTITION BY HASH (id)
PARTITIONS 8;
```

#### KEY: similar a HASH pero con clave interna de MySQL

```sql
CREATE TABLE usuarios_key (
    id INT NOT NULL,
    email VARCHAR(100),
    PRIMARY KEY (id)
) ENGINE=InnoDB
PARTITION BY KEY (id)
PARTITIONS 4;
```

### Partition pruning

```sql
-- MySQL solo lee las particiones relevantes (partition pruning)
SELECT * FROM ventas_particionadas WHERE fecha >= '2024-06-01';
-- Solo lee la partición p2024, no p2023 ni p2025

-- EXPLAIN muestra qué particiones se leen
EXPLAIN SELECT * FROM ventas_particionadas WHERE fecha = '2024-06-15';
-- partitions: p2024
```

### Gestionar particiones

```sql
-- Añadir partición
ALTER TABLE ventas_particionadas
ADD PARTITION (
    PARTITION p2026 VALUES LESS THAN (TO_DAYS('2027-01-01'))
);

-- Eliminar partición (¡borra los datos de esa partición!)
ALTER TABLE ventas_particionadas DROP PARTITION p2023;

-- Reorganizar (dividir una partición existente)
ALTER TABLE ventas_particionadas
REORGANIZE PARTITION pmax INTO (
    PARTITION p2026 VALUES LESS THAN (TO_DAYS('2027-01-01')),
    PARTITION pmax VALUES LESS THAN MAXVALUE
);

-- Ver particiones
SELECT
    PARTITION_NAME, PARTITION_METHOD, PARTITION_DESCRIPTION,
    TABLE_ROWS, DATA_LENGTH
FROM information_schema.PARTITIONS
WHERE TABLE_NAME = 'ventas_particionadas';
```

### Cuándo particionar

- ✅ Tablas muy grandes (> 10M de filas o > 10GB).
- ✅ Datos con particionamiento natural por fecha o región.
- ✅ Consultas que siempre filtran por la clave de partición.
- ✅ Archivado de datos antiguos (DROP PARTITION es instantáneo).
- ❌ Tablas pequeñas (< 1M filas): el overhead supera el beneficio.
- ❌ JOINs frecuentes entre tablas particionadas de forma distinta.

### Limitaciones

- La clave de partición debe ser parte de todas las UNIQUE keys.
- Las foreign keys no funcionan con tablas particionadas.
- Máximo 8192 particiones por tabla.

---

## 6. Sharding

El sharding divide los datos entre múltiples servidores MySQL. A diferencia del
particionamiento (que divide dentro de un servidor), el sharding distribuye
entre máquinas.

### Estrategias de sharding

| Estrategia | Descripción | Ventajas | Desventajas |
|---|---|---|---|
| **Range-based** | Por rango de IDs (1-1M en shard 1, 1M-2M en shard 2) | Simple | Hotspots si los rangos son desiguales |
| **Hash-based** | Hash del ID → shard | Distribución uniforme | Re-sharding al añadir nodos |
| **Geográfico** | Por región/país | Latencia baja, cumplimiento legal | Datos desiguales entre regiones |
| **Directory-based** | Tabla de lookup que mapea registro → shard | Flexible | Punto único de fallo |

### Ejemplo conceptual de sharding por hash

```
                ┌──────────────────┐
                │  Router / Proxy   │
                │  (Vitess, ProxySQL)│
                └────┬─────┬─────┬──┘
                     │     │     │
              ┌──────┴┐ ┌──┴──┐ ┌┴──────┐
              │Shard 0│ │Shard1│ │Shard 2│
              │users  │ │users │ │users  │
              │0-33%  │ │33-66%│ │66-100%│
              └───────┘ └──────┘ └───────┘
```

### Herramientas de sharding

- **Vitess**: sharding nativo para MySQL (usado por YouTube, Slack).
- **ProxySQL**: proxy con routing de consultas.
- **MySQL Fabric**: herramienta oficial de Oracle (deprecada).
- **MySQL NDB Cluster**: clustering con sharding automático.

### Sharding: consideraciones

- Las consultas que cruzan shards son complejas y lentas.
- Los JOINs entre shards no son posibles directamente.
- Las transacciones distribuidas son complejas (XA transactions).
- El re-sharding (redistribuir al añadir nodos) es costoso.

> El sharding debe ser el **último recurso** de escalado. Antes considera:
> optimizar consultas, añadir índices, particionar, replicar lecturas,
> aumentar hardware (scale up).

---

## 7. Slow Query Log

El slow query log registra todas las consultas que tardan más de un umbral
configurable.

### Activar y configurar

```sql
-- En my.cnf
-- [mysqld]
-- slow_query_log = 1
-- slow_query_log_file = /var/log/mysql/slow.log
-- long_query_time = 1
-- log_queries_not_using_indexes = 1

-- En caliente
SET GLOBAL slow_query_log = ON;
SET GLOBAL long_query_time = 0.5;
SET GLOBAL log_queries_not_using_indexes = ON;

-- Verificar
SHOW VARIABLES LIKE 'slow_query_log%';
SHOW VARIABLES LIKE 'long_query_time';
```

### Analizar el slow query log con mysqldumpslow

```bash
# Resumen de consultas lentas ordenadas por tiempo total
mysqldumpslow -s t /var/log/mysql/slow.log

# Top 10 por número de apariciones
mysqldumpslow -s c -t 10 /var/log/mysql/slow.log

# Por tiempo promedio
mysqldumpslow -s at -t 10 /var/log/mysql/slow.log

# Filtrar por un patrón
mysqldumpslow -g 'SELECT' /var/log/mysql/slow.log
```

### pt-query-digest (Percona Toolkit)

```bash
# Análisis mucho más detallado que mysqldumpslow
pt-query-digest /var/log/mysql/slow.log

# Analizar queries en tiempo real desde PROCESSLIST
pt-query-digest --processlist h=localhost,u=root
```

### Formato de una entrada del slow log

```
# Time: 2024-01-15T14:30:45.123456Z
# User@Host: root[root] @ localhost []  Id: 123
# Query_time: 2.543210  Lock_time: 0.000123  Rows_sent: 10  Rows_examined: 1000000
SET timestamp=1705320645;
SELECT * FROM productos WHERE nombre LIKE '%laptop%' ORDER BY precio;
```

| Campo | Significado |
|---|---|
| `Query_time` | Tiempo total de ejecución |
| `Lock_time` | Tiempo esperando locks |
| `Rows_sent` | Filas devueltas al cliente |
| `Rows_examined` | Filas leídas (si es mucho mayor que Rows_sent → problema) |

> Si `Rows_examined` es 1000000 y `Rows_sent` es 10, falta un índice o la
> consulta está mal diseñada.

---

## 8. Performance Schema

Performance Schema es una herramienta de monitorización integrada en MySQL
que registra eventos del servidor a bajo nivel.

### Activar y verificar

```sql
-- Verificar si está activo
SELECT * FROM performance_schema.setup_timers;

-- Ver consumidores activos
SELECT NAME, ENABLED, TIMED
FROM performance_schema.setup_consumers;

-- Activar consumidores
UPDATE performance_schema.setup_consumers
SET ENABLED = 'YES' WHERE NAME LIKE '%statement%';

UPDATE performance_schema.setup_instruments
SET ENABLED = 'YES', TIMED = 'YES'
WHERE NAME LIKE '%statement%';
```

### Consultas útiles de Performance Schema

```sql
-- Consultas con mayor tiempo de ejecución
SELECT
    DIGEST_TEXT,
    COUNT_STAR AS ejecuciones,
    ROUND(AVG_TIMER_WAIT/1000000000, 2) AS tiempo_avg_ms,
    ROUND(SUM_TIMER_WAIT/1000000000, 2) AS tiempo_total_ms
FROM performance_schema.events_statements_summary_by_digest
ORDER BY SUM_TIMER_WAIT DESC
LIMIT 10;

-- Consultas con full table scans
SELECT
    DIGEST_TEXT,
    COUNT_STAR AS ejecuciones,
    SUM_NO_INDEX_USED AS sin_indice,
    SUM_NO_GOOD_INDEX_USED AS sin_buen_indice
FROM performance_schema.events_statements_summary_by_digest
WHERE SUM_NO_INDEX_USED > 0
ORDER BY SUM_NO_INDEX_USED DESC
LIMIT 10;

-- Errores por consulta
SELECT
    DIGEST_TEXT,
    COUNT_STAR AS ejecuciones,
    SUM_ERRORS AS errores
FROM performance_schema.events_statements_summary_by_digest
WHERE SUM_ERRORS > 0
ORDER BY SUM_ERRORS DESC;

-- Conexiones activas
SELECT * FROM performance_schema.threads WHERE TYPE = 'FOREGROUND';

-- Esperas (locks, I/O, etc.)
SELECT
    EVENT_NAME,
    COUNT_STAR AS veces,
    ROUND(AVG_TIMER_WAIT/1000000000, 2) AS tiempo_avg_ms
FROM performance_schema.events_waits_summary_global_by_event_name
WHERE COUNT_STAR > 0
ORDER BY SUM_TIMER_WAIT DESC
LIMIT 10;

-- Uso de índices por tabla
SELECT
    OBJECT_SCHEMA AS db,
    OBJECT_NAME AS tabla,
    INDEX_NAME,
    COUNT_READ AS lecturas,
    COUNT_FETCH AS fetches,
    COUNT_INSERT AS inserts,
    COUNT_UPDATE AS updates,
    COUNT_DELETE AS deletes
FROM performance_schema.table_io_waits_summary_by_index_usage
WHERE OBJECT_SCHEMA NOT IN ('mysql', 'performance_schema', 'information_schema')
ORDER BY COUNT_READ DESC
LIMIT 20;

-- Índices no usados (candidatos a eliminar)
SELECT
    OBJECT_SCHEMA AS db,
    OBJECT_NAME AS tabla,
    INDEX_NAME
FROM performance_schema.table_io_waits_summary_by_index_usage
WHERE INDEX_NAME IS NOT NULL
  AND COUNT_READ = 0
  AND COUNT_INSERT = 0
  AND COUNT_UPDATE = 0
  AND COUNT_DELETE = 0
  AND OBJECT_SCHEMA NOT IN ('mysql', 'performance_schema', 'information_schema');
```

### sys schema: vistas simplificadas

```sql
-- Consultas más lentas
SELECT * FROM sys.statements_with_runtime_in_95th_percentile;

-- Consultas con full table scan
SELECT * FROM sys.statements_with_full_table_scans;

-- Índices no usados
SELECT * FROM sys.schema_unused_indexes;

-- Tablas con locks
SELECT * FROM sys.innodb_lock_waits;

-- Sesiones activas
SELECT * FROM sys.session;

-- Memoria usada por componente
SELECT * FROM sys.memory_global_by_current_bytes LIMIT 10;
```

---

## 9. Checklist de optimización

### Antes de optimizar

1. **Medir**: usa EXPLAIN ANALYZE y slow query log para identificar cuellos de botella.
2. **Priorizar**: optimiza primero las consultas que se ejecutan con más frecuencia.
3. **No optimizar prematuramente**: si una consulta tarda 1ms, no necesita optimización.

### Optimizaciones por frecuencia de impacto

| Prioridad | Acción | Impacto |
|---|---|---|
| 1 | Añadir índices a columnas en WHERE/JOIN | 🔴 Crítico |
| 2 | Eliminar `SELECT *`, seleccionar solo columnas necesarias | 🟠 Alto |
| 3 | Configurar `innodb_buffer_pool_size` correctamente | 🔴 Crítico |
| 4 | Evitar funciones en columnas indexadas en WHERE | 🟠 Alto |
| 5 | Usar covering indexes | 🟠 Alto |
| 6 | Particionar tablas grandes (> 10M filas) | 🟡 Medio |
| 7 | Optimizar JOINs (JOIN order, índices en FKs) | 🟠 Alto |
| 8 | Configurar `sort_buffer_size` y `tmp_table_size` | 🟡 Medio |
| 9 | Eliminar índices no usados | 🟡 Medio |
| 10 | Considerar caché externa (Redis) para lecturas frecuentes | 🟡 Medio |

### Anti-patrones de rendimiento

```sql
-- ❌ Función en columna indexada (no usa índice)
SELECT * FROM productos WHERE YEAR(creado_en) = 2024;
-- ✅ Rango que usa el índice
SELECT * FROM productos WHERE creado_en >= '2024-01-01' AND creado_en < '2025-01-01';

-- ❌ OR que impide usar índices (a veces)
SELECT * FROM productos WHERE categoria = 'A' OR categoria = 'B';
-- ✅ UNION ALL (si los OR dan problemas de índice)
SELECT * FROM productos WHERE categoria = 'A'
UNION ALL
SELECT * FROM productos WHERE categoria = 'B';

-- ❌ SELECT * innecesario
SELECT * FROM productos WHERE id = 1;
-- ✅ Solo columnas necesarias
SELECT nombre, precio FROM productos WHERE id = 1;

-- ❌ Subconsulta correlacionada (se ejecuta N veces)
SELECT p.nombre,
    (SELECT COUNT(*) FROM ventas v WHERE v.producto_id = p.id) AS total
FROM productos p;
-- ✅ JOIN con GROUP BY (se ejecuta una vez)
SELECT p.nombre, COUNT(v.id) AS total
FROM productos p
LEFT JOIN ventas v ON p.id = v.producto_id
GROUP BY p.id, p.nombre;

-- ❌ ORDER BY RAND() (extremadamente lento en tablas grandes)
SELECT * FROM productos ORDER BY RAND() LIMIT 5;
-- ✅ Alternativa: seleccionar IDs aleatorios en la app o usar OFFSET aleatorio
SELECT * FROM productos WHERE id >= (SELECT FLOOR(RAND() * (SELECT MAX(id) FROM productos))) LIMIT 5;
```

---

## Conceptos clave

| Concepto | Definición |
|---|---|
| **EXPLAIN ANALYZE** | Ejecuta la consulta y muestra tiempos reales por operación |
| **Buffer Pool** | Memoria RAM donde InnoDB guarda datos e índices en caché |
| **Hint** | Directiva que fuerza al optimizador a usar una estrategia concreta |
| **Partitioning** | División física de una tabla en piezas más pequeñas en el mismo servidor |
| **Sharding** | Distribución de datos entre múltiples servidores |
| **Slow Query Log** | Registro de consultas que superan un umbral de tiempo |
| **Performance Schema** | Sistema de monitorización interna de MySQL |
| **Partition pruning** | Capacidad de MySQL para leer solo las particiones relevantes |
| **Covering index** | Índice que cubre todas las columnas de una consulta |

---

## Errores comunes

### 1. Usar funciones en columnas indexadas

```sql
-- ❌ No usa índice
WHERE YEAR(fecha) = 2024
WHERE LOWER(email) = 'admin'
WHERE LEFT(nombre, 3) = 'abc'

-- ✅ Usa índice
WHERE fecha >= '2024-01-01' AND fecha < '2025-01-01'
WHERE email = 'admin'  -- si la collation es _ci
WHERE nombre LIKE 'abc%'
```

### 2. Buffer pool demasiado pequeño

Si el buffer pool es pequeño, MySQL lee del disco constantemente. El hit rate
debe ser > 95%.

### 3. Particionar tablas pequeñas

El particionamiento tiene overhead. En tablas pequeñas empeora el rendimiento.

### 4. Sharding prematuro

El sharding añade complejidad masiva. Solo se justifica cuando un solo servidor
no puede manejar la carga o el volumen de datos (típicamente > 1TB o > 100K
QPS).

### 5. No usar log_queries_not_using_indexes

```ini
# Detecta consultas que no usan índices aunque sean rápidas
log_queries_not_using_indexes = 1
```

### 6. Confiar en el query cache (eliminado en MySQL 8.0)

El query cache fue eliminado en MySQL 8.0 porque causaba más problemas que
soluciones en entornos de alta concurrencia. Para caché, usa Redis o Memcached.

### 7. Ignorar Rows_examined vs Rows_sent

Si examinas 1,000,000 de filas para devolver 10, tienes un problema de índice
o diseño de consulta.

---

## Siguiente paso

Continúa con la [Guía 05 — Administración y producción](05-administracion-y-produccion.md)
para aprender sobre usuarios, backups, replicación, clustering y seguridad.
