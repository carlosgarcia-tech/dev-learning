# Ejercicio 05 — Multi-stage optimizado

- **Nivel:** 3/5
- **Tema:** multi-stage con cache de dependencias, imagen final mínima
- **Tiempo estimado:** 35 min

## Enunciado

Crea un `Dockerfile` multi-stage **optimizado** para una app Node que:
1. Usa un stage intermedio `deps` para instalar dependencias (cacheable).
2. Un stage `builder` que compila la app (`npm run build`).
3. Un stage final `runtime` basado en `node:20-alpine` que solo copia `dist/` y las deps de producción.
4. Ejecuta como usuario no root.
5. Incluye `HEALTHCHECK`.

1. **Stage `deps`**: `FROM node:20-alpine AS deps`, copia `package*.json`, `npm ci`.
2. **Stage `builder`**: `FROM node:20-alpine AS builder`, copia `deps` y el código, `npm run build` (genera `dist/`).
3. **Stage `runtime`**: `FROM node:20-alpine`, crea usuario, copia `deps/node_modules` (con `--from=deps`), copia `dist` (con `--from=builder`), `USER app`, `HEALTHCHECK`, `CMD`.

## Requisitos

- [ ] Tres stages: `deps`, `builder`, `runtime`
- [ ] `deps` instala dependencias completas (`npm ci`)
- [ ] `builder` ejecuta `npm run build`
- [ ] `runtime` copia `node_modules` con `COPY --from=deps`
- [ ] `runtime` copia `dist` con `COPY --from=builder`
- [ ] `runtime` crea y usa `USER app`
- [ ] `HEALTHCHECK` presente
- [ ] `CMD ["node", "dist/server.js"]`
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Separar `deps` en su propio stage permite reutilizarlo si el `package.json` no cambia.
- `COPY --from=deps /app/node_modules ./node_modules` reutiliza las deps instaladas.
- `--chown=app:app` en el COPY final ajusta permisos en el mismo paso.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```dockerfile
FROM node:20-alpine AS deps
WORKDIR /app
COPY app/package.json app/package-lock.json ./
RUN npm ci

FROM node:20-alpine AS builder
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY app/ ./
RUN npm run build

FROM node:20-alpine
RUN addgroup -S app && adduser -S app -G app
WORKDIR /app
COPY --from=deps --chown=app:app /app/node_modules ./node_modules
COPY --from=builder --chown=app:app /app/dist ./dist
USER app
EXPOSE 3000
HEALTHCHECK --interval=30s --timeout=3s --retries=3 CMD wget -qO- http://localhost:3000/health || exit 1
CMD ["node", "dist/server.js"]
```

</details>
