# 01 — Fundamentos de PostgreSQL

## Objetivos

- [ ] Entender qué es PostgreSQL y sus características
- [ ] Instalar y configurar PostgreSQL
- [ ] Conectar a PostgreSQL usando psql
- [ ] Crear y gestionar bases de datos
- [ ] Crear tablas con diferentes tipos de datos
- [ ] Usar comandos básicos de DDL y DML
- [ ] Entender el sistema de esquemas
- [ ] Conocer las herramientas de administración

## Apuntes

### ¿Qué es PostgreSQL?

PostgreSQL es un sistema de gestión de bases de datos relacionales (RDBMS) de código abierto, considerado uno de los más avanzados del mundo.

**Características principales:**
- **ACID**: Transacciones atómicas, consistentes, aisladas y duraderas
- **Extensible**: Permite definir tipos de datos, operadores, funciones
- **Multi-versión**: MVCC (Multi-Version Concurrency Control)
- **JSON**: Soporte nativo con JSON y JSONB
- **Full-Text Search**: Búsqueda de texto completo
- **Espacial**: PostGIS para datos geográficos
- **Replicación**: Streaming replication y logical replication

### Instalación

```bash
# Ubuntu/Debian
sudo apt update
sudo apt install postgresql postgresql-contrib

# macOS con Homebrew
brew install postgresql

# Verificar instalación
psql --version

# Iniciar servicio (Linux)
sudo systemctl start postgresql

# Iniciar servicio (macOS)
brew services start postgresql
```

### Conexión con psql

```bash
sudo -u postgres psql
psql -d nombre_bd -U usuario
psql -h localhost -p 5432 -U usuario -d nombre_bd

# Comandos útiles en psql
\?           # Ayuda
\l           # Listar bases de datos
\c nombre    # Conectar a base de datos
\dt          # Listar tablas
\d tabla     # Describir tabla
\du          # Listar usuarios
\q           # Salir
```

### Estructura de PostgreSQL

```
PostgreSQL Cluster
    └── Bases de Datos (Databases)
         └── Esquemas (Schemas)
              └── Tablas (Tables)
                   └── Columnas + Índices + Constraints
```

### Tipos de datos principales

#### Numéricos
| Tipo | Tamaño | Rango |
|------|--------|-------|
| `SMALLINT` | 2 bytes | -32768 a 32767 |
| `INTEGER` | 4 bytes | -2.1e9 a 2.1e9 |
| `BIGINT` | 8 bytes | -9e18 a 9e18 |
| `NUMERIC(p,s)` | Variable | Hasta 131072 dígitos |
| `REAL` | 4 bytes | 6 dígitos decimales |
| `DOUBLE PRECISION` | 8 bytes | 15 dígitos decimales |
| `SERIAL` | 4 bytes | Auto-increment |
| `BIGSERIAL` | 8 bytes | Auto-increment grande |

#### Texto
| Tipo | Descripción |
|------|-------------|
| `VARCHAR(n)` | Variable con límite |
| `CHAR(n)` | Fijo, rellena con espacios |
| `TEXT` | Ilimitado |
| `JSON` | JSON como texto |
| `JSONB` | JSON binario (indexable) |

#### Fechas/Horas
`DATE`, `TIME`, `TIMESTAMP`, `TIMESTAMPTZ`, `INTERVAL`

#### Otros
`BOOLEAN`, `UUID`, `ARRAY` (p.ej. `INTEGER[]`), `TSVECTOR`, `TSQUERY`

### Comandos DDL básicos

```sql
CREATE DATABASE mi_bd;
CREATE DATABASE mi_bd ENCODING 'UTF8';

CREATE TABLE clientes (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    telefono VARCHAR(20),
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    activo BOOLEAN DEFAULT TRUE
);

CREATE TABLE productos (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    precio DECIMAL(10,2) NOT NULL CHECK (precio >= 0),
    stock INT NOT NULL DEFAULT 0 CHECK (stock >= 0),
    categoria_id INT
);

ALTER TABLE clientes ADD COLUMN ciudad VARCHAR(50);
ALTER TABLE clientes DROP COLUMN telefono;
ALTER TABLE clientes RENAME COLUMN ciudad TO localidad;

DROP TABLE clientes;
DROP TABLE clientes CASCADE;

CREATE SCHEMA tienda;
SET search_path TO tienda, public;
```

