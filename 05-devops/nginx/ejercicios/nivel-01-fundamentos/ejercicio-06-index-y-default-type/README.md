# Ejercicio 06 — index y default_type

- **Nivel:** 1/5
- **Tema:** `index` y `default_type` para MIME y archivos por defecto
- **Tiempo estimado:** 20 min

## Enunciado

Configura Nginx para servir una API mock desde `./web`:

- Puerto `8080`.
- `root` apunta a `web/`.
- `index index.html;`.
- Un `location /api/` con `default_type application/json;` que sirva `web/api/data.json`.

Crea `web/index.html` con `inicio` y `web/api/data.json` con `{"ok":true}`.

El test verifica:
- `/` sirve `index.html` con `Content-Type: text/html`.
- `/api/data.json` sirve el JSON con `Content-Type: application/json` (forzado por `default_type` o por `mime.types`).

## Requisitos

- [ ] `server` escucha en `8080`
- [ ] `root` apunta a `web/`, `index index.html`
- [ ] Existe `location /api/` con `default_type application/json;`
- [ ] `web/index.html` contiene `inicio`
- [ ] `web/api/data.json` contiene `{"ok":true}`
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Pista 1: `include mime.types;` en `http` mapea `.json` → `application/json` automáticamente. Si no lo incluyes, usa `default_type application/json;` para forzarlo.
- Pista 2: `location /api/` hereda el `root`, así que `/api/data.json` sirve `web/api/data.json`.
- Pista 3: Para el Content-Type de `index.html`, el `mime.types` mapea `.html` → `text/html`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```nginx
events { worker_connections 1024; }
http {
    include       /etc/nginx/mime.types;   # o el path del sistema
    default_type  application/octet-stream;
    server {
        listen 8080;
        root /ruta/abs/a/web;
        index index.html;
        location / {
            try_files $uri $uri/ =404;
        }
        location /api/ {
            default_type application/json;
            try_files $uri =404;
        }
    }
}
```

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
