# Guía 02 — Consultas y Funciones de MySQL

## Objetivos

- [ ] Dominar SELECT, WHERE, ORDER BY y LIMIT
- [ ] Agrupar datos con GROUP BY y filtrar con HAVING
- [ ] Combinar tablas con todos los tipos de JOIN
- [ ] Escribir subconsultas correlacionadas y no correlacionadas
- [ ] Usar funciones de MySQL: matemáticas, texto, fecha y agregación
- [ ] Aplicar control de flujo: IF, IFNULL, COALESCE, CASE
- [ ] Convertir tipos con CAST y CONVERT

---

## 1. SELECT

```sql
-- Selección básica
SELECT * FROM productos;

-- Columnas específicas
SELECT id, nombre, precio FROM productos;

-- Alias de columnas
SELECT nombre AS producto, precio AS costo_unitario FROM productos;

-- Expresiones calculadas
SELECT nombre, precio, stock, precio * stock AS valor_inventario FROM productos;

-- Valores literales y constantes
SELECT 'tienda' AS aplicacion, NOW() AS fecha_consulta, VERSION() AS mysql_version;

-- DISTINCT: eliminar duplicados
SELECT DISTINCT categoria FROM productos;
SELECT DISTINCT categoria, marca FROM productos;

-- Concatenación con CONCAT
SELECT CONCAT(nombre, ' ($', precio, ')') AS etiqueta FROM productos;
SELECT CONCAT_WS(' - ', id, nombre, precio) AS info FROM productos;
```

---

## 2. WHERE

```sql
-- Operadores de comparación
SELECT * FROM productos WHERE precio > 100;
SELECT * FROM productos WHERE precio >= 50 AND precio <= 200;
SELECT * FROM productos WHERE precio BETWEEN 50 AND 200;

-- Operadores lógicos: AND, OR, NOT
SELECT * FROM productos WHERE categoria = 'electronica' AND stock > 0;
SELECT * FROM productos WHERE categoria = 'electronica' OR categoria = 'hogar';
SELECT * FROM productos WHERE NOT categoria = 'ropa';

-- IN: múltiples valores
SELECT * FROM productos WHERE categoria IN ('electronica', 'hogar', 'ropa');

-- NOT IN
SELECT * FROM productos WHERE categoria NOT IN ('ropa', 'otros');

-- NULL: IS NULL / IS NOT NULL (nunca uses = NULL)
SELECT * FROM productos WHERE descripcion IS NULL;
SELECT * FROM productos WHERE descripcion IS NOT NULL;

-- LIKE: patrón de texto
SELECT * FROM productos WHERE nombre LIKE 'Laptop%';     -- empieza con
SELECT * FROM productos WHERE nombre LIKE '%Pro%';        -- contiene
SELECT * FROM productos WHERE nombre LIKE '%14';           -- termina con
SELECT * FROM productos WHERE nombre LIKE 'Laptop__';     -- _ es un caracter exacto

-- REGEXP / RLIKE: expresiones regulares
SELECT * FROM productos WHERE nombre REGEXP '^Laptop [0-9]+';
SELECT * FROM usuarios WHERE email REGEXP '^[a-z]+@[a-z]+\\.com$';
SELECT * FROM productos WHERE codigo REGEXP '[A-Z]{3}-[0-9]{4}';
```

### Precedencia de operadores

| Orden | Operador |
|---|---|
| 1 | `NOT` |
| 2 | `=`, `<>`, `!=`, `<`, `>`, `<=`, `>=`, `LIKE`, `REGEXP`, `IN`, `IS`, `BETWEEN` |
| 3 | `AND` |
| 4 | `OR`, `XOR` |

```sql
-- Usa paréntesis para forzar el orden
SELECT * FROM productos
WHERE (categoria = 'electronica' OR categoria = 'hogar')
  AND stock > 0
  AND NOT (precio > 1000);
```

---

## 3. ORDER BY

