# Ejercicio 02 — OAuth 2.0 Flow Simulado

- **Nivel:** 4/5
- **Tema:** Flujo OAuth 2.0 Authorization Code (simulado)
- **Tiempo estimado:** 40 min

## Enunciado

El servidor `server.sh` (puerto 8096) simula un **Authorization Server** y un **Resource Server** en uno. Vas a recorrer el flujo **Authorization Code** completo:

1. `GET /authorize?response_type=code&client_id=app123&redirect_uri=http://localhost:3000/cb&state=xyz` → redirige (302) a `redirect_uri?code=AUTH_CODE&state=xyz`.
2. `POST /token` con `grant_type=authorization_code&code=AUTH_CODE&client_id=app123&client_secret=secret` → devuelve `{"access_token":"...","token_type":"Bearer","expires_in":3600}`.
3. `GET /api/perfil` con `Authorization: Bearer <access_token>` → devuelve los datos del usuario.

Completa `expected.json` con los campos esperados de cada paso y `peticiones.http` con las tres peticiones.

## Requisitos

- [ ] `expected.json` es JSON válido con `authorize_status: 302`
- [ ] `expected.json` tiene `token.token_type: "Bearer"` y `token.expires_in: 3600`
- [ ] `expected.json` tiene `perfil.usuario: "ana"`
- [ ] `peticiones.http` tiene las tres peticiones (authorize, token, perfil)
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- El paso 1 es un GET que devuelve 302 con `Location: redirect_uri?code=...`.
- El paso 2 es un POST con body `application/x-www-form-urlencoded`.
- El paso 3 usa el access_token como Bearer.
- El `state` debe coincidir entre authorize y la redirección.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`expected.json`:

```json
{
  "authorize_status": 302,
  "token": {
    "token_type": "Bearer",
    "expires_in": 3600
  },
  "perfil": {
    "usuario": "ana"
  }
}
```

`peticiones.http`:

```http
GET /authorize?response_type=code&client_id=app123&redirect_uri=http://localhost:3000/cb&state=xyz HTTP/1.1
Host: localhost:8096

POST /token HTTP/1.1
Host: localhost:8096
Content-Type: application/x-www-form-urlencoded
Content-Length: 90

grant_type=authorization_code&code=AUTH_CODE&client_id=app123&client_secret=secret

GET /api/perfil HTTP/1.1
Host: localhost:8096
Authorization: Bearer ACCESS_TOKEN
```

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
