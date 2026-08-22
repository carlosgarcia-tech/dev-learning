# Proyecto 03: App full-stack dockerizada

Proyecto integrador de **nivel avanzado**. Construye una aplicación full-stack completa: frontend en React, backend (Node o Python), base de datos PostgreSQL, todo orquestado con Docker Compose, Nginx como reverse proxy y un pipeline de CI/CD.

---

## Contexto

En el Proyecto 02 construiste una API REST dockerizada con base de datos. Este proyecto lleva la idea a producción: añades un **frontend** que consume esa API, un **reverse proxy** (Nginx) que enruta el tráfico, una arquitectura de **tres contenedores** que se levantan con un comando, y un **pipeline de CI/CD** que ejecuta tests y puede desplegar automáticamente.

Es el proyecto que más se parece a un entorno real: múltiples servicios, redes internas, variables de entorno, build optimizado y despliegue automatizado.

### ¿Qué construirás?

Una app de gestión de tareas con interfaz web:

```
Usuario → Nginx (puerto 80) → Frontend (React, estático)
                           ↘ Backend API (Express/FastAPI)
                                 ↘ PostgreSQL
```

- El usuario abre `http://localhost` en el navegador.
- Nginx sirve el frontend estático (build de React).
- Las llamadas a `/api/*` se redirigen al backend.
- El backend se conecta a PostgreSQL en la red interna.

### Stack

| Capa | Tecnología |
|---|---|
| Frontend | React 18 + Vite + TypeScript |
| Backend | El que usaste en el Proyecto 02 (Express o FastAPI) |
| Base de datos | PostgreSQL 16 |
| Reverse proxy | Nginx |
| Orquestación | Docker Compose |
| CI/CD | GitHub Actions |

Puedes reutilizar y adaptar el backend del Proyecto 02.

### Tiempo estimado

40-80 horas según experiencia.

---

## Arquitectura

```
┌─────────────────────────────────────────────────────┐
│  Host (docker compose)                               │
│                                                      │
│   Puerto 80 ──► Nginx (reverse proxy)                │
│                    │                                 │
│                    ├── /        → frontend (estático)│
│                    └── /api/*   → backend:3000       │
│                                        │             │
│                                        ▼             │
│                                   PostgreSQL:5432     │
│                                        │             │
│                                   volumen pgdata     │
└─────────────────────────────────────────────────────┘
```

### Redes

- `app-net`: red interna donde viven backend y db.
- El frontend no necesita estar en la red de la BD: Nginx lo sirve como estáticos.
- Nginx está en `app-net` (para llegar al backend) y expone el puerto 80 al host.

### Contenedores

| Servicio | Imagen base | Puerto expuesto al host | Puerto interno |
|---|---|---|---|
| `frontend` | nginx:alpine (sirve build) | — | 80 |
| `backend` | node:20-alpine / python:3.12 | — | 3000 |
| `db` | postgres:16-alpine | 5432 (dev) | 5432 |
| `nginx` | nginx:alpine | 80 | 80 |

> En desarrollo expones el puerto de la BD para inspeccionarla. En producción, la BD no se expone.

---

## Requisitos funcionales

### Frontend (React)

- Pantalla de **login** y **registro**.
- Listado de tareas del usuario con filtros (status, priority).
- Formulario para **crear** y **editar** tareas.
- **Borrar** tareas con confirmación.
- Manejo del token JWT (localStorage o memoria).
- Redirección a login si el token expira (401).
- Estados de carga y errores amigables.
- Diseño responsive mínimo (no tiene que ser bonito, pero usable).

### Backend

- Reutiliza la API del Proyecto 02 (auth + tareas).
- CORS configurado para aceptar peticiones desde el frontend.
- Healthcheck endpoint `GET /api/health` → `{ status: "ok" }`.
- Migraciones que se ejecutan al arrancar el contenedor.

### Nginx

- Sirve el build estático de React.
- Redirige `/api/*` al backend.
- Sirve `index.html` para rutas del frontend (SPA fallback).
- Cabeceras básicas de seguridad.

### CI/CD

- En cada push o PR: lint, tests, build de imágenes.
- En main: construir y (opcionalmente) publicar imágenes a un registry.

