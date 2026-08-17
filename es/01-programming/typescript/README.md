# TypeScript

> Ruta de aprendizaje completa de TypeScript en español: guías de estudio, ejercicios por niveles y proyectos integradores.

TypeScript es un **superset tipado de JavaScript** desarrollado por Microsoft. Añade anotaciones de tipos, interfaces, genéricos y un sistema de tipos moderno sobre el código JavaScript que ya conoces, manteniendo compatibilidad total con el ecosistema Node.js y del navegador.

Esta ruta asume que dominas los fundamentos de JavaScript. Cada guía introduce la teoría con ejemplos ejecutables y enlaza a los ejercicios que la refuerzan. Ejecuta el código con `npx tsc --outDir dist <archivo>.ts` seguido de `node dist/<archivo>.js`, o simplemente con `npx tsx <archivo>.ts` si tienes tsx instalado.

## Guías de estudio

| Guía | Contenido |
|---|---|
| [01 — Tipos básicos](01-tipos-basicos.md) | Anotaciones, primitivos, arrays, tuplas, enums y uniones |
| [02 — Interfaces y type alias](02-interfaces-y-type-alias.md) | Interfaces, type alias, extender, uniones de objetos y composición |
| [03 — Funciones y genéricos](03-funciones-y-generics.md) | Funciones tipadas, parámetros opcionales, overloads y genéricos |
| [04 — Async/await tipado](04-async-await-tipado.md) | Promesas tipadas, fetch, aserción de tipos y narrowing |
| [05 — Errores y utilidades](05-errores-y-utilidades.md) | Utility types, never, unknown y tsconfig |

## Ejercicios por nivel

Cada ejercicio incluye enunciado, requisitos, pistas y solución. Verifica cada solución con `npx tsc --strict <archivo>.ts`.

| Nivel | Dificultad | Ejercicios |
|---|---|---|
| [Nivel 01 — Fundamentos](ejercicios/nivel-01-fundamentos/) | ⭐ 1/5 | Tipos básicos, anotaciones, funciones, arrays/tuplas, enums y uniones |
| [Nivel 02 — Básico](ejercicios/nivel-02-basico/) | ⭐⭐ 2/5 | Interfaces, type alias, funciones avanzadas, clases, módulos y null |
| [Nivel 03 — Intermedio](ejercicios/nivel-03-intermedio/) | ⭐⭐⭐ 3/5 | Genéricos, utility types, overloads, narrowing y aserciones |
| [Nivel 04 — Avanzado](ejercicios/nivel-04-avanzado/) | ⭐⭐⭐⭐ 4/5 | Async tipado, decoradores, mapped/conditional types, tsconfig y testing |
| [Nivel 05 — Experto](ejercicios/nivel-05-experto/) | ⭐⭐⭐⭐⭐ 5/5 | Gestor de tareas, servidor HTTP, API REST, EventEmitter y mini-proyectos |

Índice completo con los 30 ejercicios: [ejercicios/README.md](ejercicios/README.md)

## Proyectos

Al terminar los niveles, integra todo lo aprendido con los [3 proyectos integradores](ejercicios/proyectos/README.md):

1. **Gestor de finanzas tipado** — aplicación CLI con modelos, validación y persistencia.
2. **API REST tipada con archivo** — servidor HTTP con rutas, tipos de dominio y validación.
3. **App full-stack tipada** — frontend, backend y capa compartida de tipos.