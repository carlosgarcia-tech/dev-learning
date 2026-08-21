# Proyecto final — Reverse proxy de producción para microservicios

> Proyecto integrador que combina **todo** lo aprendido en las guías y ejercicios de Nginx: reverse proxy, load balancing, TLS, security headers, rate limiting, caching, health checks, logging estructurado y configuración multi-entorno.

## Contexto

Imagina que trabajas en una empresa con una arquitectura de microservicios. Tienes **3 backends** que exponen APIs HTTP:

- **`auth-svc`** — servicio de autenticación (puerto 3001)
- **`api-svc`** — API principal (puerto 3002, 2 instancias para HA)
- **`web-svc`** — frontend SSR (puerto 3003)

Necesitas desplegar **Nginx como reverse proxy y load balancer** por delante de todos ellos, con:

- **TLS** terminado en Nginx (HTTPS al cliente, HTTP a los backends).
- **Load balancing** entre las 2 instancias de `api-svc` con health checks pasivos.
- **Rate limiting** en `/auth/` (login es sensible a brute force).
- **Caching** de respuestas de `api-svc` (GET cacheable).
- **Security headers** en todas las respuestas.
- **Logging estructurado** (JSON) con `request_time` y `upstream_response_time`.
- **Config multi-entorno**: `dev`, `staging`, `prod` con variables distintas.

El proyecto se entrega como un conjunto de archivos starter que debes completar.

## Estructura del proyecto

```
proyectos/
├── README.md                          # este archivo
├── nginx.conf                         # config principal (TODO: completar)
├── conf.d/
│   ├── 00-upstreams.conf              # upstreams con health checks
│   ├── 01-rate-limiting.conf          # limit_req_zone
│   ├── 02-cache.conf                  # proxy_cache_path
│   ├── 03-logging.conf                # log_format JSON
│   ├── 10-auth.conf                   # vhost: auth.ejemplo.com
│   ├── 11-api.conf                    # vhost: api.ejemplo.com
│   └── 12-web.conf                    # vhost: web.ejemplo.com
├── ssl/
│   └── generate-cert.sh               # genera cert self-signed para dev
├── backends/
│   ├── auth-svc.sh                    # backend simulado (auth)
│   ├── api-svc-1.sh                   # backend simulado (api instancia 1)
│   ├── api-svc-2.sh                   # backend simulado (api instancia 2)
│   └── web-svc.sh                     # backend simulado (web)
├── envs/
│   ├── dev.conf                       # variables de entorno dev
│   ├── staging.conf                   # variables de entorno staging
│   └── prod.conf                      # variables de entorno prod
├── logrotate/
│   └── nginx                           # rotación de logs
└── test.sh                            # validación del proyecto
```

## Requisitos

### Fase 1 — Estructura base y upstreams

- [ ] `conf.d/00-upstreams.conf` define 3 upstreams:
  - `auth_backend` → 1 server (3001)
  - `api_backend` → 2 servers (3002, 3003) con `max_fails=3 fail_timeout=30s` y `keepalive 32`
  - `web_backend` → 1 server (3004)
- [ ] `nginx.conf` incluye todos los `conf.d/*.conf` con `include`.

### Fase 2 — Rate limiting, cache y logging

- [ ] `conf.d/01-rate-limiting.conf`: `limit_req_zone $binary_remote_addr zone=auth:10m rate=5r/s;` y `zone=api:10m rate=20r/s;`
- [ ] `conf.d/02-cache.conf`: `proxy_cache_path` con `keys_zone=api_cache:10m`.
- [ ] `conf.d/03-logging.conf`: `log_format json escape=json` con `request_time` y `upstream_response_time`.

### Fase 3 — TLS y security headers

- [ ] `ssl/generate-cert.sh` genera un cert self-signed con `openssl`.
- [ ] Cada vhost HTTPS tiene `ssl_certificate`, `ssl_certificate_key`, `ssl_protocols TLSv1.2 TLSv1.3`.
- [ ] Security headers: HSTS, X-Frame-Options, X-Content-Type-Options en cada vhost.

### Fase 4 — Vhosts con proxy_pass, cache y rate limit

- [ ] `conf.d/10-auth.conf`: vhost `auth.ejemplo.com` → `proxy_pass http://auth_backend;` con `limit_req zone=auth burst=5 nodelay;`.
- [ ] `conf.d/11-api.conf`: vhost `api.ejemplo.com` → `proxy_pass http://api_backend;` con `proxy_cache api_cache`, `limit_req zone=api burst=20 nodelay;` y `proxy_set_header` completos.
- [ ] `conf.d/12-web.conf`: vhost `web.ejemplo.com` → `proxy_pass http://web_backend;`.

### Fase 5 — Multi-entorno

- [ ] `envs/dev.conf`, `envs/staging.conf`, `envs/prod.conf` definen variables (`$upstream_auth`, `$upstream_api1`, etc.) o includes distintos.
- [ ] `nginx.conf` hace `include envs/dev.conf;` (cambiable a staging/prod).

### Fase 6 — Rotación de logs

- [ ] `logrotate/nginx` con `daily`, `rotate 30`, `compress`, `postrotate` con `kill -USR1`.

## Criterios de aceptación

- [ ] `nginx -t` pasa sin errores sobre la config completa.
- [ ] Los 3 backends simulados responden tras arrancarlos.
- [ ] `curl -k https://auth.ejemplo.com/` → 200 con body `auth-ok`.
- [ ] `curl -k https://api.ejemplo.com/` → 200 con body `api-ok`; la 2ª petición tiene `X-Cache-Status: HIT`.
- [ ] `curl -k https://web.ejemplo.com/` → 200 con body `web-ok`.
- [ ] 30 peticiones rápidas a `/auth/` → algunas dan 429 (rate limit).
- [ ] Las respuestas tienen HSTS, X-Frame-Options y X-Content-Type-Options.
- [ ] El access log está en formato JSON con `request_time`.
- [ ] `test.sh` pasa con `OK Tests pasaron`.

## Cómo ejecutar

```bash
# 1. Generar certificado
bash ssl/generate-cert.sh

# 2. Arrancar backends simulados
bash backends/auth-svc.sh &
bash backends/api-svc-1.sh &
bash backends/api-svc-2.sh &
bash backends/web-svc.sh &

# 3. Validar y arrancar Nginx
nginx -t -c nginx.conf
nginx -c nginx.conf

# 4. Probar
curl -k https://auth.ejemplo.com/
curl -k https://api.ejemplo.com/
curl -k https://web.ejemplo.com/

# 5. Test automático
bash test.sh
```

## Notas

- Los backends simulados usan `nc -l` (netcat) para responder HTTP mínimo.
- Los dominios (`auth.ejemplo.com`, etc.) se resuelven a `127.0.0.1` vía `/etc/hosts` o `curl --resolve`.
- En `prod.conf`, los upstreams apuntan a IPs reales (no 127.0.0.1).
- El certificado self-signed es solo para dev/staging; en prod se usa Let's Encrypt o un CA real.
