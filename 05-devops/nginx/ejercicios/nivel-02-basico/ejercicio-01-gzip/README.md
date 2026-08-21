# Ejercicio 01 — gzip

- **Nivel:** 2/5
- **Tema:** Compresión `gzip` de respuestas
- **Tiempo estimado:** 20 min

## Enunciado

Configura Nginx para que comprima con gzip las respuestas de texto. Sirve archivos estáticos desde `./web` en el puerto `8080`:

- `gzip on;` activado a nivel `http`.
- `gzip_types text/plain text/css application/javascript application/json image/svg+xml;`
- `gzip_min_length 256;`
- `gzip_comp_level 6;`
- `gzip_vary on;`

Crea `web/app.css` con un contenido largo (al menos 300 bytes de CSS repetido) y `web/index.html`.

El test pide `/app.css` con `Accept-Encoding: gzip` y verifica que la respuesta tiene `Content-Encoding: gzip`.

## Requisitos

- [ ] `server` escucha en `8080` con `root` apuntando a `web/`
- [ ] `gzip on;` presente en el bloque `http`
- [ ] `gzip_types` incluye al menos `text/css` y `application/json`
- [ ] `gzip_min_length 256;` configurado
- [ ] `web/app.css` tiene al menos 300 bytes
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Pista 1: `gzip` se activa en el contexto `http` (o `server`/`location`).
- Pista 2: El cliente debe enviar `Accept-Encoding: gzip` para que Nginx comprima.
- Pista 3: `gzip_min_length` evita comprimir archivos pequeños (no compensa la CPU).
- Pista 4: `text/html` **siempre** se comprime si gzip está on, no hace falta ponerlo en `gzip_types`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```nginx
events { worker_connections 1024; }
http {
    gzip on;
    gzip_comp_level 6;
    gzip_min_length 256;
    gzip_vary on;
    gzip_types text/plain text/css application/javascript application/json image/svg+xml;

    server {
        listen 8080;
        root /ruta/abs/a/web;
        index index.html;
        location / { try_files $uri $uri/ =404; }
    }
}
```

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
