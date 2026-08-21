# Ejercicio 06 — Transacciones

- **Nivel:** 3/5
- **Tema:** Intermedio de PostgreSQL
- **Tiempo estimado:** 25 minutos

## Enunciado

1. Transacción simple para registrar un préstamo
2. Transacción con verificación de stock y ROLLBACK si falla
3. Uso de SAVEPOINT

## Requisitos

- [ ] El script `init.sql` crea el esquema necesario
- [ ] `solucion.sql` resuelve el enunciado
- [ ] Los tests pasan: `bash test.sh`

## Notas

El `DO $$ ... $$` no puede contener `COMMIT`/`ROLLBACK` explícitos (un bloque `DO` corre dentro de la transacción que ya esté abierta), así que se usa `RAISE EXCEPTION` para abortarla quien la invoque, en vez de intentar un `BEGIN/COMMIT` anidado dentro del bloque, que fallaría.
## Solución

<details>
<summary>Mostrar solución</summary>

```sql
-- Transaccion simple de prestamo
BEGIN;
INSERT INTO prestamos (libro_id, usuario_id) VALUES (1, 1);
UPDATE libros SET cantidad = cantidad - 1 WHERE id = 1;
COMMIT;

-- Con verificacion de stock (aborta si no hay suficiente)
DO $$
DECLARE
    v_stock INT;
BEGIN
    SELECT cantidad INTO v_stock FROM libros WHERE id = 1 FOR UPDATE;
    IF v_stock < 1 THEN
        RAISE EXCEPTION 'Stock insuficiente';
    END IF;

    INSERT INTO prestamos (libro_id, usuario_id) VALUES (1, 2);
    UPDATE libros SET cantidad = cantidad - 1 WHERE id = 1;
END $$;

-- Con SAVEPOINT: revertir solo una parte de la transaccion
BEGIN;
INSERT INTO prestamos (libro_id, usuario_id) VALUES (2, 1);
SAVEPOINT antes_ajuste;
UPDATE libros SET cantidad = 0 WHERE id = 2; -- ajuste erroneo (por ejemplo, al libro equivocado)
ROLLBACK TO SAVEPOINT antes_ajuste;          -- deshace SOLO ese UPDATE, no el INSERT anterior
UPDATE libros SET cantidad = cantidad - 1 WHERE id = 2;   -- ajuste correcto
COMMIT;
```

</details>

## Ejecutar localmente

```bash
cd ejercicios/nivel-03-intermedio/ejercicio-06-transacciones
bash test.sh
```
