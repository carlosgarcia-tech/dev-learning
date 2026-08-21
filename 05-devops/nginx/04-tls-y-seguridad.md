# 04 — TLS y seguridad
> Guía de HTTPS y seguridad en Nginx: certificados con `openssl`, redirect HTTP→HTTPS, `ssl_certificate`/`ssl_protocols` (TLSv1.2/1.3), cipher suites, HSTS, rate limiting con `limit_req`/`limit_conn`, basic auth, cabeceras de seguridad, `geo`/`map`, `deny`/`allow`, ModSecurity básico y hardening. Escrito para Nginx 1.22+.

---

## Objetivos

- [ ] Habilitar HTTPS con un certificado autofirmado generado con `openssl`
- [ ] Configurar `ssl_certificate`, `ssl_certificate_key` y el path correcto
- [ ] Forzar TLSv1.2 y TLSv1.3 y deshabilitar versiones inseguras
- [ ] Elegir cipher suites modernas y entender `ssl_ciphers`/`ssl_prefer_server_ciphers`
- [ ] Redirigir todo el tráfico HTTP a HTTPS con `return 301`
- [ ] Activar **HSTS** y entender sus riesgos (`includeSubDomains`, `preload`)
- [ ] Aplicar **rate limiting** con `limit_req` y `limit_req_zone`
- [ ] Limitar conexiones simultáneas con `limit_conn`/`limit_conn_zone`
- [ ] Proteger rutas con **basic auth** (`auth_basic` y `htpasswd`)
- [ ] Inyectar cabeceras de seguridad: `X-Frame-Options`, `X-Content-Type-Options`, `CSP`, `Referrer-Policy`
- [ ] Usar `geo` y `map` para control de acceso por IP
- [ ] Usar `allow`/`deny` para bloquear/permitir IPs
- [ ] Conocer ModSecurity (OWASP CRS) como WAF y el hardening básico de Nginx

---

## Apuntes

### 1. HTTPS y certificados con `openssl`

**Generar un certificado autofirmado** (para desarrollo):

```bash
# clave privada + cert en un solo paso (sin passphrase)
openssl req -x509 -nodes -newkey rsa:2048 \
  -keyout /etc/nginx/ssl/selfsigned.key \
  -out /etc/nginx/ssl/selfsigned.crt \
  -days 365 \
  -subj "/C=ES/ST=Madrid/L=Madrid/O=Dev/CN=localhost"
```

- `-x509`: certificado auto-firmado (no CSR).
- `-nodes`: sin passphrase (Nginx no la podría leer si la tuviera).
- `-days 365`: válido 1 año.
- `CN=localhost`: el Common Name debe coincidir con el dominio.

En producción se usa **Let's Encrypt** (gratuito, auto-renovable):

```bash
sudo apt install certbot python3-certbot-nginx
sudo certbot --nginx -d ejemplo.com -d www.ejemplo.com
```

### 2. Servidor HTTPS básico

```nginx
server {
    listen 443 ssl;
    server_name ejemplo.com;

    ssl_certificate     /etc/nginx/ssl/ejemplo.com.crt;
    ssl_certificate_key /etc/nginx/ssl/ejemplo.com.key;

    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers HIGH:!aNULL:!MD5;
    ssl_prefer_server_ciphers on;

    root /var/www/ejemplo.com;
    index index.html;
}
```

