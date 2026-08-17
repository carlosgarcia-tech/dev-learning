# Ejercicio 05 — Triggers

- **Nivel:** 4/5
- **Tema:** CREATE TRIGGER, BEFORE/AFTER, automatización
- **Tiempo estimado:** 25 min

## Enunciado

> ⚠️ Los triggers tienen sintaxis distinta según el motor. El ejemplo funciona en **SQLite**. En PostgreSQL la sintaxis usa `CREATE TRIGGER` + `CREATE FUNCTION` como función disparadora.

Dadas las tablas `productos` y `stock_log`:

1. Crea un **trigger en SQLite** que, **después de cada `INSERT` o `UPDATE`** en `productos`, inserte una fila en `stock_log` registrando: el id del producto, la fecha/hora y la acción (`'INSERT'`/`'UPDATE'`).
2. Prueba el trigger: inserta un producto nuevo y modifica uno existente. Comprueba que `stock_log` tiene 2 entradas.

## Schema inicial

```sql
CREATE TABLE productos (
    id INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL,
    stock INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE stock_log (
    id INTEGER PRIMARY KEY,
    producto_id INTEGER,
    fecha TEXT DEFAULT (datetime('now')),
    accion TEXT
);

INSERT INTO productos (id, nombre, stock) VALUES
    (1, 'Camiseta', 20),
    (2, 'Pantalon', 15);
```

## Requisitos

- [ ] La consulta devuelve el resultado esperado
- [ ] Ejecutarlo localmente (SQLite o PostgreSQL) y verificar
- [ ] Los tests pasan: `bash ejercicio-05-triggers-test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Pista 1: En SQLite: `CREATE TRIGGER trg_log AFTER INSERT ON productos BEGIN INSERT INTO stock_log (producto_id, accion) VALUES (NEW.id, 'INSERT'); END;`
- Pista 2: Para el `UPDATE` usa otro trigger con `AFTER UPDATE` y `NEW.id`.
- Pista 3: `NEW` es el registro que se está insertando/actualizando.
- Pista 4: Prueba con `INSERT INTO productos (nombre, stock) VALUES ('Gorra', 5);` y `UPDATE productos SET stock = 10 WHERE id = 1;`

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````sql
-- Triggers en SQLite
CREATE TRIGGER trg_log_insert
AFTER INSERT ON productos
BEGIN
    INSERT INTO stock_log (producto_id, accion)
    VALUES (NEW.id, 'INSERT');
END;

CREATE TRIGGER trg_log_update
AFTER UPDATE ON productos
BEGIN
    INSERT INTO stock_log (producto_id, accion)
    VALUES (NEW.id, 'UPDATE');
END;

-- Pruebas
INSERT INTO productos (nombre, stock) VALUES ('Gorra', 5);
UPDATE productos SET stock = 10 WHERE id = 1;

-- Verificación: 2 filas en el log
SELECT * FROM stock_log;
````

</details>