# Ejercicio 05 — Caching con proxy_cache

- **Nivel:** 3/5
- **Tema:** Caching de respuestas del backend con `proxy_cache`
- **Tiempo estimado:** 30 min

## Enunciado

Configura Nginx para cachear las respuestas del backend:

- `proxy_cache_path /var/cache/nginx levels=1:2 keys_zone=api_cache:10m max_size=100m inactive=60m;` en `http`.
- `upstream app_backend { server 127.0.0.1:9001; }`
- Puerto `8080`, `location /api/` con:
  - `proxy_pass http://app_backend;`
  - `proxy_cache api_cache;`
  - `proxy_cache_valid 200 10m;`
  - `proxy_cache_key "$scheme$request_method$host$request_uri";`
  - `add_header X-Cache-Status $upstream_cache_status;`

El backend simulado (`backend.sh`) responde `cached-data`.

El test hace dos peticiones a `/api/` y verifica que la segunda tiene `X-Cache-Status: HIT`.

## Requisitos

- [ ] `proxy_cache_path` definido en `http` con `keys_zone=api_cache`
- [ ] `proxy_cache api_cache;` en `location /api/`
- [ ] `proxy_cache_valid 200 10m;` presente
- [ ] `proxy_cache_key` definido
- [ ] `add_header X-Cache-Status $upstream_cache_status;` presente
- [ ] `backend.sh` existe y responde `cached-data`
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Pista 1: `proxy_cache_path` define el directorio del caché y la zona en RAM (`keys_zone`).
- Pista 2: La primera petición es MISS (va al backend); la segunda HIT (sirve del caché).
- Pista 3: `$upstream_cache_status` vale `MISS`, `HIT`, `EXPIRED`, `BYPASS`...
- Pista 4: El directorio del caché debe existir y tener permisos de escritura para el worker.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```nginx
events { worker_connections 1024; }
http {
    proxy_cache_path /var/cache/nginx levels=1:2
                     keys_zone=api_cache:10m max_size=100m inactive=60m;

    upstream app_backend {
        server 127.0.0.1:9001;
    }

    server {
        listen 8080;

        location /api/ {
            proxy_pass http://app_backend;
            proxy_cache api_cache;
            proxy_cache_valid 200 10m;
            proxy_cache_key "$scheme$request_method$host$request_uri";
            add_header X-Cache-Status $upstream_cache_status;
        }
    }
}
```

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
