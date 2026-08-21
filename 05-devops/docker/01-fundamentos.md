# 01 — Fundamentos de Docker

## Objetivos

- [ ] Entender qué es Docker y qué problema resuelve (portabilidad y aislamiento)
- [ ] Diferenciar contenedores vs máquinas virtuales (VMs)
- [ ] Conocer el concepto de **imagen**, **contenedor** y **capa** (layer)
- [ ] Describir la arquitectura de Docker: daemon, CLI, runtime, registry
- [ ] Instalar y verificar Docker en Linux, macOS y Windows
- [ ] Ejecutar `docker run hello-world` y entender su flujo
- [ ] Conocer el ciclo de vida de un contenedor (created → running → stopped → removed)
- [ ] Publicar puertos y montar volúmenes básicos con `docker run`
- [ ] Usar Docker Hub como registry público: `search`, `pull`, `push`, `login`

## Apuntes

### ¿Qué es Docker?

**Docker** es una plataforma que empaqueta una aplicación y todas sus dependencias (bibliotecas, binarios, configuración) en una unidad estándar llamada **contenedor**. El objetivo es: **"construir una vez, ejecutar en cualquier sitio"**. Resuelve dos problemas reales:

- **"En mi máquina funciona"**: el contenedor incluye exactamente la misma versión de librerías y configuración en desarrollo, pruebas y producción.
- **Aislamiento**: cada contenedor corre en su propio espacio de nombres del kernel de Linux (PID, red, mount, user), sin interferir con otros procesos del host.

> Docker **NO es una máquina virtual**: no incluye un sistema operativo invitado completo. Aprovecha el kernel del host y solo añade el userspace de la aplicación.

### Contenedores vs Máquinas Virtuales

| Característica | Contenedor (Docker) | Máquina virtual (VM) |
|---|---|---|
| Kernel | Comparte el kernel del host | Kernel propio (guest OS) |
| Tamaño | MB (alpine ~5 MB) | GB (Ubuntu ~700 MB+) |
| Arranque | Segundos (o milisegundos) | Minutos |
| Densidad | Decenas/miles por host | Pocas decenas por host |
| Aislamiento | A nivel de proceso (namespaces + cgroups) | A nivel de hardware (hypervisor) |
| Portabilidad | Muy alta (misma imagen) | Baja (hay que migrar la VM) |
| Overhead | Mínimo | Alto (OS completo por VM) |

Diagrama simplificado:

```
   Contenedor                      Máquina virtual
   ┌─────────────┐                 ┌─────────────┐
   │ App + libs  │                 │   App + libs │
   ├─────────────┤                 ├─────────────┤
   │  Container  │                 │  Guest OS   │
   ├─────────────┤                 ├─────────────┤
   │ Docker/Runc │                 │  Hypervisor │
   ├─────────────┤                 ├─────────────┤
   │  Host OS    │                 │   Host OS   │
   ├─────────────┤                 ├─────────────┤
   │  Hardware   │                 │  Hardware   │
   └─────────────┘                 └─────────────┘
```

> Los contenedores usan **namespaces** (aislamiento: lo que el contenedor "ve") y **cgroups** (límites: lo que el contenedor "puede consumir") del kernel de Linux.

### Imágenes y capas (layers)

- Una **imagen** es una plantilla de solo lectura con el sistema de archivos y los metadatos para crear contenedores. Es **inmutable**: nunca se modifica, solo se construye una nueva.
- Una imagen está formada por **capas (layers)** apiladas. Cada instrucción del `Dockerfile` que modifica el sistema de archivos (`RUN`, `COPY`, `ADD`) crea una nueva capa.
- Las capas se **comparten** entre imágenes: dos imágenes basadas en `alpine` reutilizan la capa base y solo añaden las suyas.
- Los **contenedores** añaden una capa de escritura efímera (container layer) encima de la imagen. Al eliminar el contenedor, esa capa desaparece.
- Un contenedor es **instancia en ejecución** de una imagen. Una imagen puede lanzar muchos contenedores.

