# Ejercicio 10 — Subconsultas

- **Nivel:** 2/5
- **Tema:** Básico de SQL
- **Tiempo estimado:** 25 minutos

## Enunciado

1. Encuentra productos con precio mayor al promedio
2. Encuentra pedidos superiores al promedio
3. Encuentra el producto más caro por categoría

## Requisitos

- [ ] La tabla/consulta se ajusta a lo pedido en el enunciado
- [ ] Las consultas devuelven los resultados esperados
- [ ] Los tests pasan: `bash test.sh`

## Solución

<details>
<summary>Mostrar solución</summary>

```sql
-- Productos con precio mayor al promedio
SELECT * FROM productos
WHERE precio > (SELECT AVG(precio) FROM productos);

-- Pedidos mayores al promedio
SELECT * FROM pedidos
WHERE total > (SELECT AVG(total) FROM pedidos);

-- Producto más caro por categoría
SELECT
    p.nombre,
    p.precio,
    p.categoria_id
FROM productos p
WHERE p.precio = (
    SELECT MAX(precio)
    FROM productos
    WHERE categoria_id = p.categoria_id
);
```

</details>
