# 04 — Funciones y Agregaciones en SQL

## Objetivos

- [ ] Usar funciones de agregación (COUNT, SUM, AVG, MAX, MIN)
- [ ] Agrupar datos con GROUP BY
- [ ] Filtrar grupos con HAVING
- [ ] Usar funciones de fecha/hora
- [ ] Usar funciones de string
- [ ] Usar funciones de conversión
- [ ] Usar funciones de ventana (Window Functions)

## Apuntes

### Funciones de Agregación

```sql
-- COUNT - Contar registros
SELECT COUNT(*) FROM clientes;
SELECT COUNT(email) FROM clientes;  -- No cuenta NULL
SELECT COUNT(DISTINCT ciudad) FROM clientes;

-- SUM - Sumar valores
SELECT SUM(total) FROM pedidos;
SELECT SUM(precio * cantidad) FROM detalle_pedido;

-- AVG - Promedio
SELECT AVG(precio) FROM productos;
SELECT AVG(DISTINCT precio) FROM productos;

-- MAX / MIN - Máximo y mínimo
SELECT MAX(precio), MIN(precio) FROM productos;
SELECT MAX(fecha) FROM pedidos;  -- Último pedido
```

### GROUP BY - Agrupar

```sql
-- Agrupar por una columna
SELECT 
    categoria,
    COUNT(*) AS total_productos,
    AVG(precio) AS precio_promedio
FROM productos
GROUP BY categoria;

-- Agrupar por múltiples columnas
SELECT 
    categoria,
    proveedor,
    COUNT(*) AS total,
    SUM(stock) AS stock_total
FROM productos
GROUP BY categoria, proveedor;
```

### HAVING - Filtrar Grupos

```sql
-- HAVING (filtra después de GROUP BY)
SELECT 
    cliente_id,
    COUNT(*) AS total_pedidos,
    SUM(total) AS total_gastado
FROM pedidos
GROUP BY cliente_id
HAVING COUNT(*) >= 3  -- Clientes con 3+ pedidos
   AND SUM(total) > 1000;

-- HAVING con funciones de agregación
SELECT 
    categoria,
    AVG(precio) AS precio_promedio
FROM productos
GROUP BY categoria
HAVING AVG(precio) > 500;
```

### Funciones de Fecha/Hora

```sql
-- Funciones de fecha
SELECT CURRENT_DATE;   -- Fecha actual
SELECT CURRENT_TIME;   -- Hora actual
SELECT CURRENT_TIMESTAMP;  -- Fecha y hora actual

-- Extraer partes
SELECT 
    fecha,
    EXTRACT(YEAR FROM fecha) AS año,
    EXTRACT(MONTH FROM fecha) AS mes,
    EXTRACT(DAY FROM fecha) AS día,
    EXTRACT(DOW FROM fecha) AS dia_semana
FROM pedidos;

-- Formatear
SELECT TO_CHAR(fecha, 'YYYY-MM-DD') FROM pedidos;
SELECT TO_CHAR(fecha, 'DD/MM/YYYY') FROM pedidos;

-- Intervalos
SELECT fecha + INTERVAL '1 day' FROM pedidos;
SELECT fecha - INTERVAL '1 month' FROM pedidos;

-- Date trunc
SELECT DATE_TRUNC('month', fecha) FROM pedidos;

-- Funciones de fecha
SELECT AGE(CURRENT_DATE, fecha_nacimiento) FROM personas;
SELECT NOW() - fecha_creacion FROM registros;
```

### Funciones de String

```sql
-- Concatenación
SELECT CONCAT(nombre, ' ', apellido) AS nombre_completo FROM personas;
SELECT nombre || ' ' || apellido AS nombre_completo FROM personas;

-- Longitud
SELECT LENGTH(nombre) FROM personas;

-- Mayúsculas/Minúsculas
SELECT UPPER(nombre), LOWER(apellido) FROM personas;

-- Substring
SELECT SUBSTRING(nombre, 1, 3) FROM personas;  -- Primeros 3 caracteres
SELECT SUBSTRING(email, POSITION('@' IN email) + 1) AS dominio FROM personas;

-- Reemplazo
SELECT REPLACE(nombre, 'á', 'a') FROM personas;

-- Trim
SELECT TRIM('  Hola  ') AS texto_limpio;
SELECT LTRIM('  Hola') AS sin_espacios_izq;
SELECT RTRIM('Hola  ') AS sin_espacios_der;

-- Split
SELECT SPLIT_PART(email, '@', 1) AS usuario FROM personas;
```

### Window Functions (Funciones de Ventana)

```sql
-- ROW_NUMBER - Número de fila
SELECT 
    nombre,
    precio,
    ROW_NUMBER() OVER (ORDER BY precio DESC) AS ranking
FROM productos;

-- RANK / DENSE_RANK
SELECT 
    nombre,
    precio,
    RANK() OVER (ORDER BY precio DESC) AS rank,
    DENSE_RANK() OVER (ORDER BY precio DESC) AS dense_rank
FROM productos;

-- LAG / LEAD - Valores anterior/siguiente
SELECT 
    fecha,
    total,
    LAG(total) OVER (ORDER BY fecha) AS total_anterior,
    LEAD(total) OVER (ORDER BY fecha) AS total_siguiente
FROM pedidos;

-- SUM() OVER - Acumulado
SELECT 
    fecha,
    total,
    SUM(total) OVER (ORDER BY fecha) AS total_acumulado
FROM pedidos;

-- PARTITION BY - Agrupar en ventana
SELECT 
    cliente_id,
    fecha,
    total,
    ROW_NUMBER() OVER (PARTITION BY cliente_id ORDER BY fecha DESC) AS ultimo_pedido
FROM pedidos;

-- AVG() OVER - Móvil promedio
SELECT 
    fecha,
    total,
    AVG(total) OVER (ORDER BY fecha ROWS BETWEEN 3 PRECEDING AND CURRENT ROW) AS promedio_movil
FROM pedidos;
```

## Ejemplos de Código

```sql
-- Análisis de ventas
SELECT 
    DATE_TRUNC('month', fecha) AS mes,
    COUNT(*) AS total_pedidos,
    SUM(total) AS ingresos,
    AVG(total) AS ticket_promedio,
    COUNT(DISTINCT cliente_id) AS clientes_unicos
FROM pedidos
WHERE fecha >= DATE_TRUNC('year', CURRENT_DATE)
GROUP BY DATE_TRUNC('month', fecha)
ORDER BY mes DESC;
```

## Ejercicios Relacionados

- [Ejercicio 05: Funciones Agregadas](./ejercicios/nivel-01-fundamentos/ejercicio-05-funciones-agregadas/)
- [Ejercicio 09: GROUP BY y HAVING](./ejercicios/nivel-02-basico/ejercicio-03-group-by-y-having/)
- [Ejercicio 12: Window Functions](./ejercicios/nivel-03-intermedio/ejercicio-02-window-functions/)
