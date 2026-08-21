# Ejercicio 06 — Configuración de producción completa

- **Nivel:** 5/5
- **Tema:** Configuración de producción completa (TLS 1.3, HTTP/2, security headers, rate limit, cache, gzip, múltiples vhosts)
- **Tiempo estimado:** 50 min

## Enunciado

Crea una configuración de producción completa que integre todo lo aprendido:

- `worker_processes auto;`, `worker_rlimit_nofile 65535;`, `worker_connections 4096;`, `multi_accept on;`
- `server_tokens off;`
- `gzip on;` con `gzip_types` para texto.
- `limit_req_zone $binary_remote_addr zone=api:10m rate=10r/s;`
- `proxy_cache_path /var/cache/nginx ... keys_zone=cache:10m ...`
- `upstream backend` con 2 servers, `max_fails=3 fail_timeout=30s`, `keepalive 32;`
- Server HTTP (puerto 80) que redirige a HTTPS con `return 301`.
- Server HTTPS (puerto 443) con:
  - `http2` activado
  - `ssl_certificate`, `ssl_certificate_key`, `ssl_protocols TLSv1.2 TLSv1.3`
  - Security headers: HSTS, X-Frame-Options, X-Content-Type-Options
  - `location /api/` con `proxy_pass`, `proxy_cache`, `limit_req`, `proxy_set_header`
  - `location /` con estáticos + `expires`
- `log_format` con `request_time`.

Esta es la configuración que pondrías en un servidor real de producción.

## Requisitos

- [ ] `worker_processes auto` y `worker_connections 4096`
- [ ] `server_tokens off`
- [ ] `gzip on` con `gzip_types`
- [ ] `limit_req_zone` definido
- [ ] `proxy_cache_path` definido
- [ ] `upstream` con 2 backends y `max_fails`/`fail_timeout`
- [ ] Server HTTP con `return 301 https://`
- [ ] Server HTTPS con `ssl_protocols TLSv1.2 TLSv1.3` y `http2`
- [ ] HSTS, X-Frame-Options, X-Content-Type-Options presentes
- [ ] `location /api/` con `proxy_pass`, `proxy_cache` y `limit_req`
- [ ] `log_format` con `request_time`
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Pista 1: Empieza por la estructura global (main + events + http) y luego añade los server blocks.
- Pista 2: El server HTTP (80) solo redirige; el server HTTPS (443) hace todo el trabajo.
- Pista 3: `listen 443 ssl http2;` activa HTTP/2 en el server HTTPS.
- Pista 4: Reutiliza patrones de ejercicios anteriores: gzip (nivel 2), proxy_cache (nivel 3), TLS y headers (nivel 4), tuning (nivel 5).

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```nginx
worker_processes auto;
worker_rlimit_nofile 65535;

events {
    worker_connections 4096;
    multi_accept on;
}

http {
    include       mime.types;
    default_type  application/octet-stream;
    server_tokens off;

    sendfile      on;
    tcp_nopush    on;
    tcp_nodelay   on;
    keepalive_timeout 65;
    keepalive_requests 1000;

    gzip on;
    gzip_comp_level 6;
    gzip_min_length 256;
    gzip_types text/plain text/css application/javascript application/json image/svg+xml;

    log_format main '$remote_addr - [$time_local] "$request" '
                    '$status $body_bytes_sent rt=$request_time urt=$upstream_response_time';
    access_log /var/log/nginx/access.log main;
    error_log  /var/log/nginx/error.log warn;

    limit_req_zone $binary_remote_addr zone=api:10m rate=10r/s;

    proxy_cache_path /var/cache/nginx levels=1:2
                     keys_zone=cache:10m max_size=1g inactive=60m use_temp_path=off;

    upstream backend {
        server 127.0.0.1:3000 max_fails=3 fail_timeout=30s;
        server 127.0.0.1:3001 max_fails=3 fail_timeout=30s;
        keepalive 32;
    }

    server {
        listen 80;
        server_name app.ejemplo.com;
        return 301 https://$host$request_uri;
    }

    server {
        listen 443 ssl http2;
        server_name app.ejemplo.com;

        ssl_certificate     /etc/nginx/ssl/app.crt;
        ssl_certificate_key /etc/nginx/ssl/app.key;
        ssl_protocols       TLSv1.2 TLSv1.3;
        ssl_ciphers         HIGH:!aNULL:!MD5;

        add_header Strict-Transport-Security "max-age=31536000" always;
        add_header X-Frame-Options "SAMEORIGIN" always;
        add_header X-Content-Type-Options "nosniff" always;

        location /api/ {
            proxy_pass http://backend;
            proxy_http_version 1.1;
            proxy_set_header Connection "";
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;

            proxy_cache cache;
            proxy_cache_valid 200 10m;
            add_header X-Cache-Status $upstream_cache_status;

            limit_req zone=api burst=20 nodelay;
        }

        location / {
            root /var/www/app;
            try_files $uri $uri/ /index.html;
            expires 1d;
        }
    }
}
```

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