---

## Fases del proyecto

### Fase 0: Planificación y setup

1. Crea un repo nuevo (o un monorepo con `/frontend`, `/backend`).
2. Decide si backend es Node o Python (reutiliza el del Proyecto 02 si quieres).
3. Estructura de carpetas (ver abajo).
4. `.gitignore` a nivel raíz.
5. Commit: "chore: estructura inicial monorepo".

### Fase 1: Backend

1. Adapta el backend del Proyecto 02:
   - Añade `GET /api/health`.
   - Configura CORS para permitir el origen del frontend (en prod: el propio Nginx).
   - Asegura que lee `DATABASE_URL` y `JWT_SECRET` de variables de entorno.
2. Dockerfile multi-stage del backend.
3. Verifica que arranca con `docker compose up backend db`.
4. Commit: "feat: backend con healthcheck y CORS".

### Fase 2: Frontend - estructura y auth

1. Inicia Vite + React + TypeScript: `npm create vite@latest frontend -- --template react-ts`.
2. Instala un cliente HTTP (fetch nativo o axios).
3. Pantalla de **login** y **registro** que llama a `/api/auth/*`.
4. Guarda el token JWT y lo envía en las peticiones.
5. Redirige a login si recibe 401.
6. Commit: "feat: frontend con login y registro".

### Fase 3: Frontend - CRUD de tareas

1. Pantalla de listado de tareas.
2. Filtros por status y priority.
3. Formulario de creación/edición (modal o página).
4. Botón de borrar con confirmación.
5. Estados de carga y error.
6. Commit: "feat: CRUD de tareas en el frontend".

### Fase 4: Build del frontend

1. Configura Vite para que el build salga a `frontend/dist`.
2. Variable `VITE_API_URL` para apuntar a `/api` en producción.
3. `npm run build` genera estáticos.
4. Commit: "feat: build de producción del frontend".

### Fase 5: Nginx reverse proxy

1. Crea `nginx/nginx.conf`.
2. Sirve estáticos desde `/usr/share/nginx/html`.
3. Proxy de `/api/*` a `http://backend:3000`.
4. SPA fallback: cualquier ruta no encontrada → `index.html`.
5. Dockerfile de Nginx que copia el build de React.
6. Commit: "feat: nginx reverse proxy con SPA fallback".

### Fase 6: Docker Compose completo

1. `docker-compose.yml` con 4 servicios: `db`, `backend`, `frontend`, `nginx`.
2. Red `app-net` para backend y db.
3. El backend depende de la BD (healthcheck).
4. Nginx expone el puerto 80.
5. Volumen para datos de PostgreSQL.
6. `docker compose up --build` levanta todo.
7. Abre `http://localhost` y verifica.
8. Commit: "feat: docker compose con los 4 servicios".

### Fase 7: Migraciones automáticas

1. El backend ejecuta migraciones al arrancar (script de entrypoint).
2. Usa `depends_on` con `service_healthy` para que la BD esté lista.
3. Seed opcional con un usuario de prueba.
4. Commit: "feat: migraciones automáticas al arrancar".

### Fase 8: CI con GitHub Actions

1. Workflow en `.github/workflows/ci.yml`.
2. En cada push/PR a main:
   - Checkout.
   - Setup Node/Python.
   - Instalar dependencias.
   - Lint.
   - Tests del backend.
   - Build del frontend.
3. Verifica que pasa en verde.
4. Commit: "ci: workflow de tests y build".

### Fase 9: CD (opcional)

1. En merge a main: construir imágenes Docker.
2. Publicarlas a un registry (GitHub Container Registry o Docker Hub).
3. (Opcional) Desplegar en un servidor con `docker compose pull && docker compose up -d`.
4. Commit: "cd: publish de imágenes en main".

### Fase 10: README y documentación

1. README con arquitectura, setup, comandos.
2. Diagrama de contenedores.
3. Variables de entorno documentadas.
4. Collection de Postman o `requests.http`.
5. Commit: "docs: README completo".

---

## Estructura del proyecto (monorepo)

