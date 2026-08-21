# Guía 05 — Administración y Producción de MySQL

## Objetivos

- [ ] Gestionar usuarios y privilegios con GRANT y REVOKE
- [ ] Hacer backups con mysqldump y restaurar bases de datos
- [ ] Configurar replicación master-slave
- [ ] Entender clustering y alta disponibilidad
- [ ] Monitorear MySQL en producción
- [ ] Usar las features de MySQL 8 (roles, CTE, window functions)
- [ ] Desplegar MySQL con Docker
- [ ] Aplicar mejores prácticas de seguridad

---

## 1. Usuarios y Privilegios

### Crear usuarios

```sql
-- Crear usuario con acceso solo desde localhost
CREATE USER 'app_user'@'localhost' IDENTIFIED BY 'password_seguro';

-- Crear usuario con acceso desde cualquier host
CREATE USER 'app_user'@'%' IDENTIFIED BY 'password_seguro';

-- Crear usuario con acceso desde una IP específica
CREATE USER 'app_user'@'192.168.1.100' IDENTIFIED BY 'password_seguro';

-- Crear usuario con acceso desde un rango
CREATE USER 'app_user'@'192.168.1.%' IDENTIFIED BY 'password_seguro';

-- MySQL 8.0: crear usuario con plugin de autenticación
CREATE USER 'app_user'@'localhost'
    IDENTIFIED WITH caching_sha2_password BY 'password_seguro';

-- Con expiración de contraseña
CREATE USER 'temp_user'@'localhost'
    IDENTIFIED BY 'temp_pass' PASSWORD EXPIRE INTERVAL 90 DAY;

-- Con límite de recursos
CREATE USER 'api_user'@'localhost' IDENTIFIED BY 'pass'
    WITH MAX_QUERIES_PER_HOUR 1000
         MAX_CONNECTIONS_PER_HOUR 100
         MAX_UPDATES_PER_HOUR 500;
```

### Otorgar privilegios (GRANT)

```sql
-- Todos los privilegios en una base de datos
GRANT ALL PRIVILEGES ON tienda.* TO 'app_user'@'localhost';

-- Solo SELECT e INSERT
GRANT SELECT, INSERT ON tienda.* TO 'lector'@'localhost';

-- Privilegios a nivel de tabla específica
GRANT SELECT, UPDATE ON tienda.productos TO 'editor'@'localhost';

-- Solo lectura
GRANT SELECT ON tienda.* TO 'reportes'@'localhost';

-- Crear usuario y otorgar en un solo paso
GRANT SELECT, INSERT, UPDATE, DELETE ON tienda.* TO 'dev'@'localhost' IDENTIFIED BY 'dev_pass';

-- Permitir crear usuarios y dar privilegios (admin delegado)
GRANT ALL PRIVILEGES ON tienda.* TO 'admin_tienda'@'localhost' WITH GRANT OPTION;

-- Privilegios a todas las bases de datos
GRANT ALL PRIVILEGES ON *.* TO 'superadmin'@'localhost';

-- Privilegios específicos de administración
GRANT RELOAD, PROCESS, REPLICATION CLIENT ON *.* TO 'monitor'@'localhost';

-- Replicación
GRANT REPLICATION SLAVE ON *.* TO 'replica'@'192.168.1.%' IDENTIFIED BY 'repl_pass';
```

### Revocar privilegios (REVOKE)

```sql
-- Quitar privilegios
REVOKE INSERT, DELETE ON tienda.* FROM 'app_user'@'localhost';

-- Quitar todos los privilegios
REVOKE ALL PRIVILEGES ON tienda.* FROM 'app_user'@'localhost';

-- Quitar WITH GRANT OPTION
REVOKE GRANT OPTION ON tienda.* FROM 'admin_tienda'@'localhost';

-- Aplicar cambios inmediatamente
FLUSH PRIVILEGES;
```

### Ver privilegios

```sql
-- Privilegios del usuario actual
SHOW GRANTS;

-- Privilegios de un usuario específico
SHOW GRANTS FOR 'app_user'@'localhost';

-- Ver todos los usuarios
SELECT user, host, authentication_string FROM mysql.user;

-- Ver privilegios por usuario
SELECT user, host,
    SELECT_priv, INSERT_priv, UPDATE_priv, DELETE_priv,
    CREATE_priv, DROP_priv, GRANT_priv
FROM mysql.user;
```

### Modificar y eliminar usuarios

```sql
-- Cambiar contraseña
ALTER USER 'app_user'@'localhost' IDENTIFIED BY 'nueva_password';

-- Renombrar usuario
RENAME USER 'app_user'@'localhost' TO 'web_user'@'localhost';

-- Eliminar usuario
DROP USER IF EXISTS 'app_user'@'localhost';

-- Bloquear/desbloquear cuenta
ALTER USER 'app_user'@'localhost' ACCOUNT LOCK;
ALTER USER 'app_user'@'localhost' ACCOUNT UNLOCK;

-- Expirar contraseña (forzar cambio en el próximo login)
ALTER USER 'app_user'@'localhost' PASSWORD EXPIRE;
```

