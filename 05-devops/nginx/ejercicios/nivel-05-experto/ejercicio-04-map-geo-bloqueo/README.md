# Ejercicio 04 — map y geo para bloqueo por IP

- **Nivel:** 5/5
- **Tema:** `map` y `geo` combinados para control de acceso por IP
- **Tiempo estimado:** 35 min

## Enunciado

Configura Nginx con `geo` y `map` para bloquear rangos de IPs de forma elegante:

- `geo $blocked_country { default 0; 10.0.0.0/8 0; 192.168.99.0/24 1; 203.0.113.0/24 1; }` en `http`.
- `map $blocked_country $access_action { 0 allow; 1 deny; }` en `http`.
- Puerto `8080`, `root` apuntando a `web/`.
- En `location /`, si `$access_action` es `deny`, devuelve `403`.

El test verifica la estructura de `geo` + `map` y que una IP bloqueada recibe 403.

## Requisitos

- [ ] `geo $blocked_country` (o similar) definido con al menos 2 rangos a `1`
- [ ] `map` que convierte el valor de `geo` en `allow`/`deny`
- [ ] Lógica de bloqueo con `if` o `deny` en `location /`
- [ ] `web/index.html` existe
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Pista 1: `geo` mapea IP → valor (0 o 1). Es más eficiente que una cadena de `if`.
- Pista 2: `map` convierte el valor de `geo` en otra cosa (ej: `allow`/`deny`).
- Pista 3: `if ($access_action = deny) { return 403; }` aplica el bloqueo.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```nginx
events { worker_connections 1024; }
http {
    geo $blocked_country {
        default 0;
        10.0.0.0/8       0;
        192.168.99.0/24   1;
        203.0.113.0/24    1;
    }

    map $blocked_country $access_action {
        0 allow;
        1 deny;
    }

    server {
        listen 8080;
        root /ruta/abs/a/web;
        index index.html;

        location / {
            if ($access_action = deny) { return 403; }
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