```sql
-- Ordenar por una columna
SELECT * FROM productos ORDER BY precio;           -- ASC por defecto
SELECT * FROM productos ORDER BY precio ASC;       -- explícito
SELECT * FROM productos ORDER BY precio DESC;     -- descendente

-- Múltiples columnas
SELECT * FROM productos ORDER BY categoria ASC, precio DESC;

-- Por posición de columna
SELECT nombre, precio FROM productos ORDER BY 2 DESC;

-- Con expresiones
SELECT nombre, precio * stock AS valor FROM productos ORDER BY valor DESC;

-- FIELD(): orden personalizado
SELECT * FROM productos
ORDER BY FIELD(categoria, 'electronica', 'hogar', 'ropa', 'otros');

-- ORDER BY con NULL
SELECT * FROM productos ORDER BY descripcion DESC;  -- NULLs al final en DESC
-- MySQL trata NULL como menor que cualquier valor
```

---

## 4. LIMIT y OFFSET

```sql
-- Primeros 10 resultados
SELECT * FROM productos LIMIT 10;

-- Con OFFSET (paginación)
SELECT * FROM productos LIMIT 10 OFFSET 0;   -- página 1 (filas 1-10)
SELECT * FROM productos LIMIT 10 OFFSET 10;  -- página 2 (filas 11-20)
SELECT * FROM productos LIMIT 10 OFFSET 20;  -- página 3 (filas 21-30)

-- Sintaxis alternativa
SELECT * FROM productos LIMIT 0, 10;  -- offset, count

-- Top N por categoría
SELECT * FROM productos ORDER BY precio DESC LIMIT 5;

-- Importante: LIMIT sin ORDER BY no garantiza orden
-- Siempre usa ORDER BY con LIMIT
```

### Paginación

```sql
-- Paginación típica: página N, 10 items por página
SET @pagina = 3;
SET @por_pagina = 10;
SET @offset = (@pagina - 1) * @por_pagina;

PREPARE stmt FROM 'SELECT * FROM productos ORDER BY id LIMIT ? OFFSET ?';
EXECUTE stmt USING @por_pagina, @offset;
DEALLOCATE PREPARE stmt;
```

---

## 5. GROUP BY y HAVING

```sql
-- Contar productos por categoría
SELECT categoria, COUNT(*) AS total
FROM productos
GROUP BY categoria;

-- Precio promedio por categoría
SELECT categoria, AVG(precio) AS promedio, MIN(precio) AS minimo, MAX(precio) AS maximo
FROM productos
GROUP BY categoria;

-- Valor de inventario por categoría
SELECT categoria, SUM(precio * stock) AS valor_total
FROM productos
GROUP BY categoria
ORDER BY valor_total DESC;

-- Múltiples columnas de agrupación
SELECT categoria, marca, COUNT(*) AS total, AVG(precio) AS promedio
FROM productos
GROUP BY categoria, marca;

-- HAVING: filtrar grupos (no filas)
SELECT categoria, COUNT(*) AS total
FROM productos
GROUP BY categoria
HAVING COUNT(*) > 5;

-- HAVING con agregación
SELECT categoria, AVG(precio) AS promedio
FROM productos
GROUP BY categoria
HAVING AVG(precio) > 500;

-- WHERE + GROUP BY + HAVING
SELECT categoria, COUNT(*) AS total, SUM(precio * stock) AS valor
FROM productos
WHERE stock > 0
GROUP BY categoria
HAVING valor > 10000
ORDER BY valor DESC;
```

### Orden de ejecución de una consulta

```sql
SELECT categoria, COUNT(*) AS total      -- 5. SELECT (proyectar columnas)
FROM productos                            -- 1. FROM (tabla fuente)
WHERE stock > 0                           -- 2. WHERE (filtrar filas)
GROUP BY categoria                        -- 3. GROUP BY (agrupar)
HAVING total > 5                          -- 4. HAVING (filtrar grupos)
ORDER BY total DESC                       -- 6. ORDER BY (ordenar)
LIMIT 10;                                 -- 7. LIMIT (limitar resultados)
```

> Recuerda este orden lógico: FROM → WHERE → GROUP BY → HAVING → SELECT → ORDER BY → LIMIT.
> Por eso en HAVING puedes usar alias de agregaciones, pero en WHERE no.

---

## 6. JOINs

### Tipos de JOIN

