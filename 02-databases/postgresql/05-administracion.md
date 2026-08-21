# 05 — Administración de PostgreSQL

## Objetivos

- [ ] Configurar postgresql.conf
- [ ] Gestionar usuarios y permisos
- [ ] Realizar backups
- [ ] Optimizar rendimiento
- [ ] Monitorear el servidor

## Apuntes

### Configuración del servidor

```bash
/etc/postgresql/14/main/postgresql.conf
/etc/postgresql/14/main/pg_hba.conf
```

```conf
listen_addresses = '*'
port = 5432
max_connections = 100
shared_buffers = 256MB
work_mem = 64MB
maintenance_work_mem = 128MB
effective_cache_size = 1GB

logging_collector = on
log_directory = 'log'
log_filename = 'postgresql-%Y-%m-%d_%H%M%S.log'
log_rotation_age = 1d
log_rotation_size = 10MB

wal_level = replica
checkpoint_timeout = 15min
```

### pg_hba.conf — Autenticación

```
# tipo    base_datos  usuario  dirección          método
local     all         all                         scram-sha-256
host      all         all      127.0.0.1/32        scram-sha-256
host      all         all      192.168.1.0/24       scram-sha-256
hostssl   all         all      0.0.0.0/0             scram-sha-256
```

> Evita `trust` salvo en tu máquina local de desarrollo: con `trust`
> cualquiera con acceso de red a ese rango entra sin contraseña.
> `scram-sha-256` es el método recomendado hoy en día (mejor que `md5`).

### Usuarios y permisos

```sql
CREATE USER app_user WITH PASSWORD 'secure_password';
CREATE ROLE administradores;

GRANT CONNECT ON DATABASE mi_bd TO app_user;
GRANT USAGE ON SCHEMA public TO app_user;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO app_user;
GRANT SELECT, INSERT, UPDATE ON TABLE pedidos TO app_user;
GRANT USAGE ON ALL SEQUENCES IN SCHEMA public TO app_user;

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public
    GRANT SELECT ON TABLES TO lector;

REVOKE DELETE ON TABLE pedidos FROM app_user;

\du+
\dp
```

### Backup y restore

```bash
# pg_dump - backup lógico (texto plano)
pg_dump -U postgres -h localhost -p 5432 mi_bd > backup.sql

# Formato custom (recomendado: permite pg_restore selectivo/paralelo)
pg_dump -U postgres -Fc mi_bd > backup.dump

pg_dump -U postgres -s mi_bd > esquema.sql   # solo esquema
pg_dump -U postgres -a mi_bd > datos.sql     # solo datos
pg_dump -U postgres -t productos mi_bd > productos.sql

psql -U postgres mi_bd < backup.sql
pg_restore -U postgres -d mi_bd backup.dump

pg_dump -U postgres mi_bd | gzip > backup.sql.gz
gunzip -c backup.sql.gz | psql -U postgres mi_bd

# pg_basebackup - backup físico (requiere streaming replication configurada)
pg_basebackup -U replicator -D /backup/base -Ft -P
```

### Monitoreo

```sql
SELECT pid, usename, application_name, client_addr, state, query,
       age(now(), query_start) AS duracion
FROM pg_stat_activity
WHERE state = 'active';

SELECT pg_database_size(datname) AS size, datname
FROM pg_database
ORDER BY size DESC;

SELECT schemaname, tablename,
       pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) AS total_size
FROM pg_tables
ORDER BY pg_total_relation_size(schemaname||'.'||tablename) DESC
LIMIT 20;

SELECT schemaname, relname AS tabla, seq_scan, seq_tup_read, idx_scan,
       n_live_tup, n_dead_tup
FROM pg_stat_user_tables
ORDER BY seq_scan DESC;
```

> Ojo: a diferencia de `pg_tables`/`pg_indexes` (que usan `tablename`/
> `indexname`), las vistas de estadísticas `pg_stat_user_tables` y
> `pg_stat_user_indexes` usan `relname`/`indexrelname`. Es un error común
> mezclar los nombres de columna entre ambas familias de vistas.

### VACUUM y mantenimiento

```sql
VACUUM table_name;
ANALYZE table_name;
VACUUM FULL table_name;   -- reorganiza pero bloquea la tabla
REINDEX TABLE table_name;

-- postgresql.conf
autovacuum = on
autovacuum_naptime = 1min
autovacuum_vacuum_scale_factor = 0.2
autovacuum_analyze_scale_factor = 0.1

SELECT schemaname, relname AS tabla, last_autovacuum, last_autoanalyze
FROM pg_stat_all_tables
WHERE last_autovacuum IS NOT NULL OR last_autoanalyze IS NOT NULL;
```

### Extensiones

```sql
SELECT * FROM pg_available_extensions;

CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE EXTENSION IF NOT EXISTS postgis;
CREATE EXTENSION IF NOT EXISTS pg_trgm;
CREATE EXTENSION IF NOT EXISTS pg_stat_statements;

\dx
```

> Nota: los identificadores de extensión con guiones (como `uuid-ossp`)
> deben ir entre comillas dobles: `CREATE EXTENSION IF NOT EXISTS "uuid-ossp";`.
> Sin comillas, `uuid-ossp` se interpreta como una resta (`uuid` MENOS `ossp`)
> y da un error de sintaxis.

## Ejercicios relacionados

- [Ejercicio 23: Backups](./ejercicios/nivel-04-avanzado/ejercicio-05-backups/)
- [Ejercicio 24: Roles y Permisos](./ejercicios/nivel-04-avanzado/ejercicio-06-roles-y-permisos/)
- [Ejercicio 30: Performance Tuning](./ejercicios/nivel-05-experto/ejercicio-06-performance-tuning/)
