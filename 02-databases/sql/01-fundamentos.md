# Guía 1 — Fundamentos de SQL

## Objetivos

- [ ] Comprender qué es una base de datos relacional y una tabla.
- [ ] Escribir consultas `SELECT` básicas con columnas específicas.
- [ ] Filtrar filas con `WHERE` y operadores de comparación/lógicos.
- [ ] Ordenar resultados con `ORDER BY` y limitar con `LIMIT`.
- [ ] Insertar datos con `INSERT`, actualizar con `UPDATE` y borrar con `DELETE`.
- [ ] Conocer los tipos de datos más comunes.

## Apuntes

### Qué es una base de datos relacional

Una base de datos relacional organiza la información en **tablas**. Cada tabla tiene:

- **Columnas** (campos): definen qué tipo de dato se guarda.
- **Filas** (registros): cada fila es un registro completo.
- **Llave primaria** (`PRIMARY KEY`): identifica de forma única cada fila.

El lenguaje para hablar con estas bases de datos es **SQL** (Structured Query Language). Sus comandos se dividen en categorías:

| Categoría | Sigla | Comandos | Función |
|---|---|---|---|
| Consulta | DQL | `SELECT` | Leer datos |
| Datos | DML | `INSERT`, `UPDATE`, `DELETE` | Modificar datos |
| Definición | DDL | `CREATE`, `ALTER`, `DROP` | Definir estructura |
| Control | DCL/TCL | `GRANT`, `COMMIT`, `ROLLBACK` | Permisos y transacciones |

### SELECT

`SELECT` lee datos de una o más columnas:

```sql
SELECT columna1, columna2 FROM tabla;
```

Para leer todas las columnas se usa `*`:

```sql
SELECT * FROM usuarios;
```

`DISTINCT` elimina duplicados en el resultado:

```sql
SELECT DISTINCT ciudad FROM usuarios;
```

### WHERE

`WHERE` filtra filas que cumplen una condición:

```sql
SELECT nombre, edad FROM usuarios WHERE edad >= 18;
```

Operadores de comparación: `=`, `!=` (`<>`), `>`, `>=`, `<`, `<=`.

Operadores lógicos: `AND`, `OR`, `NOT`.

`BETWEEN` filtra rangos inclusivos, `IN` filtra conjuntos, `LIKE` filtra patrones:

```sql
SELECT * FROM productos WHERE precio BETWEEN 10 AND 50;
SELECT * FROM productos WHERE categoria IN ('libros', 'papeleria');
SELECT * FROM productos WHERE nombre LIKE 'A%';
```

### ORDER BY y LIMIT

`ORDER BY` ordena las filas (ascendente por defecto, `DESC` para descendente):

```sql
SELECT nombre, precio FROM productos ORDER BY precio DESC;
SELECT nombre, precio FROM productos ORDER BY precio DESC, nombre ASC;
```

`LIMIT` devuelve solo las primeras N filas (y con `OFFSET` se puede saltar filas):

```sql
SELECT * FROM productos ORDER BY precio DESC LIMIT 5;
SELECT * FROM productos ORDER BY precio DESC LIMIT 5 OFFSET 5;
```

### INSERT

Inserta una fila. Si no se indican columnas, hay que dar valores para todas:

```sql
INSERT INTO usuarios (nombre, edad, ciudad) VALUES ('Ana', 25, 'Madrid');
INSERT INTO usuarios VALUES (1, 'Ana', 25, 'Madrid');
```

### UPDATE

Actualiza filas existentes. **Importante**: sin `WHERE` actualiza todas las filas.

```sql
UPDATE usuarios SET ciudad = 'Barcelona' WHERE nombre = 'Ana';
UPDATE productos SET precio = precio * 1.1 WHERE categoria = 'libros';
```

### DELETE

Elimina filas. **Importante**: sin `WHERE` borra todas las filas de la tabla.

```sql
DELETE FROM usuarios WHERE id = 5;
```

### Tipos de datos comunes

