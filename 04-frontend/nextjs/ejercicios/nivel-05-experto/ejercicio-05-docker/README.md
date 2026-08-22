# Ejercicio 05 — Dockerfile para Next.js

## Enunciado

Crea un `Dockerfile` para un proyecto Next.js con `output: 'standalone'`.

## Requisitos
- Un archivo `Dockerfile`.
- `FROM node:18-alpine`.
- Build con `npm run build`.
- `CMD ["node", "server.js"]`.
- `EXPOSE 3000`.
- Un archivo `next.config.js` con `output: 'standalone'`.
- Los tests pasan: `bash test.sh`

## Solución
<details><summary>Mostrar solución</summary>

**Dockerfile**:
```dockerfile
FROM node:18-alpine AS deps
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci

FROM node:18-alpine AS builder
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .
RUN npm run build

FROM node:18-alpine AS runner
WORKDIR /app
ENV NODE_ENV=production
COPY --from=builder /app/public ./public
COPY --from=builder /app/.next/standalone ./
COPY --from=builder /app/.next/static ./.next/static
EXPOSE 3000
CMD ["node", "server.js"]
```

**next.config.js**:
```js
/** @type {import('next').NextConfig} */
const nextConfig = {
  output: 'standalone'
};
module.exports = nextConfig;
```
</details>
