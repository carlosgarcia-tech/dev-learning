# TODO: crea tu Dockerfile multi-stage con distroless
# Stage builder: FROM node:20-alpine AS builder, WORKDIR /app, COPY package*.json, npm ci --omit=dev, COPY app/
# Stage runtime: FROM gcr.io/distroless/nodejs20-debian12, WORKDIR /app, COPY --from=builder node_modules y server.js, USER nonroot, CMD ["server.js"]
