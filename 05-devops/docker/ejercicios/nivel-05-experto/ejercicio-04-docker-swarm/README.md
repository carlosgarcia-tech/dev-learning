# Ejercicio 04 — Docker Swarm service

- **Nivel:** 5/5
- **Tema:** Swarm, `docker service`, réplicas, `deploy:`, rolling updates
- **Tiempo estimado:** 40 min

## Enunciado

Crea un `docker-compose.yml` con la sección `deploy:` lista para Swarm y un script `deploy.sh` que despliegue el stack.

1. `docker-compose.yml` con servicio `web` (build `./app`), `deploy.replicas: 3`, `deploy.update_config.parallelism: 1`, `deploy.update_config.delay: 10s`, `deploy.restart_policy.condition: on-failure`, `deploy.resources.limits.memory: 256M`, `deploy.resources.limits.cpus: "0.5"`.
2. `deploy.sh`: ejecuta `docker swarm init` (si no está activo) y `docker stack deploy -c docker-compose.yml miapp`.
3. Puerto `8102:3000`.

> Nota: Swarm no construye imágenes (`build:` se ignora en `stack deploy`). El script `deploy.sh` debe construir y etiquetar la imagen antes del deploy, y el compose debe usar `image:` en lugar de (o además de) `build:`.

## Requisitos

- [ ] `docker-compose.yml` con sección `deploy:`
- [ ] `deploy.replicas: 3`
- [ ] `deploy.update_config` con `parallelism` y `delay`
- [ ] `deploy.restart_policy` con `condition: on-failure`
- [ ] `deploy.resources.limits` con `memory` y `cpus`
- [ ] `deploy.sh` con `docker stack deploy`
- [ ] `deploy.sh` construye la imagen antes del deploy
- [ ] Puerto `8102:3000`
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `docker stack deploy` ignora `build:`; necesitas `image:` y construir+etiquetar antes.
- `deploy:` solo se aplica en Swarm (no en `docker compose up` standalone).
- `docker service ls` y `docker service ps <service>` muestran el estado de las réplicas.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`docker-compose.yml`:

```yaml
services:
  web:
    image: miapp:swarm
    build: ./app
    ports:
      - "8102:3000"
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
```

`deploy.sh`:

```bash
#!/usr/bin/env bash
set -euo pipefail
docker build -t miapp:swarm ./app
docker swarm init 2>/dev/null || true
docker stack deploy -c docker-compose.yml miapp
```

</details>
