# Ejercicio 03 — Rate limiting con limit_req

- **Nivel:** 4/5
- **Tema:** Rate limiting con `limit_req` y `limit_req_zone`
- **Tiempo estimado:** 30 min

## Enunciado

Configura Nginx para limitar la tasa de peticiones por IP:

- `limit_req_zone $binary_remote_addr zone=api_limit:10m rate=5r/s;` en `http`.
- Puerto `8080`.
- `location /api/` con `limit_req zone=api_limit burst=10 nodelay;`.
- `location /` sirve `web/index.html`.

El test hace muchas peticiones rápidas a `/api/` y verifica que algunas reciben **429** (o 503, el default de Nginx).

## Requisitos

- [ ] `limit_req_zone` definido en `http` con `zone=api_limit` y `rate=5r/s`
- [ ] `limit_req zone=api_limit burst=10 nodelay;` en `location /api/`
- [ ] `location /` sirve estáticos
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Pista 1: `limit_req_zone` define la zona (memoria) y la tasa. Va en `http`.
- Pista 2: `rate=5r/s` = 5 peticiones por segundo por IP.
- Pista 3: `burst=10` permite ráfagas de 10 extra; `nodelay` las sirve sin encolar.
- Pista 4: Al superar el límite, Nginx devuelve 503 (default) o 429 si configuras `limit_req_status 429`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```nginx
events { worker_connections 1024; }
http {
    limit_req_zone $binary_remote_addr zone=api_limit:10m rate=5r/s;

    server {
        listen 8080;
        root /ruta/abs/a/web;
        index index.html;

        location /api/ {
            limit_req zone=api_limit burst=10 nodelay;
            limit_req_status 429;
            return 200 "ok\n";
            default_type text/plain;
        }

        location / {
            try_files $uri $uri/ =404;
        }
    }
}
```

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
