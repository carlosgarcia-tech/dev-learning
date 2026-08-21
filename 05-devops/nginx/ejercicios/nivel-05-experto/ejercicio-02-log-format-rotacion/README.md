# Ejercicio 02 — Log format personalizado y rotación

- **Nivel:** 5/5
- **Tema:** Log format con `request_time` y `upstream_response_time` + configuración de `logrotate`
- **Tiempo estimado:** 35 min

## Enunciado

Configura Nginx con un log format personalizado que incluya tiempos de respuesta:

- Define `log_format main` con: `$remote_addr`, `$time_local`, `$request`, `$status`, `$body_bytes_sent`, `$request_time`, `$upstream_response_time`.
- `access_log /ruta/logs/access.log main;`
- `error_log /ruta/logs/error.log warn;`
- Puerto `8080`, `location /` con `return 200 "logged\n";`.
- Crea `logrotate/nginx` con la configuración de rotación (daily, rotate 14, compress, postrotate con `kill -USR1`).

## Requisitos

- [ ] `log_format main` definido con `$request_time` y `$upstream_response_time`
- [ ] `access_log` con el formato `main`
- [ ] `error_log` con nivel `warn`
- [ ] `logrotate/nginx` existe con `daily`, `rotate 14`, `compress`
- [ ] `logrotate/nginx` tiene `postrotate` con `kill -USR1`
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Pista 1: `log_format` va en el contexto `http`.
- Pista 2: `$request_time` es el tiempo total de la petición; `$upstream_response_time` el del backend.
- Pista 3: `kill -USR1` al master hace que Nginx reabra los logs sin cortar conexiones.
- Pista 4: `logrotate` usa `sharedscripts` + `postrotate` para ejecutar el signal una sola vez.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```nginx
events { worker_connections 1024; }
http {
    log_format main '$remote_addr - [$time_local] "$request" '
                    '$status $body_bytes_sent rt=$request_time '
                    'urt=$upstream_response_time';

    access_log /ruta/logs/access.log main;
    error_log  /ruta/logs/error.log warn;

    server {
        listen 8080;
        location / {
            return 200 "logged\n";
            default_type text/plain;
        }
    }
}
```

`logrotate/nginx`:

```
/ruta/logs/*.log {
    daily
    rotate 14
    compress
    delaycompress
    missingok
    notifempty
    create 640 nginx adm
    sharedscripts
    postrotate
        [ -f /run/nginx.pid ] && kill -USR1 `cat /run/nginx.pid`
    endscript
}
```

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
