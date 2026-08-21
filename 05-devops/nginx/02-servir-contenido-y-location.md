# 02 — Servir contenido y location
> Guía de servicio de contenido estático en Nginx: `root` vs `alias`, `index`, `try_files`, matching de `location` y su prioridad (exact, prefix, regex), `autoindex`, tipos MIME y `default_type`, compresión `gzip`, caché de estáticos con `expires` y ETag. Escrito para Nginx 1.22+.

---

## Objetivos

- [ ] Diferenciar `root` (añade la URI) de `alias` (sustituye la URI)
- [ ] Usar `index` para definir el archivo por defecto de un directorio
- [ ] Construir fallbacks robustos con `try_files`
- [ ] Entender el **orden de matching** de `location` (exacta `=`, prefix `^~`, regex `~`/`~*`, prefix simple)
- [ ] Elegir el modificador de `location` correcto (`=`, `~`, `~*`, `^~`)
- [ ] Servir archivos estáticos con `root` y `index`
- [ ] Activar `autoindex` para listar directorios
- [ ] Entender los tipos MIME, `include mime.types` y `default_type`
- [ ] Activar y configurar `gzip` para comprimir respuestas
- [ ] Controlar la caché del navegador con `expires` y `Cache-Control`
- [ ] Entender ETag, `Last-Modified` y las peticiones condicionales (304)
- [ ] Detectar y evitar los 404 típicos por confusión `root`/`alias`

---

## Apuntes

### 1. `root` vs `alias`

Las dos directivas sirven archivos desde el disco, pero **construyen el path de forma distinta**:

| Directiva | Cómo construye el path | Ejemplo |
|---|---|---|
| `root /var/www;` con URI `/img/logo.png` | `/var/www` + `/img/logo.png` = `/var/www/img/logo.png` | añade la URI |
| `alias /data/;` con URI `/img/logo.png` | `/data/` + `logo.png` = `/data/logo.png` | sustituye la parte matcheada |

**`root` (añade la URI completa):**

```nginx
location /static/ {
    root /var/www;          # /static/app.css -> /var/www/static/app.css
}
```

**`alias` (sustituye el prefix):**

```nginx
location /static/ {
    alias /var/www/assets/;  # /static/app.css -> /var/www/assets/app.css
}
```

> Regla práctica: usa `root` cuando la ruta del disco **coincide** con la URI. Usa `alias` cuando el directorio físico **no** se llama como la URI. `alias` debe terminar en `/` si el `location` termina en `/`.

### 2. `index`

`index` define qué archivo se sirve cuando la petición apunta a un directorio:

```nginx
location / {
    root /var/www;
    index index.html index.htm index.php;   # se prueba en orden
}
```

- Se intentan en orden; el primero que exista se sirve.
- Si **ninguno** existe y no hay `autoindex`, Nginx devuelve **403 Forbidden**.

### 3. `try_files`

`try_files` prueba una lista de archivos/URIs y usa el último como **fallback**:

```nginx
# SPA: sirve el archivo si existe, si no, devuelve index.html
location / {
    root /var/www/app;
    try_files $uri $uri/ /index.html;
}
# $uri    -> /var/www/app$uri (archivo concreto)
# $uri/   -> directorio (probar el index)
# /index.html -> fallback final (devuelve ese archivo, no 404)
```

**Fallback a un named location:**

```nginx
location / {
    try_files $uri $uri/ @app;
}
location @app {
    proxy_pass http://backend;
}
```

**Error 404 explícito:**

```nginx
try_files $uri =404;     # si no existe el archivo, 404
```

> `try_files` es la pieza clave para SPAs (React/Vue/Next exportado) y para caché-then-fallback. El **último** argumento es el fallback y dispara una sub-petición interna.

### 4. Matching de `location` y su prioridad

Nginx evalúa los `location` en este **orden estricto** (no es "de arriba abajo"):

1. **`=` exacta**: `location = /favicon.ico { }` — si matchea, se usa y se para.
2. **`^~` prefix preferente**: `location ^~ /static/ { }` — prefix sin regex; si matchea, se usa y se para (no se evalúan regex).
3. **`~` y `~*` regex** (en orden de aparición): `~` sensible a mayúsculas, `~*` insensible. Se prueba la primera que matchea.
4. **prefix simple** (la más larga): `location /api { }` — la **larga** más específica gana, pero pierde ante cualquier regex que matchee.

| Modificador | Tipo | Prioridad |
|---|---|---|
| `=` | exacta | 1 (máxima) |
| `^~` | prefix, no regex | 2 |
| `~` | regex sensible | 3 (en orden de aparición) |
| `~*` | regex insensible | 3 |
| (nada) | prefix simple | 4 (más larga gana) |

**Ejemplo completo:**

```nginx
server {
    listen 80;

    location = /exacto { return 200 "exacta\n"; }      # 1) gana si URI == /exacto
    location ^~ /static/ { root /var/www; }             # 2) gana si URI empieza por /static/
    location ~* \.(png|jpg|gif)$ { expires 1d; }       # 3) regex: imágenes
    location ~ \.php$ { fastcgi_pass ...; }            # 3) regex: php
    location /api { proxy_pass http://backend; }       # 4) prefix simple
    location / { root /var/www; index index.html; }   # 4) prefix simple genérico
}
```