### Roles (MySQL 8.0+)

Los roles agrupan privilegios que se pueden asignar a múltiples usuarios.

```sql
-- Crear roles
CREATE ROLE 'rol_lector', 'rol_escritor', 'rol_admin';

-- Asignar privilegios a roles
GRANT SELECT ON tienda.* TO 'rol_lector';
GRANT SELECT, INSERT, UPDATE, DELETE ON tienda.* TO 'rol_escritor';
GRANT ALL PRIVILEGES ON tienda.* TO 'rol_admin';

-- Asignar roles a usuarios
GRANT 'rol_lector' TO 'usuario1'@'localhost';
GRANT 'rol_escritor' TO 'usuario2'@'localhost', 'usuario3'@'localhost';

-- Activar rol (por defecto no está activo en la sesión)
SET ROLE 'rol_lector';

-- Ver rol activo
SELECT CURRENT_ROLE();

-- Ver todos los roles
SELECT * FROM mysql.role_edges;

-- Quitar rol a un usuario
REVOKE 'rol_lector' FROM 'usuario1'@'localhost';

-- Eliminar rol
DROP ROLE 'rol_lector';

-- Configurar roles por defecto al conectar
SET DEFAULT ROLE 'rol_lector' TO 'usuario1'@'localhost';
```

### Tabla de privilegios principales

| Privilegio | Descripción |
|---|---|
| `ALL PRIVILEGES` | Todos los privilegios |
| `SELECT` | Leer datos |
| `INSERT` | Insertar datos |
| `UPDATE` | Modificar datos |
| `DELETE` | Borrar datos |
| `CREATE` | Crear BD/tables |
| `DROP` | Eliminar BD/tables |
| `ALTER` | Modificar estructura |
| `INDEX` | Crear/eliminar índices |
| `REFERENCES` | Crear foreign keys |
| `GRANT OPTION` | Otorgar privilegios a otros |
| `RELOAD` | FLUSH |
| `PROCESS` | Ver procesos |
| `REPLICATION CLIENT` | Ver estado de replicación |
| `REPLICATION SLAVE` | Ser servidor réplica |
| `SUPER` | Operaciones de admin (deprecated en 8.0) |
| `SHOW DATABASES` | Ver todas las BDs |
| `SHUTDOWN` | Apagar el servidor |
| `FILE` | Leer/escribir archivos del servidor |

---

## 2. Backups con mysqldump

`mysqldump` es la herramienta de línea de comandos para exportar bases de
datos a archivos SQL.

### Backup de una base de datos

```bash
# Backup completo de una base de datos
mysqldump -u root -p tienda > backup_tienda.sql

# Backup con timestamp
mysqldump -u root -p tienda > backup_tienda_$(date +%Y%m%d_%H%M%S).sql

# Backup comprimido
mysqldump -u root -p tienda | gzip > backup_tienda.sql.gz

# Backup de múltiples bases de datos
mysqldump -u root -p --databases tienda blog > backup_multi.sql

# Backup de TODAS las bases de datos
mysqldump -u root -p --all-databases > backup_total.sql

# Solo la estructura (sin datos)
mysqldump -u root -p --no-data tienda > estructura.sql

# Solo los datos (sin estructura)
mysqldump -u root -p --no-create-info tienda > datos.sql

# Solo algunas tablas
mysqldump -u root -p tienda productos ventas > tablas.sql
```

### Opciones útiles de mysqldump

```bash
# --single-transaction: backup consistente sin bloquear (InnoDB)
mysqldump -u root -p --single-transaction tienda > backup.sql

# --routines: incluir stored procedures y funciones
mysqldump -u root -p --routines tienda > backup.sql

# --triggers: incluir triggers (por defecto sí)
mysqldump -u root -p --triggers tienda > backup.sql

# --events: incluir eventos programados
mysqldump -u root -p --events tienda > backup.sql

# --quick: no cargar todo en memoria (necesario para BDs grandes)
mysqldump -u root -p --quick tienda > backup.sql

# Combinación recomendada para producción
mysqldump -u root -p \
    --single-transaction \
    --quick \
    --routines \
    --triggers \
    --events \
    --set-gtid-purged=OFF \
    tienda > backup_tienda_completo.sql
```

### Backup físico con mysqlpump (MySQL 8.0)

```bash
# Backup paralelo (más rápido que mysqldump)
mysqlpump -u root -p --parallel-schemas=4 tienda > backup.sql

# Backup con compresión zlib
mysqlpump -u root -p --compress-output=zlib tienda > backup.sql.zlib
```

### Backup con Percona XtraBackup (físico)

