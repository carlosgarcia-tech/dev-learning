# 05 — Producción y seguridad

## Objetivos

- [ ] Entender la superficie de ataque de una imagen Docker (root, paquetes, secretos)
- [ ] Aplicar usuarios no root y la imagen `distroless`
- [ ] Escanear imágenes con Trivy e interpretar resultados
- [ ] Firmar imágenes (signing) y entender el modelo de confianza
- [ ] Limitar recursos (CPU, memoria, PIDs) y syscalls
- [ ] Configurar logging drivers y rotación de logs
- [ ] Monitorizar contenedores (cAdvisor, Prometheus, cgroups)
- [ ] Desplegar servicios en Docker Swarm
- [ ] Montar un registry privado
- [ ] Optimizar imágenes (multi-stage, capas, `dive`)
- [ ] Construir imágenes multi-arch con `buildx`
- [ ] Usar BuildKit y CI con Docker

## Apuntes

### Superficie de ataque de una imagen

Una imagen mal hecha aumenta el riesgo de RCE y de escape del contenedor. Los puntos críticos:

1. **Corre como root**: un RCE en el contenedor da root dentro; si el socket Docker está montado, da root en el host.
2. **Incluye paquetes innecesarios**: `curl`, `bash`, `git`, compiladores… más binarios = más vulnerabilidades.
3. **Secretos horneados en capas**: `ARG` con passwords, `.env` copiado con `COPY`. Quedan en `docker history`.
4. **Base `:latest` o sin pinning**: versiones movibles y no reproducibles.
5. **Sin escaneo de CVEs**: no sabes qué vulnerabilidades arrastras.

### Usuarios no root

```dockerfile
FROM node:20-alpine
RUN addgroup -S app && adduser -S app -G app
WORKDIR /app
COPY --chown=app:app . .
USER app
CMD ["node", "server.js"]
```

En Compose:

```yaml
services:
  app:
    user: "1000:1000"
    # o por nombre:
    # user: "app"
```

> Comprueba con `docker inspect --format '{{.Config.User}}' <c>` que el usuario no sea root/vacío.

### Distroless

Las imágenes **distroless** (de Google) contienen solo el runtime de tu lenguaje, sin shell, sin package manager, sin utilidades. Superficie de ataque mínima.

```dockerfile
# builder
FROM node:20-alpine AS builder
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci --omit=dev
COPY . .
RUN npm run build

# runtime distroless (sin shell, sin bash, sin curl)
FROM gcr.io/distroless/nodejs20-debian12
WORKDIR /app
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/dist ./dist
USER nonroot
CMD ["dist/server.js"]
```

Tradeoff: **no puedes hacer `docker exec sh`** (no hay shell). Para depurar usa `:debug` variants o un sidecar con tools. Tampoco `apk`/`apt`, así que no puedes instalar nada a posteriori.

### Escaneo con Trivy