```
  INNER JOIN         LEFT JOIN          RIGHT JOIN         FULL OUTER*
  ┌─────┬─────┐      ┌─────┬─────┐      ┌─────┬─────┐      ┌─────┬─────┐
  │  A  │  B  │      │  A  │  B  │      │  A  │  B  │      │  A  │  B  │
  │ ░░░▓│▓░░░ │      │ ░░░▓│▓░░░ │      │ ░░░▓│▓░░░ │      │ ░░░▓│▓░░░ │
  │     │     │      │ ░░░ │NULL │      │NULL │     │      │ ░░░ │NULL │
  └─────┴─────┘      └─────┴─────┘      └─────┴─────┘      │NULL │     │
                                                            └─────┴─────┘
  (solo intersección) (todo A + B si hay) (todo B + A si hay) (todo A + todo B)
  * FULL OUTER JOIN no existe en MySQL, se simula con UNION
```

### INNER JOIN

```sql
-- Productos con su categoría
SELECT p.nombre, p.precio, c.nombre AS categoria
FROM productos p
INNER JOIN categorias c ON p.categoria_id = c.id;

-- Three-way join
SELECT p.nombre, c.nombre AS categoria, m.nombre AS marca
FROM productos p
INNER JOIN categorias c ON p.categoria_id = c.id
INNER JOIN marcas m ON p.marca_id = m.id;

-- JOIN con condiciones adicionales
SELECT p.nombre, p.precio
FROM productos p
INNER JOIN categorias c ON p.categoria_id = c.id
WHERE c.nombre = 'electronica' AND p.stock > 0;

-- SELF JOIN: empleados y su jefe
SELECT e.nombre AS empleado, j.nombre AS jefe
FROM empleados e
INNER JOIN empleados j ON e.jefe_id = j.id;
```

### LEFT JOIN

```sql
-- Todos los productos, incluso sin categoría
SELECT p.nombre, c.nombre AS categoria
FROM productos p
LEFT JOIN categorias c ON p.categoria_id = c.id;

-- Productos sin categoría
SELECT p.nombre
FROM productos p
LEFT JOIN categorias c ON p.categoria_id = c.id
WHERE c.id IS NULL;
```

### RIGHT JOIN

```sql
-- Todas las categorías, incluso sin productos
SELECT c.nombre AS categoria, p.nombre AS producto
FROM productos p
RIGHT JOIN categorias c ON p.categoria_id = c.id;
```

### FULL OUTER JOIN (simulado)

```sql
-- MySQL no soporta FULL OUTER JOIN. Se simula con UNION:
SELECT p.nombre, c.nombre AS categoria
FROM productos p
LEFT JOIN categorias c ON p.categoria_id = c.id
UNION
SELECT p.nombre, c.nombre AS categoria
FROM productos p
RIGHT JOIN categorias c ON p.categoria_id = c.id;
```

### CROSS JOIN (producto cartesiano)

```sql
-- Combina cada fila de A con cada fila de B
SELECT p.nombre, t.nombre AS tienda
FROM productos p
CROSS JOIN tiendas t;
-- Si hay 100 productos y 5 tiendas = 500 filas
```

### JOIN con USING (cuando las columnas se llaman igual)

```sql
-- Equivalente a ON p.categoria_id = c.categoria_id
SELECT p.nombre, c.nombre
FROM productos p
INNER JOIN categorias c USING (categoria_id);
```

### JOIN con múltiple condición

```sql
SELECT p.nombre, v.cantidad, v.fecha
FROM productos p
INNER JOIN ventas v ON p.id = v.producto_id AND v.cantidad > 10;
```

---

## 7. Subconsultas

### Subconsulta en WHERE

```sql
-- Productos más caros que el promedio
SELECT nombre, precio
FROM productos
WHERE precio > (SELECT AVG(precio) FROM productos);

-- Productos de categorías que tienen más de 10 items
SELECT nombre
FROM productos
WHERE categoria_id IN (
    SELECT categoria_id FROM productos GROUP BY categoria_id HAVING COUNT(*) > 10
);

-- Productos cuyo precio es mayor que TODOS los productos de 'ropa'
SELECT nombre, precio
FROM productos
WHERE precio > ALL (SELECT precio FROM productos WHERE categoria = 'ropa');

-- Productos cuyo precio es mayor que ALGÚN producto de 'ropa'
SELECT nombre, precio
FROM productos
WHERE precio > ANY (SELECT precio FROM productos WHERE categoria = 'ropa');
```

