# 02 — Imágenes y Dockerfile

## Objetivos

- [ ] Entender qué es un `Dockerfile` y cómo define una imagen
- [ ] Construir imágenes con `docker build` y etiquetarlas (`-t`, `docker tag`)
- [ ] Dominar las instrucciones: `FROM` `RUN` `CMD` `ENTRYPOINT` `COPY` `ADD` `WORKDIR` `ENV` `ARG` `LABEL` `USER`
- [ ] Usar `.dockerignore` para reducir el contexto de build
- [ ] Entender el cache de capas y cómo ordenar instrucciones para optimizarlo
- [ ] Hacer **multi-stage builds** para imágenes pequeñas
- [ ] Elegir bases `alpine` y `scratch` y entender sus tradeoffs
- [ ] Aplicar buenas prácticas: capas, `.dockerignore`, tags, no root
- [ ] Añadir un `HEALTHCHECK` a una imagen

## Apuntes

### ¿Qué es un Dockerfile?

Un **Dockerfile** es un archivo de texto con una secuencia de instrucciones que describen cómo construir una imagen. Cada instrucción genera una **capa** (o un metadato). Docker lee el Dockerfile, ejecuta cada paso y guarda el resultado en una imagen.

```dockerfile
# Dockerfile mínimo
FROM alpine:3.20
RUN apk add --no-cache curl
CMD ["echo", "hola"]
```

Build:

```bash
docker build -t mi-app:1.0 .        # el "." es el contexto (directorio enviado al daemon)
docker tag mi-app:1.0 miuser/mi-app:demo
```

### docker build y el contexto

`docker build` envía el **contexto** (el directorio indicado, por defecto el `.`) al daemon. **Todo** lo que hay en ese directorio se envía, salvo lo que ignore `.dockerignore`. Por eso un buen `.dockerignore` es crucial: evita enviar `node_modules`, `.git`, builds, etc., y acelera el build.

```bash
docker build -t app:1.0 .                    # contexto = directorio actual
docker build -t app:1.0 -f docker/app.Dockerfile .   # Dockerfile fuera del contexto
docker build -t app:1.0 --build-arg VERSION=2.3 .     # pasar ARG
docker build --no-cache -t app:1.0 .                  # invalidar cache
docker build --target builder -t app:dev .            # build parcial de un multi-stage
```

### .dockerignore

Evita enviar al daemon archivos innecesarios o sensibles:

```
# .dockerignore
.git
.gitignore
node_modules
npm-debug.log
Dockerfile*
.dockerignore
dist
build
*.md
.env
.env.*
coverage
__pycache__
*.pyc
.venv
```

> Sin `.dockerignore`, si copias `./` con `COPY . .` y tienes `node_modules` en el host, lo enviarás y lo sobrescribirás dentro del contenedor, rompiendo dependencias.

### Instrucciones del Dockerfile

#### FROM — imagen base

Obligatoria (salvo con `ARG` antes). Define la base de la imagen.

```dockerfile
FROM alpine:3.20
FROM node:20-alpine AS builder          # stage con nombre (multi-stage)
FROM scratch                             # imagen vacía (para binarios estáticos)
FROM python:3.12-slim
```

#### RUN — ejecuta un comando en el build

Cada `RUN` crea una capa. Agrupa comandos con `&&` para reducir capas.

```dockerfile
# Mal: 3 capas
RUN apt-get update
RUN apt-get install -y curl
RUN rm -rf /var/lib/apt/lists/*

# Bien: 1 capa y limpia en el mismo RUN
RUN apt-get update \
    && apt-get install -y --no-install-recommends curl \
    && rm -rf /var/lib/apt/lists/*
```

#### CMD — comando por defecto al arrancar

Se puede sobrescribir fácilmente desde `docker run`. Solo uno por stage; si hay varios, gana el último.

```dockerfile
CMD ["nginx", "-g", "daemon off;"]        # forma exec (recomendada)
CMD echo hola                             # forma shell: se ejecuta como /bin/sh -c "echo hola"
```

