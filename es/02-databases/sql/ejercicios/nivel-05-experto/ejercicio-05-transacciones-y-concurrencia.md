# Ejercicio 05 — Transacciones y concurrencia

- **Nivel:** 5/5
- **Tema:** Niveles de aislamiento, bloqueos, lectura de no-commiteado
- **Tiempo estimado:** 40 min

## Enunciado

> ⚠️ Este ejercicio se hace **con dos conexiones/sesiones abiertas** a la vez (dos terminales `sqlite3` o dos sesiones `psql`). Verifica el comportamiento real de concurrencia.

Dada la tabla `inventario`:

1. **Sesión A**: abre una transacción (`BEGIN`) y actualiza el stock del producto 1 a `5` **sin commitear**.
2. **Sesión B**: intenta leer el stock del producto 1. En `READ COMMITTED` (PostgreSQL por defecto) verás el valor anterior (100); en SQLite, las lecturas mientras hay escritura pendiente verán el valor anterior si el bloqueo es `deferred`.
3. **Sesión A**: haz `ROLLBACK` y verifica en la sesión B que el valor vuelve a ser el original.
4. Prueba ahora con `BEGIN IMMEDIATE` (SQLite) o `BEGIN; ...; UPDATE ...;` en PostgreSQL para ver el bloqueo de escritura: la sesión B debe **esperar** o fallar con "database is locked" hasta que la sesión A haga `COMMIT` o `ROLLBACK`.

Resultado esperado: entender que sin commit los cambios no son visibles y que una escritura bloquea a otra escritura concurrente.

## Schema inicial

```sql
CREATE TABLE inventario (
    id INTEGER PRIMARY KEY,
    producto TEXT NOT NULL,
    stock INTEGER NOT NULL
);

INSERT INTO inventario (id, producto, stock) VALUES
    (1, 'Camiseta', 100),
    (2, 'Pantalon', 50);
```

## Requisitos

- [ ] La consulta devuelve el resultado esperado
- [ ] Ejecutarlo localmente (SQLite o PostgreSQL) y verificar

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Pista 1: Sesión A: `BEGIN; UPDATE inventario SET stock = 5 WHERE id = 1;` (sin COMMIT).
- Pista 2: Sesión B: `SELECT stock FROM inventario WHERE id = 1;` — verás 100 (no se ve el cambio no commiteado).
- Pista 3: Sesión A: `ROLLBACK;` → Sesión B vuelve a ver 100.
- Pista 4: En SQLite, usa `BEGIN IMMEDIATE;` en la sesión A para tomar el bloqueo de escritura antes del UPDATE. Si la sesión B intenta escribir, obtendrá `SQLITE_BUSY`.
- Pista 5: En PostgreSQL, `SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;` no cambia nada (PostgreSQL lo trata como READ COMMITTED); prueba a cambiar el nivel en la sesión B a `REPEATABLE READ` y observa la diferencia de snapshot.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````sql
-- SESIÓN A (terminal 1): escribir sin commitear
BEGIN;
UPDATE inventario SET stock = 5 WHERE id = 1;
-- No ejecutar COMMIT todavía

-- SESIÓN B (terminal 2): leer mientras A no ha commiteado
SELECT stock FROM inventario WHERE id = 1;
-- Devuelve 100 (el cambio de A no es visible)

-- SESIÓN A: deshacer
ROLLBACK;

-- SESIÓN B: confirmar que vuelve a 100
SELECT stock FROM inventario WHERE id = 1;

-- Prueba de bloqueo de escritura (SQLite)
-- SESIÓN A:
BEGIN IMMEDIATE;
UPDATE inventario SET stock = 5 WHERE id = 1;
-- SESIÓN B (intenta escribir → SQLITE_BUSY o espera):
UPDATE inventario SET stock = 1 WHERE id = 2;
-- SESIÓN A: COMMIT;  →  la sesión B ya puede completar
COMMIT;
````

</details>