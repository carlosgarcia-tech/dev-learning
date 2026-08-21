# 05 — Rendimiento y producción
> Guía de rendimiento y producción en Nginx: tuning de `worker_processes`/`worker_connections`, keepalive, buffers, timeouts, log formats y rotación, `stub_status`, monitoring (Amplify/Prometheus), tuning del kernel de Linux, `nginx -t`, reload vs restart, `fail_timeout`/`max_fails`, `proxy_cache` y FastCGI/PHP-FPM. Escrito para Nginx 1.22+.

---

## Objetivos

- [ ] Ajustar `worker_processes auto` y `worker_connections` al hardware real
- [ ] Entender el límite de conexiones y la relación con FDs del kernel
- [ ] Configurar keepalive entre cliente y Nginx y entre Nginx y el backend (`upstream`)
- [ ] Ajustar buffers (`client_body_buffer_size`, `proxy_buffer_size`, `proxy_buffers`)
- [ ] Configurar timeouts (`client_*`, `proxy_*`, `keepalive_timeout`)
- [ ] Definir un **log format** personalizado y entender las variables
- [ ] Configurar **log rotation** con `logrotate`
- [ ] Activar `stub_status` para métricas internas
- [ ] Conectar Nginx a **Prometheus** (exporter) y conocer Amplify
- [ ] Ajustar el **kernel de Linux** (`somaxconn`, `net.core`, `tw_reuse`, `fd` ulimit)
- [ ] Diferenciar `nginx -t`, `reload`, `restart` y cuándo usar cada uno
- [ ] Configurar `fail_timeout`/`max_fails` en `upstream`
- [ ] Activar y afinar `proxy_cache` para cachear respuestas del backend
- [ ] Configurar **FastCGI** con PHP-FPM para contenido dinámico
- [ ] Construir una **config de producción** coherente

---

## Apuntes

### 1. Tuning de workers

```nginx
worker_processes auto;     # 1 por núcleo
worker_rlimit_nofile 65535; # FDs por worker (debe ser ≥ worker_connections×2)

events {
    worker_connections 4096;   # conns por worker
    multi_accept on;
    use epoll;
}
```

- Máx. clientes ≈ `worker_processes × worker_connections` (en modo proxy, divide entre 2 porque cada cliente consume 2 conexiones: cliente + backend).
- `worker_rlimit_nofile` debe cubrir `worker_connections` × 2 + margen. Si no, Nginx da `too many open files`.
- Verifica los núcleos con `nproc`.

**Comprobación:**

```bash
nproc                       # núcleos
ulimit -n                   # FDs del proceso
ps -ef | grep nginx         # ver workers
```

### 2. Keepalive

**Keepalive cliente ↔ Nginx** (reusa conexiones TCP):

```nginx
http {
    keepalive_timeout 65;        # s de inactividad antes de cerrar
    keepalive_requests 1000;     # máx. requests por conexión
}
```

**Keepalive Nginx ↔ backend** (evita reconectar al upstream):

```nginx
upstream backend {
    server 127.0.0.1:3000;
    keepalive 32;                # máx. conexiones keepalive al pool
}

server {
    location / {
        proxy_pass http://backend;
        proxy_http_version 1.1;
        proxy_set_header Connection "";   # vacío = reusar
    }
}
```

- `keepalive 32` mantiene un pool de 32 conexiones abiertas al backend.
- `proxy_http_version 1.1` + `Connection ""` es **obligatorio** para que el keepalive al backend funcione (HTTP/1.0 cierra por defecto).

### 3. Buffers

```nginx
http {
    client_body_buffer_size 16k;      # body en memoria antes de ir a disco
    client_max_body_size 10m;         # tamaño máx. del body
    client_header_buffer_size 4k;

    large_client_header_buffers 4 16k;

    proxy_buffer_size 16k;            # primera parte de la respuesta (cabeceras)
    proxy_buffers 8 16k;              # buffers para el body
    proxy_busy_buffers_size 32k;       # cuándo empezar a enviar al cliente
}
```

| Buffer | Para qué |
|---|---|
| `client_body_buffer_size` | Body del cliente en RAM antes de a disco |
| `client_max_body_size` | Límite del body (400 si se pasa) |
| `proxy_buffer_size` | Cabeceras de la respuesta del backend |
| `proxy_buffers` | Body de la respuesta del backend |
| `proxy_busy_buffers_size` | Threshold para empezar a enviar al cliente |

