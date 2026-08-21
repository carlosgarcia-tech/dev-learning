# 03 — Proxy y load balancing
> Guía de reverse proxy y balanceo de carga en Nginx: `proxy_pass`, bloques `upstream`, algoritmos `round-robin`/`least_conn`/`ip_hash`, balanceo ponderado y `backup`, `proxy_set_header` (`Host`, `X-Real-IP`, `X-Forwarded-For`), health checks activos/pasivos, proxy de WebSocket y path rewriting con `rewrite`/`return`. Escrito para Nginx 1.22+.

---

## Objetivos

- [ ] Usar `proxy_pass` para reenviar peticiones a un backend
- [ ] Entender cuándo `proxy_pass` pasa o no la URI al backend (con `/` o sin `/`)
- [ ] Definir un bloque `upstream` con varios backends
- [ ] Explicar y configurar los algoritmos `round-robin` (default), `least_conn` e `ip_hash`
- [ ] Configurar balanceo **ponderado** con `weight`
- [ ] Marcar backends como `backup` y `down`
- [ ] Usar `proxy_set_header` para `Host`, `X-Real-IP` y `X-Forwarded-For`
- [ ] Diferenciar health checks **pasivos** (`max_fails`/`fail_timeout`) de **activos** (módulo comercial / `health_check`)
- [ ] Configurar el proxy de **WebSocket** con `Upgrade`/`Connection`
- [ ] Reescribir paths y redirigir con `rewrite`, `return` y `proxy_pass`
- [ ] Evitar los problemas típicos de `proxy_pass` (trailing slash, cabeceras perdidas, loops)

---

## Apuntes

### 1. `proxy_pass`: reverse proxy básico

`proxy_pass` reenvía la petición a otro servidor (backend). Nginx actúa como intermediary entre el cliente y la app:

```nginx
server {
    listen 80;
    location / {
        proxy_pass http://127.0.0.1:3000;   # backend Node/Go/Python
    }
}
```

**Trailing slash y URI:** es el punto más confuso de `proxy_pass`.

| `proxy_pass` | URI del cliente `/api/users` | Llega al backend como |
|---|---|---|
| `http://backend` (sin `/`) | `/api/users` | `/api/users` (URI original) |
| `http://backend/` (con `/`) | `/api/users` | `/users` (sustituye el prefix `/api` por `/`) |
| `http://backend/v2` | `/api/users` | `/v2/users` (sustituye `/api` por `/v2`) |

> Si `location` tiene regex o named location, `proxy_pass` **no** puede llevar URI (solo `host:port`).

```nginx
# location con prefix: la URI del backend depende del trailing slash
location /api/ {
    proxy_pass http://backend/;     # /api/users -> /users
}
location /api/ {
    proxy_pass http://backend;      # /api/users -> /api/users
}
```

### 2. Bloque `upstream`

`upstream` define un grupo de servidores para balancear. Da nombre al grupo y lo referencias en `proxy_pass`:

```nginx
http {
    upstream app_backend {
        server 127.0.0.1:3000;
        server 127.0.0.1:3001;
    }

    server {
        listen 80;
        location / {
            proxy_pass http://app_backend;   # referencia por nombre
        }
    }
}
```

- El nombre (`app_backend`) es interno de Nginx; no es DNS.
- Si un backend cae, Nginx deja de mandarle tráfico (tras `max_fails` fallos).

### 3. Algoritmos de balanceo

| Algoritmo | Directiva | Cómo reparte |
|---|---|---|
| **Round-robin** | (default) | Reparte en orden cíclico |
| **Least connections** | `least_conn;` | Al backend con menos conexiones activas |
| **IP hash** | `ip_hash;` | Hash de la IP del cliente → mismo backend (sticky) |
| **Generic hash** | `hash $key;` | Hash de una clave arbitraria (URL, header…) |
| **Random** | `random;` | Aleatorio (con `random two` elige 2 y toma el least-conn) |

**Round-robin (default):**

```nginx
upstream app_backend {
    server 127.0.0.1:3000;
    server 127.0.0.1:3001;
}
```

**Least connections:**

