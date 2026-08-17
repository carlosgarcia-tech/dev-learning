# Guía 4 — Transacciones

## Objetivos

- [ ] Comprender qué es una transacción y para qué sirve.
- [ ] Usar `BEGIN`, `COMMIT` y `ROLLBACK`.
- [ ] Conocer el modelo ACID.
- [ ] Entender los niveles de aislamiento y sus problemas.
- [ ] Saber cómo afecta la concurrencia a las transacciones.

## Apuntes

### Qué es una transacción

Una **transacción** es una secuencia de operaciones que se ejecuta **como una sola unidad**: o se aplican todas, o no se aplica ninguna. Ejemplo clásico: transferir dinero de una cuenta a otra.

```sql
BEGIN;
UPDATE cuentas SET saldo = saldo - 100 WHERE id = 1;
UPDATE cuentas SET saldo = saldo + 100 WHERE id = 2;
COMMIT;
```

Si la segunda operación falla, con `ROLLBACK` se deshace la primera. Sin transacción, quedaría el sistema en un estado inconsistente.

### Control de transacciones

| Comando | Función |
|---|---|
| `BEGIN` (o `START TRANSACTION`) | Inicia una transacción |
| `COMMIT` | Aplica todos los cambios de forma definitiva |
| `ROLLBACK` | Deshace todos los cambios desde el `BEGIN` |
| `SAVEPOINT` | Crea un punto de guardado intermedio para hacer rollback parcial |
| `ROLLBACK TO SAVEPOINT` | Vuelve a un punto de guardado sin abortar toda la transacción |

En PostgreSQL y SQLite las sentencias DML en autocommit se confirman al instante; envueltas en `BEGIN...COMMIT` se agrupan.

### Modelo ACID

| Letra | Propiedad | Significado |
|---|---|---|
| **A** | Atomicity | Todo o nada: ninguna operación queda a medias |
| **C** | Consistency | La base de datos pasa de un estado válido a otro válido (se cumplen constraints) |
| **I** | Isolation | Las transacciones concurrentes no se interfieren entre sí |
| **D** | Durability | Una vez commiteado, el cambio persiste aunque falle el sistema |

### Problemas de concurrencia

Cuando dos transacciones se ejecutan a la vez, pueden aparecer estos problemas:

| Problema | Descripción |
|---|---|
| **Dirty read** | Leer datos que otra transacción aún no ha commiteado (y puede hacer rollback) |
| **Non-repeatable read** | Dentro de una misma transacción, la misma consulta devuelve valores distintos porque otra transacción modificó y commiteó la fila |
| **Phantom read** | Dentro de una misma transacción, una consulta devuelve filas nuevas que aparecieron porque otra transacción insertó y commiteó |

### Niveles de aislamiento (ANSI SQL)

| Nivel | Previene dirty read | Previene non-repeatable read | Previene phantom read |
|---|---|---|---|
| `READ UNCOMMITTED` | ❌ | ❌ | ❌ |
| `READ COMMITTED` | ✅ | ❌ | ❌ |
| `REPEATABLE READ` | ✅ | ✅ | ❌ |
| `SERIALIZABLE` | ✅ | ✅ | ✅ |

- **READ UNCOMMITTED**: puede leer datos no commiteados (peligroso, raramente usado).
- **READ COMMITTED**: solo lee datos commiteados (predeterminado en PostgreSQL).
- **REPEATABLE READ**: una misma consulta dentro de la transacción devuelve los mismos datos (predeterminado en SQLite y MySQL).
- **SERIALIZABLE**: nivel más estricto; se comporta como si las transacciones se ejecutaran una tras otra.

Sintaxis:

```sql
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
```

### Bloqueos (locks)

Para garantizar aislamiento, los motores usan **bloqueos**:

- **Bloqueo compartido (SHARED)**: varias transacciones pueden leer a la vez.
- **Bloqueo exclusivo (EXCLUSIVE)**: solo una transacción puede escribir; las demás esperan.

En SQLite, un `BEGIN` normal (`deferred`) adquiere bloqueos compartidos al leer y exclusivos al escribir. `BEGIN IMMEDIATE` / `BEGIN EXCLUSIVE` los adquieren antes.

## Ejemplos de código

```sql
-- Tabla de cuentas
CREATE TABLE cuentas (
    id INTEGER PRIMARY KEY,
    titular TEXT NOT NULL,
    saldo REAL NOT NULL
);

INSERT INTO cuentas (id, titular, saldo) VALUES
    (1, 'Ana', 1000.00),
    (2, 'Luis', 500.00);

-- Transferencia atómica
BEGIN;
UPDATE cuentas SET saldo = saldo - 200 WHERE id = 1;
UPDATE cuentas SET saldo = saldo + 200 WHERE id = 2;
COMMIT;
```

Rollback ante error:

```sql
BEGIN;
UPDATE cuentas SET saldo = saldo - 200 WHERE id = 1;
-- Aquí la segunda operación falla (ej. id inexistente)
UPDATE cuentas SET saldo = saldo + 200 WHERE id = 99;
ROLLBACK;  -- La primera operación también se deshace
```

Savepoint:

```sql
BEGIN;
UPDATE cuentas SET saldo = saldo - 100 WHERE id = 1;
SAVEPOINT tras_descontar;
UPDATE cuentas SET saldo = saldo + 100 WHERE id = 2;
-- Algo salió mal: solo se deshace la segunda operación
ROLLBACK TO tras_descontar;
COMMIT;
```

## Ejercicios relacionados

- [ejercicios/nivel-04-avanzado/ejercicio-03-transacciones.md](ejercicios/nivel-04-avanzado/ejercicio-03-transacciones.md)
- [ejercicios/nivel-05-experto/ejercicio-05-transacciones-y-concurrencia.md](ejercicios/nivel-05-experto/ejercicio-05-transacciones-y-concurrencia.md)

## Errores comunes

- **Olvidar `COMMIT`**: la transacción queda abierta, los cambios invisibles para otras sesiones y los locks bloquean a otros usuarios.
- **Olvidar `ROLLBACK` tras un error**: si el programa no aborta la transacción, la base queda bloqueada o en estado medio.
- **`ROLLBACK` sin haber hecho `BEGIN`**: no tiene efecto y puede confundir.
- **Mezclar transacciones anidadas en SQLite**: SQLite solo permite una transacción activa a la vez (usa `SAVEPOINT` para simular anidación).
- **Leer datos no commiteados esperando consistencia**: sin `READ COMMITTED` (o superior) puedes leer basura de otras transacciones.
- **Hacer peticiones lentas dentro de una transacción larga**: mantiene locks abiertos y degrada la concurrencia.

## Recursos

- [PostgreSQL transactions docs](https://www.postgresql.org/docs/current/sql-begin.html)
- [SQLite transactions](https://www.sqlite.org/lang_transaction.html)
- [PostgreSQL isolation levels](https://www.postgresql.org/docs/current/transaction-iso.html)