#### ENTRYPOINT — comando fijo

No se sobrescribe con argumentos de `docker run` (estos se añaden como parámetros). Ideal para imágenes que se comportan como un binario.

```dockerfile
ENTRYPOINT ["python", "app.py"]
# docker run imagen --port 8000  →  ejecuta: python app.py --port 8000
```

Patrón común: `ENTRYPOINT` fijo + `CMD` con defaults sobrescribibles:

```dockerfile
ENTRYPOINT ["python", "app.py"]
CMD ["--help"]          # si no pasas argumentos, ejecuta python app.py --help
```

#### COPY vs ADD

- `COPY`: copia archivos/directorios del contexto al contenedor. **Preferir siempre.**
- `ADD`: hace lo mismo **y además** descomprime tarballs y descarga URLs. Es impredecible; úsalo solo si necesitas auto-extract.

```dockerfile
COPY package.json package-lock.json ./
COPY ./src ./src
# ADD solo cuando aporta valor:
ADD rootfs.tar.gz /            # descomprime en el destino
ADD https://ejemplo.com/app.tar.gz /tmp/   # descarga y descomprime (evítalo; usa RUN curl)
```

#### WORKDIR — directorio de trabajo

Establece el `cwd` para `RUN`, `CMD`, `ENTRYPOINT`, `COPY`. Se crea si no existe.

```dockerfile
WORKDIR /app
COPY . .
RUN npm ci
CMD ["node", "index.js"]
```

#### ENV y ARG

- `ENV`: variable de entorno que persiste en el contenedor (runtime).
- `ARG`: variable solo disponible durante el build (no en el contenedor final).

```dockerfile
ARG VERSION=1.0
ENV NODE_ENV=production \
    APP_VERSION=$VERSION
RUN echo "Construyendo versión $VERSION"
```

```bash
docker build --build-arg VERSION=2.0 -t app .
# Dentro del contenedor: echo $APP_VERSION  → 2.0
```

> Cuidado: los `ARG` pueden exponer secretos en el historial de capas (`docker history`). Usa `--secret` de BuildKit para secretos reales.

#### LABEL — metadatos

```dockerfile
LABEL org.opencontainers.image.title="mi-app" \
      org.opencontainers.image.version="1.0" \
      org.opencontainers.image.authors="ana@example.com" \
      maintainer="Ana Pérez"
```

Se consultan con `docker inspect` o `docker image inspect`.

#### USER — ejecutar como no-root

Por defecto los contenedores corren como root. Crea un usuario y úsalo:

```dockerfile
RUN addgroup -S app && adduser -S app -G app
USER app
```

En bases Debian:

```dockerfile
RUN groupadd -r app && useradd -r -g app app
USER app
```

### Capas y cache

Docker cachea cada capa. Si una capa cambia, se invalidan **ella y todas las siguientes**. Por eso el orden importa:

```dockerfile
# Mal: COPY . . invalida el cache de npm ci en cada cambio de código
COPY . .
RUN npm ci

# Bien: copia primero solo package.json (cambia poco), cachea npm ci
COPY package.json package-lock.json ./
RUN npm ci
COPY . .
```

Reglas del cache:

- Solo se cachean instrucciones que cambian el FS: `RUN`, `COPY`, `ADD`.
- `RUN` se cachea por la cadena de texto. Si cambia un argumento, invalida.
- `COPY` se cachea por el checksum de los archivos copiados. Si un archivo cambia, invalida.
- `apt-get update` solo cachea si está en el mismo `RUN` que `apt-get install`; si los separas, puedes instalar versiones obsoletas.

### Multi-stage builds

Permite usar una imagen "compiladora" grande y copiar solo el resultado a una imagen final mínima. Reduce el tamaño drásticamente.

```dockerfile
# Stage 1: builder
FROM node:20-alpine AS builder
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci
COPY . .
RUN npm run build

# Stage 2: runtime (sin node_modules ni build tools)
FROM nginx:1.27-alpine
COPY --from=builder /app/dist /usr/share/nginx/html
HEALTHCHECK CMD wget -qO- http://localhost/ || exit 1
```

