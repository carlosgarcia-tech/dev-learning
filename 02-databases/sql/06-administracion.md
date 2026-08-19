# 06 — Administración de Bases de Datos

> **Nota:** esta guía se añadió para completar el índice del curso (el archivo aparecía listado en la estructura del proyecto pero no tenía contenido en el material original).

## Objetivos

- [ ] Gestionar usuarios y roles
- [ ] Aplicar permisos (GRANT / REVOKE)
- [ ] Realizar copias de seguridad y restauración
- [ ] Entender replicación básica
- [ ] Monitorizar rendimiento
- [ ] Aplicar buenas prácticas de seguridad

## Apuntes

### Usuarios y Roles

```sql
-- Crear un rol/usuario (PostgreSQL)
CREATE ROLE app_readonly LOGIN PASSWORD 'contraseña_segura';

-- Crear usuario con permisos de conexión a una base
CREATE USER app_user WITH PASSWORD 'contraseña_segura';
GRANT CONNECT ON DATABASE tienda TO app_user;

-- Cambiar contraseña
ALTER USER app_user WITH PASSWORD 'nueva_contraseña';

-- Eliminar usuario
DROP USER app_user;
```

### Permisos (GRANT / REVOKE)

```sql
-- Dar permisos de lectura sobre una tabla
GRANT SELECT ON productos TO app_readonly;

-- Dar permisos completos sobre un esquema
GRANT ALL PRIVILEGES ON SCHEMA public TO app_user;

-- Dar permisos específicos
GRANT SELECT, INSERT, UPDATE ON pedidos TO app_user;

-- Revocar permisos
REVOKE INSERT, UPDATE ON pedidos FROM app_user;

-- Ver permisos de una tabla (PostgreSQL)
SELECT grantee, privilege_type
FROM information_schema.role_table_grants
WHERE table_name = 'pedidos';
```

### Copias de Seguridad y Restauración

```bash
# Backup completo de una base de datos (PostgreSQL)
pg_dump -U usuario -d tienda -F c -f tienda_backup.dump

# Backup solo de esquema (sin datos)
pg_dump -U usuario -d tienda --schema-only -f esquema.sql

# Backup solo de datos
pg_dump -U usuario -d tienda --data-only -f datos.sql

# Restaurar backup
pg_restore -U usuario -d tienda tienda_backup.dump

# Backup con mysqldump (MySQL)
mysqldump -u usuario -p tienda > tienda_backup.sql

# Restaurar en MySQL
mysql -u usuario -p tienda < tienda_backup.sql
```

### Replicación (conceptos básicos)

```
Servidor Primario (escritura)
        │
        ▼  (replica los cambios)
Servidor Réplica (solo lectura)
```

- **Replicación física**: copia byte a byte del WAL (PostgreSQL) o binlog (MySQL).
- **Replicación lógica**: replica sentencias o cambios de fila específicos, permite replicar subconjuntos de tablas.
- Se usa para: alta disponibilidad, balanceo de lecturas, y como base de datos de respaldo (failover).

### Monitorización de Rendimiento

```sql
-- Consultas activas (PostgreSQL)
SELECT pid, query, state, query_start
FROM pg_stat_activity
WHERE state != 'idle';

-- Tamaño de las tablas
SELECT
    relname AS tabla,
    pg_size_pretty(pg_total_relation_size(relid)) AS tamaño
FROM pg_catalog.pg_statio_user_tables
ORDER BY pg_total_relation_size(relid) DESC;

-- Estadísticas de uso de índices
SELECT relname, indexrelname, idx_scan
FROM pg_stat_user_indexes
ORDER BY idx_scan ASC;

-- Consultas más lentas (requiere extensión pg_stat_statements)
SELECT query, calls, total_exec_time, mean_exec_time
FROM pg_stat_statements
ORDER BY mean_exec_time DESC
LIMIT 10;
```

### Buenas Prácticas de Seguridad

- Aplicar el **principio de mínimo privilegio**: cada usuario/rol solo con los permisos que necesita.
- Nunca usar el superusuario (`postgres`, `root`) para las conexiones de la aplicación.
- Usar contraseñas fuertes y rotarlas periódicamente; preferir autenticación por certificados o IAM cuando sea posible.
- Cifrar las conexiones (SSL/TLS) y los datos sensibles en reposo.
- Realizar backups periódicos y **probar la restauración** regularmente.
- Registrar (`log`) y auditar accesos y cambios críticos.
- Mantener el motor de base de datos actualizado con los parches de seguridad.

## Ejemplos de Código

```sql
-- Configuración típica de un usuario de aplicación de solo lectura
CREATE ROLE reportes LOGIN PASSWORD 'contraseña_segura';
GRANT CONNECT ON DATABASE tienda TO reportes;
GRANT USAGE ON SCHEMA public TO reportes;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO reportes;

-- Asegurar que las tablas futuras también tengan el permiso
ALTER DEFAULT PRIVILEGES IN SCHEMA public
GRANT SELECT ON TABLES TO reportes;
```

## Errores Comunes

| Error | Causa | Solución |
|-------|-------|----------|
| `permission denied for table` | Falta de GRANT sobre la tabla | Otorgar el permiso adecuado con `GRANT` |
| `role does not exist` | Usuario/rol no creado | Crear el rol con `CREATE ROLE` |
| `pg_dump: connection refused` | Servidor no accesible o credenciales incorrectas | Verificar host, puerto y credenciales |
| `too many connections` | Límite de conexiones alcanzado | Usar un *connection pooler* (p. ej. PgBouncer) |

## Ejercicios Relacionados

- [Ejercicio 19: Constraints](./ejercicios/nivel-04-avanzado/ejercicio-01-constraints/)
- [Ejercicio 20: Índices](./ejercicios/nivel-04-avanzado/ejercicio-02-indexes/)
- [Ejercicio 21: Transacciones](./ejercicios/nivel-04-avanzado/ejercicio-03-transacciones/)
- [Ejercicio 29: Concurrencia](./ejercicios/nivel-05-experto/ejercicio-05-concurrencia/)