```bash
# Instalación
sudo dnf install percona-xtrabackup

# Backup físico en caliente (mucho más rápido para BDs grandes)
xtrabackup --backup --target-dir=/backups/full --user=root --password=pass

# Preparar el backup (aplicar redo logs)
xtrabackup --prepare --target-dir=/backups/full

# Restaurar (detiene el servidor primero)
sudo systemctl stop mysqld
xtrabackup --copy-back --target-dir=/backups/full
sudo chown -R mysql:mysql /var/lib/mysql
sudo systemctl start mysqld
```

---

## 3. Restauración

### Restaurar desde un dump SQL

```bash
# Restaurar una base de datos completa
mysql -u root -p tienda < backup_tienda.sql

# Crear la BD si no existe y restaurar
mysql -u root -p -e "CREATE DATABASE IF NOT EXISTS tienda;"
mysql -u root -p tienda < backup_tienda.sql

# Restaurar desde un backup comprimido
gunzip < backup_tienda.sql.gz | mysql -u root -p tienda

# Restaurar solo una tabla desde un dump
mysql -u root -p tienda -e "DROP TABLE IF EXISTS productos;"
mysql -u root -p tienda < backup_tienda.sql
```

### Restaurar con source (dentro del cliente mysql)

```sql
mysql> USE tienda;
mysql> SOURCE /ruta/al/backup_tienda.sql;
```

### Restaurar punto en el tiempo (PITR)

```bash
# 1. Restaurar el último backup completo
mysql -u root -p tienda < backup_completo.sql

# 2. Aplicar los binlogs desde el punto del backup hasta el momento del desastre
mysqlbinlog --start-datetime="2024-01-15 02:00:00" \
            --stop-datetime="2024-01-15 14:00:00" \
            /var/lib/mysql/mysql-bin.000123 \
    | mysql -u root -p
```

### Estrategias de backup

| Estrategia | Frecuencia | Herramienta | Tiempo de recuperación |
|---|---|---|---|
| **Full** | Diario/Semanal | mysqldump / xtrabackup | Lento (restaura todo) |
| **Incremental** | Diario | xtrabackup / binlogs | Medio (full + incrementales) |
| **Binlog** | Continuo | mysqlbinlog | Punto en el tiempo exacto |
| **Snapshot LVM** | Horario | LVM snapshot | Rápido |

---

## 4. Replicación

La replicación copia datos de un servidor (master/source) a uno o más
servidores (slave/replica).

### Tipos de replicación

| Tipo | Descripción |
|---|---|
| **Asynchronous** | El master no espera al slave. Default |
| **Semi-synchronous** | El master espera al menos a 1 slave |
| **Group Replication** | Multi-master con consenso Paxos |

### Arquitectura básica

```
    ┌─────────┐    binlog     ┌─────────┐
    │  Master  │ ────────────> │  Slave   │
    │ (escritura)│             │ (lectura) │
    └─────────┘                └─────────┘
```

### Configurar el Master (Source)

```ini
# my.cnf del master
[mysqld]
server_id = 1
log_bin = mysql-bin
binlog_format = ROW
gtid_mode = ON
enforce_gtid_consistency = ON
```

```sql
-- Crear usuario de replicación
CREATE USER 'repl'@'192.168.1.%' IDENTIFIED BY 'repl_password';
GRANT REPLICATION SLAVE ON *.* TO 'repl'@'192.168.1.%';

-- Ver estado del master (anotar File y Position)
SHOW MASTER STATUS;
-- +------------------+----------+--------------+------------------+
-- | File             | Position | Binlog_Do_DB | Binlog_Ignore_DB |
-- +------------------+----------+--------------+------------------+
-- | mysql-bin.000003 |      154 |              |                  |
-- +------------------+----------+--------------+------------------+
```

### Configurar el Slave (Replica)

```ini
# my.cnf del slave
[mysqld]
server_id = 2
relay_log = relay-bin
gtid_mode = ON
enforce_gtid_consistency = ON
read_only = ON
```

```sql
-- Configurar conexión al master
CHANGE REPLICATION SOURCE TO
    SOURCE_HOST = '192.168.1.10',
    SOURCE_PORT = 3306,
    SOURCE_USER = 'repl',
    SOURCE_PASSWORD = 'repl_password',
    SOURCE_LOG_FILE = 'mysql-bin.000003',
    SOURCE_LOG_POS = 154;

-- Con GTID (recomendado)
CHANGE REPLICATION SOURCE TO
    SOURCE_HOST = '192.168.1.10',
    SOURCE_PORT = 3306,
    SOURCE_USER = 'repl',
    SOURCE_PASSWORD = 'repl_password',
    SOURCE_AUTO_POSITION = 1;

-- Iniciar replicación
START REPLICA;  -- MySQL 8.0+ (antes: START SLAVE)

-- Ver estado de replicación
SHOW REPLICA STATUS\G  -- antes: SHOW SLAVE STATUS\G

-- Parar replicación
STOP REPLICA;

-- Resetear replicación
RESET REPLICA ALL;
```

