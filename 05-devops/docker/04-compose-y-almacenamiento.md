# 04 — Compose y almacenamiento

## Objetivos

- [ ] Entender qué es Docker Compose y para qué sirve (multi-contenedor declarativo)
- [ ] Escribir un `docker-compose.yml` con `services`, `volumes` y `networks`
- [ ] Usar `up`, `down`, `logs`, `exec`, `ps`, `build`, `restart` con Compose
- [ ] Modelar dependencias con `depends_on` y healthchecks de condición
- [ ] Gestionar variables de entorno y `.env` en Compose
- [ ] Usar perfiles (`profiles`) para entornos dev/test/prod
- [ ] Aplicar overrides (`docker-compose.override.yml`) y Compose Merge
- [ ] Diseñar almacenamiento persistente con volúmenes y hacer backups

## Apuntes

### ¿Qué es Docker Compose?

**Docker Compose** es una herramienta para definir y ejecutar aplicaciones multi-contenedor con un archivo YAML declarativo. En lugar de encadenar `docker run` con 20 opciones, describes todos los servicios, redes y volúmenes en `docker-compose.yml` y los levantas con un solo comando.

> Compose v2 viene integrado como plugin: `docker compose` (con espacio). La sintaxis `docker-compose` (con guion) es la v1 en Python, ya obsoleta.

### docker-compose.yml — estructura

```yaml
# docker-compose.yml
services:
  web:
    image: nginx:1.27-alpine
    ports:
      - "8080:80"
    volumes:
      - ./html:/usr/share/nginx/html:ro
    depends_on:
      - app
    restart: unless-stopped
    networks:
      - frontend

  app:
    build: ./app                 # construye desde ./app/Dockerfile
    environment:
      - DB_HOST=db
      - DB_NAME=miapp
    depends_on:
      db:
        condition: service_healthy
    networks:
      - frontend
      - backend

  db:
    image: postgres:16-alpine
    environment:
      POSTGRES_USER: app
      POSTGRES_PASSWORD: ${DB_PASSWORD}     # de .env
      POSTGRES_DB: miapp
    volumes:
      - db_data:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U app -d miapp"]
      interval: 10s
      timeout: 5s
      retries: 5
      start_period: 10s
    networks:
      - backend

volumes:
  db_data:

networks:
  frontend:
  backend:
    internal: true               # red sin salida a internet
```

Claves del esquema:

- **`services:`** — los contenedores. Cada clave es el nombre del servicio.
- **`volumes:`** — define named volumes (sección top-level).
- **`networks:`** — define redes de usuario (sección top-level).
- **`build:`** — construye una imagen desde un Dockerfile (`build: ./app` o `build: { context: ./app, dockerfile: Dockerfile, args: {...} }`).
- **`image:`** — usa una imagen ya construida.
- **`ports:`** — publica puertos (igual que `-p`).
- **`environment:`** — variables de entorno (lista o mapa).
- **`volumes:` (de servicio)** — monta volúmenes o bind mounts.
- **`depends_on:`** — orden de arranque y, opcionalmente, condición de salud.
- **`healthcheck:`** — define el chequeo de salud del servicio.
- **`restart:`** — política de reinicio.
- **`networks:` (de servicio)** — redes a las que se une el servicio.

### Comandos esenciales

```bash
docker compose up -d                 # levanta todo en background
docker compose up -d --build          # construye imágenes antes de levantar
docker compose up web                 # levanta solo un servicio (y sus deps)
docker compose up --scale app=3       # escala a 3 réplicas del servicio app
docker compose down                   # para y borra contenedores y red
docker compose down -v                # también borra los volúmenes
docker compose ps                     # estado de los servicios
docker compose logs -f                # logs de todos (follow)
docker compose logs -f web            # logs de un servicio
docker compose exec web sh           # shell en un servicio
docker compose exec db psql -U app miapp
docker compose build                  # construye sin levantar
docker compose start / stop           # arranca/para sin borrar
docker compose restart web            # reinicia un servicio
docker compose run --rm app npm test  # ejecuta un comando puntual en un servicio nuevo
docker compose config                 # valida y muestra el YAML final fusionado
docker compose top                    # procesos por servicio
```

> `docker compose up` sin `-d` corre en foreground y muestra logs; `Ctrl+C` para los servicios. Con `-d` va a background.

### depends_on y healthchecks

`depends_on` solo garantiza **orden de arranque**, no que el servicio esté "listo". Para esperar a que una BBDD acepte conexiones, combina `depends_on` + `healthcheck`:

```yaml
services:
  app:
    depends_on:
      db:
        condition: service_healthy   # espera hasta que db esté "healthy"
  db:
    image: postgres:16-alpine
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U app"]
      interval: 10s
      timeout: 5s
      retries: 5
      start_period: 10s
```

Condiciones disponibles: `service_started` (por defecto), `service_healthy` (espera healthcheck healthy), `service_completed` (espera a que el contenedor termine; útil para migraciones).