### Subconsulta en SELECT

```sql
-- Contar ventas por producto en el SELECT
SELECT
    p.nombre,
    p.precio,
    (SELECT COUNT(*) FROM ventas v WHERE v.producto_id = p.id) AS total_ventas
FROM productos p;
```

### Subconsulta en FROM (tabla derivada)

```sql
-- Top 3 productos más vendidos por categoría
SELECT categoria, nombre, total
FROM (
    SELECT
        p.categoria,
        p.nombre,
        SUM(v.cantidad) AS total,
        ROW_NUMBER() OVER (PARTITION BY p.categoria ORDER BY SUM(v.cantidad) DESC) AS rn
    FROM productos p
    JOIN ventas v ON p.id = v.producto_id
    GROUP BY p.categoria, p.nombre
) ranked
WHERE rn <= 3;
```

### Subconsulta correlacionada vs no correlacionada

```sql
-- No correlacionada: se ejecuta una sola vez
SELECT nombre FROM productos
WHERE categoria_id = (SELECT id FROM categorias WHERE nombre = 'electronica');

-- Correlacionada: se ejecuta una vez por cada fila de la consulta externa
SELECT p.nombre
FROM productos p
WHERE EXISTS (
    SELECT 1 FROM ventas v WHERE v.producto_id = p.id
);
```

### EXISTS / NOT EXISTS

```sql
-- Productos que tienen al menos una venta
SELECT p.nombre
FROM productos p
WHERE EXISTS (SELECT 1 FROM ventas v WHERE v.producto_id = p.id);

-- Productos que nunca se han vendido
SELECT p.nombre
FROM productos p
WHERE NOT EXISTS (SELECT 1 FROM ventas v WHERE v.producto_id = p.id);
```

---

## 8. Funciones de MySQL

### Funciones matemáticas

| Función | Descripción | Ejemplo |
|---|---|---|
| `ABS(x)` | Valor absoluto | `ABS(-5)` → 5 |
| `CEIL(x)` / `CEILING(x)` | Redondea hacia arriba | `CEIL(4.2)` → 5 |
| `FLOOR(x)` | Redondea hacia abajo | `FLOOR(4.8)` → 4 |
| `ROUND(x, d)` | Redondea a d decimales | `ROUND(4.567, 2)` → 4.57 |
| `TRUNCATE(x, d)` | Trunca a d decimales | `TRUNCATE(4.567, 2)` → 4.56 |
| `POWER(x, y)` | Potencia | `POWER(2, 10)` → 1024 |
| `SQRT(x)` | Raíz cuadrada | `SQRT(16)` → 4 |
| `MOD(x, y)` | Módulo / resto | `MOD(17, 5)` → 2 |
| `RAND()` | Número aleatorio 0-1 | `RAND()` → 0.7382... |
| `SIGN(x)` | Signo (-1, 0, 1) | `SIGN(-5)` → -1 |
| `GREATEST(...)` | Mayor de una lista | `GREATEST(3, 7, 1)` → 7 |
| `LEAST(...)` | Menor de una lista | `LEAST(3, 7, 1)` → 1 |
| `PI()` | Valor de pi | `PI()` → 3.141593 |

```sql
-- Número aleatorio entre 1 y 100
SELECT FLOOR(1 + RAND() * 100) AS aleatorio;

-- Ordenar aleatoriamente (útil para muestreo)
SELECT * FROM productos ORDER BY RAND() LIMIT 5;
```

### Funciones de texto