| Tipo | Descripción | Ejemplo |
|---|---|---|
| `INTEGER` / `INT` | Números enteros | `42`, `-7` |
| `REAL` / `DECIMAL(p,s)` | Números decimales | `3.14`, `19.99` |
| `TEXT` / `VARCHAR(n)` | Cadenas de texto | `'Hola'` |
| `DATE` | Fecha | `'2024-01-15'` |
| `TIME` | Hora | `'14:30:00'` |
| `TIMESTAMP` / `DATETIME` | Fecha y hora | `'2024-01-15 14:30:00'` |
| `BOOLEAN` | Verdadero/falso | `TRUE`, `FALSE` |

En SQLite, `VARCHAR(n)` se trata como `TEXT` y los booleanos se guardan como 0/1, pero la sintaxis estándar funciona igual.

### Valores NULL

`NULL` significa "sin valor" (no es cero ni cadena vacía). Se compara con `IS NULL` / `IS NOT NULL`, nunca con `=`:

```sql
SELECT * FROM usuarios WHERE email IS NULL;
SELECT * FROM usuarios WHERE email IS NOT NULL;
```

## Ejemplos de código

Crear una tabla e insertar datos:

```sql
CREATE TABLE productos (
    id INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL,
    categoria TEXT,
    precio REAL
);

INSERT INTO productos (id, nombre, categoria, precio) VALUES
    (1, 'Cuaderno', 'papeleria', 2.50),
    (2, 'Libro de SQL', 'libros', 29.99),
    (3, 'Boligrafo', 'papeleria', 0.90);
```

Consultar:

```sql
-- Productos más caros
SELECT nombre, precio FROM productos ORDER BY precio DESC;

-- Productos de papeleria con precio menor a 5
SELECT nombre FROM productos WHERE categoria = 'papeleria' AND precio < 5;

-- Los 2 productos más baratos
SELECT * FROM productos ORDER BY precio ASC LIMIT 2;
```

Actualizar y borrar:

```sql
UPDATE productos SET precio = 3.00 WHERE nombre = 'Cuaderno';
DELETE FROM productos WHERE nombre = 'Boligrafo';
```

## Ejercicios relacionados

- [ejercicios/nivel-01-fundamentos/ejercicio-01-select-basico.md](ejercicios/nivel-01-fundamentos/ejercicio-01-select-basico.md)
- [ejercicios/nivel-01-fundamentos/ejercicio-02-where-y-orden.md](ejercicios/nivel-01-fundamentos/ejercicio-02-where-y-orden.md)
- [ejercicios/nivel-01-fundamentos/ejercicio-03-insert.md](ejercicios/nivel-01-fundamentos/ejercicio-03-insert.md)
- [ejercicios/nivel-01-fundamentos/ejercicio-04-update-y-delete.md](ejercicios/nivel-01-fundamentos/ejercicio-04-update-y-delete.md)
- [ejercicios/nivel-01-fundamentos/ejercicio-05-funciones-agregadas.md](ejercicios/nivel-01-fundamentos/ejercicio-05-funciones-agregadas.md)
- [ejercicios/nivel-01-fundamentos/ejercicio-06-like-y-filtros.md](ejercicios/nivel-01-fundamentos/ejercicio-06-like-y-filtros.md)

## Errores comunes

- **Olvidar `WHERE` en `UPDATE`/`DELETE`**: modifica o borra todas las filas. Siempre escribe el `WHERE` primero.
- **Comparar `NULL` con `=`**: `WHERE email = NULL` nunca devuelve filas; usa `IS NULL`.
- **Usar `=` en vez de `==`**: SQL solo usa `=` (un solo signo) para comparar.
- **Poner `;` al final**: aunque muchos motores lo toleran, es buena práctica cerrar cada sentencia.
- **Comillas**: los valores de texto van entre comillas simples `'...'`, los identificadores con comillas dobles.
- **Usar `AND`/`OR` sin paréntesis**: mezclar ambos requiere paréntesis para evitar ambigüedad: `(a OR b) AND c`.

## Recursos

- [PostgreSQL SELECT docs](https://www.postgresql.org/docs/current/sql-select.html)
- [SQLite query language](https://www.sqlite.org/lang.html)
- [SQLBolt (interactivo)](https://sqlbolt.com/)