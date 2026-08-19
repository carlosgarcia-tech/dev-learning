# Ejercicio 14 — Window Functions

- **Nivel:** 3/5
- **Tema:** Intermedio de SQL
- **Tiempo estimado:** 30 minutos

## Enunciado

1. Ranking de productos por precio
2. Total acumulado de ventas por fecha
3. Promedio móvil de los últimos 3 pedidos
4. Producto más caro por categoría

> **Nota de corrección:** el enunciado original intentaba filtrar
> directamente con `WHERE ROW_NUMBER() OVER (...) = 1`, lo cual no es
> válido en SQL — las funciones de ventana no pueden usarse en la
> cláusula `WHERE`. La solución correcta envuelve la función de ventana
> en una subconsulta o CTE y filtra fuera de ella, como se muestra abajo.

## Requisitos

- [ ] La tabla/consulta se ajusta a lo pedido en el enunciado
- [ ] Las consultas devuelven los resultados esperados
- [ ] Los tests pasan: `bash test.sh`

## Solución

<details>
<summary>Mostrar solución</summary>

```sql
-- Ranking de productos
SELECT
    nombre,
    precio,
    RANK() OVER (ORDER BY precio DESC) AS ranking
FROM productos;

-- Total acumulado de ventas
SELECT
    fecha,
    total,
    SUM(total) OVER (ORDER BY fecha) AS total_acumulado
FROM pedidos;

-- Promedio móvil de los últimos 3 pedidos
SELECT
    fecha,
    total,
    AVG(total) OVER (
        ORDER BY fecha
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS promedio_movil_3
FROM pedidos;

-- Producto más caro por categoría (forma correcta, con CTE)
WITH productos_rankeados AS (
    SELECT
        nombre,
        categoria_id,
        precio,
        ROW_NUMBER() OVER (PARTITION BY categoria_id ORDER BY precio DESC) AS posicion
    FROM productos
)
SELECT nombre, categoria_id, precio
FROM productos_rankeados
WHERE posicion = 1;
```

</details>
