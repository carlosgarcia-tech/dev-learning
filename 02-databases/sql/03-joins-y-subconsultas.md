# 03 — Joins y Subconsultas en SQL

## Objetivos

- [ ] Entender los diferentes tipos de JOIN
- [ ] Usar INNER JOIN para relaciones
- [ ] Usar LEFT y RIGHT JOIN
- [ ] Usar FULL OUTER JOIN
- [ ] Usar SELF JOIN
- [ ] Escribir subconsultas
- [ ] Usar EXISTS y ANY

## Apuntes

### INNER JOIN

```sql
-- INNER JOIN básico
SELECT 
    pedidos.id,
    clientes.nombre,
    pedidos.fecha,
    pedidos.total
FROM pedidos
INNER JOIN clientes ON pedidos.cliente_id = clientes.id;

-- Con alias
SELECT 
    p.id,
    c.nombre,
    p.fecha,
    p.total
FROM pedidos p
INNER JOIN clientes c ON p.cliente_id = c.id;

-- Múltiples joins
SELECT 
    p.id AS pedido_id,
    c.nombre AS cliente,
    pr.nombre AS producto,
    dp.cantidad,
    pr.precio
FROM pedidos p
INNER JOIN clientes c ON p.cliente_id = c.id
INNER JOIN detalle_pedido dp ON p.id = dp.pedido_id
INNER JOIN productos pr ON dp.producto_id = pr.id;
```

### LEFT JOIN

```sql
-- LEFT JOIN (todos los clientes, tengan pedidos o no)
SELECT 
    c.nombre,
    c.email,
    p.id AS pedido_id,
    p.total
FROM clientes c
LEFT JOIN pedidos p ON c.id = p.cliente_id;

-- LEFT JOIN con filtro de nulos
SELECT 
    c.nombre,
    c.email
FROM clientes c
LEFT JOIN pedidos p ON c.id = p.cliente_id
WHERE p.id IS NULL;  -- Clientes sin pedidos
```

### RIGHT JOIN

```sql
-- RIGHT JOIN (todos los pedidos, tengan cliente o no)
SELECT 
    c.nombre,
    p.id AS pedido_id,
    p.total
FROM clientes c
RIGHT JOIN pedidos p ON c.id = p.cliente_id;
```

### FULL OUTER JOIN

```sql
-- FULL OUTER JOIN (todos los registros de ambas tablas)
SELECT 
    c.nombre,
    p.id AS pedido_id,
    p.total
FROM clientes c
FULL OUTER JOIN pedidos p ON c.id = p.cliente_id;
```

### SELF JOIN

```sql
-- SELF JOIN (unir tabla consigo misma)
SELECT 
    e1.nombre AS empleado,
    e2.nombre AS jefe
FROM empleados e1
LEFT JOIN empleados e2 ON e1.jefe_id = e2.id;

-- Jerarquía de categorías
SELECT 
    c1.nombre AS categoria,
    c2.nombre AS subcategoria
FROM categorias c1
LEFT JOIN categorias c2 ON c1.id = c2.parent_id
WHERE c1.parent_id IS NULL;
```

### Subconsultas

```sql
-- Subconsulta en WHERE
SELECT * FROM productos
WHERE precio > (SELECT AVG(precio) FROM productos);

-- Subconsulta en FROM (como tabla)
SELECT 
    categoria,
    AVG(precio) AS precio_promedio
FROM (
    SELECT 
        categoria,
        precio
    FROM productos
    WHERE stock > 0
) AS productos_disponibles
GROUP BY categoria;

-- Subconsulta en SELECT
SELECT 
    nombre,
    precio,
    (SELECT AVG(precio) FROM productos) AS precio_promedio,
    precio - (SELECT AVG(precio) FROM productos) AS diferencia
FROM productos;

-- Subconsulta correlacionada
SELECT 
    c.nombre,
    (SELECT COUNT(*) FROM pedidos p WHERE p.cliente_id = c.id) AS total_pedidos
FROM clientes c;
```

### EXISTS / NOT EXISTS

```sql
-- EXISTS (clientes con pedidos)
SELECT * FROM clientes c
WHERE EXISTS (
    SELECT 1 FROM pedidos p 
    WHERE p.cliente_id = c.id
);

-- NOT EXISTS (clientes sin pedidos)
SELECT * FROM clientes c
WHERE NOT EXISTS (
    SELECT 1 FROM pedidos p 
    WHERE p.cliente_id = c.id
);
```

### ANY / ALL

```sql
-- ANY (mayor que al menos un producto)
SELECT * FROM productos
WHERE precio > ANY (
    SELECT precio FROM productos WHERE categoria = 'Electrónica'
);

-- ALL (mayor que todos los productos)
SELECT * FROM productos
WHERE precio > ALL (
    SELECT precio FROM productos WHERE categoria = 'Electrónica'
);
```

## Ejemplos de Código

```sql
-- Reporte de ventas por cliente
SELECT 
    c.nombre,
    c.email,
    COUNT(p.id) AS total_pedidos,
    COALESCE(SUM(p.total), 0) AS total_gastado,
    COALESCE(AVG(p.total), 0) AS promedio_por_pedido,
    MAX(p.fecha) AS ultima_compra
FROM clientes c
LEFT JOIN pedidos p ON c.id = p.cliente_id
GROUP BY c.id, c.nombre, c.email
ORDER BY total_gastado DESC;
```

## Ejercicios Relacionados

- [Ejercicio 07: INNER JOIN](./ejercicios/nivel-02-basico/ejercicio-01-inner-join/)
- [Ejercicio 08: LEFT y RIGHT JOIN](./ejercicios/nivel-02-basico/ejercicio-02-left-y-right-join/)
- [Ejercicio 09: GROUP BY y HAVING](./ejercicios/nivel-02-basico/ejercicio-03-group-by-y-having/)
- [Ejercicio 10: Subconsultas](./ejercicios/nivel-02-basico/ejercicio-04-subconsultas/)