```yaml
  migrate:
    build: ./migrator
    depends_on:
      db:
        condition: service_healthy
  app:
    depends_on:
      migrate:
        condition: service_completed   # espera a que migraciones terminen
```

### Variables de entorno y .env

Compose sustituye `${VAR}` del archivo `.env` del directorio (o `--env-file`). Variables del shell tienen prioridad sobre `.env`.

```yaml
services:
  db:
    environment:
      POSTGRES_PASSWORD: ${DB_PASSWORD}
      POSTGRES_USER: ${DB_USER:-app}     # default si no está definida
```

`.env`:

```
DB_PASSWORD=supersecreto
DB_USER=app
```

```bash
docker compose config         # muestra el YAML con la sustitución resuelta
docker compose --env-file prod.env up -d
```

> Para secretos en producción no uses `.env` plano. Usa **Docker secrets** (en Swarm) o archivos montados con permisos restrictivos.

### Perfiles (profiles)

Permiten definir grupos de servicios que solo arrancan con `--profile`.

```yaml
services:
  web:
    image: nginx:1.27-alpine
  debug:
    image: nicolaka/netshoot
    profiles: ["debug"]
  tests:
    build: ./tests
    profiles: ["ci"]
```

```bash
docker compose up -d                       # solo servicios sin profile (web)
docker compose --profile debug up -d        # web + debug
docker compose --profile ci run --rm tests  # ejecuta el runner de CI
```

### Overrides

Compose fusiona automáticamente `docker-compose.yml` + `docker-compose.override.yml`. Útil para diferenciar desarrollo de producción:

```yaml
# docker-compose.yml (base)
services:
  app:
    build: ./app
    environment:
      NODE_ENV: production
    ports:
      - "3000:3000"
```

```yaml
# docker-compose.override.yml (desarrollo, se fusiona automáticamente)
services:
  app:
    environment:
      NODE_ENV: development
    volumes:
      - ./app/src:/app/src         # código en caliente
    command: npm run dev
```

Para producción, nombra los archivos explícitamente y usa `-f`:

```bash
docker compose -f docker-compose.yml -f docker-compose.prod.yml up -d
```

Reglas de fusión: listas (como `ports`, `volumes`) se **concatenan**; mapas (como `environment`) se **fusionan** (gana el override); escalares (como `image`, `command`) se **sobrescriben**.

### Volúmenes persistentes y backups

Named volumes para datos persistentes:

```yaml
volumes:
  db_data:
    driver: local
    # driver_opts:           # si necesitas NFS, etc.
    #   type: nfs
    #   o: addr=10.0.0.1,rw
```

**Backup** de un volumen (vía contenedor efímero que monta el volumen):

```bash
# Backup: tar del contenido del volumen a un archivo del host
docker run --rm -v mi_proyecto_db_data:/data -v "$PWD:/backup" alpine \
  tar czf /backup/db_data_$(date +%F).tar.gz -C /data .

# Restore
docker run --rm -v mi_proyecto_db_data:/data -v "$PWD:/backup" alpine \
  tar xzf /backup/db_data_2026-08-20.tar.gz -C /data
```

En Compose, puedes definir un servicio de backup one-shot:

```yaml
services:
  backup:
    image: alpine:3.20
    volumes:
      - db_data:/data:ro
      - ./backups:/backup
    command: >
      sh -c "tar czf /backup/db_$(date +%F).tar.gz -C /data . && echo OK"
    profiles: ["backup"]
```

```bash
docker compose --profile backup run --rm backup
```

### Ejemplo real completo: app + db + cache

```yaml
# docker-compose.yml
services:
  app:
    build:
      context: ./app
      args:
        NODE_VERSION: "20"
    environment:
      DB_HOST: db
      DB_PASSWORD: ${DB_PASSWORD}
      REDIS_URL: redis://cache:6379
    depends_on:
      db:
        condition: service_healthy
      cache:
        condition: service_started
    ports:
      - "3000:3000"
    networks: [appnet]
    restart: unless-stopped

  db:
    image: postgres:16-alpine
    environment:
      POSTGRES_USER: app
      POSTGRES_PASSWORD: ${DB_PASSWORD}
      POSTGRES_DB: miapp
    volumes:
      - db_data:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U app -d miapp"]
      interval: 10s
      timeout: 5s
      retries: 5
    networks: [appnet]
    restart: unless-stopped

  cache:
    image: redis:7-alpine
    command: ["redis-server", "--save", "60", "1", "--loglevel", "warning"]
    volumes:
      - cache_data:/data
    networks: [appnet]
    restart: unless-stopped

volumes:
  db_data:
  cache_data:

networks:
  appnet:
    driver: bridge
```

```bash
docker compose up -d --build
docker compose ps
docker compose logs -f app
docker compose down -v          # ojo: -v borra los volúmenes (datos)
```