> Truco: para assets con regex, pon el `^~` en `/static/` si quieres que **no** pasen por las regex de imágenes/php y vayan directo a servir archivos (más rápido y predecible).

### 5. Servir archivos estáticos

Configuración típica para estáticos:

```nginx
server {
    listen 80;
    server_name static.ejemplo.com;
    root /var/www/static;

    location / {
        index index.html;
        try_files $uri $uri/ =404;
    }
}
```

Optimización con `sendfile` y `tcp_nopush`:

```nginx
http {
    sendfile on;        # copia de FD a FD sin pasar por userspace
    tcp_nopush on;      # envía cabeceras + file en un solo packet (con sendfile)
    aio threads;        # I/O asíncrona para archivos grandes (Linux)
}
```

### 6. `autoindex`

Lista el contenido del directorio cuando no hay `index`:

```nginx
location /descargas/ {
    alias /data/descargas/;
    autoindex on;              # lista el directorio
    autoindex_exact_size off;  # tamaños legibles (1.2K en vez de 1234)
    autoindex_localtime on;    # hora local en vez de GMT
}
```

- Útil para repositorios de archivos, builds, logs.
- **Peligroso** si el directorio tiene datos sensibles: no lo actives en `/`.

### 7. Tipos MIME y `default_type`

Nginx mapea extensiones a `Content-Type` con `include mime.types`:

```nginx
http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;   # si la extensión no está mapeada
}
```

`mime.types` contiene líneas como:

```
types {
    text/html                             html htm shtml;
    text/css                              css;
    application/javascript                js;
    image/png                             png;
    application/json                      json;
}
```

Para forzar un tipo concreto:

```nginx
location ~* \.json$ {
    default_type application/json;
    root /var/www;
}
```

> Un `Content-Type` malo rompe el navegador: si sirve un `.js` como `application/octet-stream`, el navegador lo descarga en vez de ejecutarlo. Por eso el `include mime.types` es obligatorio.

### 8. `gzip`

Compresión de respuestas para ahorrar ancho de banda:

```nginx
http {
    gzip on;
    gzip_vary on;                 # añade Vary: Accept-Encoding
    gzip_proxied any;             # comprimir aunque la petición venga de un proxy
    gzip_comp_level 6;            # 1 (rápido) a 9 (lento); 6 equilibrio
    gzip_min_length 256;         # no comprimir respuestas < 256 bytes
    gzip_types
        text/plain
        text/css
        text/xml
        application/json
        application/javascript
        application/xml
        image/svg+xml;
}
```

- `gzip on` comprime si el cliente envía `Accept-Encoding: gzip`.
- **No** comprimir archivos ya comprimidos (png, jpg, gz, br) — gastarías CPU sin ganar tamaño. `gzip_types` se aplica a tipos de texto.
- `gzip_comp_level` alto (>6) apenas reduce más y gasta CPU; 5–6 es el sweet spot.

Comprobación:

```bash
curl -H "Accept-Encoding: gzip" -I http://localhost/app.css
# Content-Encoding: gzip
```

### 9. Caché de estáticos con `expires`

Controla cuánto tiempo el navegador cachea el archivo:

```nginx
location ~* \.(css|js|png|jpg|jpeg|gif|svg|woff2)$ {
    root /var/www;
    expires 30d;                 # Cache-Control: max-age=2592000
    add_header Cache-Control "public, immutable";
}

location ~* \.(html)$ {
    expires -1;                  # no cachear (siempre revalidar)
    add_header Cache-Control "no-cache";
}
```

- `expires 1h` / `1d` / `30d` / `max` → `Cache-Control: max-age=...`
- `expires off` (default) → no añade `Cache-Control`.
- `expires -1` → `Cache-Control: no-cache`.
- `immutable` le dice al navegador que el archivo **nunca** cambia y no hace falta revalidar (ideal para assets con hash: `app.abc123.js`).

### 10. ETag y peticiones condicionales

Nginx genera `ETag` y `Last-Modified` automáticamente para archivos estáticos:

```
HTTP/1.1 200 OK
Last-Modified: Mon, 01 Jan 2024 12:00:00 GMT
ETag: "659a1a3b-12cf"
```

El navegador puede enviar:

```
If-Modified-Since: Mon, 01 Jan 2024 12:00:00 GMT
If-None-Match: "659a1a3b-12cf"
```

Si el archivo no cambió, Nginx responde **304 Not Modified** sin body (ahorra ancho de banda):

```
HTTP/1.1 304 Not Modified
ETag: "659a1a3b-12cf"
```

> No hay que configurar nada para ETag en estáticos: Nginx lo hace a partir de `mtime` + `size`. Para respuestas de proxy hay que usar `proxy_cache` (guía 03/05) si quieres ETag en backends.

### 11. Patrón completo: estáticos optimizados