```nginx
upstream app_backend {
    least_conn;
    server 127.0.0.1:3000;
    server 127.0.0.1:3001;
}
```

**IP hash (sticky por IP del cliente):**

```nginx
upstream app_backend {
    ip_hash;
    server 127.0.0.1:3000;
    server 0.0.0.0:3001;   # si una IP cae, se reasigna
}
```

> `ip_hash` es útil para sesiones en memoria (sin shared store), pero si el cliente pasa por NAT/CDN, todas las IPs son la misma y se rompe la distribución. Mejor usar una cookie de sesión compartida en Redis.

### 4. Balanceo ponderado y `backup`/`down`

```nginx
upstream app_backend {
    server 127.0.0.1:3000 weight=3;    # 3x más tráfico
    server 127.0.0.1:3001 weight=1;
    server 127.0.0.1:3002 backup;      # solo si los demás fallan
    server 127.0.0.1:3003 down;        # fuera de rotation (mantenimiento)
}
```

| Parámetro | Significado |
|---|---|
| `weight=N` | Peso relativo (default 1) |
| `max_fails=N` | Fallos consecutivos para retirar (default 1) |
| `fail_timeout=T` | Tiempo durante el que se considera caído (default 10s) |
| `backup` | Solo recibe tráfico si los primarios fallan |
| `down` | Marcado permanentemente fuera |
| `max_conns=N` | Máx. conexiones simultáneas a ese backend |
| `slow_start=T` | Sube el peso gradualmente al recuperar (comercial) |

### 5. `proxy_set_header`: cabeceras que el backend necesita

Por defecto, Nginx al hacer `proxy_pass` **reescribe** algunas cabeceras. Para que el backend vea la IP real del cliente y el host original, hay que reenviarlas:

```nginx
location / {
    proxy_pass http://app_backend;
    proxy_set_header Host              $host;
    proxy_set_header X-Real-IP         $remote_addr;
    proxy_set_header X-Forwarded-For   $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
}
```

| Cabecera | Contiene |
|---|---|
| `Host` | El host original pedido por el cliente (`$host`) |
| `X-Real-IP` | La IP del cliente (`$remote_addr`) |
| `X-Forwarded-For` | Cadena de IPs por las que ha pasado (`$proxy_add_x_forwarded_for`) |
| `X-Forwarded-Proto` | `http` o `https` (`$scheme`) |

> Sin estas cabeceras, el backend cree que el cliente es Nginx (`127.0.0.1`) y que el Host es `app_backend`. Esto rompe generación de URLs, logs y rate limiting por IP.

### 6. Health checks

**Pasivos (open source):** Nginx detecta fallos al intentar comunicarse. Si en `fail_timeout` hay `max_fails` fallos, lo retira durante `fail_timeout`.

```nginx
upstream app_backend {
    server 127.0.0.1:3000 max_fails=3 fail_timeout=30s;
    server 127.0.0.1:3001 max_fails=3 fail_timeout=30s;
}
```

- `max_fails=3 fail_timeout=30s`: si falla 3 veces en 30 s, lo retira 30 s.
- Un "fallo" es un timeout, conexión rechazada o 5xx leído (configurable con `proxy_next_upstream`).

**Activos (Nginx Plus / comercial):** Nginx hace una petición periódica a cada backend y lo retira si no responde. En open source se simula con un `location` de health + un script externo (Prometheus, Consul), o con `proxy_next_upstream` para no mandarle tráfico a un backend que devuelva 502/503.

```nginx
# patrón open source: endpoint de health en el backend
location /health {
    proxy_pass http://app_backend/health;
    access_log off;
}
```

### 7. `proxy_next_upstream`: qué hacer ante un fallo

```nginx
proxy_next_upstream error timeout http_502 http_503 http_504;
proxy_next_upstream_tries 3;
```

- Si un backend responde 502/503/504 o hay timeout, Nginx prueba el siguiente upstream.
- `proxy_next_upstream_tries` limita cuántos intentos (evita amplificar el tráfico ante un fallo general).

### 8. Proxy de WebSocket

WebSocket usa el mecanismo HTTP Upgrade. Hay que reenviar `Upgrade` y `Connection`:

