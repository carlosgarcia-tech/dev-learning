# Ejercicio 06 — Build args y multi-arch

- **Nivel:** 3/5
- **Tema:** `ARG`, `--build-arg`, `TARGETPLATFORM`, `buildx` multi-arch
- **Tiempo estimado:** 35 min

## Enunciado

Crea un `Dockerfile` que acepte un `ARG` para la versión de Node y prepare la imagen para multi-arch con `buildx`.

1. `ARG NODE_VERSION=20` al inicio (antes del `FROM`).
2. `FROM node:${NODE_VERSION}-alpine`.
3. Un segundo `ARG APP_VERSION=1.0.0` (después del `FROM`) y un `ENV APP_VERSION=$APP_VERSION`.
4. `WORKDIR /app`, copia y ejecuta `node server.js`.
5. Un `LABEL` con `org.opencontainers.image.version=$APP_VERSION`.
6. (Opcional) Comando `docker buildx build` con `--platform linux/amd64,linux/arm64 --push`.

## Requisitos

- [ ] `ARG NODE_VERSION=20` antes del `FROM`
- [ ] `FROM node:${NODE_VERSION}-alpine`
- [ ] `ARG APP_VERSION=1.0.0` después del `FROM`
- [ ] `ENV APP_VERSION=$APP_VERSION`
- [ ] `LABEL org.opencontainers.image.version`
- [ ] `CMD ["node", "server.js"]`
- [ ] Existe `.dockerignore`
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Un `ARG` antes de `FROM` solo se puede usar en la propia instrucción `FROM`. Para usarlo después, hay que redeclararlo.
- `docker build --build-arg NODE_VERSION=22 .` sobrescribe el valor por defecto.
- `docker buildx build --platform linux/amd64,linux/arm64 -t miuser/app:1.0 .` construye para ambas arquitecturas.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```dockerfile
ARG NODE_VERSION=20
FROM node:${NODE_VERSION}-alpine

ARG APP_VERSION=1.0.0
ENV APP_VERSION=$APP_VERSION
LABEL org.opencontainers.image.version="${APP_VERSION}"

WORKDIR /app
COPY app/package.json ./
RUN npm ci --omit=dev
COPY app/ ./
EXPOSE 3000
CMD ["node", "server.js"]
```

</details>
