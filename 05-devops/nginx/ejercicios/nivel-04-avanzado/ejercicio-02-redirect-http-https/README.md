# Ejercicio 02 — Redirect HTTP → HTTPS

- **Nivel:** 4/5
- **Tema:** Redirección permanente de HTTP a HTTPS
- **Tiempo estimado:** 25 min

## Enunciado

Configura Nginx con dos server blocks: uno HTTP que redirige a HTTPS y otro HTTPS que sirve el contenido:

- `server { listen 80; return 301 https://$host$request_uri; }`
- `server { listen 443 ssl; ... }` con el certificado y `location /` sirviendo `web/index.html`.

Reutiliza el certificado del ejercicio 01 (o genera uno con `ssl/generate-cert.sh`).

El test verifica que `http://localhost` devuelve 301 con `Location: https://...`.

## Requisitos

- [ ] Un `server` con `listen 80` y `return 301 https://$host$request_uri;`
- [ ] Un `server` con `listen 443 ssl`, `ssl_certificate`, `ssl_certificate_key`
- [ ] `ssl_protocols TLSv1.2 TLSv1.3;`
- [ ] `web/index.html` existe
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Pista 1: `return 301 https://$host$request_uri;` redirige preservando el host y la ruta.
- Pista 2: `$host` es el Host de la petición; `$request_uri` es la URI completa con query string.
- Pista 3: Necesitas 2 `server` blocks en el mismo `http`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```nginx
events { worker_connections 1024; }
http {
    server {
        listen 80;
        server_name localhost;
        return 301 https://$host$request_uri;
    }

    server {
        listen 443 ssl;
        server_name localhost;

        ssl_certificate     /ruta/abs/ssl/selfsigned.crt;
        ssl_certificate_key /ruta/abs/ssl/selfsigned.key;
        ssl_protocols       TLSv1.2 TLSv1.3;

        root /ruta/abs/a/web;
        index index.html;
        location / { try_files $uri $uri/ =404; }
    }
}
```

</details>

## Cómo ejecutar los tests

```bash
bash ssl/generate-cert.sh
bash test.sh
```
