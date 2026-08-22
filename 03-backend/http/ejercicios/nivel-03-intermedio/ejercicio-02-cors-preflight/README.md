# Ejercicio 02 — CORS Preflight

- **Nivel:** 3/5
- **Tema:** CORS y el preflight OPTIONS
- **Tiempo estimado:** 30 min

## Enunciado

Una SPA en `https://app.tienda.com` quiere llamar a tu API en `http://localhost:8090`. Como es cross-origin y la petición usa `Content-Type: application/json`, el navegador enviará un **preflight OPTIONS** antes del POST real.

El servidor `server.sh` ya está configurado para responder al preflight. Tu tarea:

1. Completa `peticiones.http` con la petición preflight `OPTIONS` y la petición real `POST`.
2. Completa `respuesta.json` indicando los headers CORS que el servidor debe devolver.

## Requisitos

- [ ] `peticiones.http` tiene `OPTIONS /datos` con `Origin: https://app.tienda.com`
- [ ] `peticiones.http` tiene `Access-Control-Request-Method: POST`
- [ ] `peticiones.http` tiene la petición real `POST /datos`
- [ ] `respuesta.json` lista los headers CORS esperados en la respuesta del preflight
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- El preflight es un `OPTIONS` con `Origin` y `Access-Control-Request-Method`.
- El servidor responde con `Access-Control-Allow-Origin`, `Access-Control-Allow-Methods` y `Access-Control-Allow-Headers`.
- Si el preflight pasa, el navegador envía la petición real (POST).

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`peticiones.http`:

```http
OPTIONS /datos HTTP/1.1
Host: localhost:8090
Origin: https://app.tienda.com
Access-Control-Request-Method: POST
Access-Control-Request-Headers: Content-Type

POST /datos HTTP/1.1
Host: localhost:8090
Origin: https://app.tienda.com
Content-Type: application/json
Content-Length: 18

{"valor": "hola"}
```

`respuesta.json`:

```json
{
  "headers_preflight": {
    "Access-Control-Allow-Origin": "https://app.tienda.com",
    "Access-Control-Allow-Methods": "GET, POST, OPTIONS",
    "Access-Control-Allow-Headers": "Content-Type"
  }
}
```

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
