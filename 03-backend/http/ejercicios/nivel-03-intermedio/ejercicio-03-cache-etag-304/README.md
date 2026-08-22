# Ejercicio 03 — Caché con ETag y 304

- **Nivel:** 3/5
- **Tema:** Caché HTTP con ETag e If-None-Match
- **Tiempo estimado:** 30 min

## Enunciado

El servidor `server.sh` (puerto 8091) sirve `GET /recurso` con un `ETag`. En la primera petición recibes el recurso y el ETag. En la segunda, envías `If-None-Match` con ese ETag; si el recurso no cambió, el servidor responde **304 Not Modified** (sin body).

Completa `peticiones.http` con las dos peticiones y `respuesta.json` indicando los códigos esperados.

## Requisitos

- [ ] `peticiones.http` tiene la primera petición `GET /recurso`
- [ ] `peticiones.http` tiene la segunda petición `GET /recurso` con `If-None-Match: "v1"`
- [ ] `respuesta.json` mapea `primera` → 200 y `segunda` → 304
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- La primera petición no lleva `If-None-Match`; el servidor responde 200 + `ETag`.
- La segunda petición envía `If-None-Match: "v1"` (con comillas, como el ETag).
- Si coincide, el servidor responde 304 sin body.
- `curl -s -D -` muestra los headers de respuesta (donde está el `ETag`).

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`peticiones.http`:

```http
GET /recurso HTTP/1.1
Host: localhost:8091

GET /recurso HTTP/1.1
Host: localhost:8091
If-None-Match: "v1"
```

`respuesta.json`:

```json
{"primera": 200, "segunda": 304}
```

Comprobar:

```bash
# 1ª petición
curl -s -D - http://localhost:8091/recurso
# → 200 OK + ETag: "v1"

# 2ª petición con If-None-Match
curl -s -o /dev/null -w "%{http_code}\n" -H 'If-None-Match: "v1"' http://localhost:8091/recurso
# → 304
```

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