```
fullstack-app/
├── frontend/
│   ├── src/
│   │   ├── components/
│   │   ├── pages/
│   │   ├── api/            # cliente HTTP
│   │   ├── hooks/
│   │   ├── context/        # AuthContext
│   │   └── App.tsx
│   ├── nginx/
│   │   └── default.conf    # config de Nginx para servir el build
│   ├── public/
│   ├── Dockerfile          # multi-stage: build + nginx
│   ├── package.json
│   ├── tsconfig.json
│   └── vite.config.ts
├── backend/
│   ├── src/
│   │   ├── routes/
│   │   ├── controllers/
│   │   ├── services/
│   │   ├── middleware/
│   │   ├── db/
│   │   └── server.js
│   ├── Dockerfile
│   ├── package.json
│   └── .env.example
├── nginx/
│   ├── nginx.conf          # reverse proxy principal
│   └── Dockerfile
├── .github/
│   └── workflows/
│       └── ci.yml
├── docker-compose.yml
├── docker-compose.prod.yml  # (opcional) overrides de producción
├── .env.example
├── .gitignore
└── README.md
```

---

## docker-compose.yml de referencia

```yaml
services:
  db:
    image: postgres:16-alpine
    environment:
      POSTGRES_USER: app
      POSTGRES_PASSWORD: secret
      POSTGRES_DB: tasksdb
    volumes:
      - pgdata:/var/lib/postgresql/data
    networks:
      - app-net
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U app"]
      interval: 5s
      timeout: 3s
      retries: 5

  backend:
    build: ./backend
    environment:
      DATABASE_URL: postgresql://app:secret@db:5432/tasksdb
      JWT_SECRET: cambia-esto-en-produccion
      PORT: 3000
      NODE_ENV: production
    depends_on:
      db:
        condition: service_healthy
    networks:
      - app-net
    restart: unless-stopped

  frontend:
    build: ./frontend
    networks:
      - app-net
    restart: unless-stopped

  nginx:
    image: nginx:alpine
    volumes:
      - ./nginx/nginx.conf:/etc/nginx/nginx.conf:ro
    ports:
      - "80:80"
    depends_on:
      - backend
      - frontend
    networks:
      - app-net
    restart: unless-stopped

networks:
  app-net:
    driver: bridge

volumes:
  pgdata:
```

---

## nginx/nginx.conf de referencia

```nginx
events {
    worker_connections 1024;
}

http {
    upstream backend {
        server backend:3000;
    }

    server {
        listen 80;
        server_name localhost;

        # API → backend
        location /api/ {
            proxy_pass http://backend;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
        }

        # Frontend estático
        location / {
            proxy_pass http://frontend;
            proxy_set_header Host $host;
        }
    }
}
```

> Alternativa: que Nginx sirva directamente los estáticos desde un volumen con el build, en vez de a través del contenedor `frontend`.

### frontend/Dockerfile (multi-stage)

```dockerfile
# Stage 1: build
FROM node:20-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# Stage 2: servir con nginx
FROM nginx:alpine
COPY --from=build /app/dist /usr/share/nginx/html
COPY nginx/default.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

### frontend/nginx/default.conf

```nginx
server {
    listen 80;
    root /usr/share/nginx/html;
    index index.html;

    # SPA fallback: cualquier ruta sirve index.html
    location / {
        try_files $uri $uri/ /index.html;
    }
}
```

---

## .github/workflows/ci.yml de referencia

```yaml
name: CI

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  backend:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: 20
          cache: npm
          cache-dependency-path: backend/package-lock.json
      - run: npm ci
        working-directory: backend
      - run: npm run lint
        working-directory: backend
      - run: npm test
        working-directory: backend

  frontend:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: 20
          cache: npm
          cache-dependency-path: frontend/package-lock.json
      - run: npm ci
        working-directory: frontend
      - run: npm run lint
        working-directory: frontend
      - run: npm run build
        working-directory: frontend
```

---

## Variables de entorno (.env.example)

```env
# Base de datos
POSTGRES_USER=app
POSTGRES_PASSWORD=secret
POSTGRES_DB=tasksdb
DATABASE_URL=postgresql://app:secret@db:5432/tasksdb

# Backend
JWT_SECRET=tu-secreto-super-largo-y-aleatorio
PORT=3000

