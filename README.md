# dev-learning

Repo personal para aprender programación **de 0 a experto**: guías, apuntes, ejercicios por niveles (1–5) y proyectos. Todo el contenido está en español en la raíz del repo (la capa `es/` se aplanó).

Personal repo to learn programming **from 0 to expert**: guides, notes, leveled exercises (1–5) and projects. Content lives at the repo root (the `es/` layer was flattened).

---

## Índice / Index

| Sección | Descripción |
|---|---|
| [00-roadmap](00-roadmap/roadmap.md) | Hoja de ruta completa de 0 a experto |
| [01-programming](01-programming/) | Lenguajes: JS, TS, Python, Java, Rust, Go, C#, PHP, Ruby, Kotlin |
| [02-databases](02-databases/) | SQL, PostgreSQL, MySQL, MongoDB, Redis |
| [03-backend](03-backend/) | HTTP, REST, GraphQL, Auth, Arquitectura |
| [04-frontend](04-frontend/) | HTML, CSS, JS, React, Next.js |
| [05-devops](05-devops/) | Linux, Git, Docker, K8s, Nginx, CI/CD |
| [06-tools](06-tools/) | npm, pnpm, VSCode, opencode, terminal |
| [07-concepts](07-concepts/) | Redes, SO, estructuras de datos, algoritmos, system design |
| [08-projects](08-projects/) | Proyectos integradores |
| [09-cheatsheets](09-cheatsheets/) | Chuletas rápidas |
| [10-errors](10-errors/) | Errores comunes y cómo resolverlos |
| [resources](resources/) | Libros, cursos, webs, repos útiles |

## Cómo funciona / How it works

Cada **tema** sigue la misma estructura:

```
tema/
├── README.md              # índice del tema
├── *.md                   # guías de estudio
└── ejercicios/
    ├── README.md          # índice de niveles
    ├── nivel-01-fundamentos/
    ├── nivel-02-basico/
    ├── nivel-03-intermedio/
    ├── nivel-04-avanzado/
    ├── nivel-05-experto/
    └── proyectos/         # retos integradores
```

