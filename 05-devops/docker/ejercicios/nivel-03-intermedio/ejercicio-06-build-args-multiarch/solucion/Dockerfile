ARG NODE_VERSION=20
FROM node:${NODE_VERSION}-alpine

ARG APP_VERSION=1.0.0
ENV APP_VERSION=$APP_VERSION
LABEL org.opencontainers.image.version="${APP_VERSION}"

WORKDIR /app
COPY app/package.json ./
RUN npm ci --omit=dev
COPY app/ ./
EXPOSE 3000
CMD ["node", "server.js"]
