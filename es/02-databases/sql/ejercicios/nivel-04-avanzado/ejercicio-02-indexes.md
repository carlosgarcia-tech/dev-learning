# Ejercicio 02 — Índices

- **Nivel:** 4/5
- **Tema:** CREATE INDEX, UNIQUE INDEX, EXPLAIN QUERY PLAN
- **Tiempo estimado:** 20 min

## Enunciado

Dada la tabla `pedidos`:

1. Crea un **índice compuesto** sobre `(cliente_id, fecha)` para acelerar los reportes por cliente y fecha.
2. Crea un **índice único** sobre `referencia` para garantizar que no se repita.
3. Ejecuta `EXPLAIN QUERY PLAN` sobre una consulta que filtre por `cliente_id` y comprueba en la salida que el motor usa el índice (debe aparecer `SEARCH ... USING INDEX`).

Nota: SQLite puede no usar el índice con pocas filas (elige scan). Si no lo usa, inserta más datos o ignora la elección del planificador: lo importante es entender la salida.

## Schema inicial

```sql
CREATE TABLE pedidos (
    id INTEGER PRIMARY KEY,
    referencia TEXT NOT NULL,
    cliente_id INTEGER NOT NULL,
    fecha DATE,
    total REAL
);

INSERT INTO pedidos (id, referencia, cliente_id, fecha, total) VALUES
    (1, 'REF-001', 10, '2024-01-05', 120.00),
    (2, 'REF-002', 20, '2024-01-05', 250.00),
    (3, 'REF-003', 10, '2024-01-06', 80.00),
    (4, 'REF-004', 30, '2024-01-07', 340.00),
    (5, 'REF-005', 20, '2024-01-08', 90.00);
```

## Requisitos

- [ ] La consulta devuelve el resultado esperado
- [ ] Ejecutarlo localmente (SQLite o PostgreSQL) y verificar

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Pista 1: `CREATE INDEX idx_pedidos_cliente_fecha ON pedidos (cliente_id, fecha);`
- Pista 2: `CREATE UNIQUE INDEX idx_pedidos_referencia ON pedidos (referencia);`
- Pista 3: En SQLite: `EXPLAIN QUERY PLAN SELECT * FROM pedidos WHERE cliente_id = 10;` — busca `SEARCH pedidos USING INDEX`.
- Pista 4: En PostgreSQL: `EXPLAIN SELECT ...` y busca `Index Scan` o `Bitmap Index Scan`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````sql
-- 1. Índice compuesto
CREATE INDEX idx_pedidos_cliente_fecha
ON pedidos (cliente_id, fecha);

-- 2. Índice único sobre referencia
CREATE UNIQUE INDEX idx_pedidos_referencia
ON pedidos (referencia);

-- 3. Ver el plan de ejecución (SQLite)
EXPLAIN QUERY PLAN
SELECT * FROM pedidos WHERE cliente_id = 10;

-- 3b. Ver el plan de ejecución (PostgreSQL)
-- EXPLAIN
-- SELECT * FROM pedidos WHERE cliente_id = 10;

-- Borrar índices si es necesario
-- DROP INDEX idx_pedidos_cliente_fecha;
-- DROP INDEX idx_pedidos_referencia;
````

</details>