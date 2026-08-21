# Ejercicio 06 — Bloqueo por IP con geo y deny

- **Nivel:** 4/5
- **Tema:** Bloqueo por IP con `geo`, `map`, `deny` y `allow`
- **Tiempo estimado:** 30 min

## Enunciado

Configura Nginx para bloquear IPs específicas usando `geo` y `deny`/`allow`:

- Define `geo $blocked { default 0; 192.168.99.50 1; }` en `http` (IP a bloquear).
- Puerto `8080`, `root` apuntando a `web/`.
- En `location /`, si `$blocked` es 1, devuelve `403`.
- `location /admin` con `allow 10.0.0.0/8; deny all;` (solo red interna).

El test verifica que la configuración contiene `geo`, `deny` y `allow` correctamente.

## Requisitos

- [ ] `geo $blocked` (o similar) definido en `http`
- [ ] `allow` y `deny` presentes en `location /admin`
- [ ] La lógica de bloqueo por `geo` presente (con `if` o `deny`)
- [ ] `web/index.html` existe
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Pista 1: `geo $blocked { default 0; 192.168.99.50 1; }` mapea la IP a 1.
- Pista 2: `if ($blocked) { return 403; }` bloquea si el valor es 1.
- Pista 3: `allow 10.0.0.0/8; deny all;` permite solo la red interna.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```nginx
events { worker_connections 1024; }
http {
    geo $blocked {
        default 0;
        192.168.99.50 1;
    }

    server {
        listen 8080;
        root /ruta/abs/a/web;
        index index.html;

        location / {
            if ($blocked) { return 403; }
            try_files $uri $uri/ =404;
        }

        location /admin {
            allow 10.0.0.0/8;
            deny all;
            return 200 "admin interno\n";
            default_type text/plain;
        }
    }
}
```

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
