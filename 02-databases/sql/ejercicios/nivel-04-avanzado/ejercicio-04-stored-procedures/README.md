# Ejercicio 22 — Stored Procedures

- **Nivel:** 4/5
- **Tema:** Avanzado de SQL
- **Tiempo estimado:** 35 minutos

## Enunciado

1. Crea procedimiento para actualizar stock
2. Crea función para calcular total de pedido
3. Crea procedimiento para reporte mensual

## Requisitos

- [ ] La tabla/consulta se ajusta a lo pedido en el enunciado
- [ ] Las consultas devuelven los resultados esperados
- [ ] Los tests pasan: `bash test.sh`

## Solución

<details>
<summary>Mostrar solución</summary>

SQLite no tiene `CREATE PROCEDURE`/`CREATE FUNCTION` (PL/pgSQL). Los mismos tres conceptos se resuelven con sentencias SQL directas sobre un pedido real:

```sql
-- 1) Crear un pedido real
INSERT INTO pedidos (id, cliente_id, fecha, total, estado)
VALUES (5, 2, '2024-01-15', 0, 'pendiente');

-- 2) Añadir su detalle
INSERT INTO detalle_pedido (pedido_id, producto_id, cantidad, precio_unitario)
VALUES (5, 1, 2, 999.99);

-- 3) Actualizar stock con validación (equivale a actualizar_stock)
SELECT CASE WHEN stock >= 2 THEN 'ok' ELSE 'insuficiente' END AS validacion_stock
FROM productos WHERE id = 1;

UPDATE productos
SET stock = stock - 2
WHERE id = 1 AND stock >= 2;

-- 4) Calcular el total del pedido (equivale a calcular_total_pedido)
UPDATE pedidos
SET total = (SELECT COALESCE(SUM(cantidad * precio_unitario), 0)
             FROM detalle_pedido
             WHERE pedido_id = 5)
WHERE id = 5;

-- 5) Reporte mensual (equivale a generar_reporte_mensual)
SELECT
    c.nombre AS cliente,
    COUNT(p.id) AS total_pedidos,
    COALESCE(SUM(p.total), 0) AS total_gastado
FROM clientes c
INNER JOIN pedidos p ON c.id = p.cliente_id
WHERE strftime('%m', p.fecha) = '01'
  AND strftime('%Y', p.fecha) = '2024'
GROUP BY c.id, c.nombre
ORDER BY total_gastado DESC;
```

La lógica que en PostgreSQL viviría en procedimientos se puede encapsular también con `CREATE TRIGGER` (ver ejercicio 23).

</details>
