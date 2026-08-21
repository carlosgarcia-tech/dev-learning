# Docker

> Guía de estudio + ejercicios por niveles para aprender Docker desde cero hasta nivel experto.

Docker es la plataforma de **contenedores** más usada del mundo: empaqueta una aplicación y sus dependencias en una unidad portátil, ligera y reproducible que se ejecuta igual en cualquier máquina. Esta sección cubre desde la instalación y el ciclo de vida de un contenedor hasta Dockerfile, multi-stage, redes, volúmenes, Compose, seguridad, BuildKit, multi-arch y Swarm. Todos los ejemplos y ejercicios funcionan con la CLI de **docker** (y **docker compose** v2) instalada localmente; cuando Docker no está disponible, los `test.sh` validan la sintaxis de `Dockerfile` y `docker-compose.yml` con `grep`/`awk` y, opcionalmente, con `hadolint` si está instalado.

## Cómo usar esta sección

1. Lee las **guías** en orden: `01-fundamentos` → `02-imagenes-y-dockerfile` → `03-contenedores-y-redes` → `04-compose-y-almacenamiento` → `05-produccion-y-seguridad`.
2. Resuelve los **ejercicios** de cada nivel antes de pasar al siguiente. Cada ejercicio tiene un `test.sh` con `set -euo pipefail` que valida el `Dockerfile`/`docker-compose.yml` sin necesidad de ejecutar contenedores.
3. Ejecuta cada ejercicio localmente: cada carpeta incluye `Dockerfile` (o `docker-compose.yml`), `app/` con código de ejemplo (Node.js o Python simple), `.dockerignore`, `solucion/` con la solución y `test.sh`.
4. Al final, completa el **proyecto integrador**: despliegue de microservicios con Docker Compose (frontend + backend + db + nginx).

## Guías

| # | Guía | Contenido |
|---|---|---|
| 1 | [01-fundamentos.md](01-fundamentos.md) | Qué es Docker, contenedores vs VMs, imágenes y capas, arquitectura (daemon/CLI/runtime), instalación, `docker run hello-world`, ciclo de vida, puertos y volúmenes básicos, registry Docker Hub |
| 2 | [02-imagenes-y-dockerfile.md](02-imagenes-y-dockerfile.md) | Dockerfile, `FROM` `RUN` `CMD` `ENTRYPOINT` `COPY` `ADD` `WORKDIR` `ENV` `ARG` `LABEL` `USER`, `docker build`, etiquetar, `.dockerignore`, capas y cache, multi-stage, alpine y scratch, buenas prácticas, `HEALTHCHECK` |
| 3 | [03-contenedores-y-redes.md](03-contenedores-y-redes.md) | `docker run` con `-d -p -v -e --name --rm`, `exec` `logs` `ps` `stop` `rm` `inspect` `stats`, volúmenes y bind mounts, named volumes, `tmpfs`, redes `bridge` `host` `none`, DNS interno, publicación de puertos, variables de entorno, restart policies |
| 4 | [04-compose-y-almacenamiento.md](04-compose-y-almacenamiento.md) | Docker Compose, `docker-compose.yml`, `services` `volumes` `networks`, `up` `down` `logs` `exec`, `depends_on` y healthcheck, variables y `.env`, perfiles, overrides, volúmenes persistentes, backups |
| 5 | [05-produccion-y-seguridad.md](05-produccion-y-seguridad.md) | Seguridad de imágenes, escaneo con Trivy, firma, usuarios no root, distroless, límites de recursos, logging drivers, monitorización, Docker Swarm, registry privado, optimización, multi-arch con buildx, BuildKit, CI con Docker |

## Ejercicios

Cada ejercicio es una **carpeta** con: `README.md` (enunciado + requisitos + pistas + solución plegables), `Dockerfile`/`docker-compose.yml`, `app/` con código de ejemplo, `.dockerignore`, `solucion/` con la solución y `test.sh` (valida `Dockerfile` con `hadolint` si está disponible o con `grep`/`awk`, valida la estructura del `docker-compose.yml`, y opcionalmente construye/ejecuta si Docker está disponible).

| Nivel | Qué cubre | Enlaces |
|---|---|---|
| Nivel 1 — Fundamentos | primer Dockerfile `FROM alpine`, copiar y ejecutar script, exponer puerto con app Node, variables de entorno, CMD vs ENTRYPOINT, `.dockerignore` | [ejercicios/nivel-01-fundamentos/](ejercicios/nivel-01-fundamentos/) |
| Nivel 2 — Básico | multi-stage build, imagen para app Python, volumen persistente, red entre dos contenedores, Compose básico de 1 servicio, `WORKDIR` y `COPY` | [ejercicios/nivel-02-basico/](ejercicios/nivel-02-basico/) |
| Nivel 3 — Intermedio | Compose con 2 servicios (app+db), `depends_on` y healthcheck, bind mount para desarrollo, red personalizada, multi-stage optimizado, build args y multi-arch | [ejercicios/nivel-03-intermedio/](ejercicios/nivel-03-intermedio/) |
| Nivel 4 — Avanzado | imagen distroless, usuario no root, límites de recursos en Compose, logging driver, Compose con nginx y backend, imagen con healthcheck, override de Compose para dev/prod | [ejercicios/nivel-04-avanzado/](ejercicios/nivel-04-avanzado/) |
| Nivel 5 — Experto | Compose de producción (app+db+cache+proxy), buildx multi-arch, escaneo con Trivy, Docker Swarm service, registry privado, imagen mínima scratch | [ejercicios/nivel-05-experto/](ejercicios/nivel-05-experto/) |

## Proyecto integrador

| Proyecto | Descripción |
|---|---|
| [Proyecto final: Microservicios con Docker Compose](ejercicios/proyectos/) | Despliegue de 3 microservicios (frontend, backend API, base de datos) con Dockerfile multi-stage, Compose de producción con healthchecks, redes aisladas, volúmenes, variables de entorno y secrets, y un proxy nginx delante del frontend |

## Cómo ejecutar un ejercicio

```bash
cd ejercicios/nivel-01-fundamentos/ejercicio-01-primer-dockerfile
bash test.sh        # valida el Dockerfile (.dockerignore, estructura) sin necesidad de ejecutar contenedores
```

## Requisitos previos

- `docker` instalado (`docker --version`) y, si quieres ejecutar contenedores, el daemon `dockerd` activo.
- `docker compose` v2 (`docker compose version`) — incluido en Docker Desktop y en el plugin `docker-compose-plugin`.
- `bash` 4+ (para `set -euo pipefail` y arrays).
- Opcional para validaciones avanzadas: `hadolint` (linter de Dockerfiles), `trivy` (escaneo de imágenes), `jq` (parseo de `docker inspect`).
