# Ejercicio 01 — Multi-stage build

- **Nivel:** 2/5
- **Tema:** multi-stage build, `AS`, `COPY --from`
- **Tiempo estimado:** 30 min

## Enunciado

Crea un `Dockerfile` multi-stage que compile una app Node y produzca una imagen final solo con los artefactos necesarios (sin `node_modules` de dev, sin código fuente extra).

1. **Stage 1 (`builder`)**: `FROM node:20-alpine AS builder`, `WORKDIR /app`, copia `package*.json`, `npm ci`, copia el código y ejecuta `npm run build` (genera `dist/`).
2. **Stage 2 (runtime)**: `FROM node:20-alpine`, `WORKDIR /app`, copia solo `package*.json`, `npm ci --omit=dev`, copia `dist/` desde el builder con `COPY --from=builder /app/dist ./dist`, `CMD ["node", "dist/server.js"]`.

La imagen final debe ser mucho más pequeña que la del builder.

## Requisitos

- [ ] Dos `FROM` con un stage `AS builder`
- [ ] El builder instala dependencias completas (`npm ci`)
- [ ] El runtime instala solo producción (`npm ci --omit=dev`)
- [ ] `COPY --from=builder` copia el artefacto compilado
- [ ] `CMD ["node", "dist/server.js"]`
- [ ] Existe `.dockerignore`
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `FROM ... AS builder` nombra el stage; luego `COPY --from=builder /ruta/origen /ruta/destino` copia desde él.
- El runtime no necesita `src/` ni `node_modules` de dev; solo `dist/` y las deps de producción.
- El script `npm run build` está definido en `package.json` y genera `dist/`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```dockerfile
FROM node:20-alpine AS builder
WORKDIR /app
COPY app/package.json app/package-lock.json ./
RUN npm ci
COPY app/ ./
RUN npm run build

FROM node:20-alpine
WORKDIR /app
COPY app/package.json app/package-lock.json ./
RUN npm ci --omit=dev
COPY --from=builder /app/dist ./dist
EXPOSE 3000
CMD ["node", "dist/server.js"]
```

</details>
