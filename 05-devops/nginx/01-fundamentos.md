# 01 — Fundamentos de Nginx
> Guía de introducción a Nginx: qué es, web server vs reverse proxy, instalación, estructura de `nginx.conf` (`http`/`server`/`location`), directivas y bloques, `events`/`worker_processes`/`worker_connections`, tipos de directivas y el ciclo petición–respuesta HTTP. Todo está escrito para Nginx 1.22+.

---

## Objetivos

- [ ] Explicar qué es Nginx y por qué es asíncrono orientado a eventos
- [ ] Diferenciar el rol de **web server** del de **reverse proxy** y **load balancer**
- [ ] Instalar Nginx en Linux (Debian/Ubuntu y Fedora/RHEL) y verificar la versión
- [ ] Ubicar y leer los archivos de configuración: `nginx.conf`, `conf.d/`, `sites-available/`, `sites-enabled/`
- [ ] Entender la jerarquía de bloques: `events` → `http` → `server` → `location`
- [ ] Distinguir directivas **simples** de directivas de **bloque**
- [ ] Diferenciar directivas **simple** de **array** y de contexto (`http`/`server`/`location`)
- [ ] Configurar `worker_processes`, `worker_connections` y entender el límite de conexiones
- [ ] Describir el ciclo completo de una petición HTTP dentro de Nginx
- [ ] Usar `nginx -t`, `nginx -s reload` y `nginx -V`
- [ ] Leer y entender un `nginx.conf` mínimo pero válido

---

## Apuntes

### 1. ¿Qué es Nginx?

Nginx es un **servidor web**, **reverse proxy** y **proxy de correo** escrito en C por Igor Sysoev en 2002. Su diseño se basa en una arquitectura **asíncrona orientada a eventos** (event-driven), en la que un número pequeño de procesos worker atiende miles de conexiones simultáneas mediante multiplexación (`epoll` en Linux, `kqueue` en BSD).

A diferencia de un servidor web tradicional que lanza un hilo/proceso por conexión (Apache prefork), Nginx usa **un hilo por worker** y dentro de cada atiende muchas conexiones con un bucle de eventos. Por eso escala a decenas de miles de conexiones (problema C10k) con poca memoria.

**Casos de uso típicos:**

1. Servir contenido estático (HTML, CSS, JS, imágenes, fuentes).
2. Reverse proxy por delante de aplicaciones (Node, Go, Python/uWSGI, Java, PHP-FPM).
3. Load balancer entre varios backends.
4. Terminación de TLS (TLS offloading).
5. Caching de respuestas HTTP.
6. Rate limiting y protección contra abusos.
7. Streaming de video (HLS/DASH) y servir archivos grandes.

### 2. Web server vs reverse proxy vs load balancer

| Rol | Qué hace | Directivas clave |
|---|---|---|
| **Web server** | Lee archivos del disco y los sirve | `root`, `alias`, `index`, `try_files` |
| **Reverse proxy** | Recibe la petición y la reenvía a un backend | `proxy_pass`, `proxy_set_header` |
| **Load balancer** | Reparte entre varios backends | `upstream`, `least_conn`, `ip_hash` |

Los tres roles pueden coexistir en un mismo `nginx.conf`: un `location /` sirve estáticos, otro `location /api` hace proxy a la app, y un `upstream` balancea entre varias instancias.

```
Cliente ──► Nginx ──┬──► archivos estáticos (root /var/www)
                   ├──► backend-1:3000  ┐ upstream (round-robin)
                   └──► backend-2:3000  ┘
```

### 3. Instalación

**Debian / Ubuntu:**

```bash
sudo apt update
sudo apt install nginx
nginx -v          # nginx version: nginx/1.22.x
```

**Fedora / RHEL:**

```bash
sudo dnf install nginx
nginx -v
```

**Arranque y estado:**

```bash
sudo systemctl enable --now nginx   # arrancar y habilitar al boot
sudo systemctl status nginx
sudo systemctl reload nginx         # recarga sin cortar conexiones
sudo systemctl restart nginx        # reinicio completo (corta)
```

**Comprobación rápida:**

```bash
curl -I http://localhost       # HTTP/1.1 200 OK
```

### 4. Ubicación de los archivos de configuración

| Ruta | Contenido |
|---|---|
| `/etc/nginx/nginx.conf` | Configuración principal (global) |
| `/etc/nginx/conf.d/*.conf` | Configuración de vhosts (incluida por `http`) |
| `/etc/nginx/sites-available/` | (Debian) vhosts disponibles |
| `/etc/nginx/sites-enabled/` | (Debian) vhosts activados (symlinks) |
| `/etc/nginx/mime.types` | Tipos MIME (incluido con `include`) |
| `/var/www/html/` | Document root por defecto |
| `/var/log/nginx/access.log` | Log de acceso |
| `/var/log/nginx/error.log` | Log de errores |

> En **Debian/Ubuntu** el `nginx.conf` incluye `include /etc/nginx/conf.d/*.conf;` y `include /etc/nginx/sites-enabled/*;`. En **Fedora/RHEL** solo `include /etc/nginx/conf.d/*.conf;`. Si no existe `sites-enabled/`, créalo a mano o usa `conf.d/`.

