# Ejercicio 03 — autoindex

- **Nivel:** 2/5
- **Tema:** Listado de directorios con `autoindex`
- **Tiempo estimado:** 20 min

## Enunciado

Configura Nginx para listar el contenido de un directorio de descargas:

- Puerto `8080`, `root` apuntando a `web/`.
- `location /descargas/` con `autoindex on;` y `alias` apuntando a `web/descargas/`.
- `autoindex_exact_size off;` (tamaños legibles) y `autoindex_localtime on;` (hora local).
- El `location /` sirve el `index.html` normal.

Crea `web/descargas/file1.txt` y `web/descargas/file2.txt`.

El test verifica que `/descargas/` devuelve un HTML que contiene `file1.txt` y `file2.txt`.

## Requisitos

- [ ] `server` escucha en `8080` con `root` apuntando a `web/`
- [ ] `location /descargas/` con `autoindex on;`
- [ ] `autoindex_exact_size off;` presente
- [ ] `web/descargas/file1.txt` y `web/descargas/file2.txt` existen
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Pista 1: `autoindex on;` hace que Nginx genere una página HTML con la lista de archivos del directorio.
- Pista 2: Sin `index` en ese directorio y con `autoindex off` (default), devuelve 403 Forbidden.
- Pista 3: `alias /ruta/descargas/;` sustituye el prefix `/descargas/`.
- Pista 4: El HTML generado contiene enlaces `<a href="file1.txt">file1.txt</a>`.

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

        location /descargas/ {
            alias /ruta/abs/a/web/descargas/;
            autoindex on;
            autoindex_exact_size off;
            autoindex_localtime on;
        }
    }
}
```

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