### Verificar replicación

```sql
SHOW REPLICA STATUS\G

-- Campos clave:
-- Replica_IO_Running: Yes    (hilo que lee binlog del master)
-- Replica_SQL_Running: Yes   (hilo que ejecuta los eventos)
-- Seconds_Behind_Master: 0   (retraso en segundos, 0 = al día)
-- Last_Error:               (errores de replicación)
```

### Replicación semi-síncrona

```sql
-- En el master
INSTALL PLUGIN rpl_semi_sync_source SONAME 'semisync_source.so';
SET GLOBAL rpl_semi_sync_source_enabled = 1;
SET GLOBAL rpl_semi_sync_source_timeout = 3000;  -- 3 segundos

-- En el slave
INSTALL PLUGIN rpl_semi_sync_replica SONAME 'semisync_replica.so';
SET GLOBAL rpl_semi_sync_replica_enabled = 1;
STOP REPLICA;
START REPLICA;
```

---

## 5. Clustering y Alta Disponibilidad

### MySQL InnoDB Cluster

InnoDB Cluster usa Group Replication + MySQL Router + MySQL Shell para
proporcionar alta disponibilidad automática.

```
                 ┌──────────────┐
                 │ MySQL Router  │  (routing automático)
                 └──┬───┬───┬───┘
                    │   │   │
              ┌─────┤   │   ├─────┐
              ▼         ▼         ▼
         ┌────────┐ ┌────────┐ ┌────────┐
         │ Node 1  │ │ Node 2  │ │ Node 3  │
         │ Primary │ │Secondary│ │Secondary│
         └────────┘ └────────┘ └────────┘
              Group Replication (consenso)
```

### Configurar Group Replication

```ini
# my.cnf en cada nodo
[mysqld]
server_id = 1
gtid_mode = ON
enforce_gtid_consistency = ON
binlog_format = ROW
binlog_checksum = NONE

# Group Replication
plugin_load_add = 'group_replication.so'
group_replication_group_name = "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa"
group_replication_local_address = "192.168.1.10:33061"
group_replication_group_seeds = "192.168.1.10:33061,192.168.1.11:33061,192.168.1.12:33061"
group_replication_bootstrap_group = OFF  # ON solo en el primer nodo
```

```sql
-- En el primer nodo (bootstrap)
SET GLOBAL group_replication_bootstrap_group = ON;
START GROUP_REPLICATION;
SET GLOBAL group_replication_bootstrap_group = OFF;

-- En los demás nodos
START GROUP_REPLICATION;

-- Ver miembros del cluster
SELECT * FROM performance_schema.replication_group_members;

-- Ver quién es el primary
SELECT MEMBER_HOST, MEMBER_ROLE FROM performance_schema.replication_group_members;
```

### MySQL Router

```bash
# Instalar
sudo dnf install mysql-router

# Configurar
mysqlrouter --bootstrap root@localhost:3306 --directory ~/myrouter

# Iniciar
~/myrouter/start.sh

-- El router expone:
-- Puerto 6446: lecturas/escrituras (va al primary)
-- Puerto 6447: solo lecturas (va a los secondary)
```

### Otras soluciones de HA

| Solución | Descripción |
|---|---|
| **InnoDB Cluster** | Solución oficial de MySQL con failover automático |
| **InnoDB ClusterSet** | Múltiples clusters en distintos datacenters |
| **Galera Cluster** | Replicación multi-master síncrona (MariaDB/MySQL) |
| **Percona XtraDB Cluster** | Galera + Percona Server |
| **MHA** | Master High Availability manager (failover automático) |
| **Orchestrator** | Topología y failover para replicación |
| **ProxySQL** | Proxy con balanceo de carga y failover |

---

## 6. Monitoreo

### Métricas clave a monitorear

| Métrica | Comando | Valor saludable |
|---|---|---|
| Conexiones activas | `SHOW STATUS LIKE 'Threads_connected'` | < max_connections |
| Buffer pool hit rate | Performance Schema | > 95% |
| Queries por segundo | `SHOW STATUS LIKE 'Questions'` | Depende del uso |
| Slow queries | `SHOW STATUS LIKE 'Slow_queries'` | Cercano a 0 |
| Uptime | `SHOW STATUS LIKE 'Uptime'` | Alto |
| Tablas abiertas | `SHOW STATUS LIKE 'Open_tables'` | Estable |
| Threads en cache | `SHOW STATUS LIKE 'Threads_cached'` | > 0 |
| Innodb rows read | `SHOW STATUS LIKE 'Innodb_rows_read'` | Estable |

### Comandos de monitoreo

