# Python

> Ruta de aprendizaje completa de Python 3 en español: guías de estudio, ejercicios por niveles, proyectos integradores y proyecto final.

Python es un lenguaje interpretado, de alto nivel y con una sintaxis legible que lo convierte en la elección ideal para empezar a programar. Se usa en desarrollo web (FastAPI, Django, Flask), ciencia de datos (pandas, NumPy), automatización, scripting y machine learning.

Esta ruta asume que sabes lo básico de programación pero parte desde cero en Python. Cada guía introduce la teoría con ejemplos ejecutables y enlaza a los ejercicios que la refuerzan.

## Estructura

```
python/
├── 01-fundamentos.md        # Guía 01: sintaxis, tipos, variables, I/O, condicionales y bucles
├── 02-funciones.md          # Guía 02: def, parámetros, return, scope, type hints, closures
├── 03-estructuras-de-datos.md  # Guía 03: listas, tuplas, sets, diccionarios y comprehensions
├── 04-async-await.md        # Guía 04: asyncio, async/await, tasks, gather y aiohttp
├── 05-errores.md            # Guía 05: try/except/finally, raise, tipos de error y depuración
├── 06-frameworks-web.md     # Guía 06: FastAPI, Django y Flask
├── ejercicios/
│   ├── README.md            # Índice de los 30 ejercicios
│   ├── nivel-01-fundamentos/  # 6 ejercicios (1-6)
│   ├── nivel-02-basico/       # 6 ejercicios (7-12)
│   ├── nivel-03-intermedio/   # 6 ejercicios (13-18)
│   ├── nivel-04-avanzado/     # 6 ejercicios (19-24)
│   ├── nivel-05-experto/      # 6 ejercicios (25-30)
│   └── proyectos/
│       ├── README.md            # 3 proyectos integradores por fases
│       └── proyecto-final/      # Sistema de Gestión de Biblioteca con FastAPI
│           ├── starter/         # andamiaje con modelos, repositorios y servicios
│           └── tests/           # suite de tests de referencia
└── README.md                # este archivo
```

## Guías de estudio

| Guía | Contenido |
|---|---|
| [01 — Fundamentos](01-fundamentos.md) | Sintaxis, tipos, variables, I/O, condicionales y bucles |
| [02 — Funciones](02-funciones.md) | def, parámetros, return, scope, type hints y closures |
| [03 — Estructuras de datos](03-estructuras-de-datos.md) | Listas, tuplas, sets, diccionarios y comprehensions |
| [04 — Async/Await](04-async-await.md) | asyncio, async/await, tasks, gather y aiohttp |
| [05 — Errores](05-errores.md) | try/except/finally, raise, tipos de error y depuración |
| [06 — Frameworks web](06-frameworks-web.md) | FastAPI, Django y Flask |

## Ejercicios por nivel

Cada ejercicio está en una carpeta con `README.md` (enunciado, requisitos, pistas y solución), `main.py` (stub a completar) y `test_main.py` (runner con `unittest`). Ejecuta los tests desde la carpeta del ejercicio con `python3 test_main.py`.

| Nivel | Dificultad | Ejercicios |
|---|---|---|
| [Nivel 01 — Fundamentos](ejercicios/nivel-01-fundamentos/) | ⭐ 1/5 | Variables, operadores, strings, listas, bucles y diccionarios |
| [Nivel 02 — Básico](ejercicios/nivel-02-basico/) | ⭐⭐ 2/5 | Funciones, comprehensions, métodos de listas, errores, archivos y tuplas/sets |
| [Nivel 03 — Intermedio](ejercicios/nivel-03-intermedio/) | ⭐⭐⭐ 3/5 | Closures/decoradores, clases, generators, módulos, recursión y funciones avanzadas |
| [Nivel 04 — Avanzado](ejercicios/nivel-04-avanzado/) | ⭐⭐⭐⭐ 4/5 | asyncio, context managers, map/filter, testing y CLI con argparse |
| [Nivel 05 — Experto](ejercicios/nivel-05-experto/) | ⭐⭐⭐⭐⭐ 5/5 | CLI, servidor HTTP, caché LRU, scraper, API REST y pipelines |

Índice completo con los 30 ejercicios: [ejercicios/README.md](ejercicios/README.md)

## Proyectos integradores

Al terminar los niveles, integra todo lo aprendido con los [3 proyectos integradores](ejercicios/proyectos/README.md):

1. **Gestor de tareas CLI** — aplicación de consola persistente en JSON.
2. **API REST con archivo** — servidor HTTP puro que guarda datos en disco.
3. **Automatización con asyncio** — descargas concurrentes con aiohttp y reportes.

## Proyecto final

[**Sistema de Gestión de Biblioteca con FastAPI**](ejercicios/proyectos/proyecto-final/README.md) — API REST completa con FastAPI y Pydantic: gestión de libros, miembros y préstamos, persistencia en JSON, reportes y suite de tests de referencia. Incluye `starter/` con el andamiaje y `tests/` con la suite.

## Cómo ejecutar

- **Tests de los ejercicios** (sin dependencias): desde la carpeta de un ejercicio, `python3 test_main.py`.
- **Proyecto final**: instala dependencias (`pip install -r requirements.txt`) y arranca con `uvicorn app:app --reload`.

## Scripts

- [`../../scripts/new-exercise-python.sh`](../../scripts/new-exercise-python.sh) — genera un nuevo ejercicio (README.md + main.py + test_main.py).