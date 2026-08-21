# Ejercicio 01 — Server block básico

- **Nivel:** 1/5
- **Tema:** Bloque `server` con `listen` y `location /`
- **Tiempo estimado:** 15 min

## Enunciado

Crea una configuración Nginx mínima con un bloque `server` que escuche en el puerto 8080 y responda a cualquier URI con el texto `hola nginx` y `Content-Type: text/plain`.

No sirve archivos del disco: usa `return 200 "hola nginx\n";` dentro de `location /`.

## Requisitos

- [ ] El `nginx.conf` define un bloque `http` con un `server`
- [ ] El `server` escucha en el puerto `8080`
- [ ] Existe un `location /` que devuelve `200` con el body `hola nginx`
- [ ] La cabecera `Content-Type` es `text/plain`
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Pista 1: La estructura mínima es `events {}` + `http { server { ... } }`.
- Pista 2: `listen 8080;` fija el puerto. No hace falta `server_name`.
- Pista 3: `return 200 "texto\n";` devuelve 200 con body. Añade `default_type text/plain;` para forzar el MIME.
- Pista 4: Recuerda el bloque `events { worker_connections 1024; }` — es obligatorio.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```nginx
# nginx.conf
events {
    worker_connections 1024;
}

http {
    server {
        listen 8080;
        location / {
            default_type text/plain;
            return 200 "hola nginx\n";
        }
    }
}
```

</details>

## Cómo ejecutar los tests

```bash
bash test.sh   # valida nginx.conf: nginx -t + curl si nginx está; estructura si no
```
