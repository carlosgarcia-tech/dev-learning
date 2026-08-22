# Chuleta de Docker

Referencia rápida de Docker y Docker Compose: imágenes, contenedores, redes, volúmenes, build, registry, system, context, secret y config. Incluye referencia de Dockerfile, `.dockerignore` y multi-stage.

## Índice

- [Imágenes](#imágenes)
- [Contenedores](#contenedores)
- [Redes](#redes)
- [Volúmenes](#volúmenes)
- [Docker Compose](#docker-compose)
- [Build y Dockerfile](#build-y-dockerfile)
- [.dockerignore](#dockerignore)
- [Multi-stage](#multi-stage)
- [Registry](#registry)
- [System](#system)
- [Context](#context)
- [Secret](#secret)
- [Config](#config)
- [Compose YAML (referencia)](#compose-yaml-referencia)

---

## Imágenes

| Comando | Descripción |
|---|---|
| `docker images` / `docker image ls` | Lista imágenes locales |
| `docker pull <imagen>:<tag>` | Descarga una imagen |
| `docker pull nginx:1.25` | Tag concreto |
| `docker pull nginx:latest` | Última (por defecto) |
| `docker push <imagen>` | Sube a un registry |
| `docker build -t nombre:tag .` | Construye desde Dockerfile |
| `docker build -t app --build-arg VERSION=1.0 .` | Con build args |
| `docker build -f Dockerfile.prod -t app .` | Dockerfile concreto |
| `docker tag <imagen> <nuevo>:<tag>` | Etiqueta |
| `docker rmi <imagen>` | Borra una imagen |
| `docker image prune` | Borra imágenes sin usar |
| `docker image prune -a` | Borra todas no en uso |
| `docker image inspect <imagen>` | Metadatos |
| `docker save -o app.tar app:1.0` | Exporta a archivo |
| `docker load -i app.tar` | Importa desde archivo |
| `docker history <imagen>` | Capas de la imagen |
| `docker image ls --format "{{.Repository}}:{{.Tag}}"` | Formato custom |

```bash
# Flujo típico de build
docker build -t mi-app:1.0 .
docker run -p 3000:3000 mi-app:1.0
```

---

## Contenedores

| Comando | Descripción |
|---|---|
| `docker run <imagen>` | Crea y arranca |
| `docker run -d <imagen>` | En background (detached) |
| `docker run -it <imagen> bash` | Interactivo con TTY |
| `docker run --name web nginx` | Con nombre |
| `docker run -p 8080:80 nginx` | Mapea puerto host:contenedor |
| `docker run -v $(pwd):/app node` | Monta volumen |
| `docker run -e PORT=3000 app` | Variable de entorno |
| `docker run --env-file .env app` | Desde archivo |
| `docker run --rm app` | Se borra al parar |
| `docker run --network mi-red app` | En una red |
| `docker run -d --restart unless-stopped app` | Política de reinicio |
| `docker run -u 1000:1000 app` | Como un usuario concreto |
| `docker run --memory 512m --cpus 1 app` | Límites de recursos |
| `docker ps` | Contenedores en marcha |
| `docker ps -a` | Todos (incluso parados) |
| `docker ps -q` | Solo IDs |
| `docker stop <id>` | Detiene (SIGTERM) |
| `docker stop $(docker ps -q)` | Detiene todos |
| `docker start <id>` | Arranca uno parado |
| `docker restart <id>` | Reinicia |
| `docker rm <id>` | Elimina contenedor |
| `docker rm -f <id>` | Fuerza borrado en marcha |
| `docker container prune` | Borra parados |

### Inspección y ejecución

| Comando | Descripción |
|---|---|
| `docker logs <id>` | Ver logs |
| `docker logs -f <id>` | Seguir logs |
| `docker logs --tail 100 <id>` | Últimas 100 líneas |
| `docker logs -t <id>` | Con timestamps |
| `docker exec -it <id> bash` | Entrar en el contenedor |
| `docker exec <id> ls /app` | Ejecutar comando |
| `docker inspect <id>` | Metadatos completos |
| `docker stats` | Uso de recursos en vivo |
| `docker top <id>` | Procesos dentro |
| `docker cp <id>:/ruta .` | Copiar del contenedor |
| `docker cp . <id>:/ruta` | Copiar al contenedor |
| `docker rename <viejo> <nuevo>` | Renombrar |
| `docker commit <id> mi-imagen` | Crea imagen desde contenedor |
| `docker diff <id>` | Cambios en el filesystem |
| `docker port <id>` | Mapeos de puerto |

```bash
# Levantar un postgres efímero para pruebas
docker run -d --name pg \
  -e POSTGRES_PASSWORD=secret \
  -p 5432:5432 \
  postgres:16

# Entrar y abrir psql
docker exec -it pg psql -U postgres
```

---

## Redes

| Comando | Descripción |
|---|---|
| `docker network ls` | Lista redes |
| `docker network create mi-red` | Crea red bridge |
| `docker network create --driver bridge net1` | Explícito |
| `docker network inspect mi-red` | Detalles |
| `docker network connect mi-red <id>` | Conecta contenedor |
| `docker network disconnect mi-red <id>` | Desconecta |
| `docker network rm mi-red` | Borra |
| `docker network prune` | Borra no usadas |

Drivers de red:

| Driver | Uso |
|---|---|
| `bridge` | Por defecto, comunicación entre contenedores del host |
| `host` | Usa la red del host (sin aislamiento) |
| `none` | Sin red |
| `overlay` | Multi-host (Swarm) |
| `macvlan` | IP propia en la LAN |

```bash
# Comunicación por nombre de contenedor (DNS interno)
docker network create app-net
docker run -d --name db --network app-net -e POSTGRES_PASSWORD=secret postgres:16
docker run -d --name api --network app-net -e DB_HOST=db mi-api
# api puede hacer ping a "db" sin saber su IP
```

---

## Volúmenes

Dos formas de persistir datos: **volúmenes** (gestionados por Docker) y **bind mounts** (rutas del host).

| Comando | Descripción |
|---|---|
| `docker volume ls` | Lista volúmenes |
| `docker volume create mi-vol` | Crea |
| `docker volume inspect mi-vol` | Detalles (ruta en host) |
| `docker volume rm mi-vol` | Borra |
| `docker volume prune` | Borra no usados |

Tipos de montaje en `run`:

| Flag | Descripción |
|---|---|
| `-v mi-vol:/data` | Volumen con nombre |
| `-v /ruta/host:/data` | Bind mount (ruta absoluta) |
| `-v /ruta:/data:ro` | Solo lectura |
| `--mount type=volume,src=mi-vol,dst=/data` | Sintaxis explícita |
| `--mount type=bind,src=$(pwd),dst=/app` | Bind explícito |
| `--mount type=tmpfs,dst=/cache` | tmpfs (RAM) |
| `--tmpfs /cache` | tmpfs abreviado |

```bash
# Persistir datos de postgres
docker volume create pgdata
docker run -d --name pg -v pgdata:/var/lib/postgresql/data -e POSTGRES_PASSWORD=secret postgres:16
# Aunque borres el contenedor, el volumen pgdata conserva los datos
```

---

## Docker Compose

| Comando | Descripción |
|---|---|
| `docker compose up` | Crea y arranca |
| `docker compose up -d` | En background |
| `docker compose up --build` | Reconstruye imágenes |
| `docker compose up --scale api=3` | Escala un servicio |
| `docker compose down` | Detiene y borra |
| `docker compose down -v` | Borra también volúmenes |
| `docker compose stop` | Detiene sin borrar |
| `docker compose start` | Arranca los parados |
| `docker compose restart` | Reinicia |
| `docker compose ps` | Lista servicios |
| `docker compose logs -f api` | Logs de un servicio |
| `docker compose exec api bash` | Entrar |
| `docker compose run --rm api npm test` | Ejecuta one-off |
| `docker compose build` | Solo construye |
| `docker compose pull` | Descarga imágenes |
| `docker compose config` | Valida y muestra el YAML final |
| `docker compose -f compose.prod.yml up -d` | Archivo concreto |

```bash
# Archivos múltiples: base + override + prod
docker compose -f compose.yml -f compose.prod.yml up -d
```

---

## Build y Dockerfile

Instrucciones del Dockerfile:

| Instrucción | Descripción |
|---|---|
| `FROM imagen:tag` | Imagen base |
| `RUN comando` | Ejecuta en build (crea capa) |
| `WORKDIR /ruta` | Directorio de trabajo |
| `COPY src dst` | Copia archivos del contexto |
| `ADD url dst` | Como COPY + soporta URLs y .tar |
| `ENV CLAVE=valor` | Variable en build y runtime |
| `ARG VERSION=1.0` | Argumento en build (no persiste) |
| `EXPOSE 8080` | Documenta el puerto |
| `CMD ["comando", "arg"]` | Comando por defecto del contenedor |
| `ENTRYPOINT ["comando"]` | Comando fijo |
| `USER usuario` | Usuario para RUN/CMD |
| `VOLUME /data` | Declara volumen |
| `HEALTHCHECK CMD curl -f http://localhost/ \|\| exit 1` | Healthcheck |
| `LABEL clave=valor` | Metadatos |
| `SHELL ["/bin/bash", "-c"]` | Shell por defecto |
| `STOPSIGNAL SIGTERM` | Señal para parar |

### Dockerfile de ejemplo (Node)

```dockerfile
FROM node:20-alpine

WORKDIR /app

# Copiar dependencias primero (mejor caché)
COPY package*.json ./
RUN npm ci --omit=dev

# Copiar el resto del código
COPY . .

ENV NODE_ENV=production
EXPOSE 3000

HEALTHCHECK --interval=30s --timeout=3s --retries=3 \
  CMD wget -qO- http://localhost:3000/health || exit 1

CMD ["node", "server.js"]
```

### CMD vs ENTRYPOINT

```dockerfile
# CMD: se puede sobrescribir fácil
CMD ["node", "server.js"]          # docker run imagen python app.py

# ENTRYPOINT: el comando fijo; CMD son argumentos
ENTRYPOINT ["node"]
CMD ["server.js"]                  # docker run imagen -> node server.js
                                   # docker run imagen other.js -> node other.js
```

### Buenas prácticas de build

- Imágenes base pequeñas: `alpine`, `slim`, `distroless`
- Aprovechar el caché de capas: copiar `package.json` antes que el código
- Usar `.dockerignore`
- Un contenedor = un proceso
- Etiquetar versiones, no solo `latest`
- Compilar con `--target` para multi-stage
- No ejecutar como root (`USER node`)
- Combinar `RUN` para reducir capas

```bash
# Build con argumento
docker build --build-arg NODE_ENV=production -t app:prod .
```

---

## .dockerignore

Evita enviar archivos innecesarios al contexto de build.

```dockerignore
# Dependencias
node_modules/
*/node_modules/

# Build y caché
dist/
build/
.git/
.cache/
.next/
coverage/

# Logs y datos
*.log
*.tmp
.env

# Docker internos
Dockerfile*
docker-compose*
.dockerignore

# SO
.DS_Store
Thumbs.db
```

> Sin `.dockerignore`, `COPY . .` copia todo (incluido `.git`, `node_modules`), haciendo el build lento e inflando la imagen.

---

## Multi-stage

Compilar en una etapa y copiar solo el resultado a una imagen final más pequeña.

```dockerfile
# Stage 1: build
FROM node:20 AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# Stage 2: producción (solo estáticos servidos por nginx)
FROM nginx:alpine
COPY --from=builder /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

```dockerfile
# Multi-stage con target para desarrollo
FROM node:20 AS base
WORKDIR /app
COPY package*.json ./
RUN npm ci

FROM base AS dev
COPY . .
CMD ["npm", "run", "dev"]

FROM base AS prod
COPY . .
RUN npm run build
CMD ["npm", "start"]

# Construir solo una etapa
# docker build --target dev -t app:dev .
# docker build --target prod -t app:prod .
```

### Compilar Go a binario estático (imagen final en MB)

```dockerfile
FROM golang:1.22 AS build
WORKDIR /src
COPY . .
RUN CGO_ENABLED=0 go build -o app -ldflags="-s -w" .

FROM scratch
COPY --from=build /src/app /app
ENTRYPOINT ["/app"]
```

---

## Registry

| Comando | Descripción |
|---|---|
| `docker login` | Login en Docker Hub |
| `docker login registry.ejemplo.com` | Login en registry privado |
| `docker login -u user -p pass` | Con credenciales |
| `docker logout` | Logout |
| `docker tag app user/app:1.0` | Etiqueta para subir |
| `docker push user/app:1.0` | Sube |
| `docker pull user/app:1.0` | Descarga |
| `docker search nginx` | Busca en Hub |

```bash
# Publicar en Docker Hub
docker tag mi-app:1.0 usuario/mi-app:1.0
docker push usuario/mi-app:1.0

# Registry privado local
docker run -d -p 5000:5000 --name registry registry:2
docker tag mi-app:1.0 localhost:5000/mi-app:1.0
docker push localhost:5000/mi-app:1.0
```

### Insegure registry (para self-signed)

Configurar `/etc/docker/daemon.json`:

```json
{
  "insecure-registries": ["registry.midominio.com:5000"]
}
```

```bash
sudo systemctl restart docker
```

---

## System

| Comando | Descripción |
|---|---|
| `docker system df` | Espacio usado |
| `docker system prune` | Limpia lo no usado |
| `docker system prune -a` | También imágenes sin contenedor |
| `docker system prune --volumes` | También volúmenes sin usar |
| `docker system events` | Eventos en tiempo real |
| `docker system info` | Info de la instalación |
| `docker version` | Versión |
| `docker info` | Detalle del daemon |
| `docker buildx version` | BuildKit |

```bash
# Limpieza agresiva (¡cuidado!)
docker system prune -a --volumes -f

# Ver qué ocupa más
docker system df -v
```

---

## Context

Para cambiar entre varios daemons Docker (local, remoto, swarm).

```bash
docker context ls
docker context create remote --docker "host=ssh://user@server"
docker context use remote
docker context use default
docker context rm remote
```

```bash
# El comando docker ahora apunta al daemon remoto
docker ps
```

---

## Secret

Gestión de secretos en Swarm (no en standalone).

```bash
echo "mi-password" | docker secret create db_password -
docker secret ls
docker secret inspect db_password
docker service create --name api --secret db_password mi-api
# Dentro del contenedor: /run/secrets/db_password
docker secret rm db_password
```

En Compose (Swarm):

```yaml
services:
  api:
    image: mi-api
    secrets:
      - db_password
secrets:
  db_password:
    file: ./secrets/db_password.txt
```

> Para standalone, usa variables de entorno o `--env-file`, o herramientas externas (Vault, SOPS, Docker Secrets con Swarm).

---

## Config

Como secrets pero para datos no sensibles (configs). Solo Swarm.

```bash
echo "server {\n listen 80;\n}" | docker config create nginx_conf -
docker config ls
docker config rm nginx_conf
```

```yaml
services:
  web:
    image: nginx
    configs:
      - source: nginx_conf
        target: /etc/nginx/conf.d/default.conf
configs:
  nginx_conf:
    file: ./nginx.conf
```

---

## Compose YAML (referencia)

```yaml
services:
  api:
    image: mi-api:1.0
    build:
      context: .
      dockerfile: Dockerfile
      args:
        VERSION: "1.0"
      target: prod
    container_name: api
    restart: unless-stopped
    ports:
      - "3000:3000"
      - "8080-8082:8080-8082"
    environment:
      - NODE_ENV=production
      - DB_HOST=db
      - DB_PORT=5432
    env_file:
      - .env
    volumes:
      - ./src:/app/src
      - logs:/app/logs
      - ./config:/etc/app:ro
    networks:
      - app-net
    depends_on:
      db:
        condition: service_healthy
    healthcheck:
      test: ["CMD", "wget", "-qO-", "http://localhost:3000/health"]
      interval: 30s
      timeout: 3s
      retries: 3
      start_period: 10s
    deploy:
      replicas: 3
      resources:
        limits:
          cpus: "1.0"
          memory: 512M
        reservations:
          memory: 256M
      restart_policy:
        condition: on-failure
        max_attempts: 3
    secrets:
      - db_password

  db:
    image: postgres:16-alpine
    restart: unless-stopped
    environment:
      POSTGRES_USER: admin
      POSTGRES_PASSWORD: secret
      POSTGRES_DB: app
    volumes:
      - pgdata:/var/lib/postgresql/data
    networks:
      - app-net
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U admin"]
      interval: 10s
      timeout: 5s
      retries: 5
    ports:
      - "5432:5432"

  web:
    image: nginx:alpine
    ports:
      - "80:80"
    volumes:
      - ./nginx.conf:/etc/nginx/conf.d/default.conf:ro
      - ./dist:/usr/share/nginx/html:ro
    depends_on:
      - api
    networks:
      - app-net

networks:
  app-net:
    driver: bridge

volumes:
  pgdata:
  logs:

secrets:
  db_password:
    file: ./secrets/db_password.txt
```

### Claves de compose de referencia

| Clave | Nivel | Descripción |
|---|---|---|
| `services` | raíz | Servicios a levantar |
| `image` | servicio | Imagen a usar |
| `build` | servicio | Construir desde Dockerfile |
| `ports` | servicio | Mapeo de puertos |
| `environment` / `env_file` | servicio | Variables |
| `volumes` | servicio | Montajes |
| `networks` | servicio | Redes a las que pertenece |
| `depends_on` | servicio | Dependencias y condiciones |
| `healthcheck` | servicio | Chequeo de salud |
| `restart` | servicio | Política de reinicio |
| `deploy` | servicio | Solo Swarm (replicas, recursos) |
| `command` | servicio | Sobrescribe CMD |
| `entrypoint` | servicio | Sobrescribe ENTRYPOINT |
| `user` | servicio | Usuario de ejecución |
| `working_dir` | servicio | WORKDIR |
| `profiles` | servicio | Activar grupos de servicios |
| `networks` | raíz | Definición de redes |
| `volumes` | raíz | Definición de volúmenes |
| `secrets` | raíz | Definición de secretos |
| `configs` | raíz | Definición de configs |

### Perfiles

```yaml
services:
  api:
    image: mi-api
  debug-tools:
    image: busybox
    profiles: ["debug"]

# Solo se arranca con: docker compose --profile debug up
```

### Política de reinicio

| Valor | Comportamiento |
|---|---|
| `no` | No reinicia (por defecto) |
| `on-failure` | Reinicia si sale con código de error |
| `always` | Siempre reinicia |
| `unless-stopped` | Siempre, salvo que lo pares tú |

### depends_on con condición

```yaml
depends_on:
  db:
    condition: service_healthy
  cache:
    condition: service_started
  migrator:
    condition: service_completed_successfully
```
