# Ejercicio 03 — Expiración de sesión

- **Nivel:** 2/5
- **Tema:** Expiración y renovación (sliding session)
- **Tiempo estimado:** 25 min

## Enunciado

Una sesión no debe ser válida para siempre. Hay dos estrategias de expiración:

- **Absolute timeout**: la sesión expira a una hora fija desde la creación, sin importar la actividad.
- **Idle timeout (sliding)**: cada petición renueva el TTL; si el usuario está inactivo, expira.

Tu tarea es completar `expiracion.json` calculando los tiempos de expiración para ambas estrategias.

Datos:

```json
{
  "created_at": 1700000000,
  "ttl_segundos": 3600,
  "ultima_actividad": 1700001800,
  "ahora": 1700002000
}
```

- `created_at`: timestamp de creación de la sesión (Unix).
- `ttl_segundos`: 3600 (1 hora).
- `ultima_actividad`: timestamp de la última petición del usuario.
- `ahora`: timestamp actual.

Pasos:

1. Calcula el `absolute_expires_at` (created_at + ttl).
2. Calcula el `sliding_expires_at` (ultima_actividad + ttl).
3. Determina si la sesión es válida en ambos casos para `ahora`.
4. Completa `expiracion.json`.
5. Ejecuta `bash test.sh`.

## Requisitos

- [ ] `expiracion.json` es JSON válido
- [ ] `absolute_expires_at` es `1700003600` (created_at + ttl)
- [ ] `sliding_expires_at` es `1700005400` (ultima_actividad + ttl)
- [ ] `absolute_valida` es `false` (ahora > absolute_expires_at)
- [ ] `sliding_valida` es `true` (ahora < sliding_expires_at)
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Absolute: `expires = created_at + ttl = 1700000000 + 3600 = 1700003600`. Como `ahora = 1700002000` y `1700002000 < 1700003600`, la sesión sería válida. Espera, recalcula: `1700002000 < 1700003600` → true. Revisa los números.

Vamos a recalcular:
- `created_at = 1700000000`
- `absolute_expires_at = 1700000000 + 3600 = 1700003600`
- `ahora = 1700002000`
- `1700002000 < 1700003600` → absolute_valida = **true**

- `ultima_actividad = 1700001800`
- `sliding_expires_at = 1700001800 + 3600 = 1700005400`
- `1700002000 < 1700005400` → sliding_valida = **true**

Ambas son válidas en este caso, pero la sliding da más tiempo al usuario activo.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`expiracion.json`:

```json
{
  "created_at": 1700000000,
  "ttl_segundos": 3600,
  "ultima_actividad": 1700001800,
  "ahora": 1700002000,
  "absolute_expires_at": 1700003600,
  "absolute_valida": true,
  "sliding_expires_at": 1700005400,
  "sliding_valida": true,
  "diferencia_segundos": 1800
}
```

Explicación:

```
Absolute:
  expires = created_at + ttl = 1700000000 + 3600 = 1700003600
  ahora = 1700002000
  1700002000 < 1700003600 → válida (quedan 1600s)

Sliding:
  expires = ultima_actividad + ttl = 1700001800 + 3600 = 1700005400
  ahora = 1700002000
  1700002000 < 1700005400 → válida (quedan 3400s)

La sliding da 1800s más de vida porque el usuario estuvo activo.
```

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
