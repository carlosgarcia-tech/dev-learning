# Ejercicio 03 — Servir index.html estático

- **Nivel:** 1/5
- **Tema:** Servir un `index.html` estático completo
- **Tiempo estimado:** 15 min

## Enunciado

Configura Nginx para servir un sitio estático desde `./web`:

- Puerto `8080`.
- `server_name localhost`.
- `root` apuntando a `./web`.
- `index index.html`.
- `try_files $uri $uri/ =404;` para que devuelva 404 si no existe.

Crea `web/index.html` con `<h1>hola mundo</h1>` y `web/about.html` con `<h1>about</h1>`.

El test verifica que `/` sirve el index, `/about.html` sirve about y `/nope` da 404.

## Requisitos

- [ ] `server` escucha en `8080` con `server_name localhost`
- [ ] `root` apunta a `web/` y `index index.html`
- [ ] `try_files $uri $uri/ =404;` está presente
- [ ] `web/index.html` contiene `hola mundo`
- [ ] `web/about.html` contiene `about`
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Pista 1: `try_files $uri $uri/ =404;` prueba el archivo, el directorio y si no, 404.
- Pista 2: `=404` es el fallback final; produce una respuesta 404 interna.
- Pista 3: El `root` debe ser la ruta absoluta a `web/`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```nginx
events { worker_connections 1024; }
http {
    server {
        listen 8080;
        server_name localhost;
        root /ruta/absoluta/a/web;
        index index.html;
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
