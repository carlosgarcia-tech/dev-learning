# 02 — Consultas Básicas en SQL

## Objetivos

- [ ] Entender la sintaxis de SELECT
- [ ] Filtrar datos con WHERE
- [ ] Ordenar datos con ORDER BY
- [ ] Limitar resultados con LIMIT
- [ ] Usar operadores de comparación
- [ ] Usar operadores lógicos (AND, OR, NOT)
- [ ] Usar LIKE y wildcards
- [ ] Usar IN, BETWEEN, IS NULL

## Apuntes

### SELECT Básico

```sql
-- Seleccionar todas las columnas
SELECT * FROM clientes;

-- Seleccionar columnas específicas
SELECT nombre, email, telefono FROM clientes;

-- Seleccionar con alias
SELECT nombre AS nombre_completo, 
       email AS correo 
FROM clientes;

-- Seleccionar distintos valores
SELECT DISTINCT ciudad FROM clientes;

-- Seleccionar con expresión
SELECT nombre, precio, precio * 1.21 AS precio_con_iva 
FROM productos;
```

### WHERE - Filtrar

```sql
-- Comparaciones
SELECT * FROM productos WHERE precio > 100;
SELECT * FROM productos WHERE precio = 999.99;
SELECT * FROM productos WHERE precio != 0;
SELECT * FROM productos WHERE stock >= 5;

-- AND / OR
SELECT * FROM productos 
WHERE precio > 100 AND stock > 0;

SELECT * FROM productos 
WHERE precio < 50 OR precio > 1000;

-- NOT
SELECT * FROM productos 
WHERE NOT stock = 0;

-- BETWEEN (rango)
SELECT * FROM productos 
WHERE precio BETWEEN 100 AND 500;

-- IN (lista)
SELECT * FROM productos 
WHERE categoria IN ('Electrónica', 'Computadoras');

-- IS NULL / IS NOT NULL
SELECT * FROM productos 
WHERE descripcion IS NULL;

SELECT * FROM clientes 
WHERE telefono IS NOT NULL;
```

### LIKE - Búsqueda de Patrones

```sql
-- % - Cualquier cantidad de caracteres
SELECT * FROM clientes 
WHERE nombre LIKE 'Ana%';  -- Empieza con 'Ana'

SELECT * FROM clientes 
WHERE nombre LIKE '%Pérez';  -- Termina con 'Pérez'

SELECT * FROM clientes 
WHERE nombre LIKE '%María%';  -- Contiene 'María'

-- _ - Un solo carácter
SELECT * FROM productos 
WHERE nombre LIKE 'T_léfono';  -- 'Teléfono'

SELECT * FROM productos 
WHERE nombre LIKE '____';  -- 4 caracteres
```

### ORDER BY - Ordenar

```sql
-- Orden ascendente (default)
SELECT * FROM productos 
ORDER BY precio;

-- Orden descendente
SELECT * FROM productos 
ORDER BY precio DESC;

-- Múltiples columnas
SELECT * FROM productos 
ORDER BY categoria ASC, precio DESC;

-- Orden con NULLS
SELECT * FROM productos 
ORDER BY descripcion NULLS FIRST;
```

### LIMIT - Paginación

```sql
-- Limitar resultados
SELECT * FROM productos 
LIMIT 10;

-- Con offset (paginación)
SELECT * FROM productos 
ORDER BY id 
LIMIT 10 OFFSET 20;  -- Página 3 (10 por página)

-- Top N con subconsulta
SELECT * FROM productos 
ORDER BY precio DESC 
LIMIT 5;  -- Top 5 más caros
```

### CASE - Condicional

```sql
-- CASE simple
SELECT nombre, precio,
    CASE 
        WHEN precio < 100 THEN 'Barato'
        WHEN precio < 500 THEN 'Medio'
        WHEN precio < 1000 THEN 'Caro'
        ELSE 'Muy caro'
    END AS categoria_precio
FROM productos;

-- CASE con ELSE
SELECT nombre, stock,
    CASE 
        WHEN stock = 0 THEN 'Sin stock'
        WHEN stock < 5 THEN 'Poco stock'
        WHEN stock < 20 THEN 'Stock medio'
        ELSE 'Stock alto'
    END AS nivel_stock
FROM productos;
```

## Ejemplos de Código

```sql
-- Consulta compleja
SELECT 
    p.nombre AS producto,
    p.precio,
    c.nombre AS categoria,
    CASE 
        WHEN p.precio < 100 THEN 'Económico'
        WHEN p.precio < 500 THEN 'Asequible'
        ELSE 'Premium'
    END AS rango_precio,
    p.stock
FROM productos p
INNER JOIN categorias c ON p.categoria_id = c.id
WHERE p.stock > 0
  AND p.precio BETWEEN 50 AND 1000
  AND c.nombre IN ('Electrónica', 'Computadoras')
ORDER BY p.precio DESC
LIMIT 10;
```

## Ejercicios Relacionados

- [Ejercicio 02: WHERE y Orden](./ejercicios/nivel-01-fundamentos/ejercicio-02-where-y-orden/)
- [Ejercicio 05: Funciones Agregadas](./ejercicios/nivel-01-fundamentos/ejercicio-05-funciones-agregadas/)
- [Ejercicio 06: LIKE y Filtros](./ejercicios/nivel-01-fundamentos/ejercicio-06-like-y-filtros/)
