# Nginx

> Ruta de aprendizaje completa de Nginx en español: 5 guías de estudio, 30 ejercicios por niveles con tests y un proyecto final.

Nginx (se lee *"engine-x"*) es un servidor web y **reverse proxy** de altísimo rendimiento, escrito en C y basado en una arquitectura **asíncrona orientada a eventos**. Originalmente nació para resolver el problema C10k (10.000 conexiones simultáneas), y hoy se usa para servir contenido estático, equilibrar carga, terminar TLS, hacer caching, rate limiting y proteger backends.

Sus tres roles principales son:

1. **Servidor web** — sirve archivos estáticos (HTML, CSS, JS, imágenes) con un rendimiento excepcional.
2. **Reverse proxy** — se coloca por delante de tus backends (Node, Go, Python, Java…), reparte tráfico, termina TLS y cachea respuestas.
3. **Load balancer** — distribuye peticiones entre varios upstreams con algoritmos round-robin, least-conn e ip-hash.

Esta ruta asume que sabes lo básico de HTTP y Linux, pero parte desde cero en Nginx. Cada guía introduce la teoría con bloques de `nginx.conf` reales y enlaza a los ejercicios que la refuerzan.

> **Nota de entorno:** los ejercicios se validan con `test.sh`. Si `nginx` está instalado, el test arranca Nginx en un **puerto efímero**, hace peticiones con `curl` y verifica cabeceras, status y body. Si `nginx` **no** está disponible, el test valida la **estructura y directivas** de la configuración con `grep`/`awk`/regex, para que puedas practicar en cualquier entorno.

## Guías de estudio

| Guía | Contenido |
|---|---|
| [01 — Fundamentos](01-fundamentos.md) | Qué es Nginx, web server vs reverse proxy, instalación, `nginx.conf` (http/server/location), directivas y bloques, `events`/`worker_processes`/`worker_connections`, tipos de directivas, petición y respuesta HTTP |
| [02 — Servir contenido y location](02-servir-contenido-y-location.md) | `root` vs `alias`, `index`, `try_files`, location matching y prioridad (exact/prefix/regex), `autoindex`, tipos MIME y `default_type`, `gzip`, caché de estáticos, `expires`, ETag |
| [03 — Proxy y load balancing](03-proxy-y-load-balancing.md) | `proxy_pass`, reverse proxy a backend, `upstream` y balanceo (round-robin/least_conn/ip_hash), `proxy_set_header`, balanceo ponderado y backup, health checks, proxy de WebSocket, `rewrite` y `return` |
| [04 — TLS y seguridad](04-tls-y-seguridad.md) | HTTPS, certificados con `openssl`, redirect HTTP→HTTPS, `ssl_certificate`, `ssl_protocols` TLSv1.2/1.3, cipher suites, HSTS, rate limiting (`limit_req`/`limit_conn`), basic auth, cabeceras de seguridad, `geo`/`map`, `deny`/`allow`, hardening |
| [05 — Rendimiento y producción](05-rendimiento-y-produccion.md) | `worker_processes auto`, `worker_connections`, keepalive, buffers, timeouts, log formats, `stub_status`, monitoring, tuning del kernel de Linux, `nginx -t`, reload vs restart, `fail_timeout`/`max_fails`, `proxy_cache`, FastCGI/PHP-FPM |

## Ejercicios por nivel

Cada ejercicio es una carpeta con **enunciado, requisitos, pistas y solución** (`README.md`), archivos de soporte (`nginx.conf`/`conf.d/*.conf`, estáticos, backend simulado), una **solución** en `solucion/` y un **script de tests** (`test.sh`) que valida con nginx real o, en su defecto, la estructura de la configuración.

| Nivel | Dificultad | Ejercicios |
|---|---|---|
| [Nivel 01 — Fundamentos](ejercicios/nivel-01-fundamentos/) | ⭐ 1/5 | server block, location y root, index.html estático, virtual hosts, try_files, index y default_type |
| [Nivel 02 — Básico](ejercicios/nivel-02-basico/) | ⭐⭐ 2/5 | gzip, expires y caché de estáticos, autoindex, proxy_pass, location regex, rewrite y return |
| [Nivel 03 — Intermedio](ejercicios/nivel-03-intermedio/) | ⭐⭐⭐ 3/5 | load balancing upstream, least_conn, proxy_set_header, WebSocket, proxy_cache |
| [Nivel 04 — Avanzado](ejercicios/nivel-04-avanzado/) | ⭐⭐⭐⭐ 4/5 | HTTPS self-signed, redirect HTTP→HTTPS, rate limiting, basic auth, security headers |
| [Nivel 05 — Experto](ejercicios/nivel-05-experto/) | ⭐⭐⭐⭐⭐ 5/5 | tuning de workers/buffers, log format y rotación, fail_timeout/max_fails, map geo por IP, FastCGI PHP-FPM, configuración de producción completa |

Índice completo: [ejercicios/README.md](ejercicios/README.md)

## Proyectos

Al terminar los niveles, integra todo lo aprendido con el **proyecto final integrador**: [Reverse proxy de producción para microservicios](ejercicios/proyectos/README.md) — Nginx como reverse proxy y load balancer para 3 backends, con TLS, security headers, rate limiting, caching, health checks, logging estructurado y config multi-entorno.

## Cómo ejecutar los tests

Cada ejercicio se verifica desde su propia carpeta:

```bash
cd 05-devops/nginx/ejercicios/nivel-01-fundamentos/ejercicio-01-server-block
bash test.sh   # valida nginx.conf: nginx -t + curl si nginx está; estructura si no
```

Requisitos opcionales para validación completa:

- `nginx` instalado (`sudo apt install nginx` / `sudo dnf install nginx`)
- `curl` y `bash`
