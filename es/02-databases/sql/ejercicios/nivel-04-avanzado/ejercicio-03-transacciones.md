# Ejercicio 03 — Transacciones

- **Nivel:** 4/5
- **Tema:** BEGIN, COMMIT, ROLLBACK, atomicidad
- **Tiempo estimado:** 20 min

## Enunciado

Dada la tabla `cuentas`, realiza una **transferencia bancaria**:

1. Dentro de una transacción (`BEGIN`), descuenta 150 de la cuenta `1` y añade 150 a la cuenta `2`. Haz `COMMIT` y verifica que la operación persiste.
2. Ahora simula un error: dentro de otra transacción descuenta 100 de la cuenta `1` y luego intenta actualizar la cuenta `999` (que no existe). Haz `ROLLBACK` y verifica que **ninguno** de los cambios se aplicó.

Saldo inicial: cuenta 1 → 1000, cuenta 2 → 500. Al final del ejercicio: cuenta 1 → 850, cuenta 2 → 650.

## Schema inicial

```sql
CREATE TABLE cuentas (
    id INTEGER PRIMARY KEY,
    titular TEXT NOT NULL,
    saldo REAL NOT NULL
);

INSERT INTO cuentas (id, titular, saldo) VALUES
    (1, 'Ana', 1000.00),
    (2, 'Luis', 500.00);
```

## Requisitos

- [ ] La consulta devuelve el resultado esperado
- [ ] Ejecutarlo localmente (SQLite o PostgreSQL) y verificar

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Pista 1: `BEGIN; UPDATE ...; UPDATE ...; COMMIT;` — o `START TRANSACTION;`.
- Pista 2: Después del `UPDATE` que falla (0 filas afectadas en el id inexistente), ejecuta `ROLLBACK;` y luego `SELECT * FROM cuentas;`.
- Pista 3: Si en SQLite te aparece "cannot start a transaction within a transaction", asegúrate de haber cerrado la anterior con `COMMIT` o `ROLLBACK`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````sql
-- 1. Transferencia que se confirma
BEGIN;
UPDATE cuentas SET saldo = saldo - 150 WHERE id = 1;
UPDATE cuentas SET saldo = saldo + 150 WHERE id = 2;
COMMIT;

SELECT * FROM cuentas;  -- 850 y 650

-- 2. Transferencia que se revierte
BEGIN;
UPDATE cuentas SET saldo = saldo - 100 WHERE id = 1;
UPDATE cuentas SET saldo = saldo + 100 WHERE id = 999;  -- 0 filas afectadas
ROLLBACK;

SELECT * FROM cuentas;  -- sigue 850 y 650
````

</details>