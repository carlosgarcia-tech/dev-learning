# Ejercicio 24 — Optimización

- **Nivel:** 4/5
- **Tema:** Avanzado de SQL
- **Tiempo estimado:** 30 minutos

## Enunciado

1. Analiza consultas lentas con EXPLAIN
2. Optimiza una consulta con índices
3. Optimiza una consulta con subconsultas

## Requisitos

- [ ] La tabla/consulta se ajusta a lo pedido en el enunciado
- [ ] Las consultas devuelven los resultados esperados
- [ ] Los tests pasan: `bash test.sh`

## Solución

<details>
<summary>Mostrar solución</summary>

SQLite no tiene `EXPLAIN ANALYZE`; el plan de ejecución se consulta con `EXPLAIN QUERY PLAN` (antes del índice sale `SCAN` y después `SEARCH ... USING INDEX`).

```sql
-- Analizar consulta (sin índice)
EXPLAIN QUERY PLAN
SELECT * FROM pedidos
WHERE cliente_id = 1
  AND fecha > '2024-01-01';

-- Crear índice optimizado
CREATE INDEX idx_pedidos_cliente_fecha
ON pedidos(cliente_id, fecha);

-- Analizar consulta (con índice)
EXPLAIN QUERY PLAN
SELECT * FROM pedidos
WHERE cliente_id = 1
  AND fecha > '2024-01-01';

-- Optimizar con CTE
WITH pedidos_filtrados AS (
    SELECT * FROM pedidos
    WHERE fecha > '2024-01-01'
)
SELECT
    c.nombre,
    pf.id,
    pf.fecha,
    pf.total
FROM clientes c
INNER JOIN pedidos_filtrados pf ON c.id = pf.cliente_id
ORDER BY pf.id;

-- IN (más lento)
SELECT * FROM clientes
WHERE id IN (SELECT DISTINCT cliente_id FROM pedidos)
ORDER BY id;

-- EXISTS (normalmente más rápido)
SELECT * FROM clientes c
WHERE EXISTS (SELECT 1 FROM pedidos p WHERE p.cliente_id = c.id)
ORDER BY id;
```

</details>
