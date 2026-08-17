# Ejercicio 03 — CTEs (WITH)

- **Nivel:** 3/5
- **Tema:** Common Table Expressions, WITH
- **Tiempo estimado:** 20 min

## Enunciado

Dada la tabla `pedidos`, escribe las consultas usando **CTEs** (`WITH`):

1. Crea una CTE `total_por_cliente` que calcule la suma del importe por cada `cliente_id`. Luego, **fuera de la CTE**, muestra la fila del cliente con el mayor total.
2. Reutiliza la misma idea para mostrar **los 2 clientes con más gasto**, ordenados de mayor a menor.

Resultado esperado: la consulta 2 devuelve el cliente `2` (410) y el `1` (290).

## Schema inicial

```sql
CREATE TABLE pedidos (
    id INTEGER PRIMARY KEY,
    cliente_id INTEGER NOT NULL,
    importe REAL NOT NULL
);

INSERT INTO pedidos (id, cliente_id, importe) VALUES
    (1, 1, 120.00),
    (2, 2, 250.00),
    (3, 3, 90.00),
    (4, 1, 170.00),
    (5, 2, 160.00),
    (6, 3, 75.00);
```

## Requisitos

- [ ] La consulta devuelve el resultado esperado
- [ ] Ejecutarlo localmente (SQLite o PostgreSQL) y verificar
- [ ] Los tests pasan: `bash ejercicio-03-ctes-test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Pista 1: `WITH total_por_cliente AS (SELECT cliente_id, SUM(importe) AS total FROM pedidos GROUP BY cliente_id) SELECT ... FROM total_por_cliente ...`.
- Pista 2: Sobre la CTE, ordena por `total DESC` y usa `LIMIT 2`.
- Pista 3: La CTE se comporta como una tabla temporal que solo existe dentro de esa consulta.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````sql
-- 1. Cliente con mayor gasto total
WITH total_por_cliente AS (
    SELECT cliente_id, SUM(importe) AS total
    FROM pedidos
    GROUP BY cliente_id
)
SELECT cliente_id, total
FROM total_por_cliente
ORDER BY total DESC
LIMIT 1;

-- 2. Los 2 clientes con más gasto
WITH total_por_cliente AS (
    SELECT cliente_id, SUM(importe) AS total
    FROM pedidos
    GROUP BY cliente_id
)
SELECT cliente_id, total
FROM total_por_cliente
ORDER BY total DESC
LIMIT 2;
````

</details>