# Ejercicio 03 — fail_timeout y max_fails en upstream

- **Nivel:** 5/5
- **Tema:** Health checks pasivos con `fail_timeout` y `max_fails` en upstream
- **Tiempo estimado:** 30 min

## Enunciado

Configura Nginx con health checks pasivos en el upstream:

- `upstream app_backend` con 2 backends, cada uno con `max_fails=3 fail_timeout=30s;`.
- `proxy_next_upstream error timeout http_502 http_503 http_504;`
- `proxy_next_upstream_tries 2;`
- Puerto `8080`, `proxy_pass http://app_backend;`.

Si un backend falla 3 veces en 30s, Nginx lo retira durante 30s y reenvía al otro.

## Requisitos

- [ ] `upstream` con 2 backends, cada uno con `max_fails=3` y `fail_timeout=30s`
- [ ] `proxy_next_upstream` con `error timeout http_502 http_503 http_504`
- [ ] `proxy_next_upstream_tries 2;`
- [ ] `proxy_pass http://app_backend;`
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Pista 1: `max_fails=3 fail_timeout=30s`: si falla 3 veces en 30s, se retira 30s.
- Pista 2: `proxy_next_upstream` define qué se considera fallo (timeout, 502, 503, 504).
- Pista 3: `proxy_next_upstream_tries` limita cuántos backends se prueban antes de fallar.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```nginx
events { worker_connections 1024; }
http {
    upstream app_backend {
        server 127.0.0.1:9001 max_fails=3 fail_timeout=30s;
        server 127.0.0.1:9002 max_fails=3 fail_timeout=30s;
    }

    server {
        listen 8080;

        location / {
            proxy_pass http://app_backend;
            proxy_set_header Host $host;
            proxy_next_upstream error timeout http_502 http_503 http_504;
            proxy_next_upstream_tries 2;
        }
    }
}
```

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
