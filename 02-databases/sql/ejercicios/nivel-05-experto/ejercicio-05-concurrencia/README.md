# Ejercicio 29 — Concurrencia

- **Nivel:** 5/5
- **Tema:** Experto en SQL
- **Tiempo estimado:** 40 minutos

## Enunciado

1. Maneja actualizaciones concurrentes
2. Usa SELECT FOR UPDATE
3. Maneja deadlocks
4. Usa transaction isolation levels

## Requisitos

- [ ] La tabla/consulta se ajusta a lo pedido en el enunciado
- [ ] Las consultas devuelven los resultados esperados
- [ ] Los tests pasan: `bash test.sh`

## Solución

<details>
<summary>Mostrar solución</summary>

SQLite no soporta `SELECT ... FOR UPDATE` ni `ISOLATION LEVEL SERIALIZABLE`. En su lugar usa bloqueo de escritura a nivel de base de datos y transacciones `DEFERRED`/`IMMEDIATE`/`EXCLUSIVE`. La solución enseña los mismos conceptos: candado de escritura con `BEGIN IMMEDIATE`, optimistic locking con columna `version` + `changes()`, y `PRAGMA busy_timeout`.

```sql
-- 1) PRAGMA busy_timeout: cuánto tiempo espera una conexión si otra
--    mantiene el candado de escritura antes de devolver "database is locked".
PRAGMA busy_timeout = 5000;

-- 2) BEGIN IMMEDIATE obtiene el candado de escritura al empezar, de forma
--    que ningún otro escritor puede interferir hasta el COMMIT. Es el
--    equivalente práctico al bloqueo de fila de SELECT ... FOR UPDATE.
BEGIN IMMEDIATE;
UPDATE productos SET stock = stock - 1 WHERE id = 1;
SELECT changes() AS filas_afectadas;
COMMIT;

-- 3) Optimistic locking con columna version.
--    La actualización solo tiene efecto si la versión leída sigue intacta;
--    si otro proceso la modificó, la fila no se actualiza y changes() = 0.
UPDATE productos_version
SET stock = stock - 1, version = version + 1
WHERE id = 1 AND version = 1;

SELECT
    changes() AS filas_afectadas,
    (SELECT stock FROM productos_version WHERE id = 1) AS stock,
    (SELECT version FROM productos_version WHERE id = 1) AS version;

-- 4) Segundo intento con la versión ANTIGUA (1): no afecta a ninguna fila.
--    La aplicación detecta el conflicto vía changes() y debe reintentar
--    releyendo la versión más reciente.
UPDATE productos_version
SET stock = stock - 1, version = version + 1
WHERE id = 1 AND version = 1;

-- 5) Transacción DEFERRED: el candado de escritura se adquiere solo en la
--    primera sentencia de escritura, no al abrir la transacción.
BEGIN;
UPDATE productos SET stock = stock - 1 WHERE id = 2;
COMMIT;
```

</details>
