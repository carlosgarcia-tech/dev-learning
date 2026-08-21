# Ejercicio 05 — location con regex

- **Nivel:** 2/5
- **Tema:** `location` con regex (`~` y `~*`) y prioridad de matching
- **Tiempo estimado:** 25 min

## Enunciado

Configura Nginx para tratar distintos tipos de archivo con `location` regex:

- Puerto `8080`, `root` apuntando a `web/`.
- `location ~* \.(jpg|png|gif|svg)$ { expires 30d; }` — imágenes con caché.
- `location ~* \.php$ { return 403; }` — bloquear PHP (seguridad).
- `location ~* \.(css|js)$ { expires 1y; }` — assets con caché larga.
- `location / { try_files $uri $uri/ =404; }` — el resto normal.

Crea `web/logo.svg`, `web/app.css` y `web/index.html`.

El test verifica:
- `/logo.svg` → 200 con `Cache-Control` que contiene `max-age` (de las imágenes).
- `/app.css` → 200 con `max-age=31536000`.
- `/evil.php` → 403.

## Requisitos

- [ ] `server` escucha en `8080` con `root` apuntando a `web/`
- [ ] `location ~*` para imágenes con `expires 30d`
- [ ] `location ~*` para css/js con `expires 1y`
- [ ] `location ~*` para `.php` con `return 403`
- [ ] `location /` con `try_files`
- [ ] `web/logo.svg`, `web/app.css`, `web/index.html` existen
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Pista 1: `~*` es regex insensible a mayúsculas (matchea `.PNG` y `.png`).
- Pista 2: Las regex se evalúan en orden de aparición; la primera que matchea gana.
- Pista 3: `return 403;` devuelve Forbidden sin servir archivo.
- Pista 4: El orden importa: pon `\.php$` antes si quieres que se aplique aunque matchee otra regex.

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

        location ~* \.php$ {
            return 403;
        }
        location ~* \.(jpg|png|gif|svg)$ {
            expires 30d;
        }
        location ~* \.(css|js)$ {
            expires 1y;
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
