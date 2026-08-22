# Ejercicio 01 — Servidor WebSocket Básico

- **Nivel:** 5/5
- **Tema:** WebSockets
- **Tiempo estimado:** 45 min

## Enunciado

El servidor `server.sh` (puerto 8101) implementa un servidor WebSocket mínimo en Python puro (sin librerías externas) que hace el **upgrade handshake** y responde a mensajes de texto con su eco.

Tu tarea: completa `respuesta.json` indicando el status del handshake (101) y los campos del upgrade, y completa `peticiones.http` con la petición de upgrade WebSocket.

El servidor:
- Responde a `GET /ws` con `101 Switching Protocols` si los headers de upgrade son correctos.
- Tras el upgrade, hace eco de los mensajes de texto recibidos.

## Requisitos

- [ ] `peticiones.http` tiene `GET /ws HTTP/1.1` con `Upgrade: websocket`
- [ ] `peticiones.http` tiene `Connection: Upgrade`
- [ ] `peticiones.http` tiene `Sec-WebSocket-Key` y `Sec-WebSocket-Version: 13`
- [ ] `respuesta.json` tiene `handshake_status: 101`
- [ ] `respuesta.json` menciona `Upgrade` y `Connection` en la respuesta
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- El handshake WebSocket empieza como un GET HTTP con headers `Upgrade: websocket` y `Connection: Upgrade`.
- El cliente envía `Sec-WebSocket-Key` (aleatorio en Base64).
- El servidor responde `101 Switching Protocols` con `Sec-WebSocket-Accept`.
- El `Sec-WebSocket-Accept` se calcula: `base64(sha1(key + "258EAFA5-E914-47DA-95CA-C5AB0DC85B11"))`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`peticiones.http`:

```http
GET /ws HTTP/1.1
Host: localhost:8101
Upgrade: websocket
Connection: Upgrade
Sec-WebSocket-Key: dGhlIHNhbXBsZSBub25jZQ==
Sec-WebSocket-Version: 13
```

`respuesta.json`:

```json
{
  "handshake_status": 101,
  "respuesta_headers": ["Upgrade", "Connection", "Sec-WebSocket-Accept"]
}
```

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