| Función | Descripción | Ejemplo |
|---|---|---|
| `LENGTH(s)` | Longitud en bytes | `LENGTH('hola')` → 4 |
| `CHAR_LENGTH(s)` | Longitud en caracteres | `CHAR_LENGTH('café')` → 4 |
| `UPPER(s)` / `UCASE(s)` | Mayúsculas | `UPPER('hola')` → HOLA |
| `LOWER(s)` / `LCASE(s)` | Minúsculas | `LOWER('HOLA')` → hola |
| `SUBSTRING(s, pos, len)` | Subcadena | `SUBSTRING('hola', 2, 2)` → ol |
| `LEFT(s, n)` | Primeros n caracteres | `LEFT('hola', 2)` → ho |
| `RIGHT(s, n)` | Últimos n caracteres | `RIGHT('hola', 2)` → la |
| `TRIM(s)` | Quita espacios extremos | `TRIM('  hola  ')` → hola |
| `LTRIM(s)` | Quita espacios izquierda | `LTRIM('  hola')` → hola |
| `RTRIM(s)` | Quita espacios derecha | `RTRIM('hola  ')` → hola |
| `REPLACE(s, old, new)` | Reemplaza | `REPLACE('hola', 'o', '0')` → h0la |
| `REVERSE(s)` | Invierte | `REVERSE('hola')` → aloh |
| `CONCAT(...)` | Concatena | `CONCAT('a', 'b')` → ab |
| `CONCAT_WS(sep, ...)` | Concatena con separador | `CONCAT_WS('-', 'a', 'b')` → a-b |
| `LPAD(s, len, pad)` | Rellena izquierda | `LPAD('5', 3, '0')` → 005 |
| `RPAD(s, len, pad)` | Rellena derecha | `RPAD('5', 3, '0')` → 500 |
| `INSTR(s, sub)` | Posición de subcadena | `INSTR('hola', 'la')` → 3 |
| `LOCATE(sub, s)` | Posición de subcadena | `LOCATE('la', 'hola')` → 3 |
| `SUBSTRING_INDEX(s, d, n)` | Divide por delimitador | `SUBSTRING_INDEX('a,b,c', ',', 2)` → a,b |

```sql
-- Generar SKU a partir del nombre
SELECT UPPER(SUBSTRING(nombre, 1, 3)) AS sku FROM productos;

-- Iniciales
SELECT
    SUBSTRING_INDEX(nombre, ' ', 1) AS primer_nombre,
    TRIM(SUBSTRING(nombre, LENGTH(SUBSTRING_INDEX(nombre, ' ', 1)) + 1)) AS resto
FROM clientes;

-- Rellenar ceros a la izquierda
SELECT LPAD(id, 5, '0') AS codigo FROM productos;
```

### Funciones de fecha y hora

| Función | Descripción | Ejemplo |
|---|---|---|
| `NOW()` | Fecha y hora actuales | `NOW()` → 2024-01-15 14:30:00 |
| `CURDATE()` / `CURRENT_DATE` | Fecha actual | `CURDATE()` → 2024-01-15 |
| `CURTIME()` / `CURRENT_TIME` | Hora actual | `CURTIME()` → 14:30:00 |
| `SYSDATE()` | Fecha/hora en el momento exacto | `SYSDATE()` |
| `YEAR(d)` | Año de una fecha | `YEAR('2024-01-15')` → 2024 |
| `MONTH(d)` | Mes (1-12) | `MONTH('2024-01-15')` → 1 |
| `DAY(d)` / `DAYOFMONTH(d)` | Día del mes | `DAY('2024-01-15')` → 15 |
| `DAYNAME(d)` | Nombre del día | `DAYNAME('2024-01-15')` → Monday |
| `MONTHNAME(d)` | Nombre del mes | `MONTHNAME('2024-01-15')` → January |
| `DAYOFWEEK(d)` | Día de la semana (1=domingo) | `DAYOFWEEK('2024-01-15')` → 2 |
| `DAYOFYEAR(d)` | Día del año (1-366) | `DAYOFYEAR('2024-01-15')` → 15 |
| `HOUR(t)` | Hora | `HOUR('14:30:00')` → 14 |
| `MINUTE(t)` | Minuto | `MINUTE('14:30:00')` → 30 |
| `SECOND(t)` | Segundo | `SECOND('14:30:45')` → 45 |
| `DATE(d)` | Extrae la fecha | `DATE('2024-01-15 14:30')` → 2024-01-15 |
| `TIME(d)` | Extrae la hora | `TIME('2024-01-15 14:30')` → 14:30:00 |
| `DATE_FORMAT(d, fmt)` | Formatea fecha | Ver abajo |
| `STR_TO_DATE(s, fmt)` | Convierte texto a fecha | Ver abajo |
| `DATE_ADD(d, INTERVAL)` | Suma intervalo | Ver abajo |
| `DATE_SUB(d, INTERVAL)` | Resta intervalo | Ver abajo |
| `DATEDIFF(d1, d2)` | Diferencia en días | `DATEDIFF('2024-02-01', '2024-01-01')` → 31 |
| `TIMESTAMPDIFF(unit, d1, d2)` | Diferencia en unidad | Ver abajo |
| `UNIX_TIMESTAMP()` | Timestamp Unix | `UNIX_TIMESTAMP()` → 1705320600 |
| `FROM_UNIXTIME(ts)` | Unix a fecha | `FROM_UNIXTIME(1705320600)` |
| `LAST_DAY(d)` | Último día del mes | `LAST_DAY('2024-02-15')` → 2024-02-29 |

