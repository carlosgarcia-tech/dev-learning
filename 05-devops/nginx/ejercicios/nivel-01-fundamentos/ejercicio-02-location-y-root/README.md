# Ejercicio 02 — Location y root

- **Nivel:** 1/5
- **Tema:** `location` y `root` para servir archivos del disco
- **Tiempo estimado:** 20 min

## Enunciado

Crea una configuración que sirva archivos estáticos desde el directorio `./web`:

- Escucha en el puerto `8080`.
- `location /` con `root` apuntando a `./web` (usa `root /ruta/absoluta/web;`).
- Un `index index.html` para que `/` sirva `web/index.html`.

Crea también el archivo `web/index.html` con el contenido `pagina de inicio`.

## Requisitos

- [ ] El `server` escucha en `8080`
- [ ] `location /` define `root` apuntando a la carpeta `web/`
- [ ] `index index.html` está configurado
- [ ] El archivo `web/index.html` existe con el contenido `pagina de inicio`
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Pista 1: `root /abs/path/web;` hace que `/index.html` sirva `/abs/path/web/index.html`.
- Pista 2: Necesitas un bloque `events` y un `http`.
- Pista 3: El path del `root` debe ser **absoluto** o relativo al prefijo de Nginx. Usa la ruta absoluta a `web/` dentro de la carpeta del ejercicio.
- Pista 4: Para que el test funcione sin permisos de root, no declares `user` (Nginx usa el usuario que lo arranca).

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```nginx
events {
    worker_connections 1024;
}

http {
    server {
        listen 8080;
        location / {
            root /ruta/absoluta/a/web;
            index index.html;
        }
    }
}
```

Y `web/index.html`:

```html
pagina de inicio
```

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
