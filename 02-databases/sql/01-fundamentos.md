# 01 — Fundamentos de SQL

## Objetivos

- [ ] Entender qué es SQL y su importancia
- [ ] Conocer los tipos de bases de datos relacionales
- [ ] Entender la estructura de una tabla
- [ ] Aprender los tipos de datos en SQL
- [ ] Usar comandos DDL (CREATE, ALTER, DROP)
- [ ] Usar comandos DML (INSERT, UPDATE, DELETE, SELECT)
- [ ] Entender las restricciones (Constraints)

## Apuntes

### ¿Qué es SQL?

SQL (Structured Query Language) es el lenguaje estándar para gestionar bases de datos relacionales. Permite crear, modificar y consultar datos de manera estructurada.

**Tipos de bases de datos:**
- **PostgreSQL**: Avanzada, soporte JSON, extensible
- **MySQL**: Popular, fácil de usar, buena para web
- **SQLite**: Ligera, embebida, sin servidor
- **SQL Server**: Microsoft, integración con .NET
- **Oracle**: Empresarial, robusta

### Estructura de una Base de Datos

```
Base de Datos
  └── Tablas
       └── Columnas (Campos)
            └── Filas (Registros)
```

### Tipos de Datos en SQL

#### Números
| Tipo | Descripción | Ejemplo |
|------|-------------|---------|
| `INT` | Entero | `edad INT` |
| `SMALLINT` | Entero pequeño | `cantidad SMALLINT` |
| `BIGINT` | Entero grande | `poblacion BIGINT` |
| `DECIMAL(p,s)` | Decimal exacto | `precio DECIMAL(10,2)` |
| `FLOAT` | Decimal aproximado | `peso FLOAT` |
| `NUMERIC(p,s)` | Decimal exacto | `saldo NUMERIC(15,2)` |

#### Texto
| Tipo | Descripción | Ejemplo |
|------|-------------|---------|
| `VARCHAR(n)` | Variable (hasta n) | `nombre VARCHAR(100)` |
| `CHAR(n)` | Fijo (n caracteres) | `codigo CHAR(10)` |
| `TEXT` | Texto largo | `descripcion TEXT` |
| `JSON` | JSON (PostgreSQL) | `datos JSON` |
| `JSONB` | JSON binario | `config JSONB` |

#### Fechas/Horas
| Tipo | Descripción | Ejemplo |
|------|-------------|---------|
| `DATE` | Fecha | `fecha_nac DATE` |
| `TIME` | Hora | `hora TIME` |
| `TIMESTAMP` | Fecha y hora | `creado TIMESTAMP` |
| `TIMESTAMPTZ` | Con zona horaria | `actualizado TIMESTAMPTZ` |

#### Booleanos
| Tipo | Descripción | Ejemplo |
|------|-------------|---------|
| `BOOLEAN` | Verdadero/Falso | `activo BOOLEAN` |

### Comandos DDL (Data Definition Language)

```sql
-- CREATE - Crear tabla
CREATE TABLE usuarios (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    edad INT CHECK (edad >= 0),
    activo BOOLEAN DEFAULT TRUE,
    creado TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ALTER - Modificar tabla
ALTER TABLE usuarios ADD COLUMN telefono VARCHAR(20);
ALTER TABLE usuarios DROP COLUMN edad;
ALTER TABLE usuarios MODIFY COLUMN nombre VARCHAR(150);

-- DROP - Eliminar tabla
DROP TABLE usuarios;

-- TRUNCATE - Vaciar tabla (más rápido que DELETE)
TRUNCATE TABLE usuarios;
```

### Comandos DML (Data Manipulation Language)

