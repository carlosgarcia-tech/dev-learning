# Proyecto final — Microservicios con Docker Compose

> Despliegue de 3 microservicios (frontend, backend API, base de datos) con Dockerfile multi-stage, Compose de producción con healthchecks, redes aisladas, volúmenes, variables de entorno y secrets, y un proxy nginx delante del frontend.

## Contexto

En este proyecto integrador aplicarás todo lo aprendido de Docker: Dockerfile multi-stage optimizado, Docker Compose con varios servicios, redes aisladas, volúmenes persistentes, healthchecks con condiciones, variables de entorno, gestión de secrets y un reverse proxy nginx.

La aplicación es una mini plataforma de "tareas" con tres microservicios:

- **frontend**: servidor de archivos estáticos (servido por nginx) que llama a la API.
- **backend**: API REST en Node.js que gestiona tareas y habla con la base de datos.
- **db**: PostgreSQL que almacena las tareas.

Y un **proxy** nginx delante de todo que enruta `/` al frontend y `/api` al backend.

```
                    ┌─────────────┐
   usuario ───────▶ │  proxy nginx │ :8080
                    └──────┬───────┘
                           │
              ┌────────────┴────────────┐
              ▼                          ▼
      ┌──────────────┐           ┌──────────────┐
      │  frontend    │           │   backend    │
      │  (nginx)     │           │   (Node)     │
      └──────────────┘           └──────┬───────┘
                                        │
                                        ▼
                                ┌──────────────┐
                                │     db       │
                                │ (Postgres)   │
                                └──────────────┘
```

## Requisitos

- [ ] `docker compose` v2 instalado (`docker compose version`)
- [ ] `docker` daemon activo (`docker info`)
- Opcional: `curl` para probar los endpoints

## Fases del proyecto

### Fase 1 — Backend (Node API)

1. Crea el `Dockerfile` multi-stage del backend en `backend/Dockerfile`:
   - Stage `builder`: `node:20-alpine`, instala deps, copia código.
   - Stage `runtime`: `node:20-alpine`, usuario no root, solo deps de producción + código.
   - `HEALTHCHECK` que consulte `/health`.
2. La API expone: `GET /health`, `GET /api/tasks`, `POST /api/tasks`.
3. Conéctala a la base de datos con las variables de entorno `DB_HOST`, `DB_USER`, `DB_PASSWORD`, `DB_NAME`.

### Fase 2 — Frontend (estáticos + nginx)

1. Crea el `Dockerfile` del frontend en `frontend/Dockerfile`:
   - Stage `builder`: `node:20-alpine`, copia archivos estáticos.
   - Stage `runtime`: `nginx:1.27-alpine`, copia los estáticos a `/usr/share/nginx/html`.
2. El frontend sirve `index.html` que hace `fetch('/api/tasks')` y muestra el resultado.

### Fase 3 — Base de datos (Postgres)

1. Usa la imagen `postgres:16-alpine`.
2. Volumen `db_data` para persistencia.
3. Healthcheck con `pg_isready`.
4. Script de inicialización en `db/init.sql` que crea la tabla `tasks`.

### Fase 4 — Proxy nginx

1. `proxy/nginx.conf` que enruta `/` al `frontend:80` y `/api` al `backend:3000`.
2. Imagen `nginx:1.27-alpine`, publica `8080:80`.

### Fase 5 — Compose de producción

1. `docker-compose.yml` con los 4 servicios.
2. Redes aisladas: `frontend_net` (proxy, frontend, backend) y `backend_net` (backend, db). La BBDD **no** debe estar en `frontend_net`.
3. `depends_on` con `condition: service_healthy` entre servicios.
4. Variables desde `.env`.
5. `restart: always` en todos.

## Criterios de aceptación

- [ ] `docker compose up -d --build` levanta los 4 servicios sin errores.
- [ ] `curl http://localhost:8080/` devuelve el HTML del frontend.
- [ ] `curl http://localhost:8080/api/health` devuelve `{"ok":true}`.
- [ ] `curl -X POST http://localhost:8080/api/tasks -d '{"title":"Test"}' -H 'Content-Type: application/json'` crea una tarea.
- [ ] `curl http://localhost:8080/api/tasks` devuelve la tarea creada.
- [ ] Tras `docker compose down && docker compose up -d`, los datos persisten (por el volumen `db_data`).
- [ ] `docker compose ps` muestra todos los servicios `healthy`.
- [ ] La BBDD no es accesible desde el frontend (aislamiento de red).

## Cómo ejecutar

```bash
# Copia el .env de ejemplo y ajusta los secrets
cp .env.example .env

# Levanta todo
docker compose up -d --build

# Verifica
docker compose ps
curl http://localhost:8080/api/health

# Para y borra (sin tocar volúmenes)
docker compose down

# Para y borra volúmenes (¡pierde datos!)
docker compose down -v
```

## Estructura de archivos

```
proyectos/
├── README.md                 # este archivo
├── .env.example              # variables de entorno de ejemplo
├── docker-compose.yml        # compose de producción (a completar)
├── proxy/
│   └── nginx.conf            # config del reverse proxy (a completar)
├── frontend/
│   ├── Dockerfile            # multi-stage (a completar)
│   └── html/
│       └── index.html        # SPA simple
├── backend/
│   ├── Dockerfile            # multi-stage (a completar)
│   └── src/
│       ├── package.json
│       └── server.js         # API REST
└── db/
    └── init.sql              # esquema inicial
```
