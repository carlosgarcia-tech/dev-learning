# Ejercicio 06 — Last-Modified y If-Modified-Since

- **Nivel:** 3/5
- **Tema:** Caché basada en fecha (Last-Modified)
- **Tiempo estimado:** 25 min

## Enunciado

El servidor `server.sh` (puerto 8094) sirve `GET /doc` con un `Last-Modified`. Si el cliente envía `If-Modified-Since` con una fecha posterior o igual, el servidor responde **304 Not Modified**; si no, responde **200** con el body.

Completa `peticiones.http` con las dos peticiones (primera sin `If-Modified-Since`, segunda con la fecha del `Last-Modified`) y `respuesta.json` con los códigos esperados.

El servidor usa como `Last-Modified` la fecha `Wed, 21 Oct 2025 07:28:00 GMT`.

## Requisitos

- [ ] `peticiones.http` tiene una petición `GET /doc` sin `If-Modified-Since`
- [ ] `peticiones.http` tiene una petición `GET /doc` con `If-Modified-Since: Wed, 21 Oct 2025 07:28:00 GMT`
- [ ] `respuesta.json` mapea `primera` → 200 y `segunda` → 304
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `Last-Modified` y `If-Modified-Since` usan el mismo formato de fecha HTTP (RFC 7231).
- Si `If-Modified-Since` >= `Last-Modified`, el recurso “no ha cambiado” → 304.
- Es menos preciso que ETag (resolución de segundos), pero más simple.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`peticiones.http`:

```http
GET /doc HTTP/1.1
Host: localhost:8094

GET /doc HTTP/1.1
Host: localhost:8094
If-Modified-Since: Wed, 21 Oct 2025 07:28:00 GMT
```

`respuesta.json`:

```json
{"primera": 200, "segunda": 304}
```

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
