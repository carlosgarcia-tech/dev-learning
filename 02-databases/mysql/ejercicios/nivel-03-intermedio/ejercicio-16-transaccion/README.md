# Ejercicio 16 — Transacción

- **Nivel:** 3/5
- **Tema:** Intermedio de MySQL
- **Tiempo estimado:** 25 minutos

## Enunciado

La tabla `cuentas` ya existe con datos. Realiza una transferencia entre cuentas usando
una transacción.

1. Inicia una transacción con `START TRANSACTION`.
2. Resta `500` de la cuenta con `id = 1`.
3. Suma `500` a la cuenta con `id = 2`.
4. Haz `COMMIT`.
5. Muestra `id`, `titular`, `saldo` de todas las cuentas ordenadas por `id`.

## Requisitos

- [ ] Usas `START TRANSACTION` / `COMMIT`
- [ ] Las dos modificaciones (resta y suma) van dentro de la transacción
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `START TRANSACTION;` inicia la transacción.
- `UPDATE cuentas SET saldo = saldo - 500 WHERE id = 1;` resta.
- `UPDATE cuentas SET saldo = saldo + 500 WHERE id = 2;` suma.
- `COMMIT;` confirma los cambios.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```sql
START TRANSACTION;
UPDATE cuentas SET saldo = saldo - 500 WHERE id = 1;
UPDATE cuentas SET saldo = saldo + 500 WHERE id = 2;
COMMIT;
SELECT id, titular, saldo FROM cuentas ORDER BY id;
```

</details>

## Ejecutar localmente

```bash
cd 02-databases/mysql/ejercicios/nivel-03-intermedio/ejercicio-16-transaccion
bash test.sh
```
