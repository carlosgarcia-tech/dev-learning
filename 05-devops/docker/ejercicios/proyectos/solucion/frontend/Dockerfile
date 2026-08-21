FROM node:20-alpine AS builder
WORKDIR /app
COPY html/ ./html/

FROM nginx:1.27-alpine
COPY --from=builder /app/html/ /usr/share/nginx/html/
HEALTHCHECK --interval=30s --timeout=3s --retries=3 CMD wget -qO- http://localhost/ || exit 1
