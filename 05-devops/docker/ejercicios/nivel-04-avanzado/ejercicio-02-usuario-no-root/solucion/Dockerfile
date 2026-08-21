FROM node:20-alpine
RUN addgroup -S -g 10001 app && adduser -S -D -H -u 10001 -G app app
WORKDIR /app
COPY --chown=app:app app/package.json ./
RUN npm ci --omit=dev
COPY --chown=app:app app/ ./
USER app
EXPOSE 3000
CMD ["node", "server.js"]