```
Imagen (solo lectura)           Contenedor (en ejecución)
┌───────────────────┐            ┌───────────────────┐
│ RUN apk add curl  │ ← capa 3   │  Capa de escritura │ ← efímera
├───────────────────┤            ├───────────────────┤
│ COPY app /app     │ ← capa 2   │ RUN apk add curl   │ ← R/W compartida
├───────────────────┤            ├───────────────────┤
│ FROM alpine       │ ← capa 1   │ COPY app /app      │
└───────────────────┘            ├───────────────────┤
                                  │ FROM alpine        │
                                  └───────────────────┘
```

### Arquitectura de Docker

Docker sigue un modelo **cliente-servidor**:

```
   ┌─────────┐   REST/Unix socket   ┌─────────────┐
   │  CLI    │ ───────────────────▶ │   dockerd    │  (dockerd = daemon)
   │ docker  │                      │  (daemon)    │
   └─────────┘                      └──────┬───────┘
                                          │ gestiona
                            ┌─────────────┼─────────────┐
                            ▼             ▼             ▼
                       ┌─────────┐  ┌───────────┐  ┌─────────┐
                       │  image  │  │ containerd│  │  build   │
                       │ manager │  │  + runc   │  │ (BuildKit)│
                       └─────────┘  └───────────┘  └─────────┘
```

- **docker CLI** (`docker ...`): el cliente que el usuario invoca. Envía comandos al daemon.
- **dockerd (daemon)**: servicio que gestiona imágenes, contenedores, redes y volúmenes. Expone una API REST sobre un socket Unix (`/var/run/docker.sock`).
- **containerd**: runtime de alto nivel que gestiona el ciclo de vida del contenedor.
- **runc**: runtime de bajo nivel que crea y ejecuta contenedores conforme a la OCI (Open Container Initiative).
- **BuildKit**: motor de build moderno (paralelo, cache mejorado) activo por defecto desde Docker 23.0.

> En Linux el daemon corre como root: por eso `/var/run/docker.sock` es sensible. En macOS/Windows el daemon corre dentro de una VM ligera (HyperKit / WSL2).

### Instalación

**Linux (Fedora, en este repo):**

```bash
sudo dnf install dnf-plugins-core
sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
sudo dnf install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo systemctl enable --now docker
sudo usermod -aG docker "$USER"   # ejecutar docker sin sudo (requiere relogin)
```

**Linux (Debian/Ubuntu):**

```bash
curl -fsSL https://get.docker.com | sudo sh
sudo systemctl enable --now docker
```