```bash
docker build -t web:1.0 .
docker images web:1.0       # imagen pequeña (solo nginx + dist)
```

### alpine y scratch

| Base | Tamaño | Cuándo usar |
|---|---|---|
| `ubuntu` / `debian` | ~70 MB | Compatibilidad máxima, glibc |
| `python:3.12-slim` | ~50 MB | Python sin compiladores |
| `node:20-alpine` | ~50 MB | Node con musl libc |
| `alpine:3.20` | ~5 MB | Binarios estáticos o musl |
| `scratch` | 0 MB | Solo binarios estáticos (Go, Rust) |

Ejemplo Go con scratch:

```dockerfile
# builder
FROM golang:1.23-alpine AS builder
WORKDIR /src
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 go build -o /app -ldflags="-s -w" .

# runtime: imagen vacía
FROM scratch
COPY --from=builder /app /app
ENTRYPOINT ["/app"]
```

> **Atención:** alpine usa **musl libc**, no glibc. Algunas libs de Python/Node compiladas contra glibc (wheels `manylinux`) pueden fallar en alpine. Si da errores raros, usa la variante `-slim` (basada en Debian).

### Buenas prácticas

1. **Un contenedor = un proceso.** No metas nginx + app + cron en una imagen; usa Compose.
2. **Ordena el Dockerfile para aprovechar el cache:** dependencias primero, código después.
3. **Agrupa `RUN`** y limpia en el mismo paso (`rm -rf /var/lib/apt/lists/*`).
4. **Usa `COPY` en lugar de `ADD`** salvo tarballs autoextraíbles.
5. **Fija versiones:** `FROM node:20.18-alpine3.20`, no `:latest`.
6. **`.dockerignore`** siempre.
7. **No secretos en el Dockerfile** (ni en `ARG`). Usa `--secret` de BuildKit o móntalos en runtime.
8. **Forma exec** para `CMD`/`ENTRYPOINT`: `CMD ["node", "index.js"]` (evita problemas de señales).
9. **Usuario no root** con `USER`.
10. **Multi-stage** para imágenes de producción.
11. **`HEALTHCHECK`** para que Docker sepa si la app está viva.
12. **Etiqueta con `LABEL`** siguiendo `org.opencontainers.image.*`.

### HEALTHCHECK

Le dice a Docker cómo comprobar que la app responde. Docker marca el contenedor como `healthy`/`unhealthy` y los orquestadores (Compose, Swarm) pueden reaccionar.

```dockerfile
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget -qO- http://localhost:3000/health || exit 1
```

Estados: `starting` → `healthy` → `unhealthy`. Se consultan con `docker inspect --format='{{.State.Health.Status}}' <c>`.

## Tablas de referencia

### Instrucciones del Dockerfile

| Instrucción | Crea capa | Descripción |
|---|---|---|
| `FROM` | Sí | Imagen base |
| `RUN` | Sí | Ejecuta comando en el build |
| `COPY` | Sí | Copia del contexto |
| `ADD` | Sí | Copia + descomprime/descarga |
| `WORKDIR` | No (metadata) | Directorio de trabajo |
| `ENV` | No | Variable de entorno (runtime) |
| `ARG` | No | Variable solo en build |
| `LABEL` | No | Metadato |
| `USER` | No | Usuario/UID para RUN/CMD |
| `EXPOSE` | No | Documenta un puerto (no lo publica) |
| `CMD` | No | Comando por defecto (sobrescribible) |
| `ENTRYPOINT` | No | Comando fijo |
| `HEALTHCHECK` | No | Comando de chequeo de salud |
| `VOLUME` | No | Declara un punto de montaje anónimo |
| `STOPSIGNAL` | No | Señal para detener (por defecto SIGTERM) |
| `SHELL` | No | Shell por defecto para forma shell |
| `ONBUILD` | Sí (obsoleto) | Se ejecuta cuando la imagen es usada como base |