```sql
-- DATE_FORMAT: formatear fechas
SELECT DATE_FORMAT(NOW(), '%d/%m/%Y') AS fecha;           -- 15/01/2024
SELECT DATE_FORMAT(NOW(), '%W, %d de %M de %Y') AS fecha; -- Monday, 15 de January de 2024
SELECT DATE_FORMAT(NOW(), '%H:%i:%s') AS hora;            -- 14:30:00

-- STR_TO_DATE: parsear fechas
SELECT STR_TO_DATE('15/01/2024', '%d/%m/%Y') AS fecha;
SELECT STR_TO_DATE('15-Ene-2024', '%d-%b-%Y') AS fecha;

-- DATE_ADD / DATE_SUB con INTERVAL
SELECT DATE_ADD(NOW(), INTERVAL 7 DAY);        -- +7 días
SELECT DATE_ADD(NOW(), INTERVAL 3 MONTH);        -- +3 meses
SELECT DATE_ADD(NOW(), INTERVAL -1 YEAR);       -- -1 año
SELECT DATE_SUB(NOW(), INTERVAL 2 HOUR);        -- -2 horas
SELECT NOW() + INTERVAL 30 MINUTE;               -- sintaxis alternativa

-- TIMESTAMPDIFF: diferencia precisa
SELECT TIMESTAMPDIFF(YEAR, '1990-05-15', NOW()) AS edad;
SELECT TIMESTAMPDIFF(DAY, fecha_pedido, fecha_entrega) AS dias_envio;
SELECT TIMESTAMPDIFF(HOUR, login_time, logout_time) AS horas_sesion;

-- Últimos 30 días
SELECT * FROM ventas WHERE fecha >= DATE_SUB(CURDATE(), INTERVAL 30 DAY);

-- Ventas de este mes
SELECT * FROM ventas WHERE YEAR(fecha) = YEAR(CURDATE()) AND MONTH(fecha) = MONTH(CURDATE());
```

### Funciones de agregación

| Función | Descripción |
|---|---|
| `COUNT(*)` | Cuenta todas las filas |
| `COUNT(col)` | Cuenta filas no NULL de la columna |
| `COUNT(DISTINCT col)` | Cuenta valores únicos no NULL |
| `SUM(col)` | Suma de valores |
| `AVG(col)` | Promedio (ignora NULL) |
| `MIN(col)` | Valor mínimo |
| `MAX(col)` | Valor máximo |
| `GROUP_CONCAT(col)` | Concatena valores del grupo |
| `STDDEV(col)` | Desviación estándar |
| `VARIANCE(col)` | Varianza |

```sql
-- GROUP_CONCAT: concatenar valores de un grupo
SELECT categoria, GROUP_CONCAT(nombre SEPARATOR ', ') AS productos
FROM productos
GROUP BY categoria;

-- GROUP_CONCAT con orden y límite
SELECT categoria, GROUP_CONCAT(nombre ORDER BY precio DESC SEPARATOR ' | ') AS top_productos
FROM productos
GROUP BY categoria;

-- GROUP_CONCAT con DISTINCT
SELECT categoria, GROUP_CONCAT(DISTINCT marca) AS marcas
FROM productos
GROUP BY categoria;

-- COUNT vs COUNT(col)
SELECT
    COUNT(*) AS total_filas,           -- cuenta todas las filas
    COUNT(descripcion) AS con_descripcion,  -- ignora NULL
    COUNT(DISTINCT categoria) AS categorias_unicas
FROM productos;
```

