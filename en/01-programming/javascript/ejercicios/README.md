# Exercises — JavaScript

Each exercise has a statement, verifiable requirements, hints, and a collapsible solution at the end. Solutions are runnable with plain `node` — no packages required.

> **Level 1** assumes no prior knowledge. **Level 5** assumes all previous levels.

## Level 1 — Fundamentals

Syntax, types, operators, strings, arrays, loops, and objects.

| # | Exercise | File |
|---|----------|------|
| 1 | Variables and types | [exercise-01-variables-and-types.md](nivel-01-fundamentos/exercise-01-variables-and-types.md) |
| 2 | Operators and conditionals | [exercise-02-operators-and-conditionals.md](nivel-01-fundamentos/exercise-02-operators-and-conditionals.md) |
| 3 | Strings | [exercise-03-strings.md](nivel-01-fundamentos/exercise-03-strings.md) |
| 4 | Basic arrays | [exercise-04-basic-arrays.md](nivel-01-fundamentos/exercise-04-basic-arrays.md) |
| 5 | Loops | [exercise-05-loops.md](nivel-01-fundamentos/exercise-05-loops.md) |
| 6 | Basic objects | [exercise-06-basic-objects.md](nivel-01-fundamentos/exercise-06-basic-objects.md) |

## Level 2 — Basic

Functions, arrow functions, array methods, destructuring, error handling, closures.

| # | Exercise | File |
|---|----------|------|
| 1 | Functions | [exercise-01-functions.md](nivel-02-basico/exercise-01-functions.md) |
| 2 | Arrow functions | [exercise-02-arrow-functions.md](nivel-02-basico/exercise-02-arrow-functions.md) |
| 3 | Array methods (`map`/`filter`/`find`) | [exercise-03-array-methods.md](nivel-02-basico/exercise-03-array-methods.md) |
| 4 | Destructuring and spread | [exercise-04-destructuring-and-spread.md](nivel-02-basico/exercise-04-destructuring-and-spread.md) |
| 5 | Error handling (`try`/`catch`/`throw`) | [exercise-05-error-handling.md](nivel-02-basico/exercise-05-error-handling.md) |
| 6 | Closures | [exercise-06-closures.md](nivel-02-basico/exercise-06-closures.md) |

## Level 3 — Intermediate

Classes, recursion, reduce/sort, callbacks, promises, data structures.

| # | Exercise | File |
|---|----------|------|
| 1 | Classes | [exercise-01-classes.md](nivel-03-intermedio/exercise-01-classes.md) |
| 2 | Recursion and memoization | [exercise-02-recursion-and-memoization.md](nivel-03-intermedio/exercise-02-recursion-and-memoization.md) |
| 3 | Reduce and sort | [exercise-03-reduce-and-sort.md](nivel-03-intermedio/exercise-03-reduce-and-sort.md) |
| 4 | Callbacks | [exercise-04-callbacks.md](nivel-03-intermedio/exercise-04-callbacks.md) |
| 5 | Promises | [exercise-05-promises.md](nivel-03-intermedio/exercise-05-promises.md) |
| 6 | Data structures (stack and queue) | [exercise-06-data-structures.md](nivel-03-intermedio/exercise-06-data-structures.md) |

## Level 4 — Advanced

async/await, fetch, design patterns, performance, testing, CLI.

| # | Exercise | File |
|---|----------|------|
| 1 | Async/await | [exercise-01-async-await.md](nivel-04-avanzado/exercise-01-async-await.md) |
| 2 | Fetch and JSON | [exercise-02-fetch-and-json.md](nivel-04-avanzado/exercise-02-fetch-and-json.md) |
| 3 | Design patterns | [exercise-03-design-patterns.md](nivel-04-avanzado/exercise-03-design-patterns.md) |
| 4 | Memoization and performance | [exercise-04-memoization-and-performance.md](nivel-04-avanzado/exercise-04-memoization-and-performance.md) |
| 5 | Testing with `node:assert` | [exercise-05-testing-with-assert.md](nivel-04-avanzado/exercise-05-testing-with-assert.md) |
| 6 | Node CLI | [exercise-06-node-cli.md](nivel-04-avanzado/exercise-06-node-cli.md) |

## Level 5 — Expert

Mini-applications built only with the Node standard library.

| # | Exercise | File |
|---|----------|------|
| 1 | Task manager CLI | [exercise-01-task-manager-cli.md](nivel-05-experto/exercise-01-task-manager-cli.md) |
| 2 | HTTP server | [exercise-02-http-server.md](nivel-05-experto/exercise-02-http-server.md) |
| 3 | LRU cache | [exercise-03-lru-cache.md](nivel-05-experto/exercise-03-lru-cache.md) |
| 4 | Event emitter | [exercise-04-event-emitter.md](nivel-05-experto/exercise-04-event-emitter.md) |
| 5 | Minimal REST API | [exercise-05-minimal-rest-api.md](nivel-05-experto/exercise-05-minimal-rest-api.md) |
| 6 | Data pipeline | [exercise-06-data-pipeline.md](nivel-05-experto/exercise-06-data-pipeline.md) |

## Projects

After finishing all levels, tackle the capstone projects: [proyectos/](proyectos/)

- CLI application
- REST API with file storage
- Simulated full-stack application

## How to run

Each exercise's solution is standalone. Save it as `solution.js` and run:

```bash
node solution.js
```

Exercises that start a server (Level 5, projects) need `curl` in a second terminal.