```sql
-- Estado general del servidor
SHOW STATUS;
SHOW STATUS LIKE 'Threads%';
SHOW STATUS LIKE 'Connections%';
SHOW STATUS LIKE 'Innodb%';
SHOW STATUS LIKE 'Slow_%';
SHOW STATUS LIKE 'Qcache%';  -- MySQL 5.7 y anteriores

-- Variables de configuración
SHOW VARIABLES LIKE 'max_connections';
SHOW VARIABLES LIKE 'innodb_buffer_pool_size';

-- Procesos activos (qué está ejecutándose ahora)
SHOW PROCESSLIST;
SHOW FULL PROCESSLIST;

-- Matar un proceso
KILL 1234;  -- por ID
KILL QUERY 1234;  -- solo la query actual, no la conexión

-- Estado de InnoDB
SHOW ENGINE INNODB STATUS\G

-- Estado del servidor
SHOW GLOBAL STATUS;
```

### Monitorear con Performance Schema

```sql
-- Consultas más lentas
SELECT DIGEST_TEXT, COUNT_STAR,
       ROUND(AVG_TIMER_WAIT/1000000000, 2) AS avg_ms,
       ROUND(SUM_TIMER_WAIT/1000000000, 2) AS total_ms
FROM performance_schema.events_statements_summary_by_digest
ORDER BY AVG_TIMER_WAIT DESC LIMIT 10;

-- Uso de memoria por usuario
SELECT USER, EVENT_NAME,
       ROUND(CURRENT_NUMBER_OF_BYTES_USED/1024/1024, 2) AS mb
FROM performance_schema.memory_summary_by_account_by_event_name
ORDER BY CURRENT_NUMBER_OF_BYTES_USED DESC LIMIT 10;
```

### Herramientas externas de monitoreo

| Herramienta | Tipo | Descripción |
|---|---|---|
| **MySQL Workbench** | GUI | Monitor visual oficial |
| **phpMyAdmin** | Web | Administración web |
| **Percona Monitoring (PMM)** | Open source | Dashboard completo con Prometheus/Grafana |
| **Prometheus + Grafana** | Open source | Métricas y dashboards |
| **Datadog** | SaaS | Monitoreo con alertas |
| **Zabbix** | Open source | Monitorización de infraestructura |

### Exportar métricas para Prometheus

```bash
# Instalar mysqld_exporter
wget https://github.com/prometheus/mysqld_exporter/releases/download/v0.15.1/mysqld_exporter-0.15.1.linux-amd64.tar.gz
tar xzf mysqld_exporter-0.15.1.linux-amd64.tar.gz

# Crear usuario para el exporter
mysql -u root -p -e "
CREATE USER 'exporter'@'localhost' IDENTIFIED BY 'exp_pass';
GRANT PROCESS, REPLICATION CLIENT, SELECT ON *.* TO 'exporter'@'localhost';"

# Configurar
cat > .my.cnf << EOF
[client]
user=exporter
password=exp_pass
EOF

# Ejecutar
./mysqld_exporter --config.my-cnf=.my.cnf
# Expone métricas en http://localhost:9104/metrics
```

---

## 7. Features de MySQL 8

### Common Table Expressions (CTE)

```sql
-- CTE no recursiva
WITH ventas_por_categoria AS (
    SELECT categoria, SUM(total) AS total
    FROM ventas GROUP BY categoria
)
SELECT categoria, total,
       (total / (SELECT SUM(total) FROM ventas_por_categoria)) * 100 AS porcentaje
FROM ventas_por_categoria
ORDER BY total DESC;

-- CTE recursiva: jerarquía de empleados
WITH RECURSIVE jerarquia AS (
    -- Caso base: directores (sin jefe)
    SELECT id, nombre, jefe_id, 1 AS nivel
    FROM empleados WHERE jefe_id IS NULL

    UNION ALL

    -- Caso recursivo: subordinados
    SELECT e.id, e.nombre, e.jefe_id, j.nivel + 1
    FROM empleados e
    INNER JOIN jerarquia j ON e.jefe_id = j.id
)
SELECT nombre, nivel FROM jerarquia ORDER BY nivel, nombre;
```

### Window Functions

