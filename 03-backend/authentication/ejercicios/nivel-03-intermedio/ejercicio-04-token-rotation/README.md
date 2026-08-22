# Ejercicio 04 — Token rotation

- **Nivel:** 3/5
- **Tema:** Rotación de refresh tokens y detección de reuso
- **Tiempo estimado:** 35 min

## Enunciado

Con **token rotation**, cada vez que se canjea un refresh token, se emite uno nuevo y se invalida el anterior. Si alguien reusa un token ya rotado, el servidor detecta el reuso e invalida toda la familia.

Tu tarea es completar el flujo de rotation en `rotation.json` mostrando 3 pasos y un intento de reuso.

Flujo:

1. **Login**: se emiten `access_1` + `refresh_1` (familia `F1`).
2. **Refresh 1**: se canjea `refresh_1` → `access_2` + `refresh_2`. `refresh_1` se invalida.
3. **Refresh 2**: se canjea `refresh_2` → `access_3` + `refresh_3`. `refresh_2` se invalida.
4. **Reuso**: un atacante intenta canjear `refresh_1` de nuevo → **detectado** → se invalida toda la familia.

Pasos:

1. Completa `rotation.json` con el estado de cada token en cada paso.
2. Marca qué tokens están activos/invalidados en cada paso.
3. Ejecuta `bash test.sh`.

## Requisitos

- [ ] `rotation.json` es JSON válido
- [ ] Hay 4 pasos en el array `pasos` (login, refresh_1, refresh_2, reuso)
- [ ] Tras refresh_1: `refresh_1` está invalidado, `refresh_2` activo
- [ ] Tras refresh_2: `refresh_2` está invalidado, `refresh_3` activo
- [ ] El paso de reuso detecta el reuso de `refresh_1` e invalida toda la familia
- [ ] Tras el reuso: todos los tokens de la familia F1 están invalidados
- [ ] `familia_invalidada` es `true` tras el reuso
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Cada refresh token tiene una `family_id` compartida por todos los tokens derivados del mismo login.
- Al rotar, el refresh token anterior se añade al blacklist (o se marca como `used`).
- Si un token marcado como `used` se presenta de nuevo → reuso detectado.
- El servidor invalida toda la familia: todos los tokens con ese `family_id`.
- Esto fuerza al usuario legítimo a loguearse de nuevo, pero protege contra robo de token.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`rotation.json`:

```json
{
  "familia_id": "F1",
  "pasos": [
    {
      "nombre": "login",
      "accion": "Login inicial",
      "emitidos": ["access_1", "refresh_1"],
      "invalidados": [],
      "activos": ["refresh_1"],
      "familia_invalidada": false
    },
    {
      "nombre": "refresh_1",
      "accion": "Canjear refresh_1 → access_2 + refresh_2",
      "emitidos": ["access_2", "refresh_2"],
      "invalidados": ["refresh_1"],
      "activos": ["refresh_2"],
      "familia_invalidada": false
    },
    {
      "nombre": "refresh_2",
      "accion": "Canjear refresh_2 → access_3 + refresh_3",
      "emitidos": ["access_3", "refresh_3"],
      "invalidados": ["refresh_1", "refresh_2"],
      "activos": ["refresh_3"],
      "familia_invalidada": false
    },
    {
      "nombre": "reuso_detectado",
      "accion": "Atacante intenta canjear refresh_1 (ya invalidado)",
      "emitidos": [],
      "invalidados": ["refresh_1", "refresh_2", "refresh_3"],
      "activos": [],
      "familia_invalidada": true
    }
  ]
}
```

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