- Si `client_body_buffer_size` es pequeño, Nginx escribe el body a un archivo temporal → I/O lento.
- `proxy_buffering on` (default) deja a Nginx leer toda la respuesta antes de enviar: protege al cliente de backends lentos pero usa más memoria. `off` hace streaming (útil para SSE/long-poll).

### 4. Timeouts

```nginx
client_body_timeout 30s;     # leer el body del cliente
client_header_timeout 30s;   # leer las cabeceras
send_timeout 30s;            # enviar respuesta al cliente

proxy_connect_timeout 5s;    # conectar al backend
proxy_send_timeout 60s;       # enviar petición al backend
proxy_read_timeout 60s;      # leer respuesta del backend
```

- Timeouts cortos en el **cliente** mitigan slowloris.
- `proxy_connect_timeout` corto (5s) para no colgar al usuario si el backend está caído.
- `proxy_read_timeout` debe cubrir el tiempo máximo del backend (para SSE/WS, 3600s).

### 5. Log formats

```nginx
http {
    log_format main '$remote_addr - $remote_user [$time_local] '
                    '"$request" $status $body_bytes_sent '
                    '"$http_referer" "$http_user_agent" '
                    'rt=$request_time uct=$upstream_connect_time '
                    'urt=$upstream_response_time';

    access_log /var/log/nginx/access.log main;
    error_log  /var/log/nginx/error.log warn;
}
```

| Variable | Contenido |
|---|---|
| `$remote_addr` | IP del cliente |
| `$time_local` | Timestamp local |
| `$request` | Request line (método + URI + proto) |
| `$status` | Código de estado |
| `$body_bytes_sent` | Bytes del body (sin cabeceras) |
| `$request_time` | Tiempo total de la petición (s) |
| `$upstream_response_time` | Tiempo del backend (s) |
| `$upstream_connect_time` | Tiempo de conectar al backend |
| `$http_referer` | Cabecera Referer |
| `$http_user_agent` | Cabecera User-Agent |

> Para **log estructurado (JSON)**: define un `log_format` con `escape=json` (1.11.8+) y salidas JSON. Ideal para ELK/Loki.

```nginx
log_format json escape=json '{'
    '"time":"$time_iso8601",'
    '"remote_addr":"$remote_addr",'
    '"request":"$request",'
    '"status":$status,'
    '"request_time":$request_time,'
    '"upstream_response_time":"$upstream_response_time"'
'}';
access_log /var/log/nginx/access.json json;
```

### 6. Log rotation con `logrotate`

`/etc/logrotate.d/nginx`:

```
/var/log/nginx/*.log {
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

- `kill -USR1` a Nginx le dice "reabre los logs" sin cortar conexiones (sin reload).
- `daily rotate 14` guarda 14 días; `compress` los comprime.

### 7. `stub_status`: métricas internas

```nginx
server {
    listen 127.0.0.1:8090;
    location /stub_status {
        stub_status;
        allow 127.0.0.1;
        deny all;
    }
}
```

Salida:

```
Active connections: 15
server accepts handled requests
 8456 8456 32891
Reading: 0 Writing: 3 Waiting: 12
```

| Métrica | Significado |
|---|---|
| Active connections | Conexiones abiertas |
| accepts | Total aceptadas |
| handled | Total gestionadas |
| requests | Total de peticiones |
| Reading | Leyendo cabeceras |
| Writing | Devolviendo respuesta |
| Waiting | Idle en keepalive |

### 8. Monitoring con Prometheus / Amplify

**Prometheus** no habla `stub_status` directamente; se usa un exporter (ej. `nginx-prometheus-exporter`):

```bash
nginx-prometheus-exporter --nginx.scrape-uri=http://localhost:8090/stub_status
```

Métricas que expone: `nginx_connections_active`, `nginx_connections_reading`, `nginx_connections_writing`, `nginx_connections_waiting`, `nginx_http_requests_total`.

**Nginx Amplify** es el SaaS oficial de monitorización: un agente (`amplify-agent`) envía métricas, logs y config a un dashboard. Útil para empezar sin infra.

**Métricas a vigilar:**

- Conexiones activas y waiting (si waiting baja mucho, el keepalive no funciona).
- `requests/s` (throughput).
- `upstream_response_time` (latencia del backend).
- 4xx/5xx rate (errores).
- FDs usados vs límite.

### 9. Tuning del kernel de Linux

Nginx depende del kernel para red, FDs y timeouts. Ajustes típicos en `/etc/sysctl.d/99-nginx.conf`:

```bash
# cola de conexiones (backlog)
net.core.somaxconn = 4096
net.ipv4.tcp_max_syn_backlog = 4096

