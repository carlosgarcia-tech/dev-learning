# Ejercicio 01 — Compose con 2 servicios (app + db)

- **Nivel:** 3/5
- **Tema:** Compose multi-servicio, red de usuario, BBDD
- **Tiempo estimado:** 35 min

## Enunciado

Crea un `docker-compose.yml` con dos servicios: una app Node (`app`) y una base de datos PostgreSQL (`db`), conectados por una red de usuario.

1. **`db`**: imagen `postgres:16-alpine`, con variables de entorno `POSTGRES_USER`, `POSTGRES_PASSWORD`, `POSTGRES_DB`, un volumen `db_data` para persistir, y un `healthcheck` con `pg_isready`.
2. **`app`**: se construye con `build: ./app`, depende de `db` con `condition: service_healthy`, se conecta a la red de usuario, y recibe las credenciales por variables de entorno.
3. Red `appnet` definida en top-level.
4. Volumen `db_data` definido en top-level.
5. `app` publica `8091:3000`.

## Requisitos

- [ ] `docker-compose.yml` con servicios `app` y `db`
- [ ] `db` usa `postgres:16-alpine`
- [ ] `db` tiene `healthcheck` con `pg_isready`
- [ ] `db` monta el volumen `db_data` en `/var/lib/postgresql/data`
- [ ] `app` tiene `depends_on: db: condition: service_healthy`
- [ ] Red `appnet` y volumen `db_data` definidos en top-level
- [ ] `app` publica `8091:3000`
- [ ] `app` recibe credenciales por `environment`
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `pg_isready -U <user> -d <db>` devuelve 0 cuando Postgres acepta conexiones.
- `depends_on` con `condition: service_healthy` hace que `app` espere hasta que `db` esté "healthy".
- Las credenciales en `app` y `db` deben coincidir (`POSTGRES_USER`, `POSTGRES_PASSWORD`, `POSTGRES_DB`).

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`docker-compose.yml`:

```yaml
services:
  app:
    build: ./app
    environment:
      DB_HOST: db
      DB_USER: app
      DB_PASSWORD: ${DB_PASSWORD}
      DB_NAME: miapp
    depends_on:
      db:
        condition: service_healthy
    ports:
      - "8091:3000"
    networks: [appnet]

  db:
    image: postgres:16-alpine
    environment:
      POSTGRES_USER: app
      POSTGRES_PASSWORD: ${DB_PASSWORD}
      POSTGRES_DB: miapp
    volumes:
      - db_data:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U app -d miapp"]
      interval: 10s
      timeout: 5s
      retries: 5
      start_period: 10s
    networks: [appnet]

volumes:
  db_data:

networks:
  appnet:
```

</details>
