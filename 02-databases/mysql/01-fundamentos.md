# Guía 01 — Fundamentos de MySQL

## Objetivos

- [ ] Entender qué es MySQL y cómo se diferencia de MariaDB
- [ ] Instalar MySQL y usar el cliente `mysql`
- [ ] Crear bases de datos y tablas con los tipos de datos correctos
- [ ] Usar `AUTO_INCREMENT`, `CHARACTER SET` y `COLLATION`
- [ ] Distinguir entre los motores InnoDB y MyISAM
- [ ] Usar `SHOW` y `DESCRIBE` para inspeccionar la base de datos

---

## 1. ¿Qué es MySQL?

MySQL es un sistema de gestión de bases de datos relacionales (RDBMS) open source,
desarrollado originalmente por la empresa sueca MySQL AB en 1995. Actualmente es
propiedad de Oracle Corporation (desde 2008). Es el RDBMS más utilizado del mundo
en aplicaciones web y la "M" del stack LAMP (Linux, Apache, MySQL, PHP).

### Características principales

- **Relacional**: datos organizados en tablas con filas y columnas.
- **Cliente-servidor**: el servidor `mysqld` escucha conexiones; los clientes se conectan vía TCP/IP.
- **Multi-motor**: soporta varios motores de almacenamiento (InnoDB, MyISAM, Memory, etc.).
- **ACID**: con InnoDB, garantiza Atomicidad, Consistencia, Isolation y Durabilidad.
- **Multiplataforma**: Linux, Windows, macOS.
- **Replicación**: master-slave y master-master.
- **Escalabilidad**: soporta bases de datos de terabytes.

### Versiones importantes

| Versión | Año | Cambios clave |
|---|---|---|
| 5.6 | 2013 | Optimizador mejorado, replicación GTID |
| 5.7 | 2015 | JSON nativo, generated columns |
| **8.0** | 2018 | CTE, window functions, roles, data dictionary |
| 8.4 LTS | 2024 | Versión de soporte extendido |

---

## 2. MariaDB vs MySQL

MariaDB es un fork de MySQL creado por el desarrollador original de MySQL,
Michael "Monty" Widenius, en 2009, tras la adquisición de MySQL por Oracle.

| Aspecto | MySQL | MariaDB |
|---|---|---|
| Desarrollador | Oracle | MariaDB Foundation / Corporation |
| Licencia | GPL (con licencia comercial dual) | GPL |
| Compatibilidad | Estándar | Alta compatibilidad binaria con MySQL |
| Motores extra | — | Aria, ColumnStore, Spider, Connect |
| Funciones | JSON nativo (5.7+), CTE, window functions (8.0+) | Secuencia, SYSTEM_VERSIONING, RETURNING |
| Velocidad | Optimizado por Oracle | Parches de rendimiento propios |
| Default en | — | Ubuntu, Debian, CentOS, Fedora |

> En Fedora y muchas distribuciones Linux, MariaDB viene instalado por defecto en
> lugar de MySQL. El cliente `mysql` funciona con ambos servidores. Los comandos
> y la sintaxis SQL son compatibles en un 95% de los casos.

### Cuándo elegir cada uno

- **MySQL**: si necesitas compatibilidad con productos de Oracle, soporte oficial
  de Oracle, o usas MySQL Enterprise.
- **MariaDB**: si prefieres licencia 100% GPL, features extra (sequences,
  system-versioned tables), o vienes de una distro que ya lo incluye.

---

## 3. Instalación

### Linux (Fedora/RHEL)

```bash
# MySQL Community Server
sudo dnf install mysql-server
sudo systemctl start mysqld
sudo systemctl enable mysqld

# Obtener contraseña temporal de root (solo primera vez)
sudo grep 'temporary password' /var/log/mysqld.log

# Configuración de seguridad
sudo mysql_secure_installation
```

### Linux (Ubuntu/Debian) — MariaDB

```bash
sudo apt install mariadb-server
sudo systemctl start mariadb
sudo mysql_secure_installation
```

### macOS (Homebrew)

```bash
brew install mysql
brew services start mysql
```

### Docker (la forma más rápida)

```bash
docker run --name mysql-dev -e MYSQL_ROOT_PASSWORD=root \
  -p 3306:3306 -d mysql:8.0

# Conectar
docker exec -it mysql-dev mysql -uroot -proot
```

---