### Diferencias CMD vs ENTRYPOINT

| Caso | ENTRYPOINT | CMD | Resultado de `docker run imagen X` |
|---|---|---|---|
| `ENTRYPOINT ["app"]` | `app` | (nada) | `app X` |
| `CMD ["app"]` | (nada) | `app` | `X` (sustituye) |
| `ENTRYPOINT ["app"]` + `CMD ["--help"]` | `app` | `--help` | `app X` (X sustituye a --help) |

### Comandos de imagen

| Comando | Acción |
|---|---|
| `docker build -t name:tag .` | Construye y etiqueta |
| `docker build --no-cache` | Invalida el cache |
| `docker build --target stage` | Construye solo hasta un stage |
| `docker build --build-arg K=V` | Pasa un ARG |
| `docker tag src dst` | Crea alias |
| `docker images` | Lista imágenes |
| `docker history <img>` | Historial de capas |
| `docker image inspect <img>` | Metadata JSON |
| `docker image prune -a` | Borra imágenes sin contenedor |
| `docker save -o file.tar <img>` | Exporta imagen a tar |
| `docker load -i file.tar` | Importa imagen de tar |
| `docker push / docker pull` | Sube/descarga del registry |

## Conceptos clave

- **Dockerfile** = receta de texto que produce una imagen.
- **Contexto de build** = directorio enviado al daemon. Todo lo que no esté en `.dockerignore` se envía.
- **Capa (layer)** = diff del FS. Se cachean y comparten entre imágenes.
- **Cache de build** = reutilización de capas idénticas. Invalidation en cascada: cambia una, se rehacen las siguientes.
- **Multi-stage** = varios `FROM` en un Dockerfile; copias solo artefactos al stage final.
- **Stage** = bloque nombrado (`FROM ... AS builder`) al que se referencia con `--from=builder`.
- **Forma exec vs shell**: `CMD ["node","x"]` (exec, recibe señales correctamente) frente a `CMD node x` (shell, arranca bajo `/bin/sh -c`).
- **scratch** = imagen vacía (capa 0). Solo válida para binarios estáticos.
- **HEALTHCHECK** = instrucción que define cómo saber si el contenedor está sano.
- **LABEL OCI** = metadatos estandarizados (`org.opencontainers.image.*`).

## Errores comunes

- **`COPY failed: file not found`**: el archivo no está en el **contexto** (o el path es relativo a otro sitio). Recuerda que `COPY` solo ve lo que se envía como contexto.
- **El cache se invalida siempre**: porque pusiste `COPY . .` antes de `RUN npm ci`. Reordena: copia `package.json` primero.
- **Imagen enorme (1 GB)**: porque copiaste `node_modules` o usaste una base con build tools. Usa multi-stage y una base `-slim`/`alpine`.
- **`apt-get update` cacheado por separado de `install`**: provoca instalar versiones antiguas. Ponlos en el mismo `RUN`.
- **Usar `ADD` con URLs**: descarga en build y mete el archivo en una capa (no se borra). Mejor `RUN curl ... && rm`.
- **Secretos en `ARG`**: quedan visibles con `docker history`. Usa `RUN --mount=type=secret` de BuildKit.
- **`CMD` en forma shell pierde señales**: `CMD npm start` arranca `sh -c "npm start"` y `npm` no reenvía SIGTERM; el contenedor tarda 10s en morir. Usa `CMD ["npm","start"]` o `exec npm`.
- **Olvidar `USER`**: el contenedor corre como root. Si hay RCE, el atacante es root del contenedor (y si el socket está montado, root del host).
- **`EXPOSE` no publica puertos**: solo documenta. Tienes que añadir `-p` en `docker run` o `ports:` en Compose.
- **alpine + wheel glibc**: errores de `not found` al ejecutar Python/Node en alpine. Cambia a `python:3.12-slim` o instala build deps con `apk add ... build-base`.
- **`docker build` lento por contexto enorme**: falta `.dockerignore` y se envían `node_modules` o `.git` de cientos de MB.
