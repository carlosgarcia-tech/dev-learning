FROM node:20-alpine
WORKDIR /app
COPY app/package.json ./
RUN npm ci --omit=dev
COPY app/ ./
VOLUME ["/app/data"]
EXPOSE 3000
CMD ["node", "server.js"]
