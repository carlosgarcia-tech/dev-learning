# Proyecto 02: API REST + base de datos

Proyecto integrador de **nivel intermedio**. Construye una API REST completa con Express (Node) o FastAPI (Python), PostgreSQL como base de datos, autenticación JWT, validaciones, tests y Docker.

---

## Contexto

En el Proyecto 01 construiste una CLI con persistencia en JSON. Ahora darás un salto cualitativo: la misma lógica de negocio (gestión de tareas) se expone como una **API HTTP REST**, conectada a una **base de datos relacional real** (PostgreSQL), con **autenticación** (cada usuario tiene sus tareas), **validación** de entradas, **tests** automatizados y todo **dockerizado** para que funcione en cualquier máquina con un comando.

Es el proyecto que más se acerca a cómo se trabaja en el mundo real.

### ¿Qué construirás?

Una API para gestionar tareas de usuarios autenticados:

```bash
# Registro
POST /api/auth/register   { email, password }

# Login → devuelve JWT
POST /api/auth/login      { email, password }   → { token }

# Tareas del usuario autenticado (requiere JWT en Authorization)
GET    /api/tasks          → lista de tareas del usuario
POST   /api/tasks          → crea tarea
GET    /api/tasks/:id      → una tarea
PUT    /api/tasks/:id      → actualiza
DELETE /api/tasks/:id      → borra

# Filtrado por query params
GET /api/tasks?status=pending&priority=high
```

### Stack

Elige **una** opción:

| Opción | Backend | ORM | Validación |
|---|---|---|---|
| **Node.js** | Express | Prisma o Sequelize | Zod o Joi |
| **Python** | FastAPI | SQLAlchemy | Pydantic (integrado en FastAPI) |

- **Base de datos**: PostgreSQL 16.
- **Auth**: JWT (`jsonwebtoken` en Node, `python-jose` o `PyJWT` en Python).
- **Hash de passwords**: `bcrypt`.
- **Tests**: Vitest/Jest (Node) o Pytest (Python).
- **Docker**: Docker Compose para levantar API + DB.

### Tiempo estimado

20-40 horas según experiencia.

---

## Modelo de datos

### Tabla `users`

| Columna | Tipo | Notas |
|---|---|---|
| `id` | SERIAL / UUID | PK |
| `email` | VARCHAR(255) | UNIQUE, NOT NULL |
| `password_hash` | VARCHAR(255) | bcrypt hash, nunca la contraseña en claro |
| `created_at` | TIMESTAMPTZ | default NOW() |

### Tabla `tasks`

| Columna | Tipo | Notas |
|---|---|---|
| `id` | SERIAL / UUID | PK |
| `user_id` | INTEGER / UUID | FK → users.id, ON DELETE CASCADE |
| `title` | VARCHAR(255) | NOT NULL |
| `description` | TEXT | nullable |
| `priority` | VARCHAR(20) | CHECK en `low`, `medium`, `high`; default `medium` |
| `status` | VARCHAR(20) | CHECK en `pending`, `in-progress`, `done`; default `pending` |
| `tags` | TEXT[] o JSON | array de strings |
| `created_at` | TIMESTAMPTZ | default NOW() |
| `completed_at` | TIMESTAMPTZ | nullable |

Relación: un usuario tiene muchas tareas (1:N).

---

## Endpoints

### Autenticación (públicas)

#### `POST /api/auth/register`

```json
// Request
{ "email": "ana@x.com", "password": "secret123" }

// Response 201
{ "id": 1, "email": "ana@x.com" }
```

- Valida email válido y password ≥ 8 caracteres.
- Hashea password con bcrypt.
- Email único → 409 si ya existe.

#### `POST /api/auth/login`

```json
// Request
{ "email": "ana@x.com", "password": "secret123" }

// Response 200
{ "token": "eyJhbGciOi...", "user": { "id": 1, "email": "ana@x.com" } }
```

- Verifica email + password (bcrypt.compare).
- Genera JWT con `{ userId: ... }`, expira en 24h.
- 401 si credenciales inválidas.

