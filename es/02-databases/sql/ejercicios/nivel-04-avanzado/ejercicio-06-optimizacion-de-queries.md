# Ejercicio 06 — Optimización de queries

- **Nivel:** 4/5
- **Tema:** EXPLAIN, índices, reescritura de consultas
- **Tiempo estimado:** 25 min

## Enunciado

Dada una tabla `transacciones` (se insertan 50.000 filas), tu objetivo es optimizar la consulta:

```sql
SELECT * FROM transacciones WHERE cliente_id = 4242 AND fecha >= '2024-01-01';
```

Pasos:

1. Genera los datos de ejemplo (puedes usar una inserción con `WITH RECURSIVE` o un bucle en el lenguaje que uses).
2. Ejecuta `EXPLAIN QUERY PLAN` (SQLite) o `EXPLAIN` (PostgreSQL) **sin índice** y observa el `SCAN`.
3. Crea el índice apropiado y vuelve a ejecutar `EXPLAIN` para comprobar que ahora usa `SEARCH ... USING INDEX`.
4. Revisa qué otros cambios podrían acelerar la consulta (seleccionar solo las columnas necesarias en vez de `*`).

## Schema inicial

```sql
CREATE TABLE transacciones (
    id INTEGER PRIMARY KEY,
    cliente_id INTEGER NOT NULL,
    fecha DATE NOT NULL,
    importe REAL NOT NULL,
    detalle TEXT
);
```

Puedes poblar la tabla con esta técnica en SQLite (50.000 filas):

```sql
WITH RECURSIVE serie(n) AS (
    SELECT 1
    UNION ALL
    SELECT n + 1 FROM serie WHERE n < 50000
)
INSERT INTO transacciones (id, cliente_id, fecha, importe, detalle)
SELECT
    n,
    (n % 5000) + 1,
    date('2024-01-01', '+' || (n % 400) || ' days'),
    ROUND((n % 1000) / 10.0, 2),
    'detalle ' || n
FROM serie;
```

## Requisitos

- [ ] La consulta devuelve el resultado esperado
- [ ] Ejecutarlo localmente (SQLite o PostgreSQL) y verificar
- [ ] Los tests pasan: `bash ejercicio-06-optimizacion-de-queries-test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Pista 1: Sin índice, el plan dirá `SCAN transacciones`.
- Pista 2: El índice correcto es compuesto: `CREATE INDEX idx_trans_cliente_fecha ON transacciones (cliente_id, fecha);`.
- Pista 3: Con el índice, el plan dirá `SEARCH transacciones USING INDEX idx_trans_cliente_fecha (cliente_id=? AND fecha>?)`.
- Pista 4: En PostgreSQL, busca `Index Scan using idx_trans_cliente_fecha`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````sql
-- 0. Poblar datos (ver Schema inicial) y después:

-- 1. Sin índice: plan con SCAN
EXPLAIN QUERY PLAN
SELECT * FROM transacciones
WHERE cliente_id = 4242 AND fecha >= '2024-01-01';

-- 2. Crear índice compuesto
CREATE INDEX idx_trans_cliente_fecha
ON transacciones (cliente_id, fecha);

-- 3. Con índice: plan con SEARCH ... USING INDEX
EXPLAIN QUERY PLAN
SELECT * FROM transacciones
WHERE cliente_id = 4242 AND fecha >= '2024-01-01';

-- 4. Versión optimizada: solo las columnas necesarias
EXPLAIN QUERY PLAN
SELECT id, importe, fecha
FROM transacciones
WHERE cliente_id = 4242 AND fecha >= '2024-01-01';

-- PostgreSQL equivalente: EXPLAIN ANALYZE SELECT ...
````

</details>