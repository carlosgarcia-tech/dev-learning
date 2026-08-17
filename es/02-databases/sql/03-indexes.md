# Guía 3 — Índices

## Objetivos

- [ ] Comprender qué es un índice y cómo funciona internamente.
- [ ] Crear índices con `CREATE INDEX`.
- [ ] Distinguir índices simples, compuestos y únicos.
- [ ] Saber cuándo usar (y cuándo NO usar) un índice.
- [ ] Analizar consultas con `EXPLAIN` / `EXPLAIN QUERY PLAN`.

## Apuntes

### Qué es un índice

Un índice es una estructura de datos (normalmente un **árbol B** o hash) que permite encontrar filas **sin recorrer toda la tabla**. Sin índice, el motor hace un **scan completo** (`full table scan`): lee fila por fila. Con índice, busca directamente por el valor como si consultara un índice de libro.

Un índice funciona **como un índice de libro**: guarda un valor ordenado y un puntero a dónde vive la fila. No almacena los datos, solo los ordena para buscarlos rápido.

### Cómo crear índices

```sql
CREATE INDEX idx_usuarios_email ON usuarios (email);
```

Índice **único** (impide duplicados, además de acelerar búsquedas):

```sql
CREATE UNIQUE INDEX idx_usuarios_email ON usuarios (email);
```

Índice **compuesto** (varias columnas, respeta el orden de las columnas):

```sql
CREATE INDEX idx_ventas_fecha_cliente ON ventas (fecha, cliente_id);
```

Índice **parcial** (solo indexa filas que cumplen condición, PostgreSQL):

```sql
CREATE INDEX idx_ventas_activas ON ventas (fecha) WHERE estado = 'activo';
```

### Llaves primarias, UNIQUE y índices implícitos

- La `PRIMARY KEY` crea automáticamente un índice único.
- La restricción `UNIQUE` también crea un índice único.
- Las `FOREIGN KEY` **no** crean índices automáticamente en la mayoría de motores; si consultas mucho por la columna foránea, conviene indexarla.

### Cuándo usar índices

**Sí conviene** cuando la columna se usa mucho en:
- `WHERE`: `WHERE email = 'a@b.com'`
- `JOIN ON`: `ON p.cliente_id = c.id`
- `ORDER BY`: `ORDER BY fecha`
- `GROUP BY`: `GROUP BY ciudad`
- Búsquedas de unicidad (`UNIQUE`)

**No conviene** cuando:
- La tabla es muy pequeña (leerla completa es más barato que el índice).
- La columna se actualiza/inserta mucho (cada escritura debe actualizar el índice también).
- Hay pocos valores distintos (baja **cardinalidad**), como un booleano.
- La consulta devuelve un gran porcentaje de las filas (el planificador prefiere el scan).

### Coste de los índices

Cada índice cuesta:
- **Espacio en disco**.
- **Tiempo de escritura**: `INSERT`, `UPDATE`, `DELETE` deben mantener el índice sincronizado.

Regla práctica: **más consultas que escrituras → índices; más escrituras que consultas → pocos índices.**

### EXPLAIN

`EXPLAIN` muestra el **plan de ejecución** que el motor seguirá. Permite ver si una consulta usa un índice o hace scan completo.

PostgreSQL:

```sql
EXPLAIN SELECT * FROM usuarios WHERE email = 'a@b.com';
```

SQLite:

```sql
EXPLAIN QUERY PLAN SELECT * FROM usuarios WHERE email = 'a@b.com';
```

Salida típica de SQLite sin índice:

```
SCAN usuarios
```

Con índice:

```
SEARCH usuarios USING INDEX idx_usuarios_email (email=?)
```

## Ejemplos de código

```sql
CREATE TABLE usuarios (
    id INTEGER PRIMARY KEY,
    email TEXT NOT NULL,
    ciudad TEXT,
    fecha_registro DATE
);

-- Índice único sobre el email (evita duplicados y acelera búsquedas)
CREATE UNIQUE INDEX idx_usuarios_email ON usuarios (email);

-- Índice para filtrar/ordenar por ciudad
CREATE INDEX idx_usuarios_ciudad ON usuarios (ciudad);

-- Índice compuesto para reportes por ciudad y fecha
CREATE INDEX idx_usuarios_ciudad_fecha ON usuarios (ciudad, fecha_registro);

-- Ver el plan de ejecución (SQLite)
EXPLAIN QUERY PLAN
SELECT * FROM usuarios WHERE email = 'ana@example.com';

-- Ver el plan de ejecución (PostgreSQL)
EXPLAIN
SELECT * FROM usuarios WHERE ciudad = 'Madrid' ORDER BY fecha_registro;

-- Borrar un índice
DROP INDEX idx_usuarios_ciudad;
```

## Ejercicios relacionados

- [ejercicios/nivel-04-avanzado/ejercicio-02-indexes.md](ejercicios/nivel-04-avanzado/ejercicio-02-indexes.md)
- [ejercicios/nivel-04-avanzado/ejercicio-06-optimizacion-de-queries.md](ejercicios/nivel-04-avanzado/ejercicio-06-optimizacion-de-queries.md)

## Errores comunes

- **Indexar todo**: cada índice ralentiza las escrituras; solo indexa lo que se consulta de verdad.
- **Índices compuestos con orden incorrecto**: para `WHERE ciudad = ? AND fecha = ?` el orden en el índice importa; el motor puede usar menos columnas de las esperadas.
- **Filtros en una función**: `WHERE UPPER(email) = ...` inutiliza el índice normal sobre `email` (el motor no puede usar el índice con la función). Solución: índice funcional o normalizar los datos.
- **Medir sin datos**: los índices brillan con tablas grandes; en tablas pequeñas el scan es igual de rápido.
- **Indexar columnas de baja cardinalidad**: `WHERE sexo = 'M'` con 2 valores no aprovecha el índice.
- **Usar `SELECT *` en índices**: un índice **cubriente** (que incluye todas las columnas pedidas) evita volver a la tabla; selecciona solo las columnas necesarias.

## Recursos

- [PostgreSQL indexes docs](https://www.postgresql.org/docs/current/indexes.html)
- [SQLite index docs](https://www.sqlite.org/queryplanner.html)
- [Use the Index, Luke!](https://use-the-index-luke.com/)