```nginx
map $http_upgrade $connection_upgrade {
    default upgrade;
    ''      close;
}

server {
    listen 80;
    location /ws {
        proxy_pass http://ws_backend;
        proxy_http_version 1.1;
        proxy_set_header Upgrade    $http_upgrade;
        proxy_set_header Connection $connection_upgrade;
        proxy_set_header Host       $host;

        proxy_read_timeout 3600s;   # WebSocket es long-lived
    }
}
```

- `proxy_http_version 1.1`: Upgrade solo funciona con HTTP/1.1.
- `map $http_upgrade` normaliza: si hay `Upgrade: websocket`, reenvía `Connection: upgrade`; si no, `close` (para HTTP normal no rompe keepalive).
- `proxy_read_timeout` alto: las conexiones WS están abiertas mucho tiempo; sin esto Nginx las cierra a los 60 s.

### 9. Path rewriting con `rewrite`

`rewrite` cambia la URI antes de elegir el `location`:

```nginx
# reescribe /v1/x -> /x
rewrite ^/v1/(.*)$ /$1 break;

# redirección permanente (301)
rewrite ^/old/(.*)$ https://$host/new/$1 permanent;
```

| Flag | Efecto |
|---|---|
| `last` | Reevalúa la nueva URI contra los `location` (default si no hay flag) |
| `break` | No reevalúa; sigue en el mismo location |
| `redirect` | 302 temporal |
| `permanent` | 301 permanente |

> Cuidado con `last` en bucle: un `rewrite` que vuelve a matchear puede crear un loop (Nginx corta tras 10 iteraciones con error 500).

### 10. `return` para redirecciones limpias

`return` es más simple y rápido que `rewrite` para redirecciones y respuestas directas:

```nginx
# redirect 301 a HTTPS
return 301 https://$host$request_uri;

# respuesta directa con body
location = /health {
    return 200 "ok\n";
    add_header Content-Type text/plain;
}

# error 410 Gone
location /legacy {
    return 410;
}
```

| Sintaxis | Uso |
|---|---|
| `return 301 <url>` | Redirección permanente |
| `return 302 <url>` | Redirección temporal |
| `return 200 "texto"` | Respuesta directa (200 con body) |
| `return 404` | Código de estado sin body |

### 11. Patrón completo: API con varios backends

```nginx
http {
    upstream api_backend {
        least_conn;
        server 10.0.0.1:3000 max_fails=3 fail_timeout=30s;
        server 10.0.0.2:3000 max_fails=3 fail_timeout=30s;
        server 10.0.0.3:3000 backup;
    }

    server {
        listen 80;
        server_name api.ejemplo.com;

        location / {
            proxy_pass http://api_backend;
            proxy_set_header Host              $host;
            proxy_set_header X-Real-IP         $remote_addr;
            proxy_set_header X-Forwarded-For   $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;

            proxy_connect_timeout 2s;
            proxy_read_timeout    30s;
            proxy_send_timeout    30s;

            proxy_next_upstream error timeout http_502 http_503 http_504;
        }

        location /ws {
            proxy_pass http://api_backend;
            proxy_http_version 1.1;
            proxy_set_header Upgrade    $http_upgrade;
            proxy_set_header Connection $connection_upgrade;
            proxy_read_timeout 3600s;
        }
    }
}
```

---

## Tablas de referencia

### Algoritmos de `upstream`

| Algoritmo | Directiva | Mejor para |
|---|---|---|
| Round-robin | (default) | Backends homogéneos, requests cortas |
| Least conn | `least_conn` | Requests de duración variable |
| IP hash | `ip_hash` | Sesiones sticky por IP (sin shared store) |
| Generic hash | `hash $key` | Sesión por cookie/URL consistente |
| Random | `random` | Reducir sincronización entre workers |

### Parámetros de `server` en `upstream`

| Parámetro | Default | Para qué |
|---|---|---|
| `weight=N` | 1 | Peso relativo |
| `max_fails=N` | 1 | Fallos para retirar |
| `fail_timeout=T` | 10s | Ventana de fallos y tiempo retirado |
| `backup` | off | Solo si los primarios fallan |
| `down` | off | Fuera de rotation |
| `max_conns=N` | 0 (∞) | Límite de conexiones |

