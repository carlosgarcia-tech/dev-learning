# Ejercicio 01 — HTTPS con certificado self-signed

- **Nivel:** 4/5
- **Tema:** HTTPS con certificado autofirmado generado con `openssl`
- **Tiempo estimado:** 30 min

## Enunciado

Configura Nginx para servir HTTPS con un certificado autofirmado:

- Genera el certificado con `openssl` (ya provisto en `ssl/generate-cert.sh`).
- `listen 443 ssl;`
- `ssl_certificate /ruta/ssl/selfsigned.crt;`
- `ssl_certificate_key /ruta/ssl/selfsigned.key;`
- `ssl_protocols TLSv1.2 TLSv1.3;`
- `location /` sirve `web/index.html` con `hola https`.

El test verifica que `https://localhost` responde 200 con `hola https` (usando `-k` para ignorar el certificado self-signed).

## Requisitos

- [ ] `listen 443 ssl;` presente
- [ ] `ssl_certificate` y `ssl_certificate_key` configurados
- [ ] `ssl_protocols TLSv1.2 TLSv1.3;` presente
- [ ] `web/index.html` contiene `hola https`
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Pista 1: Genera el certificado con `bash ssl/generate-cert.sh` antes de probar.
- Pista 2: `openssl req -x509 -nodes -newkey rsa:2048 -keyout ... -out ... -days 365 -subj "/CN=localhost"`.
- Pista 3: El test usa `curl -k` para ignorar la validación del certificado self-signed.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```nginx
events { worker_connections 1024; }
http {
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
bash ssl/generate-cert.sh   # genera el certificado (una vez)
bash test.sh
```
