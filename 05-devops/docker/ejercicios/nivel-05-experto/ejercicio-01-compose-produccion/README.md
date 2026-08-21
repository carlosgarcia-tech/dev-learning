# Ejercicio 01 — Compose de producción

- **Nivel:** 5/5
- **Tema:** Compose de producción (app + db + cache + proxy), healthchecks, redes aisladas, volúmenes
- **Tiempo estimado:** 50 min

## Enunciado

Crea un `docker-compose.yml` de producción con 4 servicios: app, db, cache y proxy.

1. **`app`**: `build: ./app`, depende de `db` (service_healthy) y `cache` (service_started), con `healthcheck`, `restart: always`, `mem_limit: 512m`, conectada a `appnet` y `cachenet`.
2. **`db`**: `postgres:16-alpine`, volumen `db_data`, `healthcheck` con `pg_isready`, `restart: always`, conectada solo a `appnet`.
3. **`cache`**: `redis:7-alpine`, volumen `cache_data`, `restart: always`, conectada a `cachenet`.
4. **`proxy`**: `nginx:1.27-alpine`, publica `8101:80`, monta `./nginx/default.conf`, depende de `app` (service_healthy), conectada a `appnet` (donde está `app`).
5. Redes: `appnet` (db, app, proxy) y `cachenet` (app, cache) — la BBDD **no** debe estar en `cachenet` y la caché **no** en `appnet`.
6. Variables de entorno desde `.env`.

## Requisitos

- [ ] 4 servicios: `app`, `db`, `cache`, `proxy`
- [ ] `db` con `healthcheck` (`pg_isready`) y volumen `db_data`
- [ ] `app` con `healthcheck` y `depends_on` con condiciones
- [ ] `cache` (redis) con volumen `cache_data`
- [ ] `proxy` (nginx) publica `8101:80`
- [ ] Redes `appnet` y `cachenet` aisladas correctamente (db no en cachenet, cache no en appnet)
- [ ] Todos con `restart: always`
- [ ] `app` con `mem_limit: 512m`
- [ ] Archivo `.env` con credenciales
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Separa redes para aislar: la caché no necesita ver a la BBDD, y el proxy no necesita ver a la caché.
- `condition: service_healthy` espera healthcheck; `service_started` solo espera arranque.
- `proxy` depende de `app` (service_healthy) para no servir 502 mientras la app arranca.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`docker-compose.yml`:

```yaml
services:
  proxy:
    image: nginx:1.27-alpine
    ports:
      - "8101:80"
    volumes:
      - ./nginx/default.conf:/etc/nginx/conf.d/default.conf:ro
    depends_on:
      app:
        condition: service_healthy
    networks: [appnet]
    restart: always

  app:
    build: ./app
    environment:
      DB_HOST: db
      DB_USER: ${DB_USER}
      DB_PASSWORD: ${DB_PASSWORD}
      DB_NAME: ${DB_NAME}
      REDIS_URL: redis://cache:6379
    depends_on:
      db:
        condition: service_healthy
      cache:
        condition: service_started
    healthcheck:
      test: ["CMD-SHELL", "wget -qO- http://localhost:3000/health || exit 1"]
      interval: 10s
      timeout: 3s
      retries: 5
      start_period: 5s
    mem_limit: 512m
    networks: [appnet, cachenet]
    restart: always

  db:
    image: postgres:16-alpine
    environment:
      POSTGRES_USER: ${DB_USER}
      POSTGRES_PASSWORD: ${DB_PASSWORD}
      POSTGRES_DB: ${DB_NAME}
    volumes:
      - db_data:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U ${DB_USER} -d ${DB_NAME}"]
      interval: 10s
      timeout: 5s
      retries: 5
    networks: [appnet]
    restart: always

  cache:
    image: redis:7-alpine
    volumes:
      - cache_data:/data
    networks: [cachenet]
    restart: always

volumes:
  db_data:
  cache_data:

networks:
  appnet:
  cachenet:
```

</details>
