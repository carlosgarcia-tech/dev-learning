# Ejercicio 21 — Transacciones

- **Nivel:** 4/5
- **Tema:** Avanzado de SQL
- **Tiempo estimado:** 30 minutos

## Enunciado

1. Crea una transacción para crear un pedido
2. Maneja errores con ROLLBACK
3. Usa SAVEPOINT
4. Aísla transacciones

## Requisitos

- [ ] La tabla/consulta se ajusta a lo pedido en el enunciado
- [ ] Las consultas devuelven los resultados esperados
- [ ] Los tests pasan: `bash test.sh`

## Solución

<details>
<summary>Mostrar solución</summary>

```sql
-- Transacción completa
BEGIN;

INSERT INTO pedidos (cliente_id, fecha, total, estado)
VALUES (1, '2024-01-10', 0, 'pendiente');

INSERT INTO detalle_pedido (pedido_id, producto_id, cantidad, precio_unitario)
VALUES (1, 1, 2, 299.99);

UPDATE productos SET stock = stock - 2 WHERE id = 1;

UPDATE pedidos
SET total = (SELECT SUM(cantidad * precio_unitario)
             FROM detalle_pedido
             WHERE pedido_id = 1)
WHERE id = 1;

COMMIT;

-- Con SAVEPOINT
BEGIN;

INSERT INTO pedidos (cliente_id, fecha, total, estado)
VALUES (2, '2024-01-12', 0, 'pendiente');

SAVEPOINT antes_detalle;

INSERT INTO detalle_pedido (pedido_id, producto_id, cantidad, precio_unitario)
VALUES (2, 1, 1, 299.99);

ROLLBACK TO SAVEPOINT antes_detalle;

COMMIT;
```

Nota: en SQLite no se usa `RETURNING id`; los IDs se controlan porque `pedidos` y `detalle_pedido` arrancan vacíos. Conviene activar `PRAGMA foreign_keys = ON;` para que las claves foráneas se apliquen.

</details>