### Tareas (protegidas, requieren JWT)

Header obligatorio: `Authorization: Bearer <token>`.

#### `GET /api/tasks`

Query params opcionales: `status`, `priority`, `tag`, `sort`, `page`, `limit`.

```json
// Response 200
{
  "data": [ { "id": 1, "title": "...", ... } ],
  "pagination": { "page": 1, "limit": 20, "total": 45, "pages": 3 }
}
```

- Solo devuelve tareas del usuario autenticado (WHERE user_id = ?).
- 401 si no hay token o es inválido.

#### `POST /api/tasks`

```json
// Request
{ "title": "Comprar pan", "priority": "high", "tags": ["compra"] }

// Response 201
{ "id": 1, "title": "Comprar pan", "priority": "high", "status": "pending", ... }
```

- `title` obligatorio (1-255 chars).
- `priority` validado.
- `user_id` se toma del JWT, no del body.

#### `GET /api/tasks/:id`

- Devuelve la tarea si pertenece al usuario.
- 404 si no existe o es de otro usuario.

#### `PUT /api/tasks/:id`

- Actualiza campos proporcionados.
- Si `status` → `done`, setea `completed_at`.
- 404 si no existe o no es del usuario.

#### `DELETE /api/tasks/:id`

- 204 No Content si borra.
- 404 si no existe o no es del usuario.

---

## Fases del proyecto

### Fase 0: Setup

1. Crea repo git.
2. Crea `docker-compose.yml` con dos servicios: `db` (postgres:16) y `api` (tu app).
3. Variables de entorno en `.env` (y `.env.example` commiteado).
4. `.gitignore` con `node_modules/`, `__pycache__/`, `.env`, `venv/`.
5. Levanta la BD: `docker compose up -d db`.
6. Conéctate con un cliente (psql, DBeaver) para verificar.
7. Commit: "chore: setup docker y postgres".

### Fase 1: Conexión a la base de datos

1. Instala el driver/ORM (Prisma, SQLAlchemy...).
2. Configura la conexión usando `DATABASE_URL` del `.env`.
3. Crea el schema/migraciones para `users` y `tasks`.
4. Ejecuta las migraciones.
5. Verifica con una query de prueba.
6. Commit: "feat: esquema de base de datos y migraciones".

### Fase 2: Modelo User y registro

1. Endpoint `POST /api/auth/register`.
2. Valida email y password (middleware o schema).
3. Hashea password con bcrypt.
4. Inserta en la BD.
5. Maneja email duplicado (409).
6. Commit: "feat: registro de usuarios".

### Fase 3: Login y JWT

1. Endpoint `POST /api/auth/login`.
2. Verifica credenciales con bcrypt.
3. Genera JWT firmado con `JWT_SECRET`.
4. Middleware `authenticate`: lee header, verifica token, añade `req.user`.
5. Protege rutas de tareas con el middleware.
6. Commit: "feat: login con JWT y middleware de auth".

### Fase 4: CRUD de tareas

1. `POST /api/tasks`: crea tarea para el usuario autenticado.
2. `GET /api/tasks`: lista las del usuario.
3. `GET /api/tasks/:id`: una tarea.
4. `PUT /api/tasks/:id`: actualiza.
5. `DELETE /api/tasks/:id`: borra.
6. Todas respetan `user_id` (nunca devuelven tareas ajenas).
7. Commit: "feat: CRUD de tareas".

### Fase 5: Validación y errores

1. Valida el body de cada endpoint (Zod/Pydantic/Joi).
2. Errores 400 con mensajes claros por campo.
3. Manejador de errores centralizado.
4. Errores 404, 401, 403, 409 consistentes.
5. Commit: "feat: validación y manejo de errores".

### Fase 6: Filtros y paginación

1. `GET /api/tasks?status=pending&priority=high&tag=compra`.
2. `?sort=priority|date` y `?order=asc|desc`.
3. Paginación: `?page=1&limit=20`.
4. Devuelve metadata de paginación.
5. Commit: "feat: filtros y paginación en GET /api/tasks".

