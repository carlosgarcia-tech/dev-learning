# dev-learning

Repo personal para aprender programación **de 0 a experto**: guías, apuntes, ejercicios por niveles (1–5) y proyectos. Todo el contenido está en español en la raíz del repo (la capa `es/` se aplanó).

Personal repo to learn programming **from 0 to expert**: guides, notes, leveled exercises (1–5) and projects. Content lives at the repo root (the `es/` layer was flattened).

---

## Índice / Index

| Sección | Descripción |
|---|---|
| [00-roadmap](00-roadmap/roadmap.md) | Hoja de ruta completa de 0 a experto |
| [01-programming](01-programming/) | Lenguajes: JS, TS, Python, Java, Rust, Go, C++, C#, PHP, Ruby, Kotlin, Swift |
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

Cada **ejercicio** contiene: enunciado, requisitos (checklist), pistas plegables y **solución al final** (también plegable). En los lenguajes reestructurados (C#, Go, Java, TypeScript, Python) cada ejercicio es una **carpeta** con su `README.md`, un stub (`Program.cs`/`Main.java`/`main.go`/`index.ts`/`main.py`), su runner de tests y la configuración de build (`*.csproj`, `go.mod`, `tsconfig`, `test_main.py`).

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
| [Go](01-programming/go/) | 5 | 30 (carpetas) | ✅ | Structs, interfaces, concurrencia, testing |
| [Java](01-programming/java/) | 6 | 30 (carpetas) | ✅ | POO, streams, concurrencia, Spring Boot |
| [TypeScript](01-programming/typescript/) | 6 | 30 (carpetas) | ✅ | Tipos, generics, async, Express |
| [JavaScript](01-programming/javascript/) | 5 | 30 | ✅ | Formato plano (`.js` + `.md` + `.test.js`) |
| [PHP](01-programming/php/) | 5 | 30 | ✅ | Formato plano (`.php` + `.md` + tests) |
| [Python](01-programming/python/) | 6 | 30 (carpetas) | ✅ | Funciones, estructuras, asyncio, FastAPI/Django/Flask, proyecto final con FastAPI |
| [Rust](01-programming/rust/) | 5 | 30 | — | Formato plano |
| C++ · Kotlin · Ruby · Swift | — | — | — | Solo esqueleto de niveles |

## Estado actual / Current status

- [x] Estructura completa aplanada en la raíz
- [x] Fase 1: JavaScript y SQL (guías + 5 niveles de ejercicios)
- [x] Lenguajes completos con 30 ejercicios: C#, Go, Java, TypeScript, Python
- [x] Lenguajes con 30 ejercicios en formato plano: JS, PHP, Rust
- [ ] Bases de datos restantes (PostgreSQL, MySQL, MongoDB, Redis) — solo esqueleto
- [ ] Backend (HTTP, REST, GraphQL, Auth, Arquitectura)
- [ ] Frontend (HTML, CSS, JS, React, Next.js)
- [ ] DevOps (Linux, Git, Docker, K8s, Nginx, CI/CD)
- [ ] Herramientas, conceptos, cheatsheets, errores, recursos
- [ ] C++ · Kotlin · Ruby · Swift: rellenar guías y ejercicios

## Scripts

```bash
scripts/init.sh                                  # regenera el esqueleto completo (no sobrescribe)
scripts/new-topic.sh 02-databases/dynamodb       # nuevo tema con ejercicios
scripts/new-guide.sh 01-programming/python oop   # nueva guía de estudio
scripts/new-exercise.sh 01-programming/javascript 1 variables-y-tipos   # nuevo ejercicio (formato plano)
scripts/new-exercise-java.sh nivel-01-fundamentos 07 hola-mundo        # ejercicio en carpeta (Java)
scripts/new-exercise-typescript.sh nivel-01-fundamentos 07 hola-mundo  # ejercicio en carpeta (TS)
scripts/new-exercise-csharp.sh nivel-01-fundamentos 07 hola-mundo      # ejercicio en carpeta (C#)
scripts/new-exercise-python.sh nivel-01-fundamentos 07 hola-mundo      # ejercicio en carpeta (Python)
```

## Empezar / Start here

Lee [00-roadmap/roadmap.md](00-roadmap/roadmap.md) y luego el lenguaje que quieras en [01-programming](01-programming/).