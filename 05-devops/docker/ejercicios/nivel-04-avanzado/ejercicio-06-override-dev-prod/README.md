# Ejercicio 06 — Override de Compose para dev/prod

- **Nivel:** 4/5
- **Tema:** Compose merge, overrides, `-f`, perfiles para entornos
- **Tiempo estimado:** 40 min

## Enunciado

Crea un `docker-compose.yml` base y dos overrides: uno para desarrollo (`docker-compose.dev.yml`) y uno para producción (`docker-compose.prod.yml`).

1. **Base (`docker-compose.yml`)**: servicio `app` con `build: ./app`, `environment: NODE_ENV=production`, `restart: unless-stopped`, puerto `8100:3000`.
2. **Override dev (`docker-compose.dev.yml`)**: sobrescribe `environment: NODE_ENV=development`, añade un bind mount `./app/src:/app/src`, y cambia el `command` a `node --watch src/server.js`.
3. **Override prod (`docker-compose.prod.yml`)**: añade `mem_limit: 256m`, `cpus: "0.5"`, `read_only: true`, `tmpfs: ["/tmp"]`, y `restart: always`.

Uso: `docker compose -f docker-compose.yml -f docker-compose.dev.yml up -d`.

## Requisitos

- [ ] `docker-compose.yml` base con servicio `app`
- [ ] `docker-compose.dev.yml` con `NODE_ENV=development`
- [ ] `docker-compose.dev.yml` con bind mount `./app/src:/app/src`
- [ ] `docker-compose.dev.yml` con `command` de `node --watch`
- [ ] `docker-compose.prod.yml` con `mem_limit: 256m`
- [ ] `docker-compose.prod.yml` con `cpus: "0.5"`
- [ ] `docker-compose.prod.yml` con `read_only: true`
- [ ] `docker-compose.prod.yml` con `restart: always`
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Compose fusiona los archivos `-f` en orden: el último sobrescribe escalares y fusiona mapas.
- En dev, el bind mount permite editar código en caliente; en prod, `read_only` protege el FS.
- `docker compose -f docker-compose.yml -f docker-compose.prod.yml config` muestra el resultado fusionado.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`docker-compose.yml`:

```yaml
services:
  app:
    build: ./app
    ports:
      - "8100:3000"
    environment:
      NODE_ENV: production
    restart: unless-stopped
```

`docker-compose.dev.yml`:

```yaml
services:
  app:
    environment:
      NODE_ENV: development
    volumes:
      - ./app/src:/app/src
    command: ["node", "--watch", "src/server.js"]
```

`docker-compose.prod.yml`:

```yaml
services:
  app:
    mem_limit: 256m
    cpus: "0.5"
    read_only: true
    tmpfs:
      - /tmp
    restart: always
```

</details>
