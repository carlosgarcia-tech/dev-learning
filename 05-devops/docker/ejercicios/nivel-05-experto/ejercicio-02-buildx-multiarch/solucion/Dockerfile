FROM --platform=$BUILDPLATFORM node:20-alpine AS builder
WORKDIR /app
COPY app/package.json ./
RUN npm ci --omit=dev
COPY app/ ./

FROM --platform=$TARGETPLATFORM node:20-alpine
ARG TARGETPLATFORM
RUN echo "Construyendo imagen para: ${TARGETPLATFORM}"
WORKDIR /app
COPY --from=builder /app/ ./
EXPOSE 3000
CMD ["node", "server.js"]
