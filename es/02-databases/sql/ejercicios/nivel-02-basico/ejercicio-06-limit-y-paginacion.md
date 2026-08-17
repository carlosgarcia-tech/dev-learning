# Ejercicio 06 — LIMIT y paginación

- **Nivel:** 2/5
- **Tema:** LIMIT, OFFSET, paginación
- **Tiempo estimado:** 15 min

## Enunciado

Dada la tabla `articulos`, queremos paginar el listado de a **3 artículos por página**, ordenados por `id`:

1. Escribe la consulta para la **página 1** (primeros 3).
2. Escribe la consulta para la **página 2** (siguientes 3).
3. Escribe la consulta para la **página 3** (últimos 2, la página queda incompleta).

Resultado esperado: página 1 → ids 1,2,3 · página 2 → ids 4,5,6 · página 3 → ids 7,8.

## Schema inicial

```sql
CREATE TABLE articulos (
    id INTEGER PRIMARY KEY,
    titulo TEXT NOT NULL,
    autor TEXT
);

INSERT INTO articulos (id, titulo, autor) VALUES
    (1, 'Introducción a SQL', 'Ana'),
    (2, 'Joins explicados', 'Luis'),
    (3, 'Índices en la práctica', 'Marta'),
    (4, 'Transacciones y ACID', 'Carlos'),
    (5, 'Window functions', 'Lucia'),
    (6, 'CTEs en profundidad', 'Pedro'),
    (7, 'Normalización', 'Ana'),
    (8, 'Optimización de queries', 'Luis');
```

## Requisitos

- [ ] La consulta devuelve el resultado esperado
- [ ] Ejecutarlo localmente (SQLite o PostgreSQL) y verificar

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Pista 1: `LIMIT 3` sin `OFFSET` (o `OFFSET 0`).
- Pista 2: Para la página N con tamaño 3, `OFFSET = (N-1) * 3`, así que página 2 → `OFFSET 3`.
- Pista 3: Página 3 → `LIMIT 3 OFFSET 6`, devuelve las filas que queden.
- Ordena siempre con `ORDER BY id` para que la paginación sea estable.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````sql
-- Página 1: filas 1-3
SELECT id, titulo
FROM articulos
ORDER BY id
LIMIT 3 OFFSET 0;

-- Página 2: filas 4-6
SELECT id, titulo
FROM articulos
ORDER BY id
LIMIT 3 OFFSET 3;

-- Página 3: filas 7-8
SELECT id, titulo
FROM articulos
ORDER BY id
LIMIT 3 OFFSET 6;
````

</details>