**macOS / Windows:** instala **Docker Desktop** (<https://docker.com/products/docker-desktop>), que incluye el daemon en una VM (HyperKit en macOS, WSL2 en Windows).

Verificar:

```bash
docker --version               # Docker version 27.x
docker compose version          # Compose v2 (plugin)
docker info                    # info del daemon (servidor, storage driver, runtime)
docker run hello-world          # primer contenedor de prueba
```

### docker run hello-world

```bash
$ docker run hello-world
Unable to find image 'hello-world:latest' locally
latest: Pulling from library/hello-world
... (descarga de capas)
Hello from Docker!
This message shows that your installation appears to be working correctly.
```

El flujo exacto:

1. La CLI envía `run hello-world` al daemon.
2. El daemon busca la imagen `hello-world:latest` en el **almacén local**. No la encuentra.
3. Descarga (pull) la imagen del registry por defecto: **Docker Hub** (`registry-1.docker.io`).
4. Crea un contenedor a partir de esa imagen.
5. Ejecuta el comando por defecto de la imagen y muestra la salida por la stdout conectada al terminal.
6. El contenedor termina y su estado pasa a `exited` (no se elimina automáticamente).

### Ciclo de vida de un contenedor

Estados principales: `created` → `running` → `paused` → `exited` → (removed).

```bash
docker create --name web nginx       # crea (estado created), no arranca
docker start   web                    # arranca el contenedor (running)
docker pause   web                    # congela procesos (paused)
docker unpause web                    # reanuda
docker stop    web                     # envía SIGTERM, tras 10s SIGKILL
docker kill    web                     # SIGKILL inmediato
docker rm      web                     # elimina el contenedor (debe estar parado)
docker rm -f   web                     # fuerza parada + borrado
```

Combinación habitual: `docker run` = `docker create` + `docker start` + (si no hay `-d`) adjuntar stdout.

### Puertos y volúmenes básicos

**Puertos:** el contenedor tiene su propia red y sus propios puertos. Para que el host acceda, hay que **publicar** el puerto del contenedor a un puerto del host con `-p`.

```bash
docker run -d -p 8080:80 --name web nginx
# -p PUERTO_HOST:PUERTO_CONTENEDOR
# Ahora http://localhost:8080 sirve el nginx del contenedor
docker run -d -p 80 nginx          # puerto del host asignado por Docker (-P mayúscula)
docker port web                    # muestra el mapeo de puertos
```

**Volúmenes:** los datos del contenedor se pierden al borrarlo. Para persistirlos, montamos un **volumen** (gestionado por Docker) o un **bind mount** (un path del host).

```bash
# Volumen gestionado por Docker (almacenado en /var/lib/docker/volumes)
docker run -d -v mis_datos:/var/lib/mysql mysql:8

# Bind mount: directorio del host montado en el contenedor
docker run -d -v /home/yo/proyecto:/app -w /app node:20-alpine
# Sintaxis moderna recomendada (--mount es más explícita)
docker run -d --mount type=bind,source=/home/yo/proyecto,target=/app node:20-alpine
```

### Registry: Docker Hub

Un **registry** es un servidor que almacena imágenes. **Docker Hub** (`hub.docker.com`) es el registry público por defecto.

```bash
docker login                       # login con tu cuenta de Docker Hub
docker pull nginx:1.27             # descarga una imagen (tag concreto)
docker pull nginx                  # tag por defecto = latest
docker images                      # lista imágenes locales
docker tag nginx:1.27 miuser/nginx:demo   # crea un alias/etiqueta
docker push miuser/nginx:demo      # sube la imagen a tu repositorio
docker search nginx                # busca imágenes públicas
docker rmi nginx:1.27              # borra una imagen local
```

Nomenclatura de imágenes: `registry/usuario/repositorio:tag`

- `nginx` → `docker.io/library/nginx:latest` (imágenes oficiales)
- `miuser/nginx` → `docker.io/miuser/nginx:latest` (usuario)
- `ghcr.io/owner/repo:v1` → registry de GitHub Container Registry

> **Buenas prácticas:** evita `:latest` en producción (no es reproducible). Fija un tag concreto (`nginx:1.27.2-alpine`) o, mejor, un digest inmutable (`nginx@sha256:abc...`).

## Tablas de referencia

### Comandos esenciales

| Comando | Acción |
|---|---|
| `docker version` | Versión de CLI y del daemon |
| `docker info` | Estado del daemon (storage driver, runtime, recursos) |
| `docker images` / `docker image ls` | Lista imágenes locales |
| `docker pull <img>:<tag>` | Descarga imagen del registry |
| `docker push <img>:<tag>` | Sube imagen al registry |
| `docker rmi <img>` | Borra una imagen |
| `docker ps` | Lista contenedores en ejecución |
| `docker ps -a` | Lista todos (incluidos los parados) |
| `docker run ...` | Crea + arranca un contenedor |
| `docker create ...` | Crea pero no arranca |
| `docker start <c>` | Arranca un contenedor creado |
| `docker stop <c>` | Detiene con SIGTERM (graceful) |
| `docker kill <c>` | Mata con SIGKILL (inmediato) |
| `docker rm <c>` | Elimina un contenedor (parado) |
| `docker rm -f <c>` | Fuerza parada + borrado |
| `docker logs <c>` | Muestra stdout/stderr |
| `docker exec -it <c> sh` | Abre shell dentro del contenedor |
| `docker inspect <c>` | Metadata completa en JSON |
| `docker stats` | Uso de CPU/memoria/red en vivo |
| `docker system prune -a` | Borra lo no usado (¡cuidado!) |

### Estados de un contenedor

| Estado | Significado | Transición |
|---|---|---|
| `created` | Creado, no arrancado | `docker create` |
| `running` | Proceso activo | `docker start` / `docker run` |
| `paused` | Procesos congelados (cgroups freezer) | `docker pause` |
| `exited` | Proceso terminado (0 u otro código) | `docker stop` / fin natural |
| `dead` | Error del runtime | fallo interno |
| (eliminado) | Borrado del almacén | `docker rm` |

### Tipos de almacenamiento

| Tipo | Sintaxis `-v` | Qué es |
|---|---|---|
| Named volume | `-v mis_datos:/data` | Docker lo gestiona en `/var/lib/docker/volumes` |
| Anonymous volume | `-v /data` | Docker crea un volumen con hash aleatorio |
| Bind mount | `-v /host/path:/data` | Directorio real del host |
| tmpfs mount | `--tmpfs /data` | RAM del host (no persistente) |

## Conceptos clave

- **Contenedor** = instancia en ejecución de una imagen. Es efímero y desechable: nunca guardes datos importantes dentro de él.
- **Imagen** = plantilla inmutable de solo lectura, formada por capas.
- **Capa (layer)** = conjunto de diferencias en el sistema de archivos. Cada `RUN`/`COPY`/`ADD` del Dockerfile añade una capa. Las capas se cachean y comparten.
- **Container layer** = capa de escritura fina que el contenedor añade sobre la imagen. Se pierde al borrar el contenedor.
- **Namespace** = mecanismo del kernel Linux que aísla lo que un contenedor "ve" (PID, red, mount, UTS, IPC, user).
- **cgroup** = mecanismo del kernel que limita lo que un contenedor "consume" (CPU, memoria, I/O).
- **OCI (Open Container Initiative)** = estándar abierto para formato de imagen y runtime; `runc` es el runtime de referencia.
- **Registry** = servicio que almacena y distribuye imágenes. Docker Hub es el público por defecto; existen GHCR, ECR, GCR, Quay y privados.
- **Tag** = etiqueta mutable de una imagen (`:latest`, `:1.27`). **Digest** = hash inmutable `@sha256:...` que identifica una imagen exacta.
- **daemon (dockerd)** = servicio que gestiona imágenes, contenedores, redes y volúmenes. La CLI solo habla con él.

## Errores comunes

- **`Cannot connect to the Docker daemon at unix:///var/run/docker.sock`**: el daemon no está corriendo. En Linux: `sudo systemctl start docker`. En macOS/Windows: arranca Docker Desktop.
- **`permission denied while trying to connect to the Docker daemon socket`**: tu usuario no está en el grupo `docker`. Solución: `sudo usermod -aG docker $USER` y reinicia sesión. No uses `chmod 777` sobre el socket.
- **`No space left on device`**: el almacén de Docker se llenó. Limpia con `docker system prune -a --volumes` (borra contenedores parados, redes sin usar, imágenes colgadas y volúmenes anónimos).
- **Confundir `docker ps` y `docker ps -a`**: `ps` solo muestra los que corren; los `exited` se ven con `-a`. Mucha gente cree que "no hay contenedores" cuando hay decenas parados acumulados.
- **Pensar que `-p` es bidireccional o del contenedor al host**: `-p HOST:CONT` expone el puerto del **contenedor** en el **host**. El contenedor ya "escucha" en su propio puerto; lo que falta es publicarlo.
- **Borrar el contenedor y perder datos**: si no montas un volumen, los datos del container layer desaparecen con `docker rm`. Para BBDD usa siempre un named volume.
- **Usar `:latest` en producción**: `latest` se mueve y no es reproducible. Fija tags (`nginx:1.27.2-alpine`) o digests.
- **`docker run` reutiliza nombres**: si creas dos contenedores con `--name web`, el segundo falla con `The container name /web is already in use`. Usa nombres únicos o `--rm`.
- **Olvidar `-it` al abrir un shell**: `docker exec web sh` sin `-it` no da TTY y se ve raro. Usa `docker exec -it web sh`.
- **Pensar que el contenedor "salva" tus cambios**: un contenedor detenido no guarda la imagen. Si instalaste `vim` dentro con `apk add vim`, al `docker rm` se pierde. Para que quede permanente, añádelo al `Dockerfile`.