### 5. La jerarquía de bloques

La configuración de Nginx es **jerárquica**. De fuera hacia dentro:

```
events { }              # cómo Nginx gestiona conexiones (1 por config, obligatorio)
http {                  # todo lo de HTTP va aquí
    server {            # un virtual host (por dominio/puerto)
        listen 80;
        server_name ejemplo.com;
        location / {    # cómo manejar una URI
            root /var/www;
            index index.html;
        }
    }
}
```

| Bloque | Propósito | Cuántos |
|---|---|---|
| `events` | Ajustes de conexión (worker_connections) | Exactamente 1 |
| `http` | Todo el contexto HTTP | Exactamente 1 |
| `server` | Un virtual host (puerto + server_name) | Varios |
| `location` | Cómo tratar una URI dentro de un server | Varios |
| `upstream` | Grupo de backends para balancear | Varios (dentro de http) |

La regla de herencia: una directiva heredada de un bloque padre se puede sobrescribir en el hijo. **Pero ojo**: algunas directivas (como `proxy_pass` o `rewrite`) **no** se heredan; se definen donde se usan.

### 6. Directivas simples vs de bloque

- **Directiva simple**: `nombre valor;` — termina en `;`.
  ```nginx
  worker_processes auto;
  listen 80;
  ```
- **Directiva de bloque**: `nombre { ... }` — abre un contexto.
  ```nginx
  http {
      server { }
  }
  ```
- **Directiva array**: se puede repetir varias veces (los valores se acumulan).
  ```nginx
  listen 80;
  listen 443 ssl;
  proxy_set_header Host $host;
  proxy_set_header X-Real-IP $remote_addr;
  ```

### 7. `events` y workers

El bloque `events` controla cómo Nginx gestiona las conexiones a nivel de red:

```nginx
events {
    worker_connections 1024;   # máx. conexiones por worker
    use epoll;                 # Linux (autodetectado)
    multi_accept on;           # aceptar varias conexiones por evento
}
```

- `worker_connections`: número **máximo de conexiones** que un solo worker puede atender simultáneamente. Incluye conexiones de clientes **y** a backends (en modo proxy).
- El número máximo de clientes ≈ `worker_processes × worker_connections`.
- `use epoll` es automático en Linux moderno; normalmente no hace falta ponerlo.

### 8. `worker_processes`

```nginx
worker_processes auto;   # 1 worker por núcleo de CPU (recomendado)
# o un número fijo:
# worker_processes 4;
```

- `auto`: Nginx detecta los núcleos y lanza un worker por núcleo. Es lo recomendado en producción.
- Un valor fijo (ej. `4`) se usa cuando hay affinity de CPU o se limita a un cgroup.
- **No** pongas más workers que núcleos: competirán por CPU y empeorará.

### 9. Un `nginx.conf` mínimo pero completo

```nginx
# /etc/nginx/nginx.conf
user nginx;
worker_processes auto;
error_log /var/log/nginx/error.log warn;
pid /run/nginx.pid;

events {
    worker_connections 1024;
}

http {
    include       /etc/nginx/mime.types;
    default_type   application/octet-stream;

    sendfile      on;
    tcp_nopush    on;
    keepalive_timeout 65;

    access_log /var/log/nginx/access.log;

    server {
        listen 80;
        server_name localhost;
        location / {
            root   /usr/share/nginx/html;
            index  index.html index.htm;
        }
    }
}
```

Léelo así:
1. `user nginx` → el worker corre como ese usuario.
2. `worker_processes auto` → un worker por núcleo.
3. `events` → 1024 conexiones por worker.
4. `http` → incluye tipos MIME, define `sendfile`, un `server` en el puerto 80.
5. `location /` → sirve archivos desde `/usr/share/nginx/html` y busca `index.html`.

### 10. El ciclo de una petición HTTP

1. El cliente abre una conexión TCP al puerto 80.
2. Un worker la acepta (evento `epoll`).
3. Nginx lee la request line + cabeceras.
4. Selecciona el `server` por `Host` y puerto (virtual host).
5. Selecciona el `location` que mejor matchea la URI.
6. Ejecuta las fases: `rewrite` → `access` → `content` → `log`.
   - `rewrite`: reescribe la URI (`rewrite`, `return`).
   - `access`: control de acceso (`allow`/`deny`, `auth_basic`, `limit_req`).
   - `content`: sirve archivo (`root`/`try_files`) o reenvía (`proxy_pass`/`fastcgi_pass`).
   - `log`: registra en `access.log`.
7. Genera la respuesta (archivo del disco o respuesta del backend).
8. Envía al cliente y, si keepalive, mantiene la conexión.

### 11. Petición y respuesta HTTP de referencia

**Petición:**

```
GET /index.html HTTP/1.1
Host: ejemplo.com
User-Agent: curl/8.0
Accept: */*
```

**Respuesta:**

```
HTTP/1.1 200 OK
Server: nginx/1.22.1
Content-Type: text/html
Content-Length: 1234
Connection: keep-alive

<html>...</html>
```

