# Python

> Ruta de aprendizaje completa de Python 3 en español: guías de estudio, ejercicios por niveles y proyectos integradores.

Python es un lenguaje interpretado, de alto nivel y con una sintaxis legible que lo convierte en la elección ideal para empezar a programar. Se usa en desarrollo web (Django, FastAPI), ciencia de datos (pandas, NumPy), automatización, scripting y machine learning.

Esta ruta asume que sabes lo básico de programación pero parte desde cero en Python. Cada guía introduce la teoría con ejemplos ejecutables y enlaza a los ejercicios que la refuerzan.

## Guías de estudio

| Guía | Contenido |
|---|---|
| [01 — Fundamentos](01-fundamentos.md) | Sintaxis, tipos, variables, I/O, condicionales y bucles |
| [02 — Funciones](02-funciones.md) | def, parámetros, return, scope y argumentos |
| [03 — Estructuras de datos](03-estructuras-de-datos.md) | Listas, tuplas, diccionarios, sets y comprehensions |
| [04 — Async/Await](04-async-await.md) | asyncio, async/await, tasks y aiohttp |
| [05 — Errores](05-errores.md) | try/except/finally, raise, tipos de error y depuración |

## Ejercicios por nivel

Cada ejercicio incluye enunciado, requisitos, pistas y solución. Ejecuta cada solución con `python3 archivo.py`.

| Nivel | Dificultad | Ejercicios |
|---|---|---|
| [Nivel 01 — Fundamentos](ejercicios/nivel-01-fundamentos/) | ⭐ 1/5 | Variables, operadores, strings, listas, bucles y diccionarios |
| [Nivel 02 — Básico](ejercicios/nivel-02-basico/) | ⭐⭐ 2/5 | Funciones, comprehensions, métodos de listas, errores, archivos y tuplas/sets |
| [Nivel 03 — Intermedio](ejercicios/nivel-03-intermedio/) | ⭐⭐⭐ 3/5 | Closures/decoradores, clases, generators, módulos, recursión y funciones avanzadas |
| [Nivel 04 — Avanzado](ejercicios/nivel-04-avanzado/) | ⭐⭐⭐⭐ 4/5 | asyncio, context managers, map/filter, pytest y CLI con argparse |
| [Nivel 05 — Experto](ejercicios/nivel-05-experto/) | ⭐⭐⭐⭐⭐ 5/5 | CLI, servidor HTTP, caché LRU, scraper, API REST y pipelines |

Índice completo con los 30 ejercicios: [ejercicios/README.md](ejercicios/README.md)

## Proyectos

Al terminar los niveles, integra todo lo aprendido con los [3 proyectos integradores](ejercicios/proyectos/README.md):

1. **Gestor de tareas CLI** — aplicación de consola persistente en JSON.
2. **API REST con archivo** — servidor HTTP puro que guarda datos en disco.
3. **Automatización con asyncio** — descargas concurrentes con aiohttp y reportes.