Cada **ejercicio** contiene: enunciado, requisitos (checklist), pistas plegables y **solución al final** (también plegable). En los lenguajes reestructurados (C#, Go, Java, TypeScript, Python) cada ejercicio es una **carpeta** con su `README.md`, un stub (`Program.cs`/`Main.java`/`main.go`/`index.ts`/`main.py`), su runner de tests y la configuración de build (`*.csproj`, `go.mod`, `tsconfig`, `test_main.py`). En bases de datos, SQL y Redis usan carpetas con enunciado + schema/setup + solución + `test.sh` que verifica la salida (SQLite/redis-cli con podman). En DevOps, Backend y las nuevas bases de datos (PostgreSQL, MySQL, MongoDB) cada ejercicio incluye `test.sh` que valida la sintaxis y estructura.

## Niveles de dificultad / Difficulty levels

| Nivel | Qué dominas al terminar |
|---|---|
| 1 Fundamentos | Sintaxis, tipos, variables, salida |
| 2 Básico | Control de flujo, funciones, estructuras |
| 3 Intermedio | Composición, errores, patrones simples |
| 4 Avanzado | Asincronía, concurrencia, optimización |
| 5 Experto | Diseño y sistemas completos |

## Estado por lenguaje

| Lenguaje | Guías | Ejercicios | Proyecto final | Notas |
|---|---|---|---|---|
| [C#](01-programming/csharp/) | 6 | 30 (carpetas) | ✅ | POO, LINQ, async/await, ASP.NET Core (Minimal APIs) |
| [Go](01-programming/go/) | 5 | 30 (carpetas) | ✅ | Structs, interfaces, concurrencia, genéricos, testing, proyecto final |
| [Java](01-programming/java/) | 6 | 30 (carpetas) | ✅ | POO, streams, concurrencia, Spring Boot |
| [TypeScript](01-programming/typescript/) | 6 | 30 (carpetas) | ✅ | Tipos, generics, async, Express |
| [JavaScript](01-programming/javascript/) | 6 | 30 (carpetas) | ✅ | Fundamentos, async/await, Node.js + Express, proyecto final MiTienda |
| [PHP](01-programming/php/) | 6 | 30 (carpetas) | ✅ | Fundamentos, OOP, PDO, Composer, Laravel, proyecto final de blog |
| [Ruby](01-programming/ruby/) | 6 | 30 (carpetas) | ✅ | Fundamentos, POO, metaprogramación, Rails, proyecto final de blog |
| [Python](01-programming/python/) | 6 | 30 (carpetas) | ✅ | Funciones, estructuras, asyncio, FastAPI/Django/Flask, proyecto final con FastAPI |
| [Rust](01-programming/rust/) | 6 | 30 (carpetas) | ✅ | Ownership, traits, concurrencia, Axum/Actix, testing, proyecto final |
| Kotlin | — | — | — | Solo esqueleto de niveles |

## Estado por sección

### Bases de datos

| Base de datos | Guías | Ejercicios | test.sh | Proyecto final | Estado |
|---|---|---|---|---|---|
| [SQL](02-databases/sql/) | 6 | 30 | ✅ | ✅ | Completo (SQLite) |
| [Redis](02-databases/redis/) | 5 | 30 | ✅ | ✅ | Completo (redis-cli/podman) |
| [PostgreSQL](02-databases/postgresql/) | 6 | 30 | 30 | ✅ | Completo (psql) |
| [MongoDB](02-databases/mongodb/) | 5 | 30 | 31 | ✅ | Completo (mongosh) |
| [MySQL](02-databases/mysql/) | 5 | 30 | 31 | ✅ | Completo (mysql/sqlite fallback) |

### Backend

| Tema | Guías | Ejercicios | test.sh | Proyecto final |
|---|---|---|---|---|
| [HTTP](03-backend/http/) | 5 | 30 | 31 | ✅ Servidor HTTP desde cero en Node.js |
| [REST](03-backend/rest/) | 5 | 30 | 31 | ✅ API REST completa |
| [GraphQL](03-backend/graphql/) | 5 | 30 | 31 | ✅ API GraphQL de red social |
| [Authentication](03-backend/authentication/) | 5 | 30 | 31 | ✅ Sistema de auth completo |
| [Architecture](03-backend/architecture/) | 5 | 30 | 31 | ✅ E-commerce arquitectónico |

### DevOps

| Tema | Guías | Ejercicios | test.sh | Proyecto final |
|---|---|---|---|---|
| [Linux](05-devops/linux/) | 5 | 30 | ✅ | ✅ Monitorización y backups |
| [Git](05-devops/git/) | 5 | 30 | ✅ | ✅ Git Flow + hooks + CI |
| [Docker](05-devops/docker/) | 5 | 30 | ✅ | ✅ Microservicios con Compose |
| [Kubernetes](05-devops/kubernetes/) | 5 | 30 | ✅ | ✅ Microservicios en K8s |
| [Nginx](05-devops/nginx/) | 5 | 30 | ✅ | ✅ Reverse proxy de producción |
| [CI/CD](05-devops/ci-cd/) | 5 | 30 | ✅ | ✅ Pipeline completo CI/CD |

## Estado actual / Current status

- [x] Estructura completa aplanada en la raíz
- [x] Fase 1: JavaScript y SQL (guías + 5 niveles de ejercicios)
- [x] Lenguajes completos con 30 ejercicios: C#, Go, Java, TypeScript, Python, PHP, Rust, Ruby
- [x] Bases de datos completas: SQL, Redis, PostgreSQL, MySQL, MongoDB
- [x] Backend completo: HTTP, REST, GraphQL, Authentication, Architecture
- [x] DevOps completo: Linux, Git, Docker, Kubernetes, Nginx, CI/CD
- [ ] Frontend (HTML, CSS, JS, React, Next.js)
- [ ] Herramientas, conceptos, cheatsheets, errores, recursos
- [ ] Kotlin: rellenar guías y ejercicios

## Scripts

Todos los scripts se ejecutan desde cualquier directorio (resuelven la raíz del repo desde su propia ubicación). Los scripts por lenguaje toman `<nivel> <numero> <slug>`.

```bash
# Esqueleto y scaffolding genérico
scripts/init.sh                                              # regenera el esqueleto completo (no sobrescribe)
scripts/new-topic.sh 02-databases/dynamodb                    # nuevo tema con ejercicios
scripts/new-guide.sh 01-programming/python oop               # nueva guía de estudio
scripts/new-exercise.sh 01-programming/javascript 1 variables-y-tipos  # ejercicio autodetectando el lenguaje

# Ejercicios por lenguaje: <nivel> <numero> <slug>
scripts/new-exercise-go.sh nivel-01-fundamentos 07 hola-mundo
scripts/new-exercise-javascript.sh nivel-01-fundamentos 07 hola-mundo
scripts/new-exercise-typescript.sh nivel-01-fundamentos 07 hola-mundo
scripts/new-exercise-python.sh nivel-01-fundamentos 07 hola-mundo
scripts/new-exercise-rust.sh nivel-01-fundamentos 07 hola-mundo
scripts/new-exercise-java.sh nivel-01-fundamentos 07 hola-mundo
scripts/new-exercise-csharp.sh nivel-01-fundamentos 07 hola-mundo
scripts/new-exercise-php.sh nivel-01-fundamentos 07 hola-mundo
scripts/new-exercise-ruby.sh nivel-01-fundamentos 07 hola-mundo
scripts/new-exercise-sql.sh nivel-01-fundamentos 07 select-basico
```

## Empezar / Start here

Lee [00-roadmap/roadmap.md](00-roadmap/roadmap.md) y luego el lenguaje que quieras en [01-programming](01-programming/).
