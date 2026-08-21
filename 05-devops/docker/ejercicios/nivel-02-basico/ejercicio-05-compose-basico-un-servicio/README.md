# Ejercicio 05 — Compose básico de 1 servicio

- **Nivel:** 2/5
- **Tema:** `docker-compose.yml`, `build`, `ports`, `volumes`, `.env`
- **Tiempo estimado:** 25 min

## Enunciado

Crea un `docker-compose.yml` que levante un único servicio web a partir del `Dockerfile` de la carpeta, con puerto y variable de entorno desde `.env`.

1. Un servicio `web` que hace `build: .` (usa el Dockerfile del directorio).
2. Publica el puerto `${WEB_PORT:-8080}:3000`.
3. Pasa la variable de entorno `NODE_ENV=production`.
4. Reinicio `unless-stopped`.
5. Define un `.env` con `WEB_PORT=8080`.

## Requisitos

- [ ] `docker-compose.yml` con un servicio `web`
- [ ] `web` usa `build: .`
- [ ] `web` publica el puerto con `${WEB_PORT:-8080}:3000`
- [ ] `web` tiene `environment: NODE_ENV=production`
- [ ] `web` tiene `restart: unless-stopped`
- [ ] Existe `.env` con `WEB_PORT=8080`
- [ ] Existe `Dockerfile` válido
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `build: .` construye usando el `Dockerfile` del directorio actual como contexto.
- `${WEB_PORT:-8080}` toma el valor de `.env` y, si no está, usa 8080 por defecto.
- Compose lee automáticamente el archivo `.env` del mismo directorio.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`docker-compose.yml`:

```yaml
services:
  web:
    build: .
    ports:
      - "${WEB_PORT:-8080}:3000"
    environment:
      NODE_ENV: production
    restart: unless-stopped
```

`Dockerfile`:

```dockerfile
FROM node:20-alpine
WORKDIR /app
COPY app/package.json ./
RUN npm ci --omit=dev
COPY app/ ./
EXPOSE 3000
CMD ["node", "server.js"]
```

</details>
