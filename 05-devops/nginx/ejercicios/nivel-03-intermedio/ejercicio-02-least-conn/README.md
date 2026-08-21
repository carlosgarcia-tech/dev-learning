# Ejercicio 02 — Balanceo least_conn

- **Nivel:** 3/5
- **Tema:** Balanceo con `least_conn` (menos conexiones activas)
- **Tiempo estimado:** 25 min

## Enunciado

Configura Nginx con balanceo `least_conn` en lugar de round-robin:

- `upstream app_backend { least_conn; server 127.0.0.1:9001; server 127.0.0.1:9002; }`
- Puerto `8080`, `proxy_pass http://app_backend;`.
- Reenvía `Host` y `X-Real-IP`.

`least_conn` envía la petición al backend con menos conexiones activas, en lugar de round-robin cíclico.

## Requisitos

- [ ] `upstream` con `least_conn;` activado
- [ ] 2 backends en el upstream (9001 y 9002)
- [ ] `proxy_pass http://app_backend;`
- [ ] `proxy_set_header Host $host;`
- [ ] `proxy_set_header X-Real-IP $remote_addr;`
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Pista 1: `least_conn;` es una directiva dentro de `upstream` (no de `server`).
- Pista 2: Se evalúa antes que round-robin: Nginx cuenta las conexiones activas de cada backend.
- Pista 3: Es útil cuando las peticiones duran distinto tiempo (backends heterogéneos).

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```nginx
events { worker_connections 1024; }
http {
    upstream app_backend {
        least_conn;
        server 127.0.0.1:9001;
        server 127.0.0.1:9002;
    }
    server {
        listen 8080;
        location / {
            proxy_pass http://app_backend;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
        }
    }
}
```

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
