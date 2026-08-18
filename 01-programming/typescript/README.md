# TypeScript — Curso Completo desde Cero hasta Experto

Curso completo de TypeScript siguiendo el mismo formato que los cursos de Java y Go, con guías detalladas, ejercicios progresivos y un proyecto final con Express + TypeScript.

## Contenido

1. **Guías de estudio** (`01-tipos-basicos.md` a `06-react-con-typescript.md`)
2. **30 ejercicios progresivos** (6 por nivel, 5 niveles) en `ejercicios/`
3. **Proyecto final**: API REST de gestión de tareas con Express + TypeScript en `ejercicios/proyectos/proyecto-final/`
4. **Tests** con `node:test` para cada ejercicio

## Guías

| # | Guía | Archivo |
|---|------|---------|
| 1 | Tipos Básicos | [01-tipos-basicos.md](./01-tipos-basicos.md) |
| 2 | Interfaces y Type Alias | [02-interfaces-y-type-alias.md](./02-interfaces-y-type-alias.md) |
| 3 | Funciones y Generics | [03-funciones-y-generics.md](./03-funciones-y-generics.md) |
| 4 | Async/Await Tipado | [04-async-await-tipado.md](./04-async-await-tipado.md) |
| 5 | Errores y Utilidades | [05-errores-y-utilidades.md](./05-errores-y-utilidades.md) |
| 6 | React con TypeScript | [06-react-con-typescript.md](./06-react-con-typescript.md) |

## Ejercicios

Ver el índice completo en [ejercicios/README.md](./ejercicios/README.md).

- **Nivel 1 — Fundamentos**: tipos básicos, variables, funciones, arrays/tuplas, enums, union/literal types.
- **Nivel 2 — Básico**: interfaces, type alias, funciones avanzadas, clases, módulos, null/undefined.
- **Nivel 3 — Intermedio**: generics, utility types, overloads, narrowing, type guards.
- **Nivel 4 — Avanzado**: async tipado, decoradores, mapped types, conditional types, tsconfig, testing.
- **Nivel 5 — Experto**: proyectos de consola, servidor HTTP, API REST tipada, event emitter, sistema de tipos, mini proyecto.

## Proyecto Final

API REST completa de gestión de tareas usando Express + TypeScript + Prisma + Zod + JWT. Ver [ejercicios/proyectos/proyecto-final/README.md](./ejercicios/proyectos/proyecto-final/README.md).

## Requisitos

- Node.js 18+
- npm o pnpm
- TypeScript (`npm install -g typescript` o como dependencia local)

## Cómo usar este curso

1. Lee la guía correspondiente al nivel.
2. Resuelve el ejercicio en su archivo `index.ts` (stub).
3. Corre los tests: `node --test index.test.ts` (usando `tsx` o compilando primero con `tsc`).
4. Compara con la solución incluida en el `README.md` de cada ejercicio.
