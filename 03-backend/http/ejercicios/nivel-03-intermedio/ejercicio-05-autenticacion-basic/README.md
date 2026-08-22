# Ejercicio 05 — Autenticación Basic

- **Nivel:** 3/5
- **Tema:** Autenticación HTTP Basic
- **Tiempo estimado:** 25 min

## Enunciado

El servidor `server.sh` (puerto 8093) protege `GET /privado` con **HTTP Basic**. Las credenciales válidas son `admin:secreto`. Sin credenciales devuelve `401` con `WWW-Authenticate: Basic realm="api"`; con credenciales correctas, `200`.

Completa `peticiones.http` con la petición que incluye el header `Authorization: Basic` correcto, y `respuesta.json` con el status esperado.

El valor del header es `base64("admin:secreto")`.

## Requisitos

- [ ] `peticiones.http` tiene `GET /privado HTTP/1.1`
- [ ] `peticiones.http` tiene `Authorization: Basic YWRtaW46c2VjcmV0bw==`
- [ ] `respuesta.json` es JSON válido con `status: 200`
- [ ] `respuesta.json` tiene `sin_auth: 401`
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Basic envía `base64(usuario:contraseña)`.
- `echo -n "admin:secreto" | base64` → `YWRtaW46c2VjcmV0bw==`
- `curl -u admin:secreto` hace la codificación por ti.
- Sin `Authorization`, el servidor responde 401 con `WWW-Authenticate`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`peticiones.http`:

```http
GET /privado HTTP/1.1
Host: localhost:8093
Authorization: Basic YWRtaW46c2VjcmV0bw==
```

`respuesta.json`:

```json
{"status": 200, "sin_auth": 401}
```

Comprobar:

```bash
# Sin auth -> 401
curl -s -o /dev/null -w "%{http_code}\n" http://localhost:8093/privado
# → 401

# Con auth -> 200
curl -s -o /dev/null -w "%{http_code}\n" -u admin:secreto http://localhost:8093/privado
# → 200
```

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