### Comandos DML básicos

```sql
INSERT INTO clientes (nombre, email, telefono)
VALUES ('Ana Pérez', 'ana@email.com', '123456789');

INSERT INTO clientes (nombre, email, telefono)
VALUES
    ('María López', 'maria@email.com', '987654321'),
    ('Carlos Ruiz', 'carlos@email.com', '456789123');

SELECT * FROM clientes;
SELECT nombre AS cliente, email FROM clientes;

SELECT * FROM clientes WHERE nombre ILIKE '%ana%'; -- case insensitive
SELECT * FROM clientes WHERE activo = TRUE;

UPDATE clientes SET telefono = '111222333' WHERE id = 1;

DELETE FROM clientes WHERE id = 1;
TRUNCATE TABLE clientes; -- más rápido que DELETE de todas las filas
```

### Esquemas

```sql
CREATE SCHEMA ventas AUTHORIZATION admin;

CREATE TABLE ventas.pedidos (
    id SERIAL PRIMARY KEY,
    cliente_id INT,
    total DECIMAL(10,2)
);

SHOW search_path;
SET search_path TO ventas, public;

DROP SCHEMA ventas CASCADE;
```

### Secuencias

```sql
CREATE SEQUENCE pedidos_numero_seq
    START 1000
    INCREMENT 1
    MINVALUE 1000
    MAXVALUE 9999
    CYCLE;

CREATE TABLE pedidos (
    id SERIAL PRIMARY KEY,
    numero INT DEFAULT nextval('pedidos_numero_seq'),
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

SELECT * FROM information_schema.sequences;
```

### Roles y permisos

```sql
CREATE ROLE administrador LOGIN PASSWORD 'admin123';
CREATE USER app_user WITH PASSWORD 'app123';

GRANT CONNECT ON DATABASE mi_bd TO app_user;
GRANT SELECT, INSERT, UPDATE ON TABLE clientes TO app_user;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO administrador;

ALTER DEFAULT PRIVILEGES IN SCHEMA public
GRANT SELECT ON TABLES TO lector;

REVOKE DELETE ON TABLE clientes FROM app_user;

CREATE ROLE equipo_ventas;
GRANT equipo_ventas TO app_user, lector;
```

> Nota: usa contraseñas de ejemplo únicamente en local. En cualquier entorno
> real, genera credenciales seguras y no las dejes en texto plano en el
> repositorio.

## Errores comunes

| Error | Causa | Solución |
|-------|-------|----------|
| `ERROR: relation "x" does not exist` | Tabla no existe | Crear tabla o verificar nombre |
| `ERROR: duplicate key value violates unique constraint` | Violación de UNIQUE | Verificar que el valor sea único |
| `ERROR: null value in column "x" violates not-null constraint` | NOT NULL violado | Proporcionar valor para la columna |
| `ERROR: insert or update on table "x" violates foreign key constraint` | FOREIGN KEY violada | Asegurar que existe en tabla padre |
| `ERROR: permission denied` | Sin permisos | Conceder permisos con GRANT |
| `FATAL: database "x" does not exist` | Base de datos no existe | Crear la base de datos primero |

## Ejercicios relacionados

- [Ejercicio 01: Connect y Create DB](./ejercicios/nivel-01-fundamentos/ejercicio-01-connect-create-db/)
- [Ejercicio 02: Create Table](./ejercicios/nivel-01-fundamentos/ejercicio-02-create-table/)
- [Ejercicio 03: INSERT](./ejercicios/nivel-01-fundamentos/ejercicio-03-insert/)
- [Ejercicio 04: SELECT Básico](./ejercicios/nivel-01-fundamentos/ejercicio-04-select-basico/)
- [Ejercicio 05: WHERE y ORDER](./ejercicios/nivel-01-fundamentos/ejercicio-05-where-y-order/)
- [Ejercicio 06: UPDATE y DELETE](./ejercicios/nivel-01-fundamentos/ejercicio-06-update-delete/)

## Recursos

- [Documentación oficial de PostgreSQL](https://www.postgresql.org/docs/)
- [PostgreSQL Tutorial](https://www.postgresqltutorial.com/)
- [PgAdmin](https://www.pgadmin.org/)
- [PostGIS](https://postgis.net/)
