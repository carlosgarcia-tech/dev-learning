# Ejercicio 04 — UPDATE y DELETE

- **Nivel:** 1/5
- **Tema:** UPDATE, DELETE, WHERE
- **Tiempo estimado:** 15 min

## Enunciado

Dada la tabla `pedidos`, realiza las siguientes operaciones **en orden**:

1. Sube un **10%** el total de todos los pedidos de la categoría `'electronica'`.
2. Cambia el `estado` de todos los pedidos del cliente `2` a `'enviado'`.
3. Elimina todos los pedidos con estado `'cancelado'`.

Resultado esperado al final: 5 pedidos (el cancelado se borró), y el pedido `'Tablet'` pasa de `300.00` a `330.00`.

## Schema inicial

```sql
CREATE TABLE pedidos (
    id INTEGER PRIMARY KEY,
    cliente_id INTEGER,
    producto TEXT NOT NULL,
    categoria TEXT,
    total REAL,
    estado TEXT
);

INSERT INTO pedidos (id, cliente_id, producto, categoria, total, estado) VALUES
    (1, 1, 'Libro', 'lectura', 25.00, 'entregado'),
    (2, 2, 'Tablet', 'electronica', 300.00, 'pendiente'),
    (3, 3, 'Auriculares', 'electronica', 80.00, 'enviado'),
    (4, 2, 'Teclado', 'informatica', 45.00, 'pendiente'),
    (5, 1, 'Monitor', 'electronica', 150.00, 'enviado'),
    (6, 4, 'Cable USB', 'informatica', 10.00, 'cancelado');
```

## Requisitos

- [ ] La consulta devuelve el resultado esperado
- [ ] Ejecutarlo localmente (SQLite o PostgreSQL) y verificar

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Pista 1: `SET total = total * 1.10` con `WHERE categoria = 'electronica'`.
- Pista 2: `SET estado = 'enviado'` con `WHERE cliente_id = 2`.
- Pista 3: `DELETE FROM pedidos WHERE estado = 'cancelado'`.
- Cuidado: revisa bien el `WHERE` antes de ejecutar, sobre todo en `UPDATE` y `DELETE`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````sql
-- 1. Subir 10% a electronica
UPDATE pedidos
SET total = total * 1.10
WHERE categoria = 'electronica';

-- 2. Marcar como enviado los pedidos del cliente 2
UPDATE pedidos
SET estado = 'enviado'
WHERE cliente_id = 2;

-- 3. Borrar cancelados
DELETE FROM pedidos
WHERE estado = 'cancelado';

-- Verificación
SELECT id, producto, total, estado FROM pedidos ORDER BY id;
````

</details>