# Ejercicio 05 — try_files

- **Nivel:** 1/5
- **Tema:** `try_files` para fallback de archivos (SPA pattern)
- **Tiempo estimado:** 20 min

## Enunciado

Configura Nginx como servidor de una SPA (single page app) en `./web`:

- Puerto `8080`.
- `root` apunta a `web/`.
- `location /` con `try_files $uri $uri/ /index.html;` para que cualquier ruta inexistente caiga en `index.html`.

Crea `web/index.html` con `SPA` y `web/real.html` con `pagina real`.

El test verifica que `/real.html` sirve "pagina real" y `/ruta/inventada` sirve el `index.html` (fallback), ambos con 200.

## Requisitos

- [ ] `server` escucha en `8080`
- [ ] `root` apunta a `web/`
- [ ] `try_files $uri $uri/ /index.html;` está presente (fallback a index.html, NO a `=404`)
- [ ] `web/index.html` contiene `SPA`
- [ ] `web/real.html` contiene `pagina real`
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Pista 1: `try_files $uri $uri/ /index.html;` prueba el archivo, el directorio y si no, sirve `/index.html` como sub-petición interna (status 200, no 404).
- Pista 2: El fallback `/index.html` es una URI interna, no un código de error.
- Pista 3: Por eso una ruta como `/ruta/inventada` devuelve 200 con el contenido del index.

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
            try_files $uri $uri/ /index.html;
        }
    }
}
```

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
