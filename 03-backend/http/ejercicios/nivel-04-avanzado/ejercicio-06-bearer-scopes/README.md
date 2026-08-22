# Ejercicio 06 — Bearer Token y Scopes

- **Nivel:** 4/5
- **Tema:** Autenticación Bearer y autorización por scopes
- **Tiempo estimado:** 35 min

## Enunciado

El servidor `server.sh` (puerto 8100) acepta Bearer tokens con **scopes**. El token `admin-token` tiene scope `admin` y puede acceder a `GET /admin` y `GET /perfil`. El token `user-token` tiene scope `user` y solo puede acceder a `GET /perfil`.

Completa `respuesta.json` indicando qué status devuelve cada combinación token/ruta, y `peticiones.http` con las peticiones que usan Bearer.

## Requisitos

- [ ] `peticiones.http` tiene peticiones con `Authorization: Bearer admin-token` y `Authorization: Bearer user-token`
- [ ] `respuesta.json` es JSON válido
- [ ] `respuesta.json` mapea `admin_en_admin: 200`, `user_en_admin: 403`, `user_en_perfil: 200`
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- El scope define qué puede hacer un token (autorización, no autenticación).
- 401 = token inválido/falta; 403 = token válido pero sin permiso (scope insuficiente).
- `admin-token` tiene scope `admin`; `user-token` tiene scope `user`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`peticiones.http`:

```http
GET /admin HTTP/1.1
Host: localhost:8100
Authorization: Bearer admin-token

GET /admin HTTP/1.1
Host: localhost:8100
Authorization: Bearer user-token

GET /perfil HTTP/1.1
Host: localhost:8100
Authorization: Bearer user-token
```

`respuesta.json`:

```json
{
  "escenarios": {
    "admin_en_admin": 200,
    "user_en_admin": 403,
    "user_en_perfil": 200,
    "sin_token_en_perfil": 401
  }
}
```

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
