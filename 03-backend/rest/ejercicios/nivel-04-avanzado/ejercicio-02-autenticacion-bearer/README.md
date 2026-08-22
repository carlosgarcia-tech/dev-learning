# Ejercicio 02 — Autenticación con Bearer token

- **Nivel:** 4/5
- **Tema:** Autenticación Bearer y errores 401/403
- **Tiempo estimado:** 20 min

## Enunciado

Implementa dos respuestas de autenticación para `GET /admin/users`:

1. `respuesta_401.json`: petición **sin** token (o token inválido). El cliente no está autenticado.
2. `respuesta_403.json`: petición con un token **válido** de un usuario con rol `viewer` que no tiene permiso para acceder al endpoint de admin.

## Requisitos

- [ ] `respuesta_401.json`: status **401**, `WWW-Authenticate: Bearer`, body con error
- [ ] `respuesta_403.json`: status **403**, body con error (no debe revelar demasiada info)
- [ ] Ambos usan `Content-Type: application/problem+json`
- [ ] El 401 menciona auth/token; el 403 menciona permiso/forbidden
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- 401 Unauthorized = "no sé quién eres" (falta auth o token inválido). Responde con `WWW-Authenticate: Bearer`.
- 403 Forbidden = "sé quién eres, pero no puedes". No hace falta `WWW-Authenticate`.
- No reveles información sensible en el cuerpo del 403.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`respuesta_401.json`:
````json
{
  "status": 401,
  "headers": { "Content-Type": "application/problem+json", "WWW-Authenticate": "Bearer" },
  "body": {
    "type": "https://docs.api.example/errors/unauthorized",
    "title": "Unauthorized",
    "status": 401,
    "detail": "Se requiere un token Bearer válido"
  }
}
````

`respuesta_403.json`:
````json
{
  "status": 403,
  "headers": { "Content-Type": "application/problem+json" },
  "body": {
    "type": "https://docs.api.example/errors/forbidden",
    "title": "Forbidden",
    "status": 403,
    "detail": "No tienes permiso para acceder a este recurso"
  }
}
````

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
