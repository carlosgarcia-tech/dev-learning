# TODO: crea tu Dockerfile multi-stage optimizado
# Stage deps: FROM node:20-alpine AS deps, COPY package*.json, npm ci
# Stage builder: FROM node:20-alpine AS builder, COPY --from=deps node_modules, COPY app, npm run build
# Stage runtime: FROM node:20-alpine, addgroup/adduser, COPY --from=deps node_modules, COPY --from=builder dist, USER app, HEALTHCHECK, CMD ["node","dist/server.js"]
