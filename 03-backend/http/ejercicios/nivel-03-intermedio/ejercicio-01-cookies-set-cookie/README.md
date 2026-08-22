# Ejercicio 01 — Cookies y Set-Cookie

- **Nivel:** 3/5
- **Tema:** Cookies, Set-Cookie y atributos
- **Tiempo estimado:** 25 min

## Enunciado

El servidor `server.sh` (puerto 8089) hace login en `POST /login` y responde con una cookie de sesión. Luego, al llamar a `GET /perfil`, lee esa cookie para identificar al usuario.

Tu tarea:

1. Completa `peticiones.http` con la petición de login y la petición a `/perfil` (enviando la cookie).
2. Completa `respuesta.json` indicando qué atributos de seguridad debe tener la cookie `Set-Cookie` (booleanos).

El servidor de login responde con:

```
Set-Cookie: sesion=abc123; HttpOnly; Secure; SameSite=Lax; Path=/; Max-Age=3600
```

## Requisitos

- [ ] `peticiones.http` tiene `POST /login`
- [ ] `peticiones.http` tiene `GET /perfil` con header `Cookie: sesion=abc123`
- [ ] `respuesta.json` es JSON válido
- [ ] `respuesta.json` indica `HttpOnly: true`, `Secure: true`, `SameSite: "Lax"`
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `POST /login` devuelve `Set-Cookie`.
- El cliente debe reenviar esa cookie en peticiones posteriores con el header `Cookie: nombre=valor`.
- Los atributos `HttpOnly`, `Secure` y `SameSite` son obligatorios para cookies de sesión seguras.
- `curl -c cookies.txt` guarda las cookies; `curl -b cookies.txt` las envía.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`peticiones.http`:

```http
POST /login HTTP/1.1
Host: localhost:8089
Content-Type: application/json
Content-Length: 32

{"usuario":"ana","pass":"123"}

GET /perfil HTTP/1.1
Host: localhost:8089
Cookie: sesion=abc123
```

`respuesta.json`:

```json
{
  "atributos": {
    "HttpOnly": true,
    "Secure": true,
    "SameSite": "Lax"
  }
}
```

Comprobar con curl:

```bash
curl -s -c cookies.txt -X POST http://localhost:8089/login \
  -H "Content-Type: application/json" -d '{"usuario":"ana","pass":"123"}'
curl -s -b cookies.txt http://localhost:8089/perfil
```

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
