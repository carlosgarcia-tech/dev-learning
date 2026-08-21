# Ejercicios — Nginx

30 ejercicios en 5 niveles de dificultad. Cada ejercicio es una carpeta con **enunciado, requisitos, pistas y solución** (`README.md`), archivos de soporte (`nginx.conf`/`conf.d/*.conf`, estáticos, backend simulado), una **solución** en `solucion/` y un **script de tests** (`test.sh`).

El `test.sh` valida de forma **real**:

- Si `nginx` está disponible: `nginx -t -c <config>` (sintaxis), arranca Nginx en un puerto efímero y hace `curl` verificando **cabeceras, status y body**.
- Si `nginx` **no** está disponible: valida la **estructura y directivas** esperadas con `grep`/`awk`/regex sobre el `nginx.conf`.

## Nivel 1 — Fundamentos

| # | Ejercicio | Tema |
|---|---|---|
| 01 | [server-block](nivel-01-fundamentos/ejercicio-01-server-block/) | Bloque `server` básico con `listen` y `location /` |
| 02 | [location-y-root](nivel-01-fundamentos/ejercicio-02-location-y-root/) | `location` y `root` para servir archivos |
| 03 | [servir-index-html](nivel-01-fundamentos/ejercicio-03-servir-index-html/) | Servir un `index.html` estático |
| 04 | [virtual-hosts](nivel-01-fundamentos/ejercicio-04-virtual-hosts/) | Múltiples `server` blocks (virtual hosts) |
| 05 | [try-files](nivel-01-fundamentos/ejercicio-05-try-files/) | `try_files` para fallback de archivos |
| 06 | [index-y-default-type](nivel-01-fundamentos/ejercicio-06-index-y-default-type/) | `index` y `default_type` |

## Nivel 2 — Básico

| # | Ejercicio | Tema |
|---|---|---|
| 01 | [gzip](nivel-02-basico/ejercicio-01-gzip/) | Compresión `gzip` de respuestas |
| 02 | [expires-y-cache-estaticos](nivel-02-basico/ejercicio-02-expires-y-cache-estaticos/) | `expires` y caché de archivos estáticos |
| 03 | [autoindex](nivel-02-basico/ejercicio-03-autoindex/) | Listado de directorios con `autoindex` |
| 04 | [proxy-pass-backend](nivel-02-basico/ejercicio-04-proxy-pass-backend/) | `proxy_pass` a un backend simulado |
| 05 | [location-regex](nivel-02-basico/ejercicio-05-location-regex/) | `location` con regex (`~` y `~*`) |
| 06 | [rewrite-y-return](nivel-02-basico/ejercicio-06-rewrite-y-return/) | `rewrite` y `return` para redirecciones |

## Nivel 3 — Intermedio

| # | Ejercicio | Tema |
|---|---|---|
| 01 | [load-balancing-upstream](nivel-03-intermedio/ejercicio-01-load-balancing-upstream/) | `upstream` con 2 backends (round-robin) |
| 02 | [least-conn](nivel-03-intermedio/ejercicio-02-least-conn/) | Balanceo con `least_conn` |
| 03 | [proxy-set-header](nivel-03-intermedio/ejercicio-03-proxy-set-header/) | `proxy_set_header` y `X-Forwarded-For` |
| 04 | [websocket-proxy](nivel-03-intermedio/ejercicio-04-websocket-proxy/) | Proxy de WebSocket (Upgrade/Connection) |
| 05 | [proxy-cache](nivel-03-intermedio/ejercicio-05-proxy-cache/) | Caching con `proxy_cache` |
| 06 | [ip-hash-sticky](nivel-03-intermedio/ejercicio-06-ip-hash-sticky/) | `ip_hash` para sesiones sticky |

## Nivel 4 — Avanzado

| # | Ejercicio | Tema |
|---|---|---|
| 01 | [https-self-signed](nivel-04-avanzado/ejercicio-01-https-self-signed/) | HTTPS con certificado self-signed |
| 02 | [redirect-http-https](nivel-04-avanzado/ejercicio-02-redirect-http-https/) | Redirect HTTP → HTTPS |
| 03 | [rate-limiting](nivel-04-avanzado/ejercicio-03-rate-limiting/) | Rate limiting con `limit_req` |
| 04 | [basic-auth](nivel-04-avanzado/ejercicio-04-basic-auth/) | Basic auth con `auth_basic` |
| 05 | [security-headers](nivel-04-avanzado/ejercicio-05-security-headers/) | Cabeceras de seguridad HSTS/X-Frame-Options |
| 06 | [geo-ip-block](nivel-04-avanzado/ejercicio-06-geo-ip-block/) | Bloqueo por IP con `geo` y `deny` |

## Nivel 5 — Experto

| # | Ejercicio | Tema |
|---|---|---|
| 01 | [tuning-workers-buffers](nivel-05-experto/ejercicio-01-tuning-workers-buffers/) | Tuning de `worker_processes` y buffers |
| 02 | [log-format-rotacion](nivel-05-experto/ejercicio-02-log-format-rotacion/) | Log format personalizado y rotación |
| 03 | [fail-timeout-max-fails](nivel-05-experto/ejercicio-03-fail-timeout-max-fails/) | `fail_timeout` y `max_fails` en upstream |
| 04 | [map-geo-bloqueo](nivel-05-experto/ejercicio-04-map-geo-bloqueo/) | `map` y `geo` para bloqueo por IP |
| 05 | [fastcgi-php-fpm](nivel-05-experto/ejercicio-05-fastcgi-php-fpm/) | FastCGI con PHP-FPM |
| 06 | [config-produccion-completa](nivel-05-experto/ejercicio-06-config-produccion-completa/) | Configuración de producción completa |

## Proyectos integradores

Proyectos que combinan todo lo aprendido en un sistema completo.

| Proyecto | Descripción |
|---|---|
| [PROYECTO FINAL: Reverse proxy de producción para microservicios](proyectos/README.md) | Nginx como reverse proxy + load balancer para 3 backends, con TLS, security headers, rate limiting, caching, health checks, logging y config multi-entorno |
