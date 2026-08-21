# Ejercicio 03 — proxy_set_header y X-Forwarded-For

- **Nivel:** 3/5
- **Tema:** `proxy_set_header` para reenviar `Host`, `X-Real-IP` y `X-Forwarded-For`
- **Tiempo estimado:** 25 min

## Enunciado

Configura Nginx como reverse proxy que reenvía las cabeceras correctas al backend:

- `upstream app_backend { server 127.0.0.1:9001; }`
- Puerto `8080`, `proxy_pass http://app_backend;`.
- `proxy_set_header Host $host;`
- `proxy_set_header X-Real-IP $remote_addr;`
- `proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;`
- `proxy_set_header X-Forwarded-Proto $scheme;`

El backend simulado (`backend.sh`) devuelve un body con las cabeceras que recibe, para que el test verifique que `X-Forwarded-For` llega al backend.

## Requisitos

- [ ] `upstream` con al menos un backend
- [ ] `proxy_pass http://app_backend;`
- [ ] `proxy_set_header Host $host;` presente
- [ ] `proxy_set_header X-Real-IP $remote_addr;` presente
- [ ] `proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;` presente
- [ ] `proxy_set_header X-Forwarded-Proto $scheme;` presente
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Pista 1: Sin `proxy_set_header Host`, el backend recibe `app_backend` como Host (el nombre del upstream).
- Pista 2: `$proxy_add_x_forwarded_for` combina el `X-Forwarded-For` existente con `$remote_addr`.
- Pista 3: `$scheme` vale `http` o `https` según la conexión entrante.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```nginx
events { worker_connections 1024; }
http {
    upstream app_backend {
        server 127.0.0.1:9001;
    }
    server {
        listen 8080;
        location / {
            proxy_pass http://app_backend;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
        }
    }
}
```

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