### Fase 7: Tests

1. Configura el framework de tests.
2. Usa una base de datos de test (otra DB o transacciones que se revierten).
3. Tests de auth: registro, login, token inválido.
4. Tests de tareas: crear, listar, actualizar, borrar.
5. Tests de autorización: usuario A no puede ver tareas de usuario B.
6. Tests de validación: campos inválidos → 400.
7. Commit: "test: suite de tests para auth y tasks".

### Fase 8: Dockerización completa

1. `Dockerfile` multi-stage para la API.
2. `docker-compose.yml` con `db` y `api`.
3. Script de entrada que espera a que la BD esté lista y corre migraciones.
4. `docker compose up` levanta todo.
5. Commit: "feat: dockerización completa con compose".

### Fase 9: Documentación y README

1. Documenta los endpoints (OpenAPI/Swagger o en README).
2. README con: setup, cómo levantar, cómo testear, variables de entorno.
3. Collection de Postman o `requests.http`.
4. Commit: "docs: README y documentación de API".

---

## Estructura del proyecto (Node.js)

```
tasks-api/
├── src/
│   ├── routes/
│   │   ├── auth.routes.js
│   │   └── tasks.routes.js
│   ├── controllers/
│   │   ├── auth.controller.js
│   │   └── tasks.controller.js
│   ├── services/
│   │   ├── auth.service.js
│   │   └── tasks.service.js
│   ├── middleware/
│   │   ├── authenticate.js
│   │   └── errorHandler.js
│   ├── db/
│   │   ├── prisma.js          # o client.js
│   │   └── migrations/
│   ├── schemas/
│   │   ├── auth.schema.js     # Zod
│   │   └── tasks.schema.js
│   ├── utils/
│   │   ├── jwt.js
│   │   └── password.js
│   ├── app.js
│   └── server.js
├── tests/
│   ├── auth.test.js
│   └── tasks.test.js
├── Dockerfile
├── docker-compose.yml
├── .env.example
├── package.json
└── README.md
```

## Estructura del proyecto (Python/FastAPI)

```
tasks-api/
├── app/
│   ├── routers/
│   │   ├── auth.py
│   │   └── tasks.py
│   ├── services/
│   │   ├── auth_service.py
│   │   └── tasks_service.py
│   ├── models/
│   │   └── db.py              # SQLAlchemy
│   ├── schemas/
│   │   ├── auth.py            # Pydantic
│   │   └── tasks.py
│   ├── dependencies/
│   │   └── auth.py            # get_current_user
│   ├── config.py              # settings (pydantic-settings)
│   ├── main.py
│   └── database.py
├── tests/
│   ├── test_auth.py
│   └── test_tasks.py
├── Dockerfile
├── docker-compose.yml
├── .env.example
├── requirements.txt
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
    ports:
      - "5432:5432"
    volumes:
      - pgdata:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U app"]
      interval: 5s
      timeout: 3s
      retries: 5

  api:
    build: .
    environment:
      DATABASE_URL: postgresql://app:secret@db:5432/tasksdb
      JWT_SECRET: cambia-esto-en-produccion
      PORT: 3000
    ports:
      - "3000:3000"
    depends_on:
      db:
        condition: service_healthy

volumes:
  pgdata:
```

---

## Variables de entorno (.env.example)

```env
# Base de datos
DATABASE_URL=postgresql://app:secret@localhost:5432/tasksdb

# JWT
JWT_SECRET=tu-secreto-super-largo-y-aleatorio
JWT_EXPIRES_IN=24h

# App
PORT=3000
NODE_ENV=development
```

---

## Criterios de aceptación

### Autenticación

- [ ] `POST /api/auth/register` crea usuario con password hasheada.
- [ ] Email duplicado → 409.
- [ ] Password < 8 caracteres → 400.
- [ ] `POST /api/auth/login` devuelve JWT válido.
- [ ] Credenciales inválidas → 401.
- [ ] Middleware protege rutas de tareas.
- [ ] Token expirado/inválido → 401.
- [ ] El `user_id` nunca se lee del body, siempre del JWT.

