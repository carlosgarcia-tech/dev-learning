# Ejercicios de TypeScript

30 ejercicios progresivos organizados en 5 niveles (6 ejercicios por nivel), más un proyecto final.

## Nivel 1: Fundamentos

| # | Ejercicio | Descripción |
|---|-----------|-------------|
| 01 | Tipos Básicos | string, number, boolean, null, undefined, void, any |
| 02 | Variables y Anotaciones | let, const, anotaciones explícitas e inferencia |
| 03 | Funciones Tipadas | Parámetros, retorno, funciones flecha |
| 04 | Arrays y Tuplas | Arrays, tuplas, métodos de arrays |
| 05 | Enums | Enums numéricos, strings, const enums |
| 06 | Union y Literal Types | Union types, literal types, type narrowing |

## Nivel 2: Básico

| # | Ejercicio | Descripción |
|---|-----------|-------------|
| 07 | Interfaces | Definición, implementación, herencia |
| 08 | Type Aliases | Definición, uso con union types |
| 09 | Funciones Avanzadas | Parámetros opcionales, rest, default |
| 10 | Clases con Tipos | Clases, herencia, modificadores |
| 11 | Módulos | import, export, barrel files |
| 12 | Null y Undefined | Optional chaining, nullish coalescing |

## Nivel 3: Intermedio

| # | Ejercicio | Descripción |
|---|-----------|-------------|
| 13 | Generics Básicos | Funciones genéricas, interfaces genéricas |
| 14 | Generics Avanzados | Restricciones, múltiples tipos genéricos |
| 15 | Utility Types | Partial, Required, Readonly, Pick, Omit |
| 16 | Overloads | Función overloads |
| 17 | Type Narrowing | typeof, instanceof, in, type predicates |
| 18 | Type Guards | Crear type guards personalizados |

## Nivel 4: Avanzado

| # | Ejercicio | Descripción |
|---|-----------|-------------|
| 19 | Async Tipado | Promesas, async/await con tipos |
| 20 | Decoradores | Decoradores de clase, método, propiedad |
| 21 | Mapped Types | Crear tipos a partir de otros |
| 22 | Conditional Types | Tipos condicionales con `extends` |
| 23 | tsconfig | Configuración avanzada |
| 24 | Testing con TS | Tests tipados con node:test |

## Nivel 5: Experto

| # | Ejercicio | Descripción |
|---|-----------|-------------|
| 25 | Gestor de Tareas CLI | Aplicación de consola tipada |
| 26 | Servidor HTTP | Servidor HTTP con tipos |
| 27 | API REST Tipada | API REST con Express y TypeScript |
| 28 | Event Emitter | Sistema de eventos tipado |
| 29 | Sistema de Tipos Complejo | Type-level programming |
| 30 | Mini Proyecto | Aplicación completa tipada |

## Proyecto Final

Ver [proyectos/proyecto-final/README.md](./proyectos/proyecto-final/README.md).

## Cómo trabajar cada ejercicio

1. Abre el `README.md` del ejercicio y lee el enunciado.
2. Completa el código en `index.ts`.
3. Corre los tests: `node --test index.test.ts` (compila primero con `tsc` o usa `tsx`/`ts-node`).
4. Compara tu solución con la incluida (colapsada) en el `README.md`.
