# Ejercicio 02 — buildx multi-arch

- **Nivel:** 5/5
- **Tema:** `docker buildx`, `--platform`, manifest list, `TARGETPLATFORM`
- **Tiempo estimado:** 40 min

## Enunciado

Crea un `Dockerfile` preparado para multi-arch y un script `build.sh` que use `buildx` para construir para `linux/amd64` y `linux/arm64`.

1. `Dockerfile` con `FROM --platform=$BUILDPLATFORM node:20-alpine AS builder` (construye en la plataforma del host) y `FROM --platform=$TARGETPLATFORM node:20-alpine` (runtime).
2. Un `ARG TARGETPLATFORM` en el runtime e imprime la plataforma destino con `RUN echo $TARGETPLATFORM`.
3. `build.sh` que ejecute `docker buildx build --platform linux/amd64,linux/arm64 -t miuser/app:multiarch .`.

## Requisitos

- [ ] `Dockerfile` con `--platform=$BUILDPLATFORM` en el builder
- [ ] `Dockerfile` con `--platform=$TARGETPLATFORM` en el runtime
- [ ] `ARG TARGETPLATFORM` presente
- [ ] `build.sh` con `docker buildx build --platform linux/amd64,linux/arm64`
- [ ] Existe `.dockerignore`
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `$BUILDPLATFORM` es la plataforma donde corre el build (el host); `$TARGETPLATFORM` es la plataforma destino de la imagen.
- buildx expone automáticamente `TARGETPLATFORM`, `TARGETOS`, `TARGETARCH`, `TARGETVARIANT`.
- Para multi-arch en CI necesitas QEMU (`docker/setup-qemu-action`).

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`Dockerfile`:

```dockerfile
FROM --platform=$BUILDPLATFORM node:20-alpine AS builder
WORKDIR /app
COPY app/package.json ./
RUN npm ci --omit=dev
COPY app/ ./

FROM --platform=$TARGETPLATFORM node:20-alpine
ARG TARGETPLATFORM
RUN echo "Construyendo imagen para: ${TARGETPLATFORM}"
WORKDIR /app
COPY --from=builder /app/ ./
EXPOSE 3000
CMD ["node", "server.js"]
```

`build.sh`:

```bash
#!/usr/bin/env bash
set -euo pipefail
docker buildx build \
  --platform linux/amd64,linux/arm64 \
  -t miuser/app:multiarch \
  .
```

</details>
