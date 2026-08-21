# Ejercicio 14 — Build de Docker image

- **Nivel:** 3/5
- **Tema:** `docker/build-push-action`, `Dockerfile`, login a registry
- **Tiempo estimado:** 25 min

## Enunciado

Crea un workflow en `.github/workflows/docker.yml` y un `Dockerfile` que:

1. El workflow se dispara en `push` a `main`.
2. Tiene un job `build` en `ubuntu-latest`.
3. Usa `actions/checkout@v4`.
4. Usa `docker/setup-buildx-action@v3` para habilitar BuildKit.
5. Usa `docker/build-push-action@v6` para construir la imagen con:
   - `context: .`
   - `push: false` (no publicamos, solo construimos)
   - `tags: app:latest`

Crea también un `Dockerfile` básico que use `node:20-alpine`, copie un `app.js` simple y ejecute `node app.js`.

## Requisitos

- [ ] El archivo existe en `.github/workflows/docker.yml`.
- [ ] El workflow usa `docker/setup-buildx-action@v3`.
- [ ] El workflow usa `docker/build-push-action@v6`.
- [ ] Existe un `Dockerfile` con `FROM node:20-alpine`.
- [ ] El `Dockerfile` tiene `COPY` y `CMD` o `ENTRYPOINT`.
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `docker/setup-buildx-action` prepara BuildKit, que permite caché avanzado y multiplataforma.
- `docker/build-push-action` construye (y opcionalmente publica) la imagen. `push: false` solo construye.
- El `Dockerfile` mínimo necesita `FROM`, `COPY` del código y `CMD` para arrancar.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```dockerfile
# Dockerfile
FROM node:20-alpine
WORKDIR /app
COPY app.js .
CMD ["node", "app.js"]
```

```yaml
# .github/workflows/docker.yml
name: Docker
on:
  push:
    branches: [main]
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: docker/setup-buildx-action@v3
      - uses: docker/build-push-action@v6
        with:
          context: .
          push: false
          tags: app:latest
```

</details>
