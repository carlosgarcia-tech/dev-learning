# Ejercicio 11 — ALIAS y CASE

- **Nivel:** 2/5
- **Tema:** Básico de SQL
- **Tiempo estimado:** 20 minutos

## Enunciado

1. Usa alias para columnas
2. Usa CASE para categorizar productos por precio
3. Usa CASE para categorizar stock

## Requisitos

- [ ] La tabla/consulta se ajusta a lo pedido en el enunciado
- [ ] Las consultas devuelven los resultados esperados
- [ ] Los tests pasan: `bash test.sh`

## Solución

<details>
<summary>Mostrar solución</summary>

```sql
-- Alias
SELECT
    nombre AS producto,
    precio AS precio_unitario,
    stock AS cantidad_disponible
FROM productos;

-- Categorizar por precio
SELECT
    nombre,
    precio,
    CASE
        WHEN precio < 100 THEN 'Económico'
        WHEN precio < 500 THEN 'Medio'
        ELSE 'Premium'
    END AS categoria_precio
FROM productos;

-- Categorizar stock
SELECT
    nombre,
    stock,
    CASE
        WHEN stock = 0 THEN 'Sin stock'
        WHEN stock < 5 THEN 'Bajo'
        WHEN stock < 20 THEN 'Medio'
        ELSE 'Alto'
    END AS nivel_stock
FROM productos;
```

</details>
