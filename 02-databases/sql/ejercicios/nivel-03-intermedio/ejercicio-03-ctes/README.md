# Ejercicio 15 — CTEs

- **Nivel:** 3/5
- **Tema:** Intermedio de SQL
- **Tiempo estimado:** 30 minutos

## Enunciado

1. Usa CTE para calcular ventas por mes
2. Usa CTE para calcular crecimiento mes a mes
3. Usa CTE recursiva para jerarquía de categorías

## Requisitos

- [ ] La tabla/consulta se ajusta a lo pedido en el enunciado
- [ ] Las consultas devuelven los resultados esperados
- [ ] Los tests pasan: `bash test.sh`

## Solución

<details>
<summary>Mostrar solución</summary>

```sql
-- Ventas por mes
WITH ventas_mes AS (
    SELECT
        strftime('%Y-%m', fecha) AS mes,
        SUM(total) AS total_ventas,
        COUNT(*) AS total_pedidos
    FROM pedidos
    GROUP BY strftime('%Y-%m', fecha)
)
SELECT * FROM ventas_mes ORDER BY mes;

-- Crecimiento mes a mes
WITH ventas_mes AS (
    SELECT
        strftime('%Y-%m', fecha) AS mes,
        SUM(total) AS total_ventas
    FROM pedidos
    GROUP BY strftime('%Y-%m', fecha)
)
SELECT
    mes,
    total_ventas,
    LAG(total_ventas) OVER (ORDER BY mes) AS mes_anterior,
    ROUND(
      (total_ventas - LAG(total_ventas) OVER (ORDER BY mes)) /
      LAG(total_ventas) OVER (ORDER BY mes) * 100, 2
    ) AS crecimiento_porcentual
FROM ventas_mes
ORDER BY mes;

-- Jerarquía de categorías (CTE recursiva)
WITH RECURSIVE jerarquia_categorias AS (
    SELECT
        id,
        nombre,
        parent_id,
        0 AS nivel
    FROM categorias
    WHERE parent_id IS NULL

    UNION ALL

    SELECT
        c.id,
        c.nombre,
        c.parent_id,
        jc.nivel + 1
    FROM categorias c
    INNER JOIN jerarquia_categorias jc ON c.parent_id = jc.id
)
SELECT * FROM jerarquia_categorias
ORDER BY nivel, nombre;
```

</details>
