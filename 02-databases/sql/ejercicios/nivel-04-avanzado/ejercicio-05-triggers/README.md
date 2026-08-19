# Ejercicio 23 — Triggers

- **Nivel:** 4/5
- **Tema:** Avanzado de SQL
- **Tiempo estimado:** 35 minutos

## Enunciado

1. Crea trigger para actualizar total de pedido
2. Crea trigger para auditoría
3. Crea trigger para validación

## Requisitos

- [ ] La tabla/consulta se ajusta a lo pedido en el enunciado
- [ ] Las consultas devuelven los resultados esperados
- [ ] Los tests pasan: `bash test.sh`

## Solución

<details>
<summary>Mostrar solución</summary>

En SQLite cada trigger admite un único evento (`INSERT`, `UPDATE` o `DELETE`), no `OR` de varios como PostgreSQL, y no existe `TG_OP` ni `row_to_json`. Para la auditoría se guarda una representación de texto.

```sql
-- Trigger actualizar total (INSERT)
CREATE TRIGGER tr_actualizar_total_insert
AFTER INSERT ON detalle_pedido
BEGIN
    UPDATE pedidos
    SET total = COALESCE(
        (SELECT SUM(cantidad * precio_unitario)
         FROM detalle_pedido
         WHERE pedido_id = NEW.pedido_id),
        0)
    WHERE id = NEW.pedido_id;
END;

-- Trigger actualizar total (UPDATE): igual pero con NEW.pedido_id
CREATE TRIGGER tr_actualizar_total_update
AFTER UPDATE ON detalle_pedido
BEGIN
    UPDATE pedidos
    SET total = COALESCE(
        (SELECT SUM(cantidad * precio_unitario)
         FROM detalle_pedido
         WHERE pedido_id = NEW.pedido_id),
        0)
    WHERE id = NEW.pedido_id;
END;

-- Trigger actualizar total (DELETE): igual pero con OLD.pedido_id
CREATE TRIGGER tr_actualizar_total_delete
AFTER DELETE ON detalle_pedido
BEGIN
    UPDATE pedidos
    SET total = COALESCE(
        (SELECT SUM(cantidad * precio_unitario)
         FROM detalle_pedido
         WHERE pedido_id = OLD.pedido_id),
        0)
    WHERE id = OLD.pedido_id;
END;

-- Trigger auditoría (sin TG_OP: la acción se fija literalmente)
CREATE TABLE auditoria (
    id INTEGER PRIMARY KEY,
    tabla TEXT,
    accion TEXT,
    datos TEXT,
    fecha TEXT
);

CREATE TRIGGER tr_auditar_pedido
AFTER INSERT ON pedidos
BEGIN
    INSERT INTO auditoria (tabla, accion, datos, fecha)
    VALUES (
        'pedidos',
        'INSERT',
        'id=' || NEW.id || ', cliente_id=' || NEW.cliente_id || ', total=' || NEW.total,
        NEW.fecha
    );
END;
```

La demostración inserta/actualiza/borra líneas de `detalle_pedido` y comprueba que el total del pedido se recalcula solo, e inserta un pedido para ver el registro en `auditoria`.

</details>
