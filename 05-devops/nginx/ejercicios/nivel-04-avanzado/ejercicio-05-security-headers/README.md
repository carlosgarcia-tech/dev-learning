# Ejercicio 05 — Cabeceras de seguridad (HSTS, X-Frame-Options)

- **Nivel:** 4/5
- **Tema:** Cabeceras de seguridad: HSTS, X-Frame-Options, X-Content-Type-Options
- **Tiempo estimado:** 25 min

## Enunciado

Configura Nginx para inyectar cabeceras de seguridad en todas las respuestas:

- Puerto `8080`, `root` apuntando a `web/`.
- `add_header Strict-Transport-Security "max-age=31536000" always;` (HSTS 1 año)
- `add_header X-Frame-Options "SAMEORIGIN" always;` (anti-clickjacking)
- `add_header X-Content-Type-Options "nosniff" always;` (anti MIME sniff)
- `add_header Referrer-Policy "strict-origin-when-cross-origin" always;`

El test verifica que la respuesta a `/` contiene las 4 cabeceras.

## Requisitos

- [ ] `Strict-Transport-Security` con `max-age=31536000`
- [ ] `X-Frame-Options` con `SAMEORIGIN`
- [ ] `X-Content-Type-Options` con `nosniff`
- [ ] `Referrer-Policy` presente
- [ ] Todas las cabeceras con `always`
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Pista 1: `always` hace que la cabecera se añada incluso en respuestas 4xx/5xx.
- Pista 2: HSTS solo tiene sentido sobre HTTPS, pero para el ejercicio lo validamos sobre HTTP.
- Pista 3: Si defines `add_header` en un `location`, se sobrescriben los del `server`. Ponlas a nivel `server` o repítelas en el `location`.

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

        add_header Strict-Transport-Security "max-age=31536000" always;
        add_header X-Frame-Options "SAMEORIGIN" always;
        add_header X-Content-Type-Options "nosniff" always;
        add_header Referrer-Policy "strict-origin-when-cross-origin" always;

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
