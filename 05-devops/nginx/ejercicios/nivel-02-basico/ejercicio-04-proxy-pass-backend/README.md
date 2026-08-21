# Ejercicio 04 — proxy_pass a un backend

- **Nivel:** 2/5
- **Tema:** `proxy_pass` para reenviar peticiones a un backend
- **Tiempo estimado:** 25 min

## Enunciado

Configura Nginx como reverse proxy de un backend. El backend simulado es `backend.sh`, un pequeño servidor HTTP en bash con `nc` que escucha en el puerto 9001 y responde `backend-ok`.

- Puerto `8080` para Nginx.
- `location /api/` con `proxy_pass http://127.0.0.1:9001;`
- `location /` sirve estáticos desde `web/` (index.html con `frontend`).

El test arranca el backend simulado, levanta Nginx y verifica que `/api/` devuelve `backend-ok`.

> Si `nc` no está disponible, el test usa solo validación de estructura.

## Requisitos

- [ ] `server` escucha en `8080`
- [ ] `location /api/` con `proxy_pass http://127.0.0.1:9001;`
- [ ] `location /` sirve estáticos desde `web/`
- [ ] `backend.sh` existe y responde `backend-ok`
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Pista 1: `proxy_pass http://127.0.0.1:9001;` reenvía la petición al backend.
- Pista 2: Sin trailing slash en `proxy_pass`, la URI original llega al backend tal cual.
- Pista 3: El backend simulado usa `nc -l` para aceptar una conexión y devolver una respuesta HTTP.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```nginx
events { worker_connections 1024; }
http {
    server {
        listen 8080;
        root /ruta/abs/a/web;
        index index.html;

        location / {
            try_files $uri $uri/ =404;
        }

        location /api/ {
            proxy_pass http://127.0.0.1:9001;
            proxy_set_header Host $host;
        }
    }
}
```

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
