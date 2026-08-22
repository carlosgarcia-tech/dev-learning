# Ejercicio 02 — SSE con Python3

- **Nivel:** 5/5
- **Tema:** Server-Sent Events (SSE)
- **Tiempo estimado:** 40 min

## Enunciado

El servidor `server.sh` (puerto 8102) implementa **Server-Sent Events** en `GET /events`: mantiene la conexión abierta y envía un evento por segundo en formato SSE.

Completa `respuesta.json` indicando el `Content-Type` esperado y el formato de un evento SSE, y completa `peticiones.http` con la petición GET al endpoint SSE.

## Requisitos

- [ ] `peticiones.http` tiene `GET /events HTTP/1.1` con `Accept: text/event-stream`
- [ ] `respuesta.json` tiene `content_type: "text/event-stream"`
- [ ] `respuesta.json` indica que cada evento empieza con `data:`
- [ ] `respuesta.json` indica que los eventos se separan con doble salto de línea
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- SSE usa `Content-Type: text/event-stream`.
- Cada evento es `data: <contenido>\n\n` (doble `\n` para separar eventos).
- El navegador reconecta solo con `EventSource`.
- El servidor no cierra la conexión.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`peticiones.http`:

```http
GET /events HTTP/1.1
Host: localhost:8102
Accept: text/event-stream
```

`respuesta.json`:

```json
{
  "content_type": "text/event-stream",
  "formato_evento": "data: <contenido>",
  "separador": "\\n\\n"
}
```

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