```sql
-- ROW_NUMBER: número de fila secuencial
SELECT nombre, precio,
       ROW_NUMBER() OVER (ORDER BY precio DESC) AS ranking
FROM productos;

-- RANK y DENSE_RANK: ranking con empates
SELECT nombre, categoria, precio,
       RANK() OVER (PARTITION BY categoria ORDER BY precio DESC) AS rank_categoria,
       DENSE_RANK() OVER (PARTITION BY categoria ORDER BY precio DESC) AS dense_rank
FROM productos;

-- LAG y LEAD: acceder a filas anteriores/siguientes
SELECT
    fecha,
    total,
    LAG(total, 1) OVER (ORDER BY fecha) AS venta_anterior,
    total - LAG(total, 1) OVER (ORDER BY fecha) AS diferencia,
    LEAD(total, 1) OVER (ORDER BY fecha) AS venta_siguiente
FROM ventas_diarias;

-- SUM/AVG acumulativas
SELECT
    fecha,
    total,
    SUM(total) OVER (ORDER BY fecha) AS total_acumulado,
    ROUND(AVG(total) OVER (ORDER BY fecha ROWS BETWEEN 6 PRECEDING AND CURRENT ROW), 2) AS promedio_movil_7d
FROM ventas_diarias;

-- NTILE: dividir en N grupos (cuartiles)
SELECT nombre, precio,
       NTILE(4) OVER (ORDER BY precio) AS cuartil
FROM productos;

-- FIRST_VALUE y LAST_VALUE
SELECT nombre, categoria, precio,
       FIRST_VALUE(precio) OVER (PARTITION BY categoria ORDER BY precio) AS mas_barato,
       LAST_VALUE(precio) OVER (PARTITION BY categoria ORDER BY precio
           ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS mas_caro
FROM productos;
```

### Funciones JSON avanzadas

```sql
-- Crear tabla con JSON
CREATE TABLE eventos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    datos JSON
);

INSERT INTO eventos (datos) VALUES
    ('{"tipo": "login", "usuario": "ana", "ip": "192.168.1.1"}'),
    ('{"tipo": "compra", "usuario": "juan", "productos": [{"id": 1, "cantidad": 2}]}');

-- JSON_TABLE: extraer datos JSON como filas (MySQL 8.0+)
SELECT e.id, jt.usuario, jt.tipo
FROM eventos e,
JSON_TABLE(e.datos, '$'
    COLUMNS (
        tipo VARCHAR(50) PATH '$.tipo',
        usuario VARCHAR(50) PATH '$.usuario'
    )
) AS jt;

-- Funciones JSON útiles
SELECT
    JSON_EXTRACT(datos, '$.usuario') AS usuario,          -- extraer
    datos->>'$.usuario' AS usuario_texto,                  -- extraer como texto
    JSON_KEYS(datos) AS claves,                            -- obtener llaves
    JSON_LENGTH(datos->'$.productos') AS num_productos,   -- contar elementos
    JSON_CONTAINS(datos, '"ana"', '$.usuario') AS es_ana, -- buscar valor
    JSON_PRETTY(datos) AS datos_bonitos                    -- formatear
FROM eventos;
```

### Invisible indexes (MySQL 8.0+)

```sql
-- Crear índice invisible: existe pero el optimizador no lo usa
CREATE INDEX idx_prueba ON productos (marca) INVISIBLE;

-- Hacerlo visible para probar si mejora
ALTER TABLE productos ALTER INDEX idx_prueba VISIBLE;

-- Si no mejora el rendimiento, eliminarlo
ALTER TABLE products ALTER INDEX idx_prueba INVISIBLE;
DROP INDEX idx_prueba ON productos;
```

### Generated columns

```sql
CREATE TABLE productos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100),
    precio DECIMAL(10,2),
    -- Columna virtual calculada
    precio_iva DECIMAL(10,2) AS (precio * 1.21) VIRTUAL,
    -- Columna almacenada (se guarda en disco)
    nombre_mayus VARCHAR(100) AS (UPPER(nombre)) STORED
);

-- Se puede indexar una columna generada
CREATE INDEX idx_nombre_mayus ON productos (nombre_mayus);

-- Insertar (no se incluye la columna generada)
INSERT INTO productos (nombre, precio) VALUES ('Mouse', 25.00);
-- precio_iva se calcula automáticamente: 30.25
```

### Lateral derived tables (MySQL 8.0.14+)

```sql
-- Para cada producto, obtener su última venta
SELECT p.nombre, lv.ultima_fecha, lv.cantidad
FROM productos p,
LATERAL (
    SELECT fecha AS ultima_fecha, cantidad
    FROM ventas
    WHERE producto_id = p.id
    ORDER BY fecha DESC
    LIMIT 1
) lv;
```

---

## 8. Docker

### Imagen oficial de MySQL

```bash
# MySQL 8.0
docker run --name mysql8 \
    -e MYSQL_ROOT_PASSWORD=root \
    -e MYSQL_DATABASE=tienda \
    -e MYSQL_USER=app \
    -e MYSQL_PASSWORD=apppass \
    -p 3306:3306 \
    -d mysql:8.0

# MySQL 8.4 LTS
docker run --name mysql-lts \
    -e MYSQL_ROOT_PASSWORD=root \
    -p 3306:3306 \
    -d mysql:8.4

# Con volumen persistente
docker run --name mysql8 \
    -e MYSQL_ROOT_PASSWORD=root \
    -v mysql_data:/var/lib/mysql \
    -p 3306:3306 \
    -d mysql:8.0

# Con archivo de configuración personalizado
docker run --name mysql8 \
    -e MYSQL_ROOT_PASSWORD=root \
    -v /path/my.cnf:/etc/mysql/conf.d/my.cnf \
    -p 3306:3306 \
    -d mysql:8.0
```

