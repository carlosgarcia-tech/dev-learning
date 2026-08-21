# App Node que verifica (de forma básica) que la BBDD está lista.
# No usa el driver pg (para no añadir deps); solo comprueba que el host db resuelve y el puerto está abierto.
FROM node:20-alpine
WORKDIR /app
COPY package.json ./
RUN npm ci --omit=dev
COPY . .
ENV DB_HOST=db DB_PORT=5432
EXPOSE 3000
CMD ["node", "server.js"]