### CRUD de tareas

- [ ] `POST /api/tasks` crea tarea asociada al usuario.
- [ ] `GET /api/tasks` devuelve solo las del usuario.
- [ ] `GET /api/tasks/:id` devuelve 404 si es de otro usuario.
- [ ] `PUT /api/tasks/:id` actualiza y setea `completed_at` al marcar done.
- [ ] `DELETE /api/tasks/:id` borra y devuelve 204.
- [ ] No hay forma de acceder a tareas ajenas.

### Validación

- [ ] Todos los endpoints validan su input.
- [ ] `priority` solo acepta low/medium/high.
- [ ] `status` solo acepta pending/in-progress/done.
- [ ] `title` no vacío y ≤ 255 caracteres.
- [ ] Errores 400 con mensajes por campo.

### Base de datos

- [ ] Esquema con FK `tasks.user_id` → `users.id`.
- [ ] `ON DELETE CASCADE`: borrar usuario borra sus tareas.
- [ ] Constraints CHECK en priority y status.
- [ ] Migraciones versionadas y reproducibles.

### Tests

- [ ] Tests de registro (éxito, duplicado, inválido).
- [ ] Tests de login (éxito, fallo).
- [ ] Tests de CRUD de tareas.
- [ ] Test de autorización (usuario A no ve tareas de B).
- [ ] Tests corren contra BD de test aislada.
- [ ] `npm test` / `pytest` pasa todo en verde.

### Docker

- [ ] `docker compose up` levanta BD + API.
- [ ] La API espera a que la BD esté lista.
- [ ] Las migraciones se ejecutan al arrancar.
- [ ] El contenedor expone el puerto correcto.
- [ ] `docker compose down -v` limpia todo.

### Calidad

- [ ] Código organizado por capas (routes/controllers/services).
- [ ] Sin secretos en el repo (`.env` en `.gitignore`).
- [ ] README claro con instrucciones.
- [ ] Commits por feature.
- [ ] Manejador de errores centralizado.

### Extras (opcionales)

- [ ] Rate limiting en `/api/auth/login`.
- [ ] Refresh tokens además de access tokens.
- [ ] Documentación OpenAPI autogenerada.
- [ ] CI en GitHub Actions que corre tests.
- [ ] Healthcheck endpoint `GET /health`.
- [ ] Logging estructurado.
- [ ] Seeds para datos de prueba.

---

## Ejemplo de flujo con curl

```bash
# Registro
curl -X POST http://localhost:3000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{"email":"ana@x.com","password":"secreto123"}'

# Login
TOKEN=$(curl -s -X POST http://localhost:3000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"ana@x.com","password":"secreto123"}' | jq -r .token)

# Crear tarea
curl -X POST http://localhost:3000/api/tasks \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"title":"Comprar pan","priority":"high"}'

# Listar
curl http://localhost:3000/api/tasks -H "Authorization: Bearer $TOKEN"

# Listar pendientes de prioridad alta
curl "http://localhost:3000/api/tasks?status=pending&priority=high" \
  -H "Authorization: Bearer $TOKEN"
```

---

## Notas pedagógicas

- **Seguridad**: nunca guardes passwords en claro. Nunca commitees `.env`. Usa `JWT_SECRET` largo y aleatorio.
- **Autorización vs autenticación**: autenticar es saber quién eres; autorizar es si puedes hacer X. Aquí un usuario autenticado solo puede tocar SUS tareas.
- **Tests**: el valor de los tests aparece cuando refactorizas. Empieza con pocos, no busques 100% de cobertura de golpe.
- **Docker**: el objetivo es que `docker compose up` funcione en cualquier máquina. Si solo te funciona en la tuya, no termina.

## Próximos pasos

Al terminar este proyecto tendrás una API real, testeada y dockerizada. El [Proyecto 03: App full-stack dockerizada](../project-03/README.md) añade un frontend React, Nginx como reverse proxy y CI/CD.
