# Ejercicio 02 — expires y caché de estáticos

- **Nivel:** 2/5
- **Tema:** `expires` y `Cache-Control` para archivos estáticos
- **Tiempo estimado:** 20 min

## Enunciado

Configura Nginx para cachear assets estáticos con distinto TTL según el tipo:

- Puerto `8080`, `root` apuntando a `web/`.
- `location ~* \.(css|js)$ { expires 1y; add_header Cache-Control "public, immutable"; }`
- `location ~* \.(png|jpg|svg)$ { expires 30d; add_header Cache-Control "public"; }`
- `location ~* \.html$ { add_header Cache-Control "no-cache"; }`

Crea `web/app.css`, `web/logo.svg` y `web/index.html`.

El test verifica:
- `/app.css` → `Cache-Control` contiene `max-age=31536000` (1 año).
- `/index.html` → `Cache-Control` contiene `no-cache`.

## Requisitos

- [ ] `server` escucha en `8080` con `root` apuntando a `web/`
- [ ] `location` regex para css/js con `expires 1y` y `Cache-Control "public, immutable"`
- [ ] `location` regex para imágenes con `expires 30d`
- [ ] `location` regex para html con `Cache-Control "no-cache"`
- [ ] `web/app.css`, `web/logo.svg` e `web/index.html` existen
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Pista 1: `expires 1y;` genera `Cache-Control: max-age=31536000`.
- Pista 2: `expires 30d;` → `max-age=2592000`.
- Pista 3: `add_header Cache-Control "no-cache";` (sin `expires`) → el navegador revalida siempre.
- Pista 4: Usa `~*` para regex insensible a mayúsculas (`.CSS` y `.css`).

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

        location ~* \.(css|js)$ {
            expires 1y;
            add_header Cache-Control "public, immutable";
        }
        location ~* \.(png|jpg|jpeg|svg)$ {
            expires 30d;
            add_header Cache-Control "public";
        }
        location ~* \.html$ {
            add_header Cache-Control "no-cache";
        }
        location / { try_files $uri $uri/ =404; }
    }
}
```

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
