# Ejercicio 05 — Alias y CASE

- **Nivel:** 2/5
- **Tema:** Alias, CASE WHEN, expresiones calculadas
- **Tiempo estimado:** 15 min

## Enunciado

Dada la tabla `pedidos`:

1. Escribe una consulta que muestre `id`, `total` y una columna calculada `descuento` (el 15% del total), con su alias.
2. Escribe una consulta que clasifique cada pedido con `CASE`: `'barato'` si `total < 30`, `'medio'` si está entre 30 y 80, y `'caro'` si es mayor a 80. Usa el alias `rango`.

Resultado esperado: la consulta 2 muestra 6 pedidos con sus rangos (`caro`, `medio`, `barato`).

## Schema inicial

```sql
CREATE TABLE pedidos (
    id INTEGER PRIMARY KEY,
    producto TEXT NOT NULL,
    total REAL NOT NULL
);

INSERT INTO pedidos (id, producto, total) VALUES
    (1, 'Cuaderno', 12.50),
    (2, 'Teclado', 65.00),
    (3, 'Monitor', 149.00),
    (4, 'Boligrafo', 3.20),
    (5, 'Auriculares', 45.00),
    (6, 'Webcam', 89.00);
```

## Requisitos

- [ ] La consulta devuelve el resultado esperado
- [ ] Ejecutarlo localmente (SQLite o PostgreSQL) y verificar

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Pista 1: `total * 0.15 AS descuento`.
- Pista 2: Estructura `CASE WHEN condicion THEN 'valor' ELSE 'valor' END AS rango`.
- Pista 3: El `ELSE` es opcional pero recomendado para cubrir todos los casos.
- Pista 4: Puedes redondear el descuento con `ROUND(total * 0.15, 2)`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````sql
-- 1. Descuento del 15%
SELECT
    id,
    total,
    ROUND(total * 0.15, 2) AS descuento
FROM pedidos;

-- 2. Clasificación por precio
SELECT
    id,
    producto,
    total,
    CASE
        WHEN total < 30 THEN 'barato'
        WHEN total BETWEEN 30 AND 80 THEN 'medio'
        ELSE 'caro'
    END AS rango
FROM pedidos
ORDER BY total;
````

</details>