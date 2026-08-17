# JavaScript

> Ruta de aprendizaje completa de JavaScript (ES2024+) en español: guías de estudio, ejercicios por niveles y proyectos integradores.

JavaScript es el lenguaje de programación de la web. Lo usan tanto el navegador como Node.js en el servidor, y dominar sus fundamentos te abre las puertas a frontend (React, Vue), backend (Node, Deno) y desarrollo móvil.

Esta ruta asume que sabes lo básico de programación pero parte desde cero en JavaScript. Cada guía introduce la teoría con ejemplos ejecutables y enlaza a los ejercicios que la refuerzan.

## Guías de estudio

| Guía | Contenido |
|---|---|
| [01 — Fundamentos](01-fundamentos.md) | Variables, tipos, operadores, condicionales y bucles |
| [02 — Funciones](02-funciones.md) | Declaración, arrow functions, scope, closures y hoisting |
| [03 — Arrays y objetos](03-arrays-y-objetos.md) | Métodos de arrays, destructuring, spread/rest y JSON |
| [04 — Async/Await](04-async-await.md) | Callbacks, promesas, async/await, fetch y errores |
| [05 — Errores](05-errores.md) | throw, try/catch/finally, tipos de error y depuración |

## Ejercicios por nivel

Cada ejercicio incluye enunciado, requisitos, pistas y solución. Ejecuta cada solución con `node archivo.js`.

| Nivel | Dificultad | Ejercicios |
|---|---|---|
| [Nivel 01 — Fundamentos](ejercicios/nivel-01-fundamentos/) | ⭐ 1/5 | Variables, operadores, strings, arrays, bucles y objetos |
| [Nivel 02 — Básico](ejercicios/nivel-02-basico/) | ⭐⭐ 2/5 | Funciones, arrow, métodos de arrays, destructuring, errores y closures |
| [Nivel 03 — Intermedio](ejercicios/nivel-03-intermedio/) | ⭐⭐⭐ 3/5 | Clases, recursión, reduce/sort, callbacks, promesas y estructuras de datos |
| [Nivel 04 — Avanzado](ejercicios/nivel-04-avanzado/) | ⭐⭐⭐⭐ 4/5 | Async/await, fetch, patrones, debounce/throttle, testing y CLI |
| [Nivel 05 — Experto](ejercicios/nivel-05-experto/) | ⭐⭐⭐⭐⭐ 5/5 | CLI, servidor HTTP, caché LRU, EventEmitter, API REST y pipelines |

Índice completo con los 30 ejercicios: [ejercicios/README.md](ejercicios/README.md)

## Proyectos

Al terminar los niveles, integra todo lo aprendido con los [3 proyectos integradores](ejercicios/proyectos/README.md):

1. **Gestor de tareas CLI** — aplicación de consola persistente en JSON.
2. **API REST con archivo** — servidor HTTP que guarda datos en disco.
3. **App full-stack simulada** — frontend y backend funcionando juntos con datos en memoria.