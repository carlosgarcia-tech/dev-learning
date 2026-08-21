# TODO: crea tu Dockerfile multi-stage
# Stage 1: FROM node:20-alpine AS builder
#   WORKDIR /app, COPY package*.json, npm ci, COPY app/, npm run build
# Stage 2: FROM node:20-alpine
#   WORKDIR /app, COPY package*.json, npm ci --omit=dev, COPY --from=builder /app/dist ./dist, CMD ["node","dist/server.js"]
