# JavaScript

A complete learning path for JavaScript (ECMAScript), from syntax fundamentals to async programming, error handling, and real Node.js mini-projects. Everything runs with plain `node`, no frameworks required.

## How to use this track

1. Read a **study guide** to learn the concepts.
2. Open the **exercises** for the matching level and solve them in order.
3. Run every solution with `node file.js` and compare your output.
4. Finish with a **capstone project** from the projects section.

## Study guides

| # | Guide | Topics |
|---|-------|--------|
| 1 | [01-fundamentals.md](01-fundamentals.md) | Variables, `let`/`const`/`var`, types, `typeof`, template literals, operators, conditionals, loops |
| 2 | [02-functions.md](02-functions.md) | Declarations, expressions, arrow functions, parameters, return, scope, closures, hoisting |
| 3 | [03-arrays-and-objects.md](03-arrays-and-objects.md) | Arrays, `push`/`pop`/`shift`/`unshift`/`map`/`filter`/`reduce`/`find`, objects, destructuring, spread/rest, JSON |
| 4 | [04-async-await.md](04-async-await.md) | Callbacks, promises (`then`/`catch`), `async`/`await`, `Promise.all`, `fetch`, async error handling |
| 5 | [05-errors.md](05-errors.md) | `throw`, `try`/`catch`/`finally`, error types, common JS errors and debugging |

## Exercises

| Level | Directory | Exercises | Difficulty |
|-------|-----------|-----------|------------|
| 1 — Fundamentals | [nivel-01-fundamentos](ejercicios/nivel-01-fundamentos/) | [Variables & types](ejercicios/nivel-01-fundamentos/exercise-01-variables-and-types.md), [Operators & conditionals](ejercicios/nivel-01-fundamentos/exercise-02-operators-and-conditionals.md), [Strings](ejercicios/nivel-01-fundamentos/exercise-03-strings.md), [Basic arrays](ejercicios/nivel-01-fundamentos/exercise-04-basic-arrays.md), [Loops](ejercicios/nivel-01-fundamentos/exercise-05-loops.md), [Basic objects](ejercicios/nivel-01-fundamentos/exercise-06-basic-objects.md) | 1/5 |
| 2 — Basic | [nivel-02-basico](ejercicios/nivel-02-basico/) | [Functions](ejercicios/nivel-02-basico/exercise-01-functions.md), [Arrow functions](ejercicios/nivel-02-basico/exercise-02-arrow-functions.md), [Array methods](ejercicios/nivel-02-basico/exercise-03-array-methods.md), [Destructuring & spread](ejercicios/nivel-02-basico/exercise-04-destructuring-and-spread.md), [Error handling](ejercicios/nivel-02-basico/exercise-05-error-handling.md), [Closures](ejercicios/nivel-02-basico/exercise-06-closures.md) | 2/5 |
| 3 — Intermediate | [nivel-03-intermedio](ejercicios/nivel-03-intermedio/) | [Classes](ejercicios/nivel-03-intermedio/exercise-01-classes.md), [Recursion & memoization](ejercicios/nivel-03-intermedio/exercise-02-recursion-and-memoization.md), [Reduce & sort](ejercicios/nivel-03-intermedio/exercise-03-reduce-and-sort.md), [Callbacks](ejercicios/nivel-03-intermedio/exercise-04-callbacks.md), [Promises](ejercicios/nivel-03-intermedio/exercise-05-promises.md), [Data structures](ejercicios/nivel-03-intermedio/exercise-06-data-structures.md) | 3/5 |
| 4 — Advanced | [nivel-04-avanzado](ejercicios/nivel-04-avanzado/) | [Async/await](ejercicios/nivel-04-avanzado/exercise-01-async-await.md), [Fetch & JSON](ejercicios/nivel-04-avanzado/exercise-02-fetch-and-json.md), [Design patterns](ejercicios/nivel-04-avanzado/exercise-03-design-patterns.md), [Memoization & performance](ejercicios/nivel-04-avanzado/exercise-04-memoization-and-performance.md), [Testing with assert](ejercicios/nivel-04-avanzado/exercise-05-testing-with-assert.md), [Node CLI](ejercicios/nivel-04-avanzado/exercise-06-node-cli.md) | 4/5 |
| 5 — Expert | [nivel-05-experto](ejercicios/nivel-05-experto/) | [Task manager CLI](ejercicios/nivel-05-experto/exercise-01-task-manager-cli.md), [HTTP server](ejercicios/nivel-05-experto/exercise-02-http-server.md), [LRU cache](ejercicios/nivel-05-experto/exercise-03-lru-cache.md), [Event emitter](ejercicios/nivel-05-experto/exercise-04-event-emitter.md), [Minimal REST API](ejercicios/nivel-05-experto/exercise-05-minimal-rest-api.md), [Data pipeline](ejercicios/nivel-05-experto/exercise-06-data-pipeline.md) | 5/5 |

See the [full exercise index](ejercicios/).

## Projects

After finishing the exercises, build the capstone projects in [ejercicios/proyectos/](ejercicios/proyectos/):

1. **Task Manager CLI** — a full command-line app that persists data to a JSON file.
2. **REST API with file storage** — a small HTTP API built only with `node:http` and `node:fs`.
3. **Simulated full-stack app** — a frontend that talks to a local Node server through `fetch`.

## Requirements

- Node.js 18 or newer (for `fetch`, `node:assert`, and modern syntax).
- No external packages — everything uses the Node standard library.