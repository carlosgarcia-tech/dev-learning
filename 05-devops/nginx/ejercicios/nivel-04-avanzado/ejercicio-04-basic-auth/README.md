# Ejercicio 04 — Basic auth

- **Nivel:** 4/5
- **Tema:** Protección de rutas con `auth_basic` y `htpasswd`
- **Tiempo estimado:** 25 min

## Enunciado

Configura Nginx para proteger el área `/admin` con basic auth:

- Puerto `8080`.
- `location /admin { auth_basic "Area restringida"; auth_basic_user_file /ruta/.htpasswd; }`
- `location /` sirve estáticos desde `web/`.

El archivo `.htpasswd` se genera con `htpasswd` (ya provisto en `auth/generate-htpasswd.sh`).
- Usuario: `admin`, contraseña: `secret123`

El test verifica que `/admin` sin credenciales da 401, y con `admin:secret123` da 200.

## Requisitos

- [ ] `location /admin` con `auth_basic` activado
- [ ] `auth_basic_user_file` apuntando al `.htpasswd`
- [ ] `auth/generate-htpasswd.sh` existe
- [ ] `web/index.html` existe
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Pista 1: `auth_basic "texto";` activa la protección; el string es el "realm".
- Pista 2: El `.htpasswd` se genera con `htpasswd -bc file user pass` (requiere `apache2-utils`).
- Pista 3: El test usa `curl -u admin:secret123` para enviar las credenciales.

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

        location /admin {
            auth_basic "Area restringida";
            auth_basic_user_file /ruta/abs/auth/.htpasswd;
            return 200 "admin area\n";
            default_type text/plain;
        }
    }
}
```

</details>

## Cómo ejecutar los tests

```bash
bash auth/generate-htpasswd.sh
bash test.sh
```