---

## 9. Control de flujo

### IF

```sql
-- IF(condicion, valor_si_verdadero, valor_si_falso)
SELECT nombre, IF(stock > 0, 'Disponible', 'Agotado') AS estado FROM productos;

-- IF anidado
SELECT nombre,
    IF(precio > 1000, 'Premium',
        IF(precio > 500, 'Medio', 'Económico')) AS rango
FROM productos;
```

### IFNULL y COALESCE

```sql
-- IFNULL(col, valor_por_defecto): solo 2 argumentos
SELECT nombre, IFNULL(descripcion, 'Sin descripción') AS descripcion FROM productos;

-- COALESCE(...): múltiples argumentos, devuelve el primero no NULL
SELECT
    nombre,
    COALESCE(telefono, email, 'Sin contacto') AS contacto
FROM clientes;

-- COALESCE es estándar SQL, IFNULL es específico de MySQL
```

### NULLIF

```sql
-- NULLIF(a, b): devuelve NULL si a = b, sino devuelve a
-- Útil para evitar división por cero
SELECT precio / NULLIF(descuento, 0) FROM productos;
-- Si descuento es 0, devuelve NULL en vez de error
```

### CASE

```sql
-- CASE buscado (como switch)
SELECT nombre, precio,
    CASE
        WHEN precio > 1000 THEN 'Premium'
        WHEN precio > 500  THEN 'Medio'
        WHEN precio > 100  THEN 'Bajo'
        ELSE 'Económico'
    END AS rango_precio
FROM productos;

-- CASE simple (compara un valor)
SELECT nombre,
    CASE categoria
        WHEN 'electronica' THEN 'Tecnología'
        WHEN 'ropa'        THEN 'Moda'
        WHEN 'hogar'       THEN 'Casa'
        ELSE 'Otros'
    END AS departamento
FROM productos;

-- CASE en agregación
SELECT
    SUM(CASE WHEN categoria = 'electronica' THEN 1 ELSE 0 END) AS total_electronica,
    SUM(CASE WHEN categoria = 'ropa' THEN 1 ELSE 0 END) AS total_ropa,
    SUM(CASE WHEN categoria = 'hogar' THEN 1 ELSE 0 END) AS total_hogar
FROM productos;

-- CASE en ORDER BY
SELECT * FROM productos
ORDER BY
    CASE WHEN stock = 0 THEN 1 ELSE 0 END,  -- agotados al final
    precio DESC;
```

---

## 10. CAST y CONVERT

```sql
-- CAST(expresion AS tipo)
SELECT CAST('123' AS SIGNED) AS numero;            -- texto a entero
SELECT CAST(3.99 AS DECIMAL(10,0)) AS entero;      -- decimal a entero
SELECT CAST(3.1416 AS DECIMAL(10,2)) AS redondeado; -- 3.14
SELECT CAST('2024-01-15' AS DATE) AS fecha;
SELECT CAST('14:30:00' AS TIME) AS hora;
SELECT CAST('2024-01-15 14:30:00' AS DATETIME) AS fecha_hora;
SELECT CAST(100 AS CHAR) AS texto;

-- CONVERT(expresion, tipo) — sintaxis alternativa
SELECT CONVERT('123', SIGNED) AS numero;
SELECT CONVERT('2024-01-15', DATE) AS fecha;

-- CONVERT con charset
SELECT CONVERT('ñandú' USING utf8mb4);

-- Tipos para CAST/CONVERT
-- BINARY, CHAR, DATE, DATETIME, TIME, DECIMAL, SIGNED, UNSIGNED, JSON
```

### Conversiones comunes

```sql
-- Entero a texto para concatenar
SELECT CONCAT('Precio: $', CAST(precio AS CHAR)) FROM productos;

-- Texto a fecha
SELECT * FROM pedidos WHERE CAST(fecha_texto AS DATE) > '2024-01-01';

-- Decimal a entero (trunca, no redondea)
SELECT CAST(4.99 AS UNSIGNED) AS entero;  -- 4

-- Número a BINARY para comparación binaria (case sensitive)
SELECT * FROM usuarios WHERE BINARY email = 'Admin@Example.com';
```

---

## 11. UNION, INTERSECT y EXCEPT