### Docker Compose

```yaml
# docker-compose.yml
version: '3.8'
services:
  mysql:
    image: mysql:8.0
    container_name: mysql-dev
    environment:
      MYSQL_ROOT_PASSWORD: root
      MYSQL_DATABASE: tienda
      MYSQL_USER: app
      MYSQL_PASSWORD: apppass
    ports:
      - "3306:3306"
    volumes:
      - mysql_data:/var/lib/mysql
      - ./init:/docker-entrypoint-initdb.d  # Ejecuta .sql al iniciar
    command:
      --character-set-server=utf8mb4
      --collation-server=utf8mb4_unicode_ci
      --innodb-buffer-pool-size=512M
      --max-connections=200
    restart: unless-stopped

  phpmyadmin:
    image: phpmyadmin
    ports:
      - "8080:80"
    environment:
      PMA_HOST: mysql
      PMA_PORT: 3306
    depends_on:
      - mysql

volumes:
  mysql_data:
```

```bash
# Levantar
docker compose up -d

# Conectar al cliente
docker exec -it mysql-dev mysql -uroot -proot tienda

# Ejecutar script SQL
docker exec -i mysql-dev mysql -uroot -proot tienda < schema.sql

# Ver logs
docker logs mysql-dev

# Backup desde el contenedor
docker exec mysql-dev mysqldump -uroot -proot tienda > backup.sql

# Restaurar al contenedor
docker exec -i mysql-dev mysql -uroot -proot tienda < backup.sql
```

---

## 9. Seguridad

### Mejores prácticas de seguridad

1. **No usar root para aplicaciones**: crea usuarios con privilegios mínimos.
2. **Usar contraseñas fuertes**: mínimo 12 caracteres, mix de tipos.
3. **Restringir hosts**: no uses `'%'` en producción, especifica IPs.
4. **Cifrar conexiones**: usa TLS/SSL.

```sql
-- Forzar TLS
CREATE USER 'app'@'192.168.1.%' IDENTIFIED BY 'pass' REQUIRE SSL;

-- Requerir un certificado específico
CREATE USER 'admin'@'10.0.0.%' IDENTIFIED BY 'pass'
    REQUIRE X509
    AND SUBJECT '/C=ES/ST=Madrid/O=MiEmpresa/CN=admin'
    AND ISSUER '/C=ES/ST=Madrid/O=MiEmpresa/CN=MiCA';
```

### Configuración de seguridad en my.cnf

```ini
[mysqld]
# No exponer MySQL a Internet si no es necesario
bind-address = 127.0.0.1  # solo localhost
# bind-address = 0.0.0.0   # todas las interfaces (usar con firewall)

# Desactivar LOAD DATA LOCAL INFILE (previene lectura de archivos del cliente)
local_infile = OFF

# Validar contraseñas (MySQL 8.0)
validate_password.policy = STRONG
validate_password.length = 12
validate_password.mixed_case_count = 1
validate_password.number_count = 1
validate_password.special_char_count = 1

# SQL mode estricto
sql_mode = STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION

# Esconder información del servidor
skip_show_database

# Limitar tamaño de paquetes
max_allowed_packet = 16M

# Desactivar símbolos del sistema innecesarios
# secure_file_priv limita LOAD DATA INFILE y LOAD_FILE()
secure_file_priv = /var/lib/mysql-files
```

### Auditoría

```sql
-- MySQL Enterprise Audit (comercial) o plugin de auditoría
INSTALL PLUGIN audit_log SONAME 'audit_log.so';

-- Ver configuración
SHOW VARIABLES LIKE 'audit_log%';
```

```ini
# my.cnf
[mysqld]
plugin_load_add = audit_log.so
audit_log_format = JSON
audit_log_policy = ALL  # ALL, LOGINS, QUERIES, NONE
```

### Hardening con mysql_secure_installation

```bash
sudo mysql_secure_installation
# Este script interactivo:
# 1. Establece contraseña de root
# 2. Elimina usuarios anónimos
# 3. Desactiva login remoto de root
# 4. Elimina la BD de test
# 5. Recarga privilegios
```

### Copia de seguridad de usuarios y privilegios

```bash
# Backup de usuarios y sus privilegios
pt-show-grants --user=root --password=pass > grants_backup.sql

# Restaurar
mysql -u root -p < grants_backup.sql
```

---

## 10. Mantenimiento rutinario

### Tareas diarias

```sql
-- Verificar estado de replicación
SHOW REPLICA STATUS\G

-- Verificar conexiones activas
SHOW STATUS LIKE 'Threads_connected';

-- Verificar errores
SHOW ERRORS;
SHOW ENGINE INNODB STATUS\G
```

### Tareas semanales

