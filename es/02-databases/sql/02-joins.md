# Guía 2 — Joins

## Objetivos

- [ ] Comprender llaves primarias y llaves foráneas.
- [ ] Combinar tablas con `INNER JOIN`.
- [ ] Usar `LEFT JOIN` y `RIGHT JOIN` para incluir filas sin coincidencia.
- [ ] Generar combinaciones completas con `CROSS JOIN`.
- [ ] Escribir joins con alias de tabla y condiciones múltiples.

## Apuntes

### Llaves primarias y foráneas

Una base de datos normalizada divide la información en varias tablas para evitar duplicados. Para relacionarlas se usan llaves:

- **Llave primaria** (`PRIMARY KEY`): columna (o conjunto de columnas) que identifica de forma única cada fila. No puede ser `NULL` ni repetirse.
- **Llave foránea** (`FOREIGN KEY`): columna que referencia la llave primaria de otra tabla, creando la relación.

```sql
CREATE TABLE clientes (
    id INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL
);

CREATE TABLE pedidos (
    id INTEGER PRIMARY KEY,
    cliente_id INTEGER,
    total REAL,
    FOREIGN KEY (cliente_id) REFERENCES clientes(id)
);
```

Los tipos de relación son:
- **1 a 1**: un registro se asocia con exactamente otro.
- **1 a muchos**: un cliente tiene muchos pedidos (el más común).
- **Muchos a muchos**: un estudiante tiene muchos cursos y un curso muchos estudiantes (se resuelve con una tabla intermedia).

### INNER JOIN

Devuelve solo las filas que tienen **coincidencia en ambas tablas**:

```sql
SELECT clientes.nombre, pedidos.total
FROM clientes
INNER JOIN pedidos ON pedidos.cliente_id = clientes.id;
```

`INNER JOIN` es equivalente a escribir `JOIN` a secas.

### LEFT JOIN

Devuelve **todas las filas de la tabla izquierda**, y las coincidencias de la derecha. Si no hay coincidencia, las columnas de la derecha quedan `NULL`:

```sql
SELECT clientes.nombre, pedidos.total
FROM clientes
LEFT JOIN pedidos ON pedidos.cliente_id = clientes.id;
```

Útil para encontrar filas "huérfanas", por ejemplo clientes sin pedidos:

```sql
SELECT clientes.nombre
FROM clientes
LEFT JOIN pedidos ON pedidos.cliente_id = clientes.id
WHERE pedidos.id IS NULL;
```

### RIGHT JOIN

Igual que `LEFT JOIN` pero conserva todas las filas de la **tabla derecha**. SQLite no soporta `RIGHT JOIN` nativamente, pero se puede simular invirtiendo el orden de las tablas y usando `LEFT JOIN`.

```sql
-- Equivalente en SQLite/estándar: conservar todos los pedidos
SELECT clientes.nombre, pedidos.total
FROM pedidos
LEFT JOIN clientes ON clientes.id = pedidos.cliente_id;
```

### CROSS JOIN

Combina **cada fila de una tabla con cada fila de la otra** (producto cartesiano). No usa `ON`:

```sql
SELECT colores.nombre, tamanos.nombre
FROM colores
CROSS JOIN tamanos;
```

Es peligroso con tablas grandes (N × M filas), pero útil para generar combinaciones completas.

### Aliasing de tablas

Los alias acortan los nombres y hacen el query legible:

```sql
SELECT c.nombre, p.total
FROM clientes AS c
INNER JOIN pedidos AS p ON p.cliente_id = c.id;
```

`AS` es opcional: `FROM clientes c`.

### Joins con múltiples condiciones

Se pueden combinar condiciones con `AND`/`OR` en el `ON`:

```sql
SELECT *
FROM empleados e
INNER JOIN asignaciones a
    ON a.empleado_id = e.id
    AND a.year = 2024;
```

### FULL JOIN

Devuelve todas las filas de ambas tablas, rellenando con `NULL` las que no coinciden. SQLite no lo soporta nativamente; en PostgreSQL existe `FULL OUTER JOIN`.

## Ejemplos de código

Schema de ejemplo:

```sql
CREATE TABLE clientes (
    id INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL
);

CREATE TABLE pedidos (
    id INTEGER PRIMARY KEY,
    cliente_id INTEGER,
    total REAL,
    FOREIGN KEY (cliente_id) REFERENCES clientes(id)
);

INSERT INTO clientes (id, nombre) VALUES
    (1, 'Ana'),
    (2, 'Luis'),
    (3, 'Marta');

INSERT INTO pedidos (id, cliente_id, total) VALUES
    (101, 1, 250.00),
    (102, 1, 80.00),
    (103, 2, 340.00);
```

Consultas:

```sql
-- Clientes con sus pedidos (solo quienes tienen pedidos)
SELECT c.nombre, p.total
FROM clientes c
INNER JOIN pedidos p ON p.cliente_id = c.id;

-- Todos los clientes, tengan o no pedidos
SELECT c.nombre, p.total
FROM clientes c
LEFT JOIN pedidos p ON p.cliente_id = c.id;

-- Clientes sin ningún pedido
SELECT c.nombre
FROM clientes c
LEFT JOIN pedidos p ON p.cliente_id = c.id
WHERE p.id IS NULL;
```

## Ejercicios relacionados

- [ejercicios/nivel-02-basico/ejercicio-01-inner-join.md](ejercicios/nivel-02-basico/ejercicio-01-inner-join.md)
- [ejercicios/nivel-02-basico/ejercicio-02-left-y-right-join.md](ejercicios/nivel-02-basico/ejercicio-02-left-y-right-join.md)
- [ejercicios/nivel-03-intermedio/ejercicio-01-joins-multiples.md](ejercicios/nivel-03-intermedio/ejercicio-01-joins-multiples.md)

## Errores comunes

- **Olvidar la condición `ON`**: produce un `CROSS JOIN` accidental con miles de filas.
- **Usar `WHERE` en vez de `ON`**: para los joins funciona igual a corto plazo, pero en `LEFT JOIN` mueve el filtro después del join y elimina filas `NULL`, cambiando el resultado.
- **Columnas ambiguas**: si ambas tablas tienen `id`, hay que calificarlas (`clientes.id`), o el motor lanza error.
- **Creer que `INNER JOIN` devuelve todos los registros**: solo devuelve las coincidencias; para el resto usa `LEFT JOIN`.
- **Combinar las tablas en el `WHERE`** (`FROM a, b WHERE a.id = b.id`): funciona pero es estilo antiguo y fácil de romper; usa `JOIN ... ON`.

## Recursos

- [PostgreSQL JOIN docs](https://www.postgresql.org/docs/current/queries-table-expressions.html)
- [SQLite joins](https://www.sqlite.org/lang_select.html#the-join-operator)
- [Visualización interactiva de joins](https://joins.spathon.com/)