```sql
-- UNION: combinar resultados, elimina duplicados
SELECT nombre, email FROM clientes
UNION
SELECT nombre, email FROM proveedores;

-- UNION ALL: no elimina duplicados (más rápido)
SELECT nombre FROM productos_2023
UNION ALL
SELECT nombre FROM productos_2024;

-- MySQL 8.0+ soporta INTERSECT y EXCEPT
SELECT id FROM productos WHERE stock > 0
INTERSECT
SELECT producto_id FROM ventas WHERE fecha > '2024-01-01';

SELECT id FROM productos
EXCEPT
SELECT producto_id FROM ventas;
```

> Para `UNION` todas las consultas deben tener el mismo número de columnas con
> tipos compatibles. `UNION ALL` es más rápido porque no elimina duplicados.

---

## Conceptos clave

| Concepto | Definición |
|---|---|
| **JOIN** | Combina filas de dos o más tablas basándose en una condición |
| **INNER JOIN** | Solo filas que tienen match en ambas tablas |
| **LEFT JOIN** | Todas las filas de la izquierda + matches de la derecha |
| **Subconsulta** | Consulta dentro de otra consulta |
| **Subconsulta correlacionada** | Depende de la fila de la consulta externa |
| **GROUP BY** | Agrupa filas con valores comunes |
| **HAVING** | Filtra grupos, se ejecuta después de GROUP BY |
| **COALESCE** | Devuelve el primer valor no NULL de una lista |
| **CASE** | Estructura condicional tipo switch en SQL |
| **CAST** | Convierte un valor a otro tipo de dato |

---

## Errores comunes

### 1. Usar `= NULL` en lugar de `IS NULL`

```sql
-- ❌ Nunca devuelve True, NULL no es igual a nada
SELECT * FROM productos WHERE descripcion = NULL;

-- ✅ Correcto
SELECT * FROM productos WHERE descripcion IS NULL;
```

### 2. Confundir WHERE y HAVING

```sql
-- ❌ No se puede usar agregación en WHERE
SELECT categoria, COUNT(*) FROM productos WHERE COUNT(*) > 5 GROUP BY categoria;

-- ✅ HAVING filtra grupos
SELECT categoria, COUNT(*) FROM productos GROUP BY categoria HAVING COUNT(*) > 5;
```

### 3. Olvidar GROUP BY al mezclar columnas y agregaciones

```sql
-- ❌ Error: nombre no está en GROUP BY ni en función de agregación
SELECT categoria, nombre, COUNT(*) FROM productos GROUP BY categoria;

-- ✅ O agrupas por todas las columnas no agregadas
SELECT categoria, nombre, COUNT(*) FROM productos GROUP BY categoria, nombre;
```

### 4. Usar alias en WHERE

```sql
-- ❌ El alias no existe en WHERE (se ejecuta antes que SELECT)
SELECT precio * 2 AS doble FROM productos WHERE doble > 100;

-- ✅ Repite la expresión o usa HAVING
SELECT precio * 2 AS doble FROM productos HAVING doble > 100;
```

### 5. COUNT(col) no cuenta NULL

```sql
-- COUNT(descripcion) no cuenta filas con descripcion = NULL
-- Usa COUNT(*) para contar todas las filas
```

### 6. Diferencia entre LENGTH y CHAR_LENGTH

```sql
-- LENGTH cuenta bytes, CHAR_LENGTH cuenta caracteres
-- Para texto Unicode (emoji, caracteres multi-byte), usa CHAR_LENGTH
SELECT LENGTH('café');        -- 5 (é es 2 bytes en utf8mb4)
SELECT CHAR_LENGTH('café');   -- 4 (4 caracteres)
```

### 7. ORDER BY sin LIMIT en tablas grandes

```sql
-- ❌ Puede ser muy lento en tablas grandes
SELECT * FROM productos ORDER BY precio DESC;

-- ✅ Siempre usa LIMIT cuando solo necesitas top N
SELECT * FROM productos ORDER BY precio DESC LIMIT 10;
```

---

## Siguiente paso

Continúa con la [Guía 03 — Avanzado](03-avanzado.md) para aprender índices,
vistas, stored procedures, triggers, transacciones y más.
