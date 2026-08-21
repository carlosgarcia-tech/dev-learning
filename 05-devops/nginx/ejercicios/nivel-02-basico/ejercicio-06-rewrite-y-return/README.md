# Ejercicio 06 — rewrite y return

- **Nivel:** 2/5
- **Tema:** `rewrite` y `return` para redirecciones y respuestas directas
- **Tiempo estimado:** 25 min

## Enunciado

Configura Nginx con reescrituras y redirecciones:

- Puerto `8080`, `root` apuntando a `web/`.
- `location = /old { return 301 /new; }` — redirección permanente de `/old` a `/new`.
- `location = /new { return 200 "nueva ruta\n"; default_type text/plain; }` — respuesta directa.
- `rewrite ^/v1/(.*)$ /$1 break;` — reescribe `/v1/index.html` a `/index.html` (dentro del mismo location).
- `location / { try_files $uri $uri/ =404; }` — resto normal.

Crea `web/index.html`.

El test verifica:
- `/old` → 301 con `Location: /new`.
- `/new` → 200 con body `nueva ruta`.
- `/v1/index.html` → 200 con `pagina reescrita` (gracias al rewrite).

## Requisitos

- [ ] `server` escucha en `8080` con `root` apuntando a `web/`
- [ ] `location = /old` con `return 301 /new;`
- [ ] `location = /new` con `return 200 "nueva ruta\n";`
- [ ] `rewrite ^/v1/(.*)$ /$1 break;` presente
- [ ] `location /` con `try_files`
- [ ] `web/index.html` contiene `pagina reescrita`
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Pista 1: `return 301 /new;` devuelve 301 con `Location: /new` (redirección interna).
- Pista 2: `return 200 "texto\n";` devuelve 200 con body directo (sin servir archivo).
- Pista 3: `rewrite ^/v1/(.*)$ /$1 break;` captura lo que va tras `/v1/` y lo usa como nueva URI. `break` evita reevaluar locations.
- Pista 4: Con `break`, Nginx sigue en el mismo `location` y sirve el archivo reescrito.

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

        location = /old {
            return 301 /new;
        }

        location = /new {
            default_type text/plain;
            return 200 "nueva ruta\n";
        }

        location /v1/ {
            rewrite ^/v1/(.*)$ /$1 break;
            try_files $uri $uri/ =404;
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