```sql
-- INSERT - Insertar datos
INSERT INTO usuarios (nombre, email, edad)
VALUES ('Ana Pérez', 'ana@email.com', 30);

INSERT INTO usuarios (nombre, email, edad)
VALUES 
    ('Juan García', 'juan@email.com', 25),
    ('María López', 'maria@email.com', 28);

-- SELECT - Consultar datos
SELECT * FROM usuarios;
SELECT nombre, email FROM usuarios;
SELECT nombre, email FROM usuarios WHERE edad > 25;

-- UPDATE - Actualizar datos
UPDATE usuarios 
SET edad = 31 
WHERE nombre = 'Ana Pérez';

-- DELETE - Eliminar datos
DELETE FROM usuarios WHERE id = 1;
DELETE FROM usuarios;  -- Elimina todos los registros
```

### Restricciones (Constraints)

```sql
-- PRIMARY KEY - Clave primaria
CREATE TABLE productos (
    id INT PRIMARY KEY,
    nombre VARCHAR(100)
);

-- FOREIGN KEY - Clave foránea
CREATE TABLE pedidos (
    id INT PRIMARY KEY,
    usuario_id INT,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
);

-- UNIQUE - Único
CREATE TABLE categorias (
    id INT PRIMARY KEY,
    nombre VARCHAR(50) UNIQUE
);

-- NOT NULL - No nulo
CREATE TABLE direcciones (
    id INT PRIMARY KEY,
    calle VARCHAR(100) NOT NULL,
    ciudad VARCHAR(50) NOT NULL
);

-- DEFAULT - Valor por defecto
CREATE TABLE log (
    id INT PRIMARY KEY,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- CHECK - Validación
CREATE TABLE personas (
    id INT PRIMARY KEY,
    edad INT CHECK (edad >= 0 AND edad <= 150)
);
```

## Ejemplos de Código

```sql
-- Crear base de datos (PostgreSQL)
CREATE DATABASE tienda;

-- Conectar a la base de datos
\c tienda;

-- Crear tablas
CREATE TABLE clientes (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    telefono VARCHAR(20),
    fecha_registro DATE DEFAULT CURRENT_DATE
);

CREATE TABLE productos (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    precio DECIMAL(10,2) NOT NULL CHECK (precio >= 0),
    stock INT NOT NULL DEFAULT 0
);

CREATE TABLE pedidos (
    id SERIAL PRIMARY KEY,
    cliente_id INT NOT NULL,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total DECIMAL(10,2) DEFAULT 0,
    FOREIGN KEY (cliente_id) REFERENCES clientes(id)
);

-- Insertar datos
INSERT INTO clientes (nombre, email, telefono)
VALUES 
    ('Ana Martínez', 'ana@email.com', '123456789'),
    ('Juan Pérez', 'juan@email.com', '987654321');

INSERT INTO productos (nombre, precio, stock)
VALUES 
    ('Laptop', 999.99, 10),
    ('Teléfono', 599.99, 25);

-- Consultar datos
SELECT * FROM clientes;
SELECT nombre, precio FROM productos WHERE precio < 1000;
SELECT * FROM productos ORDER BY precio DESC;
```

## Errores Comunes

| Error | Causa | Solución |
|-------|-------|----------|
| `Table doesn't exist` | Tabla no creada | Crear la tabla primero |
| `Duplicate entry` | Violación de UNIQUE | Verificar que el valor sea único |
| `Cannot add or update child row` | Violación de FOREIGN KEY | Asegurar que existe en tabla padre |
| `Data too long` | Texto más largo que VARCHAR | Aumentar tamaño o usar TEXT |
| `Invalid column reference` | Columna no existe | Verificar nombre de columna |

## Ejercicios Relacionados

- [Ejercicio 01: SELECT Básico](./ejercicios/nivel-01-fundamentos/ejercicio-01-select-basico/)
- [Ejercicio 02: WHERE y Orden](./ejercicios/nivel-01-fundamentos/ejercicio-02-where-y-orden/)
- [Ejercicio 03: INSERT](./ejercicios/nivel-01-fundamentos/ejercicio-03-insert/)
- [Ejercicio 04: UPDATE y DELETE](./ejercicios/nivel-01-fundamentos/ejercicio-04-update-y-delete/)