# Frontend (Vite usa el prefijo VITE_)
VITE_API_URL=/api
```

---

## Criterios de aceptación

### Frontend

- [ ] Pantalla de login funcional.
- [ ] Pantalla de registro funcional.
- [ ] Token JWT se guarda y se envía en peticiones autenticadas.
- [ ] Listado de tareas del usuario.
- [ ] Crear, editar y borrar tareas.
- [ ] Filtros por status y priority.
- [ ] Manejo de errores de API (401 → redirige a login).
- [ ] Estados de carga (spinners o mensajes).
- [ ] Responsive mínimo.
- [ ] Build de producción funciona (`npm run build`).

### Backend

- [ ] API del Proyecto 02 adaptada y funcionando.
- [ ] `GET /api/health` devuelve `{ status: "ok" }`.
- [ ] CORS configurado.
- [ ] Migraciones se ejecutan al arrancar.
- [ ] Variables de entorno documentadas y usadas.

### Nginx

- [ ] Sirve el frontend en `/`.
- [ ] Redirige `/api/*` al backend.
- [ ] SPA fallback (rutas del frontend cargan index.html).
- [ ] Cabeceras de proxy correctamente configuradas.

### Docker Compose

- [ ] `docker compose up --build` levanta los 4 servicios.
- [ ] La app responde en `http://localhost`.
- [ ] La BD persiste datos en un volumen.
- [ ] El backend espera a que la BD esté lista (healthcheck).
- [ ] `docker compose down -v` limpia todo.
- [ ] No hay secretos commiteados.

### CI/CD

- [ ] Workflow corre en cada push/PR.
- [ ] Tests del backend pasan.
- [ ] Build del frontend pasa.
- [ ] Lint pasa en ambos.
- [ ] (Opcional) Imágenes se publican en merge a main.

### Calidad

- [ ] Commits por feature, mensajes descriptivos.
- [ ] README con arquitectura, setup y comandos.
- [ ] Código organizado por capas.
- [ ] `.env.example` commiteado, `.env` ignorado.
- [ ] No hay datos sensibles en el repo.

### Extras (opcionales)

- [ ] HTTPS con certificados self-signed.
- [ ] Rate limiting en Nginx.
- [ ] Compresión gzip en Nginx.
- [ ] Caché de estáticos.
- [ ] Logging estructurado en backend.
- [ ] Monitoring con Prometheus + Grafana.
- [ ] Despliegue en un VPS real (DigitalOcean, Hetzner...).
- [ ] Dominio real con Let's Encrypt.
- [ ] Docker Swarm o Kubernetes (siguiente nivel).

---

## Verificación final

```bash
# 1. Levantar todo
docker compose up --build -d

# 2. Verificar servicios
docker compose ps
# 4 servicios "running"

# 3. Health del backend
curl http://localhost/api/health
# {"status":"ok"}

# 4. Registrar usuario
curl -X POST http://localhost/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{"email":"ana@x.com","password":"secreto123"}'

# 5. Abrir en el navegador
# http://localhost → debe cargar el frontend React
# Login con ana@x.com / secreto123 → debe entrar y ver las tareas
```

Si todo lo anterior funciona, el proyecto está completo.

---

## Notas pedagógicas

- **Reutiliza el backend del Proyecto 02**: no reescribas desde cero. Adáptalo.
- **El frontend no necesita ser bonito**: el reto está en la integración, no en CSS. Un diseño mínimo usable es suficiente.
- **Nginx es la pieza clave**: entiende bien cómo enruta. Si algo no carga, suele ser configuración de Nginx.
- **CI/CD empieza simple**: un workflow que corre tests ya es valioso. El despliegue automático es el siguiente paso, no el primero.
- **No expongas la BD en producción**: el puerto 5432 solo debe estar abierto en desarrollo para inspeccionar.

## Próximos pasos

Al terminar este proyecto tendrás una aplicación full-stack real, dockerizada y con CI/CD. Los siguientes retos naturales son:

- **Kubernetes**: migrar de Docker Compose a K8s.
- **Observabilidad**: añadir logs centralizados, métricas y tracing.
- **Escalado**: múltiples réplicas del backend tras un load balancer.
- **Dominio real**: desplegar en un VPS con HTTPS.
