# Ejercicio 03 — Límites de recursos en Compose

- **Nivel:** 4/5
- **Tema:** `mem_limit`, `cpus`, `pids_limit`, límites y reservas
- **Tiempo estimado:** 30 min

## Enunciado

Crea un `docker-compose.yml` que aplique límites de recursos a una app Node.

1. Servicio `app` con `build: ./app`, puerto `8097:3000`.
2. `mem_limit: 256m` y `mem_reservation: 128m`.
3. `cpus: "0.5"` (medio núcleo).
4. `pids_limit: 100`.
5. `restart: on-failure:3`.

## Requisitos

- [ ] Servicio `app` con `build: ./app`
- [ ] `mem_limit: 256m`
- [ ] `mem_reservation: 128m`
- [ ] `cpus: "0.5"` (o equivalente)
- [ ] `pids_limit: 100`
- [ ] `restart: on-failure:3`
- [ ] `app` publica `8097:3000`
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `mem_limit` es el límite duro; si la app lo supera, el OOM killer la mata.
- `mem_reservation` es un soft limit: Docker intenta garantizar al menos esa memoria.
- `cpus: "0.5"` limita a medio núcleo de CPU.
- `pids_limit` evita forks descontrolados (previene fork bombs).

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```yaml
services:
  app:
    build: ./app
    ports:
      - "8097:3000"
    mem_limit: 256m
    mem_reservation: 128m
    cpus: "0.5"
    pids_limit: 100
    restart: "on-failure:3"
```

</details>