Nginx añade por defecto la cabecera `Server` y `Date`. Puedes ocultar la versión con `server_tokens off;`.

### 12. Comprobación y recarga

```bash
sudo nginx -t                 # valida sintaxis sin aplicar
sudo nginx -T                # vuelca la config efectiva (con includes)
sudo nginx -s reload         # recarga graceful (sin cortar conexiones)
sudo nginx -s stop           # para Nginx
nginx -V 2>&1                # versión + módulos compilados
```

- `nginx -t` siempre antes de recargar: evita dejar Nginx caído por un error de sintaxis.
- `reload` es **graceful**: el master relee la config, lanza nuevos workers y deja que los viejos terminen sus conexiones. Es lo que se usa en producción.
- `restart` (vía systemctl) **sí** corta conexiones; úsalo solo si el reload no basta.

---

## Tablas de referencia

### Directivas del contexto `main` (fuera de `http`)

| Directiva | Default | Para qué |
|---|---|---|
| `user` | nobody | Usuario del worker |
| `worker_processes` | 1 | Número de workers (`auto` recomendado) |
| `error_log` | logs/error.log | Dónde y a qué nivel loguear |
| `pid` | logs/nginx.pid | Fichero del PID del master |
| `worker_rlimit_nofile` | auto | Límite de FDs por worker |

### Directivas del bloque `events`

| Directiva | Default | Para qué |
|---|---|---|
| `worker_connections` | 512/1024 | Conexiones por worker |
| `multi_accept` | off | Aceptar varias conexiones por evento |
| `use` | autodetect | Método de multiplexación (`epoll`, `kqueue`) |

### Comandos de gestión

| Comando | Efecto |
|---|---|
| `nginx -t` | Valida la sintaxis |
| `nginx -T` | Vuelca config efectiva |
| `nginx -s reload` | Recarga graceful |
| `nginx -s stop` | Para Nginx |
| `nginx -V` | Versión + flags de compilación |

### Contextos y qué admiten

| Contexto | Admite dentro |
|---|---|
| `main` | `events`, `http`, `mail`, `stream` |
| `http` | `server`, `upstream`, `map`, `geo`, directivas HTTP |
| `server` | `location`, directivas de server |
| `location` | `root`, `proxy_pass`, `return`, etc. |
| `upstream` | `server` (cada backend) |

---

## Conceptos clave

- **Arquitectura event-driven**: Nginx no crea un hilo por conexión; un worker atiende muchas con un bucle de eventos (`epoll`). Eso explica su baja memoria y su escalabilidad.
- **Worker**: proceso hijo del master. Un worker por núcleo es lo óptimo. Cada worker maneja `worker_connections` conexiones.
- **Master vs worker**: el **master** lee la config, lanza workers y los gestiona; los **workers** atienden el tráfico real. Un `reload` relee config y reinicia workers sin cortar.
- **Contexto de directiva**: cada directiva tiene un contexto válido. `worker_connections` solo en `events`; `listen` en `server`; `root` en `http`/`server`/`location`. Si la pones fuera, Nginx da error.
- **Herencia**: las directivas se heredan de padre a hijo, pero algunas (array como `proxy_set_header`) se **sobrescriben** si las redefines en el hijo.
- **Virtual host**: un bloque `server` se distingue por `listen` + `server_name`. Nginx elige el `server` que mejor encaja con el `Host` de la petición.
- **`include`**: permite partir la config en varios ficheros. Es el mecanismo de `conf.d/*.conf` y `sites-enabled/*`.

---

## Errores comunes

- **`nginx: [emerg] "worker_connections" directive is not allowed here`**: la pusiste fuera de `events`. Solo vale dentro de `events`.
- **`unknown directive "..."`**: o está mal escrita, o el módulo no está compilado (ej. `--without-http_gzip_static_module`).
- **Olvidar el `;` al final de una directiva simple**: produce errores de parse raros en la línea siguiente.
- **`server_name` sin `listen` distinto**: dos `server` con el mismo `listen 80` y mismos `server_name` → conflictos. Usa `server_name` distintos o puertos distintos.
- **Poner `worker_processes` mayor que núcleos**: no mejora el rendimiento y gasta más memoria.
- **Recargar con `restart` en producción**: corta conexiones activas. Usa `reload` salvo emergencia.
- **No ejecutar `nginx -t` antes de recargar**: un error de sintaxis con `reload` deja a Nginx con la config vieja (no cae), pero si usas `restart` Nginx no arranca y la web se queda fuera.
- **Editar `nginx.conf` y olvidar los `include`**: si quitas `include /etc/nginx/conf.d/*.conf;`, todos tus vhosts dejan de cargarse.
- **Confundir `root` y `alias`**: `root` **añade** la URI al path; `alias` la **sustituye**. Mezclarlos da errores 404 raros (se ve en la guía 02).
- **`server_tokens on` (default)**: revela la versión exacta de Nginx en la cabecera `Server` y en páginas 404/500. Pon `server_tokens off;` en producción.
