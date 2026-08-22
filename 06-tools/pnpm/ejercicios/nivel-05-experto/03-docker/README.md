# 03 — Dockerfile con pnpm

## Enunciado

Crea un Dockerfile multi-stage usando pnpm.

## Requisitos

1. Crea `solucion/Dockerfile`.
2. Usa `corepack enable` en el builder.
3. Copia `package.json` y `pnpm-lock.yaml` antes del código (caché de capas).
4. Instala con `--frozen-lockfile`.
5. En la etapa de producción, instala solo `--prod`.

## Solución

<details>
<summary>Mostrar solución</summary>

```dockerfile
FROM node:20-slim AS builder
RUN corepack enable
WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN pnpm install --frozen-lockfile
COPY . .
RUN pnpm run build

FROM node:20-slim AS production
RUN corepack enable
WORKDIR /app
COPY --from=builder /app/package.json /app/pnpm-lock.yaml ./
COPY --from=builder /app/dist ./dist
RUN pnpm install --frozen-lockfile --prod
CMD ["pnpm", "start"]
```

</details>