### Cabeceras de proxy habituales

| Cabecera | Variable | Contenido |
|---|---|---|
| `Host` | `$host` | Host original del cliente |
| `X-Real-IP` | `$remote_addr` | IP del cliente |
| `X-Forwarded-For` | `$proxy_add_x_forwarded_for` | Cadena de proxies |
| `X-Forwarded-Proto` | `$scheme` | http/https |

### Flags de `rewrite`

| Flag | Efecto |
|---|---|
| `last` | Reevalúa la URI contra locations |
| `break` | No reevalúa |
| `redirect` | 302 |
| `permanent` | 301 |

---

## Conceptos clave

- **`proxy_pass` + trailing slash decide la URI del backend**: sin `/` pasa la URI original; con `/` sustituye el prefix. Es la fuente nº1 de bugs.
- **`upstream` da un nombre al grupo** y permite balanceo + parámetros por backend; con IP literal se puede usar `proxy_pass` directo, pero `upstream` escala mejor.
- **Round-robin es el default** y rara vez es la mejor opción; `least_conn` reparte mejor cuando las requests duran distinto.
- **`ip_hash` pega al cliente a un backend**: útil para sesiones en memoria, pero frágil con NAT/CDN. Mejor sesión compartida (Redis) + cookie.
- **`proxy_set_header` es obligatorio en proxy real**: sin `X-Forwarded-For` el backend no conoce la IP del cliente y sin `Host` construye URLs rotas.
- **Health checks pasivos** (open source) reaccionan tras el fallo; los **activos** (Plus) lo detectan antes. Define `max_fails`/`fail_timeout` acordes a tu SLA.
- **`proxy_next_upstream`** reintenta ante 502/503/504 pero **amplifica** el tráfico: limita con `proxy_next_upstream_tries`.
- **WebSocket necesita `Upgrade`/`Connection` + HTTP/1.1**: sin eso el handshake falla. Usa el truco de `map $http_upgrade`.
- **`return` > `rewrite` para redirecciones simples**: es más barato, sin riesgo de loop y sin reevaluar locations.
- **`rewrite ... last` puede entrar en bucle**: si la nueva URI vuelve a matchear el mismo `location`. Nginx corta a 10 iteraciones con 500.

---

## Errores comunes

- **El backend recibe `/api/users` cuando esperaba `/users`**: olvidaste el trailing slash en `proxy_pass http://backend/;`.
- **El backend ve `127.0.0.1` como IP del cliente**: falta `proxy_set_header X-Real-IP $remote_addr;` y `X-Forwarded-For`.
- **WebSocket se desconecta a los 60s**: `proxy_read_timeout` por defecto es 60s; sube a 3600s para WS.
- **Loop infinito de `rewrite`**: un `rewrite ... last` cuya nueva URI vuelve a matchear. Usa `break` o restringe con condiciones.
- **El backup nunca recibe tráfico** aunque los primarios vayan lentos: `backup` solo se activa si los primarios **fallan** (no si responden lento). Para "si están lentos" usa `max_fails` con timeouts cortos.
- **502 Bad Gateway**: el backend no escucha en ese puerto/IP o rechaza la conexión. Comprueba con `curl http://backend:port` desde el servidor Nginx.
- **Sesiones no persistentes con round-robin**: el login va a backend-1 y la siguiente request a backend-2, que no tiene la sesión. Usa `ip_hash` o sessions compartidas.
- **`proxy_pass` con URI en location regex**: `location ~ \.php$ { proxy_pass http://backend/; }` → error de sintaxis. En regex, `proxy_pass` no puede llevar URI; usa `rewrite` antes si necesitas cambiar el path.
- **Timeouts largos saturan workers**: si el backend es lento y `proxy_read_timeout` es 300s, los workers quedan ocupados. Ajusta a tu SLA real.
- **Olvidar `proxy_http_version 1.1`** en WS: el handshake `Upgrade` requiere HTTP/1.1; con 1.0 se rechaza.
