# Ejercicio 04 — Virtual hosts

- **Nivel:** 1/5
- **Tema:** Múltiples `server` blocks (virtual hosts) por `server_name`
- **Tiempo estimado:** 25 min

## Enunciado

Crea **dos** virtual hosts en el mismo puerto `8080`, distinguibles por `server_name`:

- `server_name app1.local` → sirve `web/app1/index.html` con body `app1`
- `server_name app2.local` → sirve `web/app2/index.html` con body `app2`
- Un `server` por defecto (`default_server`) que responde `421` o `444` para hosts desconocidos (usa `return 444;`).

El test hace peticiones con `Host: app1.local` y `Host: app2.local` y comprueba el body correcto.

## Requisitos

- [ ] Hay **3** bloques `server`
- [ ] Dos escuchan en `8080` con `server_name app1.local` y `app2.local`
- [ ] Uno es `default_server` en `8080` y devuelve `444`
- [ ] Cada vhost sirve su `index.html` desde su carpeta (`web/app1/`, `web/app2/`)
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Pista 1: Varios `server` con el mismo `listen` se diferencian por `server_name`.
- Pista 2: `listen 8080 default_server;` marca el vhost por defecto (cuando el Host no encaja con ninguno).
- Pista 3: `return 444;` cierra la conexión sin respuesta (Nginx-specific).
- Pista 4: Cada `server` tiene su propio `root` apuntando a su carpeta.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```nginx
events { worker_connections 1024; }
http {
    server {
        listen 8080 default_server;
        server_name _;
        return 444;
    }
    server {
        listen 8080;
        server_name app1.local;
        root /ruta/abs/a/web/app1;
        index index.html;
        location / { try_files $uri $uri/ =404; }
    }
    server {
        listen 8080;
        server_name app2.local;
        root /ruta/abs/a/web/app2;
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