## 4. El cliente `mysql`

El cliente `mysql` es la herramienta de línea de comandos para interactuar con
el servidor.

```bash
# Conectar como root
mysql -u root -p

# Conectar a una BD específica
mysql -u root -p mi_base_datos

# Ejecutar un archivo SQL
mysql -u root -p mi_base_datos < script.sql

# Ejecutar un comando directo
mysql -u root -p -e "SHOW DATABASES;"

# Formato de salida en lote (tab-separated, sin bordes)
mysql -u root -p --batch -e "SELECT * FROM usuarios;"

# Formato tabla con bordes
mysql -u root -p --table -e "SELECT * FROM usuarios;"
```

### Dentro del cliente

```sql
-- Ver bases de datos
SHOW DATABASES;

-- Usar una base de datos
USE mi_base_datos;

-- Ver tablas
SHOW TABLES;

-- Estado del servidor
STATUS;

-- Salir
exit;
```

---

## 5. CREATE DATABASE

```sql
-- Crear base de datos básica
CREATE DATABASE tienda;

-- Crear con charset y collation específicos
CREATE DATABASE tienda
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

-- Crear solo si no existe
CREATE DATABASE IF NOT EXISTS tienda;

-- Eliminar base de datos
DROP DATABASE IF EXISTS tienda;

-- Modificar charset de la BD
ALTER DATABASE tienda CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

### Convenciones de nombres

- Bases de datos y tablas: minúsculas, sin espacios, `_` como separador.
- En Linux los nombres de bases de datos son sensibles a mayúsculas.
- En Windows/macOS (HFS+) no lo son. Usa siempre minúsculas para portabilidad.

---

## 6. CREATE TABLE y tipos de datos

### Sintaxis completa

```sql
CREATE TABLE [IF NOT EXISTS] nombre_tabla (
    columna1 tipo_datos [restricciones],
    columna2 tipo_datos [restricciones],
    ...
    [restricciones de tabla]
) [ENGINE=motor] [CHARACTER SET charset] [COLLATE collation];
```

### Ejemplo

```sql
CREATE TABLE productos (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    precio DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    stock INT NOT NULL DEFAULT 0,
    categoria ENUM('electronica', 'ropa', 'hogar', 'otros') DEFAULT 'otros',
    etiquetas SET('nuevo', 'oferta', 'destacado', 'limitado'),
    creado_en DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    actualizado_en TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    metadatos JSON,
    imagen BLOB,
    PRIMARY KEY (id),
    UNIQUE KEY uk_nombre (nombre),
    INDEX idx_categoria (categoria)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

---

## 7. Tipos de datos de MySQL

### Numéricos

| Tipo | Rango | Uso |
|---|---|---|
| `TINYINT` | -128 a 127 (o 0-255 con UNSIGNED) | Booleanos, estados pequeños |
| `SMALLINT` | -32768 a 32767 | IDs pequeños, cantidades |
| `MEDIUMINT` | -8388608 a 8388607 | Contadores medianos |
| `INT` / `INTEGER` | -2^31 a 2^31-1 | El más común para IDs |
| `BIGINT` | -2^63 a 2^63-1 | IDs muy grandes, timestamps |
| `DECIMAL(M,D)` | M dígitos totales, D decimales | Dinero, precisión exacta |
| `FLOAT` | Precisión simple (4 bytes) | Científico, aproximado |
| `DOUBLE` | Precisión doble (8 bytes) | Científico, aproximado |
| `BIT(M)` | M bits (1-64) | Bandera binaria |

```sql
CREATE TABLE ejemplo_numericos (
    edad TINYINT UNSIGNED,              -- 0 a 255
    id_usuario INT UNSIGNED NOT NULL,   -- solo positivos
    precio DECIMAL(10,2),               -- 99999999.99
    peso FLOAT,
    activo BIT(1)
);
```

> **Regla de oro**: para dinero usa SIEMPRE `DECIMAL`, nunca `FLOAT` o `DOUBLE`.
> `FLOAT` pierde precisión con números como 0.1 + 0.2.

### Texto

| Tipo | Tamaño | Uso |
|---|---|---|
| `CHAR(M)` | Exactamente M caracteres (1-255) | Códigos fijos (MD5=CHAR(32)) |
| `VARCHAR(M)` | Variable hasta M caracteres (1-65535) | Texto corto, el más común |
| `TINYTEXT` | Hasta 255 bytes | Texto corto |
| `TEXT` | Hasta 65,535 bytes (~64KB) | Artículos, descripciones |
| `MEDIUMTEXT` | Hasta 16MB | Documentos largos |
| `LONGTEXT` | Hasta 4GB | Texto masivo |

```sql
CREATE TABLE ejemplo_texto (
    codigo CHAR(5),              -- siempre 5 caracteres, fijo
    nombre VARCHAR(100),         -- hasta 100, variable
    descripcion TEXT,            -- hasta 64KB
    contenido LONGTEXT           -- hasta 4GB
);
```

> `CHAR` rellena con espacios y los quita al leer. `VARCHAR` almacena solo lo
> necesario + 1-2 bytes de longitud. Usa `CHAR` para datos de longitud fija
> (códigos, hashes) y `VARCHAR` para todo lo demás.

### Fecha y hora

| Tipo | Formato | Rango |
|---|---|---|
| `DATE` | `YYYY-MM-DD` | 1000-01-01 a 9999-12-31 |
| `TIME` | `HH:MM:SS` | -838:59:59 a 838:59:59 |
| `DATETIME` | `YYYY-MM-DD HH:MM:SS` | 1000-01-01 a 9999-12-31 |
| `TIMESTAMP` | `YYYY-MM-DD HH:MM:SS` | 1970-01-01 a 2038-01-19 |
| `YEAR` | `YYYY` | 1901 a 2155 |

```sql
CREATE TABLE ejemplo_fechas (
    fecha_nacimiento DATE,
    hora_apertura TIME,
    creado_en DATETIME DEFAULT CURRENT_TIMESTAMP,
    actualizado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    anio YEAR
);
```

> **TIMESTAMP vs DATETIME**: `TIMESTAMP` se convierte a UTC al almacenar y de
> vuelta a la zona horaria del cliente al leer. `DATETIME` se almacena tal cual.
> `TIMESTAMP` tiene el problema del año 2038 (overflow). Para fechas futuras
> lejanas, usa `DATETIME`.

### ENUM y SET

```sql
-- ENUM: exactamente un valor de la lista
CREATE TABLE pedidos (
    estado ENUM('pendiente', 'procesando', 'enviado', 'entregado', 'cancelado')
        DEFAULT 'pendiente'
);

-- SET: cero o más valores de la lista (combinaciones)
CREATE TABLE articulos (
    etiquetas SET('nuevo', 'oferta', 'destacado', 'limitado')
);

INSERT INTO articulos (etiquetas) VALUES
    ('nuevo,oferta'),           -- dos valores
    ('destacado'),               -- un valor
    ('nuevo,destacado,limitado'); -- tres valores
```

| Tipo | Valores por fila | Almacenamiento |
|---|---|---|
| `ENUM` | Exactamente uno | 1-2 bytes |
| `SET` | Cero o varios | 1-8 bytes |

> `ENUM` y `SET` no son escalables: cambiar la lista requiere `ALTER TABLE`.
> Para listas que cambian con frecuencia, usa una tabla de lookup.

### JSON (MySQL 5.7+)

```sql
CREATE TABLE usuarios (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100),
    preferencias JSON
);

INSERT INTO usuarios (nombre, preferencias) VALUES
    ('Ana', '{"tema": "oscuro", "notificaciones": true, "idioma": "es"}');

-- Consultar campos del JSON
SELECT nombre, preferencias->>"$.tema" AS tema
FROM usuarios;

-- Modificar campo del JSON
UPDATE usuarios
SET preferencias = JSON_SET(preferencias, "$.tema", "claro")
WHERE nombre = 'Ana';
```

> `JSON` valida que el contenido sea JSON válido. `JSONB` (de PostgreSQL) no
> existe en MySQL, pero MySQL almacena el JSON en formato binario interno.

### BLOB

| Tipo | Tamaño máximo |
|---|---|
| `TINYBLOB` | 255 bytes |
| `BLOB` | 65KB |
| `MEDIUMBLOB` | 16MB |
| `LONGBLOB` | 4GB |

```sql
CREATE TABLE archivos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(255),
    tipo_mime VARCHAR(100),
    contenido LONGBLOB
);
```

> Para archivos grandes, considera almacenar el archivo en disco o en un
> object store (S3) y guardar solo la ruta en la base de datos.

---

## 8. AUTO_INCREMENT

`AUTO_INCREMENT` genera valores automáticos secuenciales para columnas
numéricas. Solo una columna por tabla puede tenerlo y debe ser parte de una
clave (PRIMARY KEY o UNIQUE).

```sql
CREATE TABLE clientes (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    PRIMARY KEY (id)
);

INSERT INTO clientes (nombre) VALUES ('Ana'), ('Juan'), ('Maria');
-- id = 1, 2, 3 automáticamente

-- Ver el último ID insertado en la sesión actual
SELECT LAST_INSERT_ID();

-- Configurar el valor inicial
ALTER TABLE clientes AUTO_INCREMENT = 1000;

-- Obtener info del AUTO_INCREMENT
SHOW TABLE STATUS LIKE 'clientes';
```

### Con `INSERT ... ON DUPLICATE KEY UPDATE`

```sql
INSERT INTO clientes (id, nombre) VALUES (1, 'Ana')
ON DUPLICATE KEY UPDATE nombre = VALUES(nombre);
```

> Los IDs generados por `AUTO_INCREMENT` no se reutilizan: si borras la fila con
> id=3, el siguiente INSERT no será 3 sino 4. Los huecos son normales y no son
> un problema.

---

## 9. CHARACTER SET y COLLATION

### Conceptos

- **CHARACTER SET (charset)**: el conjunto de símbolos que se pueden almacenar.
  Define la codificación de los caracteres.
- **COLLATION**: las reglas de comparación y ordenación de esos caracteres.

###Charsets importantes

| Charset | Bytes por char | Soporte |
|---|---|---|
| `utf8` | 1-3 bytes | Solo BMP (hasta 3 bytes). **¡No soporta emoji!** |
| `utf8mb4` | 1-4 bytes | Unicode completo, incluidos emoji. **Recomendado** |
| `latin1` | 1 byte | Europa occidental, ISO-8859-1 |

> **Siempre usa `utf8mb4`** en lugar de `utf8`. El `utf8` de MySQL (alias de
> `utf8mb3`) solo soporta 3 bytes y no puede almacenar emoji ni caracteres
> complementarios. `utf8mb4` es el estándar en MySQL 8.0+.

### Collations comunes de utf8mb4

| Collation | Comportamiento |
|---|---|
| `utf8mb4_general_ci` | Rápido, comparaciones simples sin acentos |
| `utf8mb4_unicode_ci` | Basado en estándar Unicode (correcto) |
| `utf8mb4_0900_ai_ci` | MySQL 8.0+, estándar Unicode 9.0, recomendado |
| `utf8mb4_bin` | Binario, sensible a mayúsculas y acentos |

> `_ci` = case insensitive (no distingue mayúsculas/minúsculas).
> `_cs` = case sensitive. `_bin` = binario (sensible a todo).

### Niveles de configuración

```sql
-- A nivel de servidor (my.cnf)
-- [mysqld]
-- character-set-server = utf8mb4
-- collation-server = utf8mb4_unicode_ci

-- A nivel de base de datos
CREATE DATABASE mi_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- A nivel de tabla
CREATE TABLE productos (
    ...
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- A nivel de columna
CREATE TABLE ejemplo (
    nombre VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin
);

-- Ver charset del servidor
SHOW VARIABLES LIKE 'character_set%';

-- Ver collation del servidor
SHOW VARIABLES LIKE 'collation%';
```

---

## 10. Motores de almacenamiento

MySQL soporta múltiples motores de almacenamiento. Cada tabla puede usar uno
distinto.

### InnoDB (default desde MySQL 5.5)

- Transacciones ACID completas.
- Foreign keys (claves foráneas).
- Row-level locking (bloqueo a nivel de fila).
- Crash recovery (recuperación automática tras fallos).
- Clustered index (los datos se almacenan ordenados por la PRIMARY KEY).

### MyISAM (legacy)

- Sin transacciones.
- Sin foreign keys.
- Table-level locking (bloquea toda la tabla).
- Más rápido en lecturas puras sin escrituras concurrentes.
- No recomendado para producción moderna.

### Comparación

| Característica | InnoDB | MyISAM |
|---|---|---|
| Transacciones | ✅ | ❌ |
| Foreign keys | ✅ | ❌ |
| Locking | Row-level | Table-level |
| Crash recovery | ✅ | ❌ |
| Full-text search | ✅ (5.6+) | ✅ |
| Clustered index | ✅ | ❌ |
| Conteo rápido COUNT(*) | ❌ (escanea) | ✅ (metadata) |
| Recomendado | ✅ Sí | ❌ No |

### Otros motores

| Motor | Uso |
|---|---|
| `MEMORY` (Heap) | Tablas en RAM, muy rápido, datos volátiles |
| `ARCHIVE` | Compresión para datos históricos, solo INSERT/SELECT |
| `CSV` | Tablas en archivos CSV |
| `BLACKHOLE` | No almacena nada (útil para replicación) |
| `NDB` (Cluster) | Clustering distribuido, alta disponibilidad |

### Especificar motor al crear tabla

```sql
CREATE TABLE mi_tabla (
    ...
) ENGINE=InnoDB;

-- Cambiar motor (¡puede ser lento y causar pérdida de features!)
ALTER TABLE mi_tabla ENGINE = InnoDB;

-- Ver motor de una tabla
SHOW TABLE STATUS LIKE 'mi_tabla';

-- Ver motores disponibles
SHOW ENGINES;
```

---

## 11. SHOW y DESCRIBE

### SHOW — inspeccionar el servidor

```sql
-- Bases de datos
SHOW DATABASES;

-- Tablas de la BD actual
SHOW TABLES;

-- Tablas de otra BD
SHOW TABLES FROM otra_db;

-- Tablas que coincen con un patrón
SHOW TABLES LIKE 'prod%';

-- Estado de una tabla (motor, filas, charset, collation, auto_increment)
SHOW TABLE STATUS LIKE 'productos';

-- Creación de una tabla (DDL completo)
SHOW CREATE TABLE productos;

-- Variables del servidor
SHOW VARIABLES LIKE 'version%';
SHOW VARIABLES LIKE 'character_set%';
SHOW VARIABLES LIKE 'innodb%';

-- Estado del servidor
SHOW STATUS;
SHOW STATUS LIKE 'Threads%';

-- Procesos activos
SHOW PROCESSLIST;
SHOW FULL PROCESSLIST;

-- Warnings de la última sentencia
SHOW WARNINGS;

-- Errores de la última sentencia
SHOW ERRORS;

-- Privilegios del usuario actual
SHOW GRANTS;

-- Motores disponibles
SHOW ENGINES;

-- Índices de una tabla
SHOW INDEX FROM productos;

-- Columnas con AUTO_INCREMENT
SHOW VARIABLES LIKE 'auto_inc%';
```

### DESCRIBE — ver estructura de una tabla

```sql
-- Estructura de una tabla
DESCRIBE productos;
-- o también:
DESC productos;

-- Salida:
-- +----------+------------------+------+-----+---------+----------------+
-- | Field    | Type             | Null | Key | Default | Extra          |
-- +----------+------------------+------+-----+---------+----------------+
-- | id       | int unsigned     | NO   | PRI | NULL    | auto_increment |
-- | nombre   | varchar(100)     | NO   |     | NULL    |                |
-- | precio   | decimal(10,2)    | NO   |     | 0.00    |                |
-- +----------+------------------+------+-----+---------+----------------+

-- Equivalente con más detalle
SHOW COLUMNS FROM productos;
SHOW FULL COLUMNS FROM productos;
```

### INFORMATION_SCHEMA — consultas avanzadas de metadata

```sql
-- Todas las tablas de todas las bases de datos
SELECT table_schema, table_name, engine, table_rows
FROM information_schema.tables
WHERE table_schema NOT IN ('mysql', 'information_schema', 'performance_schema');

-- Columnas de una tabla
SELECT column_name, data_type, is_nullable, column_default
FROM information_schema.columns
WHERE table_schema = 'tienda' AND table_name = 'productos';

-- Índices de una tabla
SELECT index_name, column_name, non_unique
FROM information_schema.statistics
WHERE table_schema = 'tienda' AND table_name = 'productos';

-- Tamaño de las tablas
SELECT
    table_name,
    ROUND((data_length + index_length) / 1024 / 1024, 2) AS tamano_mb,
    table_rows
FROM information_schema.tables
WHERE table_schema = 'tienda'
ORDER BY tamano_mb DESC;
```

---

## 12. Ejemplo completo integrador

```sql
-- Crear base de datos
CREATE DATABASE IF NOT EXISTS biblioteca
    CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE biblioteca;

-- Tabla de autores
CREATE TABLE autores (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    nacionalidad VARCHAR(50),
    PRIMARY KEY (id),
    INDEX idx_nacionalidad (nacionalidad)
) ENGINE=InnoDB;

-- Tabla de libros con foreign key
CREATE TABLE libros (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    titulo VARCHAR(200) NOT NULL,
    autor_id INT UNSIGNED NOT NULL,
    isbn VARCHAR(20) UNIQUE,
    anio YEAR,
    genero ENUM('ficcion', 'no_ficcion', 'poesia', 'teatro', 'infantil'),
    precio DECIMAL(10,2) DEFAULT 0.00,
    stock INT NOT NULL DEFAULT 0 CHECK (stock >= 0),
    descripcion TEXT,
    metadatos JSON,
    creado_en DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    INDEX idx_titulo (titulo),
    INDEX idx_genero (genero),
    CONSTRAINT fk_libro_autor FOREIGN KEY (autor_id)
        REFERENCES autores(id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Verificar estructura
DESCRIBE libros;
SHOW CREATE TABLE libros\G
SHOW TABLE STATUS LIKE 'libros'\G
```

---

## Conceptos clave

| Concepto | Definición |
|---|---|
| **RDBMS** | Sistema que organiza datos en tablas relacionadas |
| **Motor de almacenamiento** | Componente que gestiona cómo se almacenan y recuperan los datos de una tabla |
| **InnoDB** | Motor ACID con transacciones, foreign keys y row-level locking. Default |
| **CHARACTER SET** | Codificación de caracteres de una columna/tabla/BD |
| **COLLATION** | Reglas de comparación y ordenamiento de caracteres |
| **AUTO_INCREMENT** | Genera IDs numéricos secuenciales automáticos |
| **utf8mb4** | Charset que soporta Unicode completo (4 bytes), incluidos emoji |
| **Clustered index** | En InnoDB, los datos se guardan físicamente ordenados por la PK |
| **INFORMATION_SCHEMA** | Base de datos de metadata con información de todas las tablas |

---

## Errores comunes

### 1. Usar `utf8` en lugar de `utf8mb4`

```sql
-- ❌ MAL: utf8 no soporta emoji ni caracteres de 4 bytes
CREATE TABLE mensajes ( texto VARCHAR(255) ) CHARSET=utf8;

-- ✅ BIEN: utf8mb4 soporta todo Unicode
CREATE TABLE mensajes ( texto VARCHAR(255) ) CHARSET=utf8mb4;
```

### 2. Usar FLOAT para dinero

```sql
-- ❌ MAL: pérdida de precisión
CREATE TABLE productos ( precio FLOAT );

-- ✅ BIEN: precisión exacta
CREATE TABLE productos ( precio DECIMAL(10,2) );
```

### 3. Olvidar `ENGINE=InnoDB` y usar MyISAM por defecto

En versiones antiguas el motor por defecto era MyISAM (sin transacciones ni
foreign keys). Siempre especifica `ENGINE=InnoDB` explícitamente.

### 4. No definir `UNSIGNED` en IDs

```sql
-- ❌ Permite negativos innecesarios
id INT AUTO_INCREMENT PRIMARY KEY

-- ✅ Solo positivos, el doble de rango positivo
id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY
```

### 5. Confundir `TIMESTAMP` con `DATETIME`

```sql
-- TIMESTAMP: se convierte a UTC, problema del 2038
creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP

-- DATETIME: se almacena tal cual, sin conversión de zona horaria
creado_en DATETIME DEFAULT CURRENT_TIMESTAMP
```

### 6. ENUM para listas que cambian

```sql
-- ❌ Cada cambio de categoría requiere ALTER TABLE
categoria ENUM('A', 'B', 'C')

-- ✅ Tabla de lookup para listas dinámicas
CREATE TABLE categorias (id INT PRIMARY KEY, nombre VARCHAR(50));
```

### 7. Longitud excesiva en VARCHAR

```sql
-- ❌ VARCHAR(10000) no hace sentido, usa TEXT
descripcion VARCHAR(10000)

-- ✅ Para textos largos, usa TEXT
descripcion TEXT
```

---

## Siguiente paso

Continúa con la [Guía 02 — Consultas y funciones](02-consultas-y-funciones.md)
para aprender SELECT, JOINs, funciones y todo lo necesario para consultar datos.
