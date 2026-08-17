# dev-learning

Repo personal para aprender programación **de 0 a experto**: guías, apuntes, ejercicios por niveles (1–5) y proyectos. Bilingüe: versión en [español](es/) e [inglés](en/).

Personal repo to learn programming **from 0 to expert**: guides, notes, leveled exercises (1–5) and projects. Bilingual: [Spanish](es/) and [English](en/) versions.

---

## Índice / Index

| Sección | Descripción |
|---|---|
| [es/00-roadmap](es/00-roadmap/roadmap.md) · [en/00-roadmap](en/00-roadmap/roadmap.md) | Hoja de ruta completa / Full roadmap |
| [es/01-programming](es/01-programming/) | Lenguajes: JS, TS, Python, Java, Rust, Go, C/C++, C#, PHP, Ruby, Kotlin, Swift |
| [es/02-databases](es/02-databases/) | SQL, PostgreSQL, MySQL, MongoDB, Redis |
| [es/03-backend](es/03-backend/) | HTTP, REST, GraphQL, Auth, Arquitectura |
| [es/04-frontend](es/04-frontend/) | HTML, CSS, JS, React, Next.js |
| [es/05-devops](es/05-devops/) | Linux, Git, Docker, K8s, Nginx, CI/CD |
| [es/06-tools](es/06-tools/) | npm, pnpm, VSCode, opencode, terminal |
| [es/07-concepts](es/07-concepts/) | Redes, SO, estructuras de datos, algoritmos, system design |
| [es/08-projects](es/08-projects/) | Proyectos integradores |
| [es/09-cheatsheets](es/09-cheatsheets/) | Chuletas rápidas |
| [es/10-errors](es/10-errors/) | Errores comunes y cómo resolverlos |
| [es/resources](es/resources/) | Libros, cursos, webs, repos útiles |

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

Cada **ejercicio** contiene: enunciado, requisitos (checklist), pistas plegables y **solución al final** (también plegable).

## Niveles de dificultad / Difficulty levels

| Nivel | Qué dominas al terminar |
|---|---|
| 1 Fundamentos | Sintaxis, tipos, variables, salida |
| 2 Básico | Control de flujo, funciones, estructuras |
| 3 Intermedio | Composición, errores, patrones simples |
| 4 Avanzado | Asincronía, concurrencia, optimización |
| 5 Experto | Diseño y sistemas completos |

## Scripts

```bash
scripts/init.sh                        # regenera el esqueleto completo (no sobrescribe)
scripts/new-topic.sh 02-databases/dynamodb     # nuevo tema con ejercicios
scripts/new-guide.sh 01-programming/python oop  # nueva guía de estudio
scripts/new-exercise.sh 01-programming/javascript 1 variables-y-tipos   # nuevo ejercicio
```

## Estado actual / Current status

- [x] Estructura completa / Full structure
- [x] Fase 1: JavaScript y SQL (guías + 5 niveles de ejercicios)
- [ ] Lenguajes restantes / Remaining languages
- [ ] Bases de datos (PostgreSQL, MySQL, MongoDB, Redis)
- [ ] Backend (HTTP, REST, GraphQL, Auth, Arquitectura)
- [ ] Frontend (HTML, CSS, JS, React, Next.js)
- [ ] DevOps (Linux, Git, Docker, K8s, Nginx, CI/CD)
- [ ] Herramientas, conceptos, cheatsheets, errores, recursos

## Empezar / Start here

Lee [es/00-roadmap/roadmap.md](es/00-roadmap/roadmap.md) o [en/00-roadmap/roadmap.md](en/00-roadmap/roadmap.md).