# Ejercicio 13 — Joins Múltiples

- **Nivel:** 3/5
- **Tema:** Intermedio de SQL
- **Tiempo estimado:** 30 minutos

## Enunciado

1. Reporte completo de pedidos con cliente, productos y cantidades
2. Resumen de ventas por cliente con total y promedio
3. Productos más vendidos con cantidad total

## Requisitos

- [ ] La tabla/consulta se ajusta a lo pedido en el enunciado
- [ ] Las consultas devuelven los resultados esperados
- [ ] Los tests pasan: `bash test.sh`

## Solución

<details>
<summary>Mostrar solución</summary>

```sql
-- Reporte completo
SELECT
    p.id AS pedido_id,
    p.fecha,
    c.nombre AS cliente,
    pr.nombre AS producto,
    dp.cantidad,
    pr.precio,
    dp.cantidad * pr.precio AS subtotal
FROM pedidos p
INNER JOIN clientes c ON p.cliente_id = c.id
INNER JOIN detalle_pedido dp ON p.id = dp.pedido_id
INNER JOIN productos pr ON dp.producto_id = pr.id
ORDER BY p.id, pr.nombre;

-- Resumen por cliente
SELECT
    c.nombre,
    COUNT(DISTINCT p.id) AS total_pedidos,
    SUM(dp.cantidad * pr.precio) AS total_gastado,
    ROUND(AVG(dp.cantidad * pr.precio), 2) AS promedio_por_producto
FROM clientes c
INNER JOIN pedidos p ON c.id = p.cliente_id
INNER JOIN detalle_pedido dp ON p.id = dp.pedido_id
INNER JOIN productos pr ON dp.producto_id = pr.id
GROUP BY c.id, c.nombre
ORDER BY total_gastado DESC;

-- Productos más vendidos
SELECT
    pr.nombre,
    SUM(dp.cantidad) AS total_vendido,
    SUM(dp.cantidad * pr.precio) AS total_ingresos
FROM productos pr
INNER JOIN detalle_pedido dp ON pr.id = dp.producto_id
GROUP BY pr.id, pr.nombre
ORDER BY total_vendido DESC
LIMIT 10;
```

</details>