- `ssl_certificate` → el certificado (puede incluir la cadena intermedia para Let's Encrypt).
- `ssl_certificate_key` → la clave privada (modo `600`).
- `ssl_protocols` → solo TLSv1.2 y 1.3 (TLSv1.0/1.1 están deprecated).
- `ssl_ciphers` → lista de cifrados permitidos.
- `ssl_prefer_server_ciphers on` → el servidor elige el cifrado (en TLS 1.3 no aplica).

### 3. Redirect HTTP → HTTPS

```nginx
server {
    listen 80;
    server_name ejemplo.com www.ejemplo.com;
    return 301 https://$host$request_uri;
}
```

- Redirige **todas** las peticiones HTTP a su equivalente HTTPS.
- Usar `return 301` es más eficiente y limpio que `rewrite ... permanent`.

> Si usas HSTS, el redirect es una segunda línea de defensa: el navegador recordará "siempre HTTPS" y no hará la primera petición HTTP. Pero el redirect sigue siendo necesario para la primera visita y para los clientes sin HSTS.

### 4. TLSv1.2 y TLSv1.3

```nginx
ssl_protocols TLSv1.2 TLSv1.3;
```

| Protocolo | Estado | Uso |
|---|---|---|
| SSLv2/v3 | Prohibido | Nunca |
| TLSv1.0/1.1 | Deprecated (2020) | Nunca |
| TLSv1.2 | Soporte legado | Aceptable |
| TLSv1.3 | Moderno | Recomendado |

TLS 1.3 es más rápido (1 RTT en lugar de 2) y más seguro. TLS 1.2 se mantiene por compatibilidad con clientes antiguos.

### 5. Cipher suites

```nginx
ssl_ciphers ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384;
ssl_prefer_server_ciphers off;   # en TLS1.3 no aplica; en 1.2 recomendado on para FIPS
```

- Prioriza **ECDHE** (forward secrecy): si la clave se filtra, el tráfico pasado sigue siendo seguro.
- Evita `aNULL` (sin cifrado) y `MD5`/`RC4` (rotos).
- Para una config moderna, copia los cifrados de **Mozilla SSL Config Generator**.

### 6. HSTS (HTTP Strict Transport Security)

```nginx
add_header Strict-Transport-Security "max-age=31536000; includeSubDomains; preload" always;
```

- `max-age=31536000` → 1 año. El navegador recordará "solo HTTPS".
- `includeSubDomains` → aplica a subdominios. **Cuidado**: si un subdominio aún no tiene HTTPS, rompe.
- `preload` → para meterse en la lista HSTS Preload de Chrome (compromiso permanente).
- `always` → aplica también en respuestas de error (4xx/5xx).

> Antes de activar HSTS con `includeSubDomains`, asegúrate de que **todos** tus subdominios sirven HTTPS. Si no, los bloqueas sin remedio hasta que expire `max-age`.

### 7. Rate limiting con `limit_req`

Limita la tasa de peticiones por clave (normalmente IP):

```nginx
http {
    # zona de 10 MB, clave = IP, tasa = 1 petición/segundo
    limit_req_zone $binary_remote_addr zone=api_limit:10m rate=10r/s;

    server {
        listen 80;

        location /api/ {
            limit_req zone=api_limit burst=20 nodelay;
            proxy_pass http://backend;
        }
    }
}
```

| Parámetro | Significado |
|---|---|
| `rate=10r/s` | 10 peticiones por segundo por clave |
| `burst=20` | Permite ráfagas de 20 extra (se encolan) |
| `nodelay` | Sirve el burst inmediatamente (sin delay) |
| `delay=N` | Sirve N del burst inmediato, el resto con delay |
| `limit_req_status 429` | Código de respuesta al exceder (default 503) |

- `limit_req_zone` define la **zona** (memoria) y la **tasa**. `limit_req` la aplica.
- `$binary_remote_addr` ocupa menos memoria que `$remote_addr` (4 bytes vs ~15).
- Sin `burst`, cualquier ráfaga se corta en seco; con `burst`, se permiten picos controlados.

**Niveles de limitación:**

```nginx
# API sensible: 1 r/s
location /login { limit_req zone=auth_limit burst=5 nodelay; }

# API general: 10 r/s
location /api/ { limit_req zone=api_limit burst=20 nodelay; }
```

### 8. `limit_conn`: conexiones simultáneas

```nginx
http {
    limit_conn_zone $binary_remote_addr zone=conn_limit:10m;

    server {
        location / {
            limit_conn conn_limit 10;   # máx 10 conexiones por IP
        }
    }
}
```

- Limita conexiones **simultáneas** (no tasa). Útil contra slowloris y clientes que abren muchas conexiones.

### 9. Basic auth con `htpasswd`

```bash
# instalar apache2-utils para htpasswd
sudo apt install apache2-utils
sudo htpasswd -c /etc/nginx/.htpasswd admin
# (pide contraseña)
```

```nginx
location /admin {
    auth_basic "Area restringida";
    auth_basic_user_file /etc/nginx/.htpasswd;
    root /var/www/admin;
}
```

- `auth_basic "..."` activa la protección (el string es el realm).
- `auth_basic_user_file` apunta al `.htpasswd` (bcrypt o apr1).
- El navegador envía `Authorization: Basic base64(user:pass)`.

**Permitir una IP sin contraseña (excepción):**

```nginx
satisfy any;
allow 10.0.0.0/24;       # red interna sin auth
deny all;
auth_basic "Restringido";
auth_basic_user_file /etc/nginx/.htpasswd;
```

### 10. Cabeceras de seguridad

```nginx
add_header X-Frame-Options "SAMEORIGIN" always;
add_header X-Content-Type-Options "nosniff" always;
add_header Referrer-Policy "strict-origin-when-cross-origin" always;
add_header Content-Security-Policy "default-src 'self'; script-src 'self'; object-src 'none'" always;
add_header Permissions-Policy "geolocation=(), camera=(), microphone=()" always;
```

| Cabecera | Para qué |
|---|---|
| `X-Frame-Options SAMEORIGIN` | Evita clickjacking (iframe de terceros) |
| `X-Content-Type-Options nosniff` | Evita MIME sniffing |
| `Referrer-Policy` | Controla qué Referer se envía |
| `Content-Security-Policy` | Restringe orígenes de JS/CSS/img |
| `Permissions-Policy` | Deshabilita APIs del navegador (cámara, geo…) |
| `Strict-Transport-Security` | HSTS (ver sección 6) |

> **Importante**: cuando defines `add_header` dentro de un `location`, se **sobrescriben** los `add_header` del contexto padre. Si necesitas varios, repítelos todos en el `location`, o usa `add_header ... always` y ponlos en `server`.

### 11. `geo` y `map`: control por IP

`geo` mapea IPs a valores:

```nginx
geo $blocked_ip {
    default        0;
    10.0.0.0/8     0;     # red interna permitida
    192.168.1.50   1;     # IP bloqueada
    203.0.113.0/24 1;     # rango bloqueado
}

server {
    location / {
        if ($blocked_ip) { return 403; }
    }
}
```

`map` mapea un valor a otro:

```nginx
map $remote_addr $is_internal {
    default        0;
    10.0.0.0/8     1;
    192.168.0.0/16 1;
}
```

> `geo` solo acepta IPs como entrada; `map` acepta cualquier variable. Ambos son más eficientes que una cadena de `if`s.

### 12. `allow` y `deny`

```nginx
location /admin {
    allow 10.0.0.0/24;     # red interna
    allow 192.168.1.10;   # una IP concreta
    deny  all;             # el resto prohibido
}
```

- Se evalúan en orden; la primera que matchea gana.
- Es la forma más simple de bloquear/permitir IPs sin `if`.

### 13. ModSecurity (WAF)

ModSecurity es un WAF (Web Application Firewall) que se integra con Nginx vía libmodsecurity. Intercepta peticiones y aplica reglas (OWASP Core Rule Set):

```nginx
load_module modules/ngx_http_modsecurity_module.so;

server {
    modsecurity on;
    modsecurity_rules_file /etc/nginx/modsec/modsecurity.conf;

    location / {
        modsecurity on;
        proxy_pass http://backend;
    }
}
```

- Las **OWASP CRS** cubren SQLi, XSS, LFI, RCE, etc.
- En modo **DetectionOnly** solo loguea; en modo **On** bloquea.
- Instalación no trivial (libmodsecurity + módulo compilado); común en entornos con requisitos de seguridad.

### 14. Hardening básico

```nginx
# nginx.conf (main)
server_tokens off;                  # no mostrar versión en Server:
client_max_body_size 10m;           # límite de body subido
client_body_timeout 30s;
client_header_timeout 30s;
large_client_header_buffers 4 8k;

# limitar métodos (en location)
if ($request_method !~ ^(GET|POST|HEAD|PUT|DELETE)$) {
    return 405;
}

# esconder versión en error pages
server_tokens off;

# no exponer .git, .env, etc.
location ~ /\.(git|env) {
    deny all;
    access_log off;
    log_not_found off;
}
```

| Hardening | Por qué |
|---|---|
| `server_tokens off` | No revelar versión (info para atacantes) |
| `client_max_body_size` | Evitar uploads gigantes |
| Timeouts cortos | Evitar slowloris |
| Bloquear `.` ocultos | No exponer `.git`/`.env` |
| `limit_req`/`limit_conn` | Mitigar brute force y DoS |
| TLS 1.2+ | Eliminar protocolos rotos |

---

## Tablas de referencia

### Protocolos y cifrados

| Protocolo | ¿Usar? |
|---|---|
| SSLv2/v3 | No |
| TLSv1.0/1.1 | No (deprecated 2020) |
| TLSv1.2 | Sí (legado) |
| TLSv1.3 | Sí (recomendado) |

### Cabeceras de seguridad

| Cabecera | Efecto |
|---|---|
| `Strict-Transport-Security` | HSTS: solo HTTPS |
| `X-Frame-Options SAMEORIGIN` | Anti-clickjacking |
| `X-Content-Type-Options nosniff` | Anti MIME sniff |
| `Referrer-Policy` | Control del Referer |
| `Content-Security-Policy` | Restringe orígenes |
| `Permissions-Policy` | Deshabilita APIs |

### Rate limiting

| Directiva | Contexto | Para qué |
|---|---|---|
| `limit_req_zone` | http | Define zona + tasa |
| `limit_req` | http/server/location | Aplica la zona |
| `limit_conn_zone` | http | Define zona de conns |
| `limit_conn` | http/server/location | Limita conns simultáneas |
| `limit_req_status` | http/server/location | Código al exceder |

### Control de acceso

| Directiva | Para qué |
|---|---|
| `allow` | Permitir IP/rango |
| `deny` | Bloquear IP/rango |
| `geo` | Mapa IP → valor |
| `map` | Mapa variable → valor |
| `auth_basic` | Activar basic auth |
| `auth_basic_user_file` | Fichero htpasswd |

---

## Conceptos clave

- **TLS termina en Nginx**: el cliente habla HTTPS con Nginx y Nginx habla HTTP (o HTTPS) con el backend. Así descargas la CPU del backend.
- **TLSv1.3 es el estándar moderno**: 1 RTT, forward secrecy por defecto. Mantén 1.2 solo por compatibilidad.
- **HSTS es permanente durante `max-age`**: si lo activas con `includeSubDomains` y un subdominio no tiene HTTPS, lo bloqueas durante 1 año. Empieza sin `includeSubDomains` y `max-age` bajo (5 min) para probar.
- **`limit_req` controla la tasa, `limit_conn` las conexiones**: combinados mitigan la mayoría de abusos. Usa `$binary_remote_addr` para ahorrar memoria.
- **`burst` permite picos controlados**: sin `burst`, una app que hace 2 requests simultáneas se corta. `nodelay` sirve el burst sin encolar.
- **`add_header` se sobrescribe en `location`**: si defines uno en `location`, pierdes los del padre. Usa `always` y repite los necesarios.
- **`geo`/`map` son más eficientes que `if`**: Nginx evalúa el mapa en O(1), mientras que `if` en `location` es problemático ("if is evil").
- **ModSecurity + OWASP CRS** es el WAF estándar: protege de SQLi/XSS/RCE. En producción se suele dejar en `DetectionOnly` primero y luego a `On`.
- **El hardening es acumulativo**: `server_tokens off` + timeouts cortos + `limit_req` + cabeceras + TLS 1.2+ reducen la superficie de ataque.

---

## Errores comunes

- **HSTS con `includeSubDomains` rompe subdominios sin HTTPS**: si `blog.ejemplo.com` no tiene HTTPS, el navegador lo bloquea. Empieza sin `includeSubDomains`.
- **`add_header` se pierde en error 404/500**: sin `always`, las cabeceras solo se añaden en 2xx/3xx. Usa `always`.
- **`limit_req` sin `burst` corta apps legítimas**: una página que carga 20 assets de golpe se corta. Usa `burst` acorde al tráfico real.
- **`.htpasswd` con permisos abiertos**: pon `chmod 600` y propietario `root`/`nginx`.
- **Certificado sin cadena intermedia**: el navegador muestra "no confiable". El `.crt` debe contener cert + intermediates.
- **`ssl_protocols SSLv3`**: activar versiones antiguas baja la nota en SSL Labs y abre ataques (POODLE).
- **`if` con `return` dentro de `location`**: "if is evil". Para control por IP usa `geo` + un único `if` simple, o mejor `allow`/`deny`.
- **Basic auth sobre HTTP**: las credenciales viajan en base64 (no cifradas). Solo sobre HTTPS.
- **Olvidar el redirect HTTP→HTTPS**: los usuarios que escriben `http://` no llegan a HTTPS. El `return 301` es obligatorio.
- **CSP demasiado restrictiva rompe la app**: empieza en `Content-Security-Policy-Report-Only`, revisa los reportes y luego endurece.
- **No renovar certificados**: Let's Encrypt caduca a los 90 días. Configura `certbot renew --dry-run` y un cron/systemd timer.
