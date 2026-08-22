# Ejercicio 05 — Logout invalidar

- **Nivel:** 2/5
- **Tema:** Logout e invalidación real de sesiones
- **Tiempo estimado:** 20 min

## Enunciado

El logout no es solo borrar la cookie del navegador: hay que **invalidar la sesión en el servidor**. Si solo borras la cookie, un atacante que robó el session ID antes del logout puede seguir usándolo.

Tu tarea es completar el flujo de logout en `logout.json`, mostrando qué pasa si se invalida correctamente vs si solo se borra la cookie.

Escenario:

1. Usuario A se loguea → session_id = `sess_a8b9c0d1e2f3`
2. Usuario A hace logout
3. Atacante intenta usar el session_id robado antes del logout

Pasos:

1. Examina `sesion.json` con la sesión inicial.
2. Completa `logout.json` con el resultado del logout correcto y el incorrecto.
3. Ejecuta `bash test.sh`.

## Requisitos

- [ ] `logout.json` es JSON válido
- [ ] Logout correcto: `sesion_invalidada: true`, `cookie_borrada: true`, `token_reutilizable: false`
- [ ] Logout incorrecto: `sesion_invalidada: false`, `cookie_borrada: true`, `token_reutilizable: true`
- [ ] El array `pasos` describe los pasos del flujo (mínimo 3)
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Logout correcto: `DELETE session:sess_a8b9c0d1e2f3` en el store del servidor + `Set-Cookie: sid=; Max-Age=0`.
- Logout incorrecto: solo `Set-Cookie: sid=; Max-Age=0` (borra cookie del navegador pero la sesión sigue viva en el servidor).
- El atacante que robó el session ID puede seguir usándolo si la sesión no se invalidó en el servidor.
- `token_reutilizable: true` en el logout incorrecto es el indicador de la vulnerabilidad.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`logout.json`:

```json
{
  "session_id": "sess_a8b9c0d1e2f3",
  "logout_correcto": {
    "sesion_invalidada": true,
    "cookie_borrada": true,
    "token_reutilizable": false,
    "descripcion": "Se borra la sesión del store del servidor y se expira la cookie del navegador. El session ID robado ya no sirve."
  },
  "logout_incorrecto": {
    "sesion_invalidada": false,
    "cookie_borrada": true,
    "token_reutilizable": true,
    "descripcion": "Solo se borra la cookie del navegador, pero la sesión sigue viva en el servidor. Un atacante con el session ID robado puede seguir usándolo."
  },
  "pasos": [
    "1. Usuario hace POST /logout con su session_id",
    "2. Servidor busca la sesión en el store y la elimina (DELETE session:sess_a8b9c0d1e2f3)",
    "3. Servidor responde con Set-Cookie: sid=; HttpOnly; Max-Age=0 para borrar la cookie del navegador",
    "4. Si un atacante intenta usar el session_id anterior, el servidor no lo encuentra → 401 Unauthorized"
  ]
}
```

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