# reusar sockets en TIME_WAIT
net.ipv4.tcp_tw_reuse = 1

# backlog de NIC
net.core.netdev_max_backlog = 4096

# keepalive del kernel
net.ipv4.tcp_keepalive_time = 600
net.ipv4.tcp_keepalive_intvl = 30
net.ipv4.tcp_keepalive_probes = 3

# FDs
fs.file-max = 1000000
```

Aplicar: `sudo sysctl --system`.

Y los límites del proceso (systemd override o `/etc/security/limits.conf`):

```
nginx soft nofile 65535
nginx hard nofile 65535
```

> Sin estos ajustes, aunque `worker_connections 4096`, el kernel te limita antes (`somaxconn` por defecto 128 en algunas distros → backlog lleno → conexiones rechazadas).

### 10. `nginx -t`, reload vs restart

```bash
sudo nginx -t              # valida sintaxis (siempre antes de recargar)
sudo nginx -T              # vuelca config efectiva
sudo nginx -s reload       # recarga graceful (no corta conexiones)
sudo systemctl restart nginx # reinicio completo (corta)
sudo nginx -s stop         # para Nginx
```

| Acción | Corta conexiones | Cuándo |
|---|---|---|
| `reload` | No | Cambios de config (99% de los casos) |
| `restart` | Sí | Solo si el reload no surte efecto |
| `stop` | Sí | Emergencia |

**Flujo correcto:**

```bash
sudo nginx -t && sudo systemctl reload nginx
```

- `nginx -t` valida; si falla, **no** recargues (deja la config vieja, pero no cae).
- `reload` manda una señal al master, que relee config y lanza nuevos workers; los viejos terminan sus conexiones y mueren.

### 11. `fail_timeout` y `max_fails` en upstream

```nginx
upstream backend {
    server 10.0.0.1:3000 max_fails=3 fail_timeout=30s;
    server 10.0.0.2:3000 max_fails=3 fail_timeout=30s;
}
```

- Si un backend falla `max_fails` veces en `fail_timeout`, Nginx lo retira durante `fail_timeout`.
- Tras `fail_timeout`, Nginx **reintenta** una petición; si responde, vuelve a producción.
- `proxy_next_upstream` define qué se considera fallo (default: `error timeout`).

```nginx
proxy_next_upstream error timeout http_502 http_503 http_504;
proxy_next_upstream_tries 2;
```

### 12. `proxy_cache`: caching de respuestas

```nginx
http {
    proxy_cache_path /var/cache/nginx levels=1:2 keys_zone=api_cache:10m
                     max_size=1g inactive=60m use_temp_path=off;

    server {
        location /api/ {
            proxy_pass http://backend;
            proxy_cache api_cache;
            proxy_cache_valid 200 10m;
            proxy_cache_valid 404 1m;
            proxy_cache_key "$scheme$request_method$host$request_uri";
            proxy_cache_use_stale error timeout updating http_500 http_502 http_503 http_504;
            add_header X-Cache-Status $upstream_cache_status;
        }
    }
}
```

| Directiva | Para qué |
|---|---|
| `proxy_cache_path` | Define el directorio y la zona de claves |
| `keys_zone` | Nombre + tamaño de la zona en RAM (1 MB ≈ 8000 claves) |
| `max_size` | Tamaño máximo en disco |
| `inactive=60m` | Si no se accede en 60 min, se evicta |
| `proxy_cache_valid 200 10m` | Cachea 200 durante 10 min |
| `proxy_cache_key` | Clave de cacheo (default: método+host+URI) |
| `use_temp_path=off` | Escribe directo al cache (mejor I/O) |
| `proxy_cache_use_stale` | Sirve caché viejo si el backend falla |
| `$upstream_cache_status` | HIT/MISS/EXPIRED/STALE/UPDATING |

> `proxy_cache` es clave para backends lentos: si tu API tarda 500ms y la cacheas 1 min, Nginx sirve el HIT en 1ms. Cuidado con cachear respuestas personalizadas (usa `proxy_cache_bypass` con cookies).

**Bypass por cookie de sesión:**

```nginx
proxy_cache_bypass $cookie_session;
proxy_no_cache $cookie_session;
```

### 13. FastCGI y PHP-FPM

Para servir PHP, Nginx no lo ejecuta: lo reenvía a PHP-FPM por FastCGI:

```nginx
server {
    listen 80;
    root /var/www/phpapp;

    location ~ \.php$ {
        fastcgi_pass unix:/run/php-fpm/www.sock;   # o 127.0.0.1:9000
        fastcgi_index index.php;
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
    }

    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }
}
```

| Directiva | Para qué |
|---|---|
| `fastcgi_pass` | Dirección/socket del FPM |
| `fastcgi_params` | Cabeceras CGI estándar |
| `SCRIPT_FILENAME` | Path del script PHP a ejecutar |
| `fastcgi_index` | Script por defecto |
| `fastcgi_buffers` | Buffers de la respuesta FPM |

- PHP-FPM suele escuchar en `unix:/run/php-fpm/www.sock` (más rápido que TCP) o `127.0.0.1:9000`.
- `try_files ... /index.php` es el front controller de Laravel/Symfony: si no existe el archivo, pasa a `index.php`.

### 14. Config de producción (resumen)

```nginx
user nginx;
worker_processes auto;
worker_rlimit_nofile 65535;
pid /run/nginx.pid;
error_log /var/log/nginx/error.log warn;