```sql
-- Analizar tablas (actualizar estadísticas del optimizador)
ANALYZE TABLE productos, ventas, clientes;

-- Optimizar tablas (desfragmentar)
OPTIMIZE TABLE productos;

-- Reparar tablas MyISAM (no necesario en InnoDB)
REPAIR TABLE tabla_myisam;

-- Verificar integridad
CHECK TABLE productos;
CHECK TABLE productos EXTENDED;

-- Eliminar tablas fragmentadas
SELECT
    TABLE_NAME,
    DATA_LENGTH,
    INDEX_LENGTH,
    DATA_FREE,
    ROUND(DATA_FREE / (DATA_LENGTH + INDEX_LENGTH) * 100, 2) AS fragmentacion_pct
FROM information_schema.TABLES
WHERE TABLE_SCHEMA = 'tienda'
  AND DATA_FREE > 0
ORDER BY DATA_FREE DESC;
```

### Tareas mensuales

```bash
# Backup completo
mysqldump -u root -p --single-transaction --routines --triggers --events \
    --all-databases > backup_mensual.sql

# Rotar binlogs
mysql -u root -p -e "FLUSH BINARY LOGS;"

# Limpiar binlogs antiguos
mysql -u root -p -e "PURGE BINARY LOGS BEFORE DATE(NOW() - INTERVAL 7 DAY);"

# Verificar espacio en disco
mysql -u root -p -e "SELECT table_schema, SUM(data_length+index_length)/1024/1024 AS mb FROM information_schema.tables GROUP BY table_schema;"
```

---

## Conceptos clave

| Concepto | Definición |
|---|---|
| **Privilegio** | Permiso concedido a un usuario para realizar una acción |
| **Rol** | Grupo de privilegios asignable a múltiples usuarios |
| **mysqldump** | Herramienta de backup lógico que genera scripts SQL |
| **Binlog** | Registro de todas las modificaciones (para replicación y PITR) |
| **Replicación** | Copia de datos de un servidor a otro en tiempo casi real |
| **GTID** | Global Transaction ID, identifica transacciones únicas para replicación robusta |
| **Group Replication** | Replicación multi-master con consenso automático |
| **Failover** | Cambio automático del servidor primario a uno secundario |
| **Docker** | Plataforma de contenedores para desplegar MySQL rápidamente |
| **Invisible index** | Índice que existe pero el optimizador no usa (para pruebas) |
| **Window function** | Función que opera sobre un conjunto de filas relacionado |

---

## Errores comunes

### 1. Usar root para aplicaciones

```sql
-- ❌ La app se conecta como root
GRANT ALL PRIVILEGES ON *.* TO 'app'@'%' IDENTIFIED BY 'root_pass';

-- ✅ Usuario con privilegios mínimos
CREATE USER 'app'@'10.0.0.%' IDENTIFIED BY 'app_pass';
GRANT SELECT, INSERT, UPDATE, DELETE ON tienda.* TO 'app'@'10.0.0.%';
```

### 2. Permitir conexiones desde cualquier host

```sql
-- ❌ Inseguro
CREATE USER 'app'@'%' IDENTIFIED BY 'pass';

-- ✅ Restringir por IP
CREATE USER 'app'@'10.0.0.%' IDENTIFIED BY 'pass';
```

### 3. No usar --single-transaction en backups

```bash
# ❌ Bloquea la tabla durante el backup
mysqldump -u root -p tienda > backup.sql

# ✅ Backup consistente sin bloquear (InnoDB)
mysqldump -u root -p --single-transaction tienda > backup.sql
```

### 4. No verificar replicación

`Seconds_Behind_Master` debe ser cercano a 0. Si crece, el slave no puede
procesar los cambios a tiempo y los datos están desactualizados.

### 5. No probar los backups

Un backup que no se ha restaurado en un entorno de prueba es un backup que
no se sabe si funciona. Restaurar regularmente para verificar.

### 6. No configurar expire_logs_days

```ini
# Sin esto, los binlogs crecen indefinidamente y llenan el disco
expire_logs_days = 7
# o en MySQL 8.4+
binlog_expire_logs_seconds = 604800  # 7 días
```

### 7. Usar el query cache

El query cache fue eliminado en MySQL 8.0. No lo uses ni lo eches de menos.
Para caché de aplicaciones, usa Redis.

---

## Resumen del curso MySQL

Has completado las 5 guías de MySQL:

1. **Fundamentos**: instalación, tipos de datos, motores
2. **Consultas y funciones**: SELECT, JOINs, subconsultas, funciones
3. **Avanzado**: índices, vistas, procedures, triggers, transacciones
4. **Optimización**: EXPLAIN, tuning, particionamiento, performance schema
5. **Administración**: usuarios, backups, replicación, Docker, seguridad

Ahora practica con los [30 ejercicios](ejercicios/README.md) y el
[proyecto final](ejercicios/proyectos/README.md) de sistema de inventario y ventas.
