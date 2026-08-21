# Ejercicio 05 — FastCGI con PHP-FPM

- **Nivel:** 5/5
- **Tema:** Contenido dinámico con FastCGI y PHP-FPM
- **Tiempo estimado:** 35 min

## Enunciado

Configura Nginx para servir PHP a través de PHP-FPM:

- Puerto `8080`, `root` apuntando a `web/`.
- `location ~ \.php$` con:
  - `fastcgi_pass 127.0.0.1:9000;` (o `unix:/run/php-fpm/www.sock;`)
  - `fastcgi_index index.php;`
  - `include fastcgi_params;`
  - `fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;`
- `location /` con `try_files $uri $uri/ /index.php?$query_string;` (front controller).
- Crea `web/index.php` con `<?php echo "php-fpm ok"; ?>`.

> Como PHP-FPM no está garantizado en el entorno, el test valida principalmente la estructura de la config (directivas `fastcgi_*`).

## Requisitos

- [ ] `location ~ \.php$` presente
- [ ] `fastcgi_pass` configurado
- [ ] `include fastcgi_params;` presente
- [ ] `fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;` presente
- [ ] `try_files` con fallback a `/index.php` en `location /`
- [ ] `web/index.php` existe con `php-fpm ok`
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Pista 1: Nginx no ejecuta PHP; lo reenvía a PHP-FPM por FastCGI.
- Pista 2: `SCRIPT_FILENAME` le dice a FPM qué script ejecutar.
- Pista 3: `fastcgi_params` incluye las cabeceras CGI estándar (CONTENT_TYPE, REQUEST_METHOD...).
- Pista 4: El front controller (`/index.php?$query_string`) es el patrón de Laravel/Symfony.

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
        index index.php index.html;

        location / {
            try_files $uri $uri/ /index.php?$query_string;
        }

        location ~ \.php$ {
            fastcgi_pass 127.0.0.1:9000;
            fastcgi_index index.php;
            include fastcgi_params;
            fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        }
    }
}
```

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