events {
    worker_connections 4096;
    multi_accept on;
}

http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;
    server_tokens off;
    sendfile      on;
    tcp_nopush    on;
    tcp_nodelay   on;
    keepalive_timeout 65;
    keepalive_requests 1000;
    client_max_body_size 10m;

    gzip on;
    gzip_types text/css application/javascript application/json image/svg+xml;

    log_format main '$remote_addr - [$time_local] "$request" '
                    '$status $body_bytes_sent rt=$request_time';

    proxy_cache_path /var/cache/nginx levels=1:2 keys_zone=api_cache:10m
                     max_size=1g inactive=60m use_temp_path=off;

    upstream backend {
        least_conn;
        server 10.0.0.1:3000 max_fails=3 fail_timeout=30s;
        server 10.0.0.2:3000 max_fails=3 fail_timeout=30s;
        keepalive 32;
    }

    server {
        listen 80;
        server_name app.ejemplo.com;
        return 301 https://$host$request_uri;
    }

    server {
        listen 443 ssl http2;
        server_name app.ejemplo.com;

        ssl_certificate     /etc/nginx/ssl/app.crt;
        ssl_certificate_key /etc/nginx/ssl/app.key;
        ssl_protocols TLSv1.2 TLSv1.3;
        ssl_ciphers HIGH:!aNULL:!MD5;

        add_header Strict-Transport-Security "max-age=31536000" always;
        add_header X-Frame-Options "SAMEORIGIN" always;
        add_header X-Content-Type-Options "nosniff" always;

        location /api/ {
            proxy_pass http://backend;
            proxy_http_version 1.1;
            proxy_set_header Connection "";
            proxy_set_header Host $host;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_cache api_cache;
            proxy_cache_valid 200 10m;
            add_header X-Cache-Status $upstream_cache_status;
        }

        location / {
            root /var/www/app;
            try_files $uri $uri/ /index.html;
            expires 1d;
        }
    }
}
```

---

## Tablas de referencia

### Tuning de workers

| Directiva | Default | Producción |
|---|---|---|
| `worker_processes` | 1 | `auto` |
| `worker_connections` | 512 | 4096+ |
| `worker_rlimit_nofile` | auto | 65535 |
| `multi_accept` | off | on |

### Buffers y timeouts

| Directiva | Default | Para qué |
|---|---|---|
| `client_body_buffer_size` | 8k/16k | Body en RAM |
| `client_max_body_size` | 1m | Límite body |
| `proxy_buffer_size` | 4k/8k | Cabeceras backend |
| `proxy_buffers` | 8 4k | Body backend |
| `keepalive_timeout` | 75s | Keepalive cliente |
| `proxy_connect_timeout` | 60s | Conectar backend |
| `proxy_read_timeout` | 60s | Leer backend |

### `proxy_cache`

| Directiva | Para qué |
|---|---|
| `proxy_cache_path` | Directorio + zona |
| `proxy_cache` | Activa la zona en location |
| `proxy_cache_valid` | TTL por código |
| `proxy_cache_key` | Clave |
| `proxy_cache_use_stale` | Servir stale si backend cae |
| `$upstream_cache_status` | HIT/MISS/EXPIRED |

### Kernel (sysctl)

| Clave | Para qué |
|---|---|
| `net.core.somaxconn` | Backlog de conexiones |
| `net.ipv4.tcp_max_syn_backlog` | SYN backlog |
| `net.ipv4.tcp_tw_reuse` | Reusar TIME_WAIT |
| `fs.file-max` | FDs globales |

---

## Conceptos clave

- **Workers = núcleos**: `worker_processes auto` es óptimo. Más workers que núcleos compiten por CPU.
- **Límite real = kernel + worker_connections**: aunque subas `worker_connections`, `somaxconn` y `ulimit -n` te cortan antes.
- **Keepalive al backend es de manual**: `proxy_http_version 1.1` + `Connection ""` + `keepalive N` en upstream. Sin esto reconectas en cada petición.
- **Buffers protegen al cliente**: `proxy_buffering on` absorbe la respuesta antes de enviar. `off` hace streaming (SSE/WS).
- **Logs estructurados (JSON)**: con `log_format escape=json` sale JSON limpio para Loki/ELK.
- **`kill -USR1` reabre logs** sin reload: es la señal que `logrotate` usa para rotar sin cortar.
- **`stub_status` da lo básico**, pero para alertar necesitas Prometheus (`nginx-prometheus-exporter`) o Amplify.
- **Reload graceful, restart corta**: en producción, solo `reload` (y siempre `nginx -t` antes).
- **`proxy_cache` es la palanca nº1 de rendimiento** para backends lentos: HIT en 1ms vs MISS en 500ms. Cuidado con personalización.
- **FastCGI ≠ proxy_pass**: PHP va por FastCGI (`fastcgi_pass`), no por HTTP. Nginx no ejecuta PHP; lo reenvía a FPM.
- **`fail_timeout`/`max_fails`** son los health checks pasivos: configúralos acordes al SLA (no dejes los defaults de 1 fallo / 10s si tu backend es inestable).

---

## Errores comunes

- **`worker_connections 4096` pero `ulimit -n 1024`**: Nginx arranca pero muere bajo carga por "too many open files". Sube `worker_rlimit_nofile` y `fs.file-max`.
- **Keepalive al backend no funciona**: falta `proxy_http_version 1.1` o `Connection ""`. El backend ve una conexión nueva cada vez.
- **Buffers pequeños causan I/O a disco**: `client_body_buffer_size 1k` hace que un body de 100k se escriba a `/var/lib/nginx/body/` → lento.
- **Timeouts largos saturan workers**: `proxy_read_timeout 300s` con un backend lento deja workers ocupados. Ajusta al SLA real.
- **Logs gigantes sin rotación**: `access.log` crece hasta llenar el disco. Configura `logrotate` con `kill -USR1`.
- **`reload` sin `nginx -t`**: un error de sintaxis + `restart` deja Nginx caído. Con `reload` sobrevive la config vieja, pero no es sano.
- **Cachear respuestas personalizadas**: una `/api/me` cacheada sirve al usuario A la respuesta del usuario B. Usa `proxy_cache_bypass $cookie_session`.
- **PHP-FPM socket no encontrado**: comprueba `/run/php-fpm/www.sock` existe y Nginx tiene permisos para leerlo.
- **`stub_status` expuesto a internet**: pon `listen 127.0.0.1:8090` y `allow 127.0.0.1`. No filtres métricas.
- **Olvidar `server_tokens off`**: la versión expuesta es info para atacantes (CVE matching).
- **No ajustar `somaxconn`**: con defaults (128 en algunas distros), el backlog se llena y las conexiones se caen en picos.
- **`proxy_cache_path` sin `use_temp_path=off`**: escribe a `/tmp` primero → doble I/O. Pon `off` para escribir directo al cache.
