# Ejercicio 04 — Proxy de WebSocket

- **Nivel:** 3/5
- **Tema:** Proxy de WebSocket (Upgrade/Connection)
- **Tiempo estimado:** 30 min

## Enunciado

Configura Nginx como proxy para conexiones WebSocket:

- Define `map $http_upgrade $connection_upgrade { default upgrade; '' close; }` en el contexto `http`.
- `upstream ws_backend { server 127.0.0.1:9001; }`
- Puerto `8080`, `location /ws` con:
  - `proxy_pass http://ws_backend;`
  - `proxy_http_version 1.1;`
  - `proxy_set_header Upgrade $http_upgrade;`
  - `proxy_set_header Connection $connection_upgrade;`
  - `proxy_read_timeout 3600s;`

El test verifica que la configuración contiene las directivas correctas para el handshake WebSocket.

## Requisitos

- [ ] `map $http_upgrade $connection_upgrade` definido en `http`
- [ ] `proxy_http_version 1.1;` presente
- [ ] `proxy_set_header Upgrade $http_upgrade;` presente
- [ ] `proxy_set_header Connection $connection_upgrade;` presente
- [ ] `proxy_read_timeout 3600s;` presente
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Pista 1: WebSocket requiere HTTP/1.1 y el header `Upgrade: websocket`.
- Pista 2: El `map` normaliza: si hay `Upgrade`, reenvía `Connection: upgrade`; si no, `close` (para no romper keepalive HTTP normal).
- Pista 3: `proxy_read_timeout` alto porque las conexiones WS están abiertas mucho tiempo.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```nginx
events { worker_connections 1024; }
http {
    map $http_upgrade $connection_upgrade {
        default upgrade;
        ''      close;
    }

    upstream ws_backend {
        server 127.0.0.1:9001;
    }

    server {
        listen 8080;

        location /ws {
            proxy_pass http://ws_backend;
            proxy_http_version 1.1;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection $connection_upgrade;
            proxy_set_header Host $host;
            proxy_read_timeout 3600s;
        }
    }
}
```

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