[Trivy](https://aquasecurity.github.io/trivy/) escanea imágenes, sistemas de archivos, IaC y configs en busca de CVEs.

```bash
trivy image miuser/app:1.0
trivy image --severity HIGH,CRITICAL miuser/app:1.0
trivy image --ignore-unfixed miuser/app:1.0
trivy fs .                              # escanea el código del contexto
trivy config .                          # escanea Dockerfile/compose en busca de malas prácticas
```

Salida típica:

```
miuser/app:1.0 (alpine 3.20)
Total: 2 (HIGH: 1, CRITICAL: 1)
+----------+------+--------+-----------+---------+------+
| LIBRARY  | VULN | SEVER. |  STATUS   | FIXED IN| ...
+----------+------+--------+-----------+---------+------+
| openssl  | CVE-...| HIGH  | fixed     | 3.3.2-r1| ...
+----------+------+--------+-----------+---------+------+
```

Integración en CI (GitHub Actions):

```yaml
jobs:
  scan:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: aquasecurity/trivy-action@master
        with:
          image-ref: miuser/app:${{ github.sha }}
          severity: HIGH,CRITICAL
          exit-code: 1            # falla el CI si hay vulns críticas
```

### Firma de imágenes (signing)

La firma garantiza que la imagen proviene de quien dice ser y no ha sido alterada. Opciones:

- **Cosign** (Sigstore, recomendado hoy): firma con claves OIDC o keys.
- **Docker Content Trust (DCT / Notary v1)**: `DOCKER_CONTENT_TRUST=1` firma en push y verifica en pull.

```bash
# Cosign
cosign generate-key-pair
cosign sign --key cosign.key miuser/app:1.0
cosign verify --key cosign.pub miuser/app:1.0

# DCT (legacy)
export DOCKER_CONTENT_TRUST=1
docker push miuser/app:1.0    # pide passphrase y firma
docker pull miuser/app:1.0    # verifica firma; falla si no está firmada
```

### Límites de recursos

En `docker run`:

```bash
docker run -d --memory=512m --memory-swap=1g --cpus="1.5" --pids-limit=200 myapp
```

En Compose (v2/v3):

```yaml
services:
  app:
    image: myapp:1.0
    mem_limit: 512m
    mem_reservation: 256m
    cpus: 1.5
    pids_limit: 200
    oom_kill_disable: false
    ulimits:
      nofile: 1024
```

> En Kubernetes estos límites se expresan con `resources.limits` (el mismo concepto). En Compose los límites son hints del cgroup del contenedor.

**Read-only filesystem y `--cap-drop`** para reducir permisos del contenedor:

```bash
docker run -d --read-only --tmpfs /tmp \
  --cap-drop ALL --cap-add NET_BIND_SERVICE \
  --security-opt no-new-privileges \
  myapp
```

```yaml
services:
  app:
    read_only: true
    tmpfs: ["/tmp"]
    cap_drop: [ALL]
    cap_add: [NET_BIND_SERVICE]
    security_opt: [no-new-privileges:true]
```

### Logging drivers y rotación

Por defecto Docker usa el driver `json-file` y crece sin límite. En producción configura rotación a nivel del daemon (`/etc/docker/daemon.json`) o por contenedor.

```json
// /etc/docker/daemon.json
{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
  }
}
```

Drivers disponibles: `json-file`, `local`, `syslog`, `journald`, `fluentd`, `gelf`, `awslogs`, `gcplogs`. En Compose:

```yaml
services:
  app:
    logging:
      driver: json-file
      options:
        max-size: "10m"
        max-file: "3"
```

> El driver `local` está optimizado para logs de contenedor y rota automáticamente; buena alternativa a `json-file`.

### Monitorización

- **`docker stats`** — métricas básicas en vivo (CPU, memoria, red, I/O).
- **cAdvisor** — exporta métricas de contenedores a Prometheus.
- **Prometheus + Grafana** — recopilan métricas y las visualizan.
- **cgroups v2** — `/sys/fs/cgroup` expone los contadores que leen estas herramientas.
- **`docker events`** — stream de eventos del daemon (create, start, die, health_status).

```bash
docker stats --no-stream
docker events --filter type=container
```

Stack de monitorización con Compose:

```yaml
services:
  cadvisor:
    image: gcr.io/cadvisor/cadvisor:v0.49
    volumes:
      - /:/rootfs:ro
      - /var/run:/var/run:ro
      - /sys:/sys:ro
      - /var/lib/docker/:/var/lib/docker:ro
    ports: ["8081:8080"]
  prometheus:
    image: prom/prometheus
    volumes: [./prometheus.yml:/etc/prometheus/prometheus.yml:ro]
    ports: ["9090:9090"]
```

### Docker Swarm

Swarm es el orquestador nativo de Docker (modo clúster). Hoy K8s domina producción, pero Swarm es simple y útil para clústeres pequeños o bordering.

```bash
docker swarm init                           # inicializa un clúster (nodo manager)
docker swarm join --token <token> <ip:2377>  # en un worker
docker node ls
docker service create --name web --replicas 3 -p 8080:80 nginx:1.27
docker service ls
docker service ps web
docker service scale web=5
docker service update --image nginx:1.27-alpine web
docker service rm web
docker stack deploy -c docker-compose.yml miapp
docker stack services miapp
docker stack rm miapp
```

Compose puede usarse como stack de Swarm con `deploy:`:

```yaml
services:
  web:
    image: miuser/web:1.0
    deploy:
      replicas: 3
      update_config:
        parallelism: 1
        delay: 10s
      restart_policy:
        condition: on-failure
      resources:
        limits:
          memory: 256M
          cpus: "0.5"
      placement:
        constraints: [node.role == worker]
    ports:
      - "8080:80"
```

> Diferencia clave con Compose standalone: `docker compose up` crea contenedores; `docker stack deploy` crea **services** (réplicas gestionadas por Swarm con rolling updates).

### Registry privado

Un registry privado guarda imágenes internas sin exponerlas a Docker Hub.

```bash
docker run -d -p 5000:5000 --name registry -v registry_data:/var/lib/registry \
  registry:2

docker tag miuser/app:1.0 localhost:5000/app:1.0
docker push localhost:5000/app:1.0
docker pull localhost:5000/app:1.0
```

Para un registry con TLS y autenticación (recomendado), usa un reverse proxy (nginx) con certificados y htpasswd. En CI se usan GHCR, ECR, GCR o Harbor.

> Para un registry sin TLS (solo pruebas) en un host distinto, hay que añadirlo a `/etc/docker/daemon.json` como insecure registry y reiniciar el daemon.

### Optimización de imágenes

Técnicas ordenadas por impacto:

1. **Multi-stage**: copia solo el artefacto final.
2. **Base pequeña**: `alpine`, `slim`, `distroless`, `scratch`.
3. **Agrupar `RUN`** y limpiar en el mismo paso.
4. **`.dockerignore`** para no enviar peso innecesario.
5. **Pinning de versiones** para cache estable.
6. **`dive`** para inspeccionar capas:

```bash
dive miuser/app:1.0       # muestra el tamaño y el "waste" por capa
```

7. **Squash experimental** (`--squash`) para fusionar capas (raramente necesario si usas multi-stage).

Ejemplo de reducción: una app Node de 1.1 GB (con `node:20` completo) → ~120 MB con `node:20-alpine` + multi-stage → ~90 MB con `distroless`.

### Multi-arch con buildx

`buildx` construye imágenes para varias arquitecturas (amd64, arm64) y las une en un **manifest list**.

```bash
docker buildx create --name multiarch --use
docker buildx inspect --bootstrap
docker buildx build \
  --platform linux/amd64,linux/arm64 \
  -t miuser/app:1.0 \
  --push .
```

En el Dockerfile:

```dockerfile
FROM --platform=$BUILDPLATFORM node:20-alpine AS builder
ARG TARGETPLATFORM
RUN echo "Construyendo en $BUILDPLATFORM para $TARGETPLATFORM"
FROM --platform=$TARGETPLATFORM node:20-alpine
COPY --from=builder /app /app
```

Variables de buildx: `BUILDPLATFORM` (host), `TARGETPLATFORM` (destino, p. ej. `linux/arm64`), `TARGETOS`, `TARGETARCH`, `TARGETVARIANT`.

> Para buildx multi-arch en CI (GitHub Actions) usa `docker/setup-qemu-action` + `docker/setup-buildx-action`.

### BuildKit

BuildKit es el motor de build moderno: paraleliza, cache remoto, secretos, SSH. Activo por defecto desde Docker 23.0.

```bash
DOCKER_BUILDKIT=1 docker build .
docker build --progress=plain .
```

Características avanzadas:

```dockerfile
# syntax=docker/dockerfile:1.7
# Montar cache (npm/pip) sin meterlo en la imagen
RUN --mount=type=cache,target=/root/.npm \
    npm ci

# Montar un secreto (no queda en capas)
RUN --mount=type=secret,id=npmrc,target=/root/.npmrc \
    npm ci

# Montar SSH para clonar repos privados
RUN --mount=type=ssh \
    git clone git@github.com:mi/repo.git
```

```bash
docker build --secret id=npmrc,src=$HOME/.npmrc .
docker build --ssh default=$SSH_AUTH_SOCK .
```

### CI con Docker

Patrón típico en GitHub Actions (build, scan, push):

```yaml
jobs:
  build:
    runs-on: ubuntu-latest
    permissions:
      contents: read
      packages: write
    steps:
      - uses: actions/checkout@v4
      - uses: docker/setup-buildx-action@v3
      - uses: docker/login-action@v3
        with:
          registry: ghcr.io
          username: ${{ github.actor }}
          password: ${{ secrets.GITHUB_TOKEN }}
      - uses: docker/build-push-action@v6
        with:
          context: .
          push: true
          tags: ghcr.io/${{ github.repository }}:latest,ghcr.io/${{ github.repository }}:${{ github.sha }}
          cache-from: type=gha
          cache-to: type=gha,mode=max
      - uses: aquasecurity/trivy-action@master
        with:
          image-ref: ghcr.io/${{ github.repository }}:${{ github.sha }}
          severity: HIGH,CRITICAL
          exit-code: 1
```

## Tablas de referencia

### Endurecimiento de contenedores

| Control | En `docker run` | En Compose |
|---|---|---|
| Usuario no root | `--user 1000:1000` | `user: "1000:1000"` |
| FS solo lectura | `--read-only` | `read_only: true` |
| tmpfs para /tmp | `--tmpfs /tmp` | `tmpfs: ["/tmp"]` |
| Dropear capabilities | `--cap-drop ALL` | `cap_drop: [ALL]` |
| No escalar privilegios | `--security-opt no-new-privileges` | `security_opt: [no-new-privileges:true] |
| Límite memoria | `--memory 512m` | `mem_limit: 512m` |
| Límite CPU | `--cpus 1.5` | `cpus: 1.5` |
| Límite PIDs | `--pids-limit 200` | `pids_limit: 200` |
| Read-only rootfs + bind | `--read-only --tmpfs /tmp` | combinación anterior |

### Drivers de log

| Driver | Destino |
|---|---|
| `json-file` | Archivo JSON (por defecto) |
| `local` | Binario rotado automáticamente |
| `syslog` | syslog del host |
| `journald` | journald |
| `fluentd` | fluentd |
| `gelf` | Graylog/Logstash |
| `awslogs` | CloudWatch |
| `gcplogs` | Cloud Logging |

### Comandos de Swarm

| Comando | Acción |
|---|---|
| `docker swarm init` | Crea clúster (manager) |
| `docker swarm join --token ...` | Une un worker |
| `docker node ls` | Lista nodos |
| `docker service create` | Crea un servicio |
| `docker service ls` | Lista servicios |
| `docker service ps <s>` | Tareas del servicio |
| `docker service scale <s>=N` | Escala réplicas |
| `docker service update --image ...` | Actualiza imagen (rolling) |
| `docker stack deploy -c file.yml` | Despliega un stack |
| `docker stack services <stack>` | Servicios del stack |
| `docker stack rm <stack>` | Elimina stack |

## Conceptos clave

- **Superficie de ataque** = binarios, paquetes y permisos que un atacante podría explotar si entra al contenedor.
- **distroless** = imagen solo con runtime del lenguaje, sin shell ni package manager.
- **Trivy** = escáner de CVEs en imágenes, IaC y código.
- **Signing (Cosign/DCT)** = firma criptográfica de imágenes para garantizar procedencia e integridad.
- **Capabilities (caps)** = permisos del kernel (Linux capabilities) que el contenedor puede tener; `--cap-drop ALL` los quita.
- **`no-new-privileges`** = evita que un proceso gane más privilegios vía setuid.
- **Logging driver** = dónde y cómo Docker guarda los stdout/stderr del contenedor.
- **Swarm** = orquestador nativo de Docker (clúster, services, replicas, rolling updates).
- **Registry privado** = servidor interno de imágenes (regustry:2, Harbor, GHCR, ECR).
- **buildx** = builder con soporte multi-arch, cache remoto y BuildKit.
- **Manifest list** = imagen que apunta a varias variantes por arquitectura; el cliente tira de la suya.
- **BuildKit** = motor de build moderno; soporta `--mount=type=cache|secret|ssh`.

## Errores comunes

- **Contenedor como root**: si hay RCE, el atacante es root del contenedor. Crea un `USER` no root.
- **Secretos en `ARG`/`COPY`**: quedan en `docker history`. Usa `--mount=type=secret` o móntalos en runtime.
- **`docker exec sh` falla en distroless**: no hay shell. Usa variant `:debug` o depura desde fuera.
- **Logs que llenan el disco**: sin `max-size`/`max-file`, `json-file` crece indefinidamente. Configura rotación.
- **`--cap-drop ALL` rompe la app**: algunas apps necesitan caps concretas (`NET_BIND_SERVICE` para puerto <1024). Añade solo las necesarias con `--cap-add`.
- **Trivy marca CVEs sin fix**: usa `--ignore-unfixed` para ruido, pero no ignores los críticos con fix disponible.
- **Multi-arch muy lento en CI**: la compilación cruzada (QEMU) es lenta. Usa runners nativos por arquitectura o buildx con cache.
- **Swarm en producción crítica**: hoy K8s es el estándar. Swarm es válido para casos simples, pero el ecosistema de herramientas es menor.
- **Registry privado sin TLS en producción**: cualquier cliente rechaza HTTP plano. Configura TLS o úsalo solo en pruebas.
- **`docker stack deploy` ignora `build:`**: Swarm no construye imágenes, solo usa `image:`. Construye y empuja antes del deploy.
- **Olvidar `--security-opt no-new-privileges`**: sin esto, un binario setuid dentro del contenedor podría escalar privilegios.
- **No pinning de bases**: `FROM node:latest` rompe la reproducibilidad y el cache. Fija versiones y, mejor, digests.
