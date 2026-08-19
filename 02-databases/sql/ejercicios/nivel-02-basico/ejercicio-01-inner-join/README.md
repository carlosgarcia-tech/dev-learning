# Ejercicio 07 — INNER JOIN

- **Nivel:** 2/5
- **Tema:** Básico de SQL
- **Tiempo estimado:** 25 minutos

## Enunciado

1. Une las tablas `pedidos` y `clientes`
2. Une `pedidos`, `detalle_pedido` y `productos`
3. Muestra: cliente, producto, cantidad, precio

## Requisitos

- [ ] La tabla/consulta se ajusta a lo pedido en el enunciado
- [ ] Las consultas devuelven los resultados esperados
- [ ] Los tests pasan: `bash test.sh`

## Solución

<details>
<summary>Mostrar solución</summary>

```sql
-- Pedidos con clientes
SELECT
    p.id AS pedido_id,
    c.nombre AS cliente,
    p.fecha,
    p.total
FROM pedidos p
INNER JOIN clientes c ON p.cliente_id = c.id;

-- Detalle completo
SELECT
    c.nombre AS cliente,
    pr.nombre AS producto,
    dp.cantidad,
    pr.precio,
    dp.cantidad * pr.precio AS subtotal
FROM pedidos p
INNER JOIN clientes c ON p.cliente_id = c.id
INNER JOIN detalle_pedido dp ON p.id = dp.pedido_id
INNER JOIN productos pr ON dp.producto_id = pr.id;
```

</details>
