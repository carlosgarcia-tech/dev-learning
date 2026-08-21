# Ejercicio 01 — Imagen distroless

- **Nivel:** 4/5
- **Tema:** distroless, multi-stage, superficie de ataque mínima
- **Tiempo estimado:** 40 min

## Enunciado

Crea un `Dockerfile` multi-stage que produzca una imagen **distroless** (sin shell, sin package manager) para una app Node.

1. **Stage `builder`**: `FROM node:20-alpine AS builder`, instala deps y copia el código.
2. **Stage runtime**: `FROM gcr.io/distroless/nodejs20-debian12`, copia `node_modules` y código desde el builder, `USER nonroot`, `CMD ["server.js"]`.

La imagen final **no tiene shell**: no puedes hacer `docker exec sh`. Esa es la idea.

## Requisitos

- [ ] Stage `builder` con `node:20-alpine`
- [ ] Stage runtime con `gcr.io/distroless/nodejs20-debian12`
- [ ] `COPY --from=builder` de `node_modules` y del código
- [ ] `USER nonroot`
- [ ] `CMD ["server.js"]` (en distroless el entrypoint ya es `node`)
- [ ] `WORKDIR /app`
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Las imágenes distroless de Node ya tienen `node` como ENTRYPOINT, así que `CMD ["server.js"]` equivale a `node server.js`.
- `nonroot` es un usuario predefinido en distroless (UID 65532).
- Para depurar (ya que no hay shell) puedes usar la variante `:debug`, que incluye `busybox`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```dockerfile
FROM node:20-alpine AS builder
WORKDIR /app
COPY app/package.json app/package-lock.json ./
RUN npm ci --omit=dev
COPY app/ ./

FROM gcr.io/distroless/nodejs20-debian12
WORKDIR /app
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/server.js ./server.js
USER nonroot
EXPOSE 3000
CMD ["server.js"]
```

</details>
