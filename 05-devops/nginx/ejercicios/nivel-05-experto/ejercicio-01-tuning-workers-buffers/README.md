# Ejercicio 01 — Tuning de workers y buffers

- **Nivel:** 5/5
- **Tema:** Ajuste de `worker_processes`, `worker_connections` y buffers para producción
- **Tiempo estimado:** 35 min

## Enunciado

Configura Nginx con tuning de rendimiento para producción:

- `worker_processes auto;`
- `worker_rlimit_nofile 65535;`
- `events { worker_connections 4096; multi_accept on; }`
- `sendfile on; tcp_nopush on; tcp_nodelay on;`
- `keepalive_timeout 65; keepalive_requests 1000;`
- `client_body_buffer_size 16k; client_max_body_size 10m;`
- `proxy_buffer_size 16k; proxy_buffers 8 16k;`

El test verifica que todas estas directivas están presentes con los valores correctos.

## Requisitos

- [ ] `worker_processes auto;` presente
- [ ] `worker_rlimit_nofile 65535;` presente
- [ ] `worker_connections 4096;` en `events`
- [ ] `multi_accept on;` en `events`
- [ ] `sendfile on;`, `tcp_nopush on;`, `tcp_nodelay on;` presentes
- [ ] `keepalive_timeout 65;` y `keepalive_requests 1000;`
- [ ] `client_body_buffer_size 16k;` y `client_max_body_size 10m;`
- [ ] `proxy_buffer_size 16k;` y `proxy_buffers 8 16k;`
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Pista 1: `worker_processes auto` lanza un worker por núcleo.
- Pista 2: `worker_rlimit_nofile` debe cubrir `worker_connections` × 2 + margen.
- Pista 3: `sendfile` + `tcp_nopush` optimizan el envío de archivos grandes.
- Pista 4: Los buffers del proxy (`proxy_buffers`) absorben la respuesta del backend.

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
    sendfile on;
    tcp_nopush on;
    tcp_nodelay on;
    keepalive_timeout 65;
    keepalive_requests 1000;

    client_body_buffer_size 16k;
    client_max_body_size 10m;

    proxy_buffer_size 16k;
    proxy_buffers 8 16k;

    server {
        listen 8080;
        location / {
            return 200 "tuned\n";
            default_type text/plain;
        }
    }
}
```

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