## Tablas de referencia

### Comandos de Compose

| Comando | Acción |
|---|---|
| `docker compose up -d` | Levanta todo en background |
| `docker compose up --build` | Reconstruye imágenes |
| `docker compose up web` | Levanta un servicio (y deps) |
| `docker compose down` | Para y borra contenedores + red |
| `docker compose down -v` | También borra volúmenes |
| `docker compose ps` | Estado de servicios |
| `docker compose logs [-f] [svc]` | Logs |
| `docker compose exec web sh` | Shell en un servicio |
| `docker compose run --rm app npm t` | Ejecuta comando puntual |
| `docker compose build` | Construye imágenes |
| `docker compose config` | Valida y muestra YAML fusionado |
| `docker compose top` | Procesos por servicio |
| `docker compose restart web` | Reinicia un servicio |
| `docker compose --profile X up` | Activa perfiles |

### Claves del YAML

| Clave (nivel servicio) | Tipo | Qué hace |
|---|---|---|
| `image` | str | Imagen a usar |
| `build` | str/map | Contexto de build (`context`, `dockerfile`, `args`, `target`) |
| `ports` | list | Publica puertos `["8080:80"]` |
| `expose` | list | Puertos internos (no publicados al host) |
| `environment` | list/map | Variables de entorno |
| `env_file` | list/str | Archivos `.env` |
| `volumes` | list | Montajes `vol:/path` o `/host:/path` |
| `networks` | list/map | Redes a las que se une |
| `depends_on` | map | Orden + condición |
| `healthcheck` | map | Chequeo de salud |
| `restart` | str | Política reinicio |
| `command` | str/list | Sobrescribe CMD |
| `entrypoint` | str/list | Sobrescribe ENTRYPOINT |
| `working_dir` | str | WORKDIR |
| `user` | str | UID:GID |
| `profiles` | list | Perfiles del servicio |
| `mem_limit` / `cpus` | str | Límites de recursos |
| `logging` | map | Logging driver + opciones |

### Condiciones de `depends_on`

| Condición | Significado |
|---|---|
| `service_started` | El contenedor dependiente ha arrancado (por defecto) |
| `service_healthy` | Está `healthy` según su `healthcheck` |
| `service_completed` | Ha terminado (salida 0); para migraciones |

## Conceptos clave

- **Compose** = herramienta declarativa para multi-contenedor. El archivo describe el estado deseado; los comandos lo aplican.
- **`services`** = los contenedores de la app. El nombre del servicio es también su nombre DNS dentro de la red.
- **`depends_on`** = orden de arranque; con `condition: service_healthy` garantiza "listo", no solo "arrancado".
- **`.env`** = archivo de variables de entorno que Compose sustituye en `${VAR}`. No se commitea a git (añádelo a `.gitignore`).
- **Profile** = grupo de servicios opcional; solo arrancan con `--profile`.
- **Override** = archivo que se fusiona con el base (`docker-compose.override.yml` por defecto) para personalizar sin tocar el original.
- **Named volume** = volumen gestionado por Docker, declarado en la sección top-level `volumes:`.
- **Backup de volumen** = contenedor efímero que monta el volumen y produce un tar en el host.
- **`docker compose down -v`** = borra los volúmenes; peligroso en producción (pierdes datos).

## Errores comunes

- **`depends_on` no espera a que la BBDD esté lista**: solo garantiza orden de arranque. Añade `healthcheck` y `condition: service_healthy`.
- **Olvidar `down -v` pierde datos**: `down` solo borra contenedores y red; `-v` borra volúmenes. En producción NUNCA uses `-v` a la ligera.
- **Variables `${VAR}` sin definir**: Compose las deja vacías con un warning. Usa `${VAR:-default}` y define `.env`.
- **Confundir `image` y `build`**: `build` construye una imagen; `image` la usa (o la descarga). Puedes combinar ambos: `build: ./app` + `image: miuser/app:1.0` construye y etiqueta.
- **`ports` sin comillas**: YAML interpreta `80:80` como un sexagesimal raro. Usa siempre comillas: `"8080:80"`.
- **Bind mount relativo sin `./`**: `volumes: [app/src:/app/src]` se interpreta como named volume `app_src`. Usa `./app/src:/app/src` para bind mount.
- **`.env` commiteado con secretos**: añade `.env` a `.gitignore` y proporciona `.env.example`.
- **Override no esperado**: `docker-compose.override.yml` se fusiona **automáticamente** si existe. Si no lo quieres, usa `-f` explícito o borra el override.
- **Cambios de código no se reflejan**: porque no montaste el código o no activaste el watch/reload del framework. En dev usa bind mount del `src`.
- **`docker compose run` crea contenedores huérfanos**: siempre con `--rm` para que se borren al terminar.
- **Healthcheck con `curl` que no existe en la imagen**: `alpine` no trae `curl` por defecto. Usa `wget -qO-` o instala `curl`.