```nginx
server {
    listen 80;
    server_name assets.ejemplo.com;
    root /var/www/assets;

    # gzip global
    gzip on;
    gzip_types text/css application/javascript application/json image/svg+xml;

    # imágenes y fuentes: cache largo
    location ~* \.(png|jpg|jpeg|gif|svg|woff2|ico)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }

    # css/js con hash: cache largo
    location ~* \.(css|js)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }

    # html: no cachear
    location ~* \.html$ {
        add_header Cache-Control "no-cache";
    }

    # el resto
    location / {
        try_files $uri =404;
    }
}
```

---

## Tablas de referencia

### Modificadores de `location`

| Modificador | Tipo | Ejemplo | Notas |
|---|---|---|---|
| `=` | exacta | `location = /x` | Solo matchea esa URI exacta |
| `^~` | prefix | `location ^~ /static/` | Si matchea, no evalúa regex |
| `~` | regex CS | `location ~ \.php$` | Sensible a mayúsculas |
| `~*` | regex CI | `location ~* \.png$` | Insensible a mayúsculas |
| (nada) | prefix | `location /api` | La más larga específica gana |

### Valores de `expires`

| Valor | Resultado |
|---|---|
| `off` | No añade cabecera (default) |
| `1h` / `1d` / `30d` | `Cache-Control: max-age=...` |
| `max` | `Cache-Control: max-age=315360000` |
| `-1` | `Cache-Control: no-cache` (siempre revalidar) |

### Directivas de archivos estáticos

| Directiva | Default | Para qué |
|---|---|---|
| `root` | html | Path base (añade la URI) |
| `alias` | — | Path base (sustituye el prefix) |
| `index` | index.html | Archivo por defecto de un directorio |
| `try_files` | — | Secuencia de fallback |
| `autoindex` | off | Listar directorios |
| `default_type` | octet-stream | MIME si no hay match |
| `sendfile` | off | Copia FD→FD en kernel |
| `tcp_nopush` | off | Batch cabeceras+file |

### Directivas de `gzip`

| Directiva | Default | Para qué |
|---|---|---|
| `gzip` | off | Activar compresión |
| `gzip_comp_level` | 1 | Nivel 1–9 |
| `gzip_min_length` | 20 | Tamaño mínimo a comprimir |
| `gzip_types` | text/html | Tipos a comprimir |
| `gzip_vary` | off | Añadir `Vary: Accept-Encoding` |
| `gzip_proxied` | off | Comprimir respuestas a proxies |

---

## Conceptos clave

- **`root` añade, `alias` sustituye**: la confusión nº1 de Nginx. `root /var/www` + URI `/a/b.html` = `/var/www/a/b.html`. `alias /var/www/` + location `/a/` + URI `/a/b.html` = `/var/www/b.html`.
- **Matching por prioridad, no por orden**: `=`, `^~`, regex, prefix. Un `location = /x` gana siempre sobre un `location /` aunque esté abajo.
- **`try_files` fallback**: el último argumento es el "plan B" (archivo, URI o código). Es lo que hace funcionar las SPAs.
- **`index` es la puerta de un directorio**: sin `index` y sin `autoindex`, un directorio sin archivo devuelve 403.
- **MIME define cómo el navegador interpreta el contenido**: un `.js` sin `Content-Type: application/javascript` se descarga en vez de ejecutarse.
- **`gzip` solo para texto**: comprimir imágenes/zip es gastar CPU inútilmente.
- **`expires` + `immutable`**: la combinación ideal para assets con hash (`app.abc123.js`).
- **ETag/Last-Modified → 304**: Nginx lo hace solo en estáticos; ahorra ancho de banda al revalidar sin enviar body.

---

## Errores comunes

- **404 por `root`/`alias` cruzados**: `location /img { alias /var/www; }` y pides `/img/logo.png` → busca `/var/wwwlogo.png` (falta la `/`). Con `alias` que termina en `/` el location también debe terminar en `/`.
- **403 Forbidden en `/`**: no existe `index.html` y `autoindex off`. Crea el archivo o activa `autoindex on`.
- **Descarga un `.js` en vez de ejecutarlo**: falta `include mime.types;` o el tipo no está mapeado.
- **El navegador no usa la caché**: pusiste `expires 30d` pero el navegador revalida porque el archivo no tiene `immutable` y el nombre no cambia.
- **`gzip` no comprime**: el archivo es menor que `gzip_min_length` o el tipo no está en `gzip_types`.
- **`location /api` no matchea `/api/users`**: sí, matchea (prefix). Pero `location = /api` **no** matchea `/api/users` (exacta).
- **Regex que captura de más**: `location ~ \.php$` matchea `/index.php` y `/foo/bar.php`. Si solo quieres el raíz, usa `^~ /` o restringe con `try_files`.
- **`expires` en `location` pero `add_header` se pierde**: si defines `add_header` en un `location`, se **sobrescriben** los del padre. Repite las cabeceras que necesites.
- **`autoindex on` en `/`**: expone todo el filesystem servido. Úsalo solo en directorios de descargas controlados.
- **Olvidar `try_files $uri =404`**: sin esto, una URI que no existe puede pasar al backend o devolver 500.
