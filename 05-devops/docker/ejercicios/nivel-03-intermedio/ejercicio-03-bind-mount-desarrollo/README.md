# Ejercicio 03 — Bind mount para desarrollo

- **Nivel:** 3/5
- **Tema:** bind mounts, hot reload en desarrollo, `docker compose watch`
- **Tiempo estimado:** 30 min

## Enunciado

Crea un `docker-compose.yml` orientado a **desarrollo**: la app Node monta el código fuente del host con un bind mount y reinicia el proceso cuando cambian los archivos.

1. **`app`**: `build: ./app`, publica `8093:3000`.
2. Monta el directorio `./app/src` del host en `/app/src` del contenedor (bind mount).
3. Monta `./app/node_modules:/app/node_modules` (para no pisar los del host).
4. Sobrescribe el `command` para usar `node --watch src/server.js` (hot reload de Node 20+).
5. `environment: NODE_ENV=development`.

## Requisitos

- [ ] `docker-compose.yml` con servicio `app`
- [ ] `app` publica `8093:3000`
- [ ] Bind mount `./app/src:/app/src`
- [ ] Bind mount `./app/node_modules:/app/node_modules` (o volumen anónimo `/app/node_modules`)
- [ ] `command` sobrescrito con `node --watch`
- [ ] `environment: NODE_ENV=development`
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- En desarrollo, montas el código del host para que los cambios se reflejen sin reconstruir.
- `node --watch server.js` reinicia el proceso al detectar cambios (Node 18.11+ / estable en 20).
- Montar `node_modules` por separado evita que el del host (distinto OS) pise el del contenedor.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`docker-compose.yml`:

```yaml
services:
  app:
    build: ./app
    ports:
      - "8093:3000"
    volumes:
      - ./app/src:/app/src
      - /app/node_modules
    environment:
      NODE_ENV: development
    command: ["node", "--watch", "src/server.js"]
```

</details>
