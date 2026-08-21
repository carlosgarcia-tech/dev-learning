# Ejercicio 01 — Load balancing upstream con 2 backends

- **Nivel:** 3/5
- **Tema:** `upstream` con 2 backends y balanceo round-robin
- **Tiempo estimado:** 30 min

## Enunciado

Configura Nginx como load balancer entre dos backends simulados:

- Define un bloque `upstream app_backend { server 127.0.0.1:9001; server 127.0.0.1:9002; }`.
- Puerto `8080` para Nginx.
- `location / { proxy_pass http://app_backend; }`.
- Reenvía `Host` y `X-Forwarded-For`.

Los backends simulados (`backend1.sh` y `backend2.sh`) responden `backend-1` y `backend-2` respectivamente.

El test arranca ambos backends, levanta Nginx y verifica que tras varias peticiones aparecen respuestas de **ambos** backends (round-robin).

## Requisitos

- [ ] Bloque `upstream` con 2 `server` (9001 y 9002)
- [ ] `proxy_pass http://app_backend;` en `location /`
- [ ] `proxy_set_header Host $host;` presente
- [ ] `proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;` presente
- [ ] `backend1.sh` y `backend2.sh` existen
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Pista 1: `upstream` va en el contexto `http`, antes de los `server`.
- Pista 2: Round-robin (default) reparte en orden: 9001, 9002, 9001, 9002...
- Pista 3: El nombre del upstream (`app_backend`) se referencia en `proxy_pass` sin path.
- Pista 4: Cada backend simulado usa `nc -l` en su puerto y responde su identificador.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```nginx
events { worker_connections 1024; }
http {
    upstream app_backend {
        server 127.0.0.1:9001;
        server 127.0.0.1:9002;
    }

    server {
        listen 8080;

        location / {
            proxy_pass http://app_backend;
            proxy_set_header Host $host;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        }
    }
}
```

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
