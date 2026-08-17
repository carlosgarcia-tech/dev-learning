# Ejercicio 04 — Vistas (CREATE VIEW)

- **Nivel:** 3/5
- **Tema:** CREATE VIEW, consultas sobre vistas
- **Tiempo estimado:** 20 min

## Enunciado

Dadas las tablas `clientes` y `pedidos`:

1. Crea una vista llamada `v_pedidos_cliente` que muestre `cliente_id`, nombre del cliente y total de cada pedido.
2. Consulta la vista para mostrar **el total acumulado por cliente** (suma agrupada sobre la vista).
3. Crea una vista `v_resumen_clientes` que directamente muestre por cliente su nombre y el total gastado.

Resultado esperado: la consulta 2 y la vista 3 devuelven `Ana` (330), `Luis` (410), `Marta` (165).

## Schema inicial

```sql
CREATE TABLE clientes (
    id INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL
);

CREATE TABLE pedidos (
    id INTEGER PRIMARY KEY,
    cliente_id INTEGER,
    total REAL,
    FOREIGN KEY (cliente_id) REFERENCES clientes(id)
);

INSERT INTO clientes (id, nombre) VALUES
    (1, 'Ana'),
    (2, 'Luis'),
    (3, 'Marta');

INSERT INTO pedidos (id, cliente_id, total) VALUES
    (101, 1, 120.00),
    (102, 2, 250.00),
    (103, 3, 90.00),
    (104, 1, 210.00),
    (105, 2, 160.00),
    (106, 3, 75.00);
```

## Requisitos

- [ ] La consulta devuelve el resultado esperado
- [ ] Ejecutarlo localmente (SQLite o PostgreSQL) y verificar
- [ ] Los tests pasan: `bash ejercicio-04-vistas-test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Pista 1: `CREATE VIEW v_pedidos_cliente AS SELECT ...` seguido del `INNER JOIN`.
- Pista 2: Una vez creada, trata la vista como una tabla: `SELECT cliente_id, SUM(total) FROM v_pedidos_cliente GROUP BY cliente_id`.
- Pista 3: Puedes crear la segunda vista **sobre la primera**: `CREATE VIEW v_resumen_clientes AS SELECT ...`.
- Pista 4: Para borrar una vista: `DROP VIEW nombre`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````sql
-- 1. Vista de pedidos con cliente
CREATE VIEW v_pedidos_cliente AS
SELECT
    p.cliente_id,
    c.nombre AS cliente,
    p.total
FROM pedidos p
INNER JOIN clientes c ON c.id = p.cliente_id;

-- 2. Total por cliente consultando la vista
SELECT cliente_id, cliente, SUM(total) AS total_gastado
FROM v_pedidos_cliente
GROUP BY cliente_id
ORDER BY total_gastado DESC;

-- 3. Vista resumen por cliente (sobre la vista anterior)
CREATE VIEW v_resumen_clientes AS
SELECT
    cliente_id,
    cliente,
    SUM(total) AS total_gastado
FROM v_pedidos_cliente
GROUP BY cliente_id;

-- Verificación
SELECT * FROM v_resumen_clientes ORDER BY total_gastado DESC;
````

</details>