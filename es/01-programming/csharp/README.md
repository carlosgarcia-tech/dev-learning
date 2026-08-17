# csharp

> Guía de estudio + ejercicios por niveles. Todo el contenido en español.

## Estado

| Recurso | Estado |
|---|---|
| [Guías](01-fundamentos.md) | ✅ 5 guías completas |
| [Ejercicios](ejercicios/) | ✅ 30 ejercicios en 5 niveles, cada uno con stub + tests |
| [Proyectos](ejercicios/proyectos/) | ✅ 3 proyectos integradores, incluido el **PROYECTO FINAL** |

## Guías

| # | Guía | Contenido |
|---|---|---|
| 01 | [Fundamentos](01-fundamentos.md) | Sintaxis, variables, tipos, operadores, condicionales, bucles, arrays, strings |
| 02 | [OOP](02-oop.md) | Clases, objetos, propiedades, herencia, interfaces, enums, nullables |
| 03 | [LINQ y colecciones](03-linq-y-colecciones.md) | List, Dictionary, LINQ básico y avanzado, delegados, eventos, extension methods, tuplas |
| 04 | [Async/await](04-async-await.md) | Task, async/await, Task.WhenAll, HttpClient, E/S asíncrona |
| 05 | [Errores y testing](05-errores-y-testing.md) | Excepciones, try/catch/throw, mini framework de tests, TDD, reflection |

## Ejercicios

[Ver índice completo](ejercicios/README.md) — 30 ejercicios en 5 niveles. Cada ejercicio tiene **enunciado, requisitos, pistas y solución** (plegable), además de un **stub** (`*.cs`) y su **runner de tests** (`*_test.cs`) que verifica la solución.

| Nivel | Temas | Enlace |
|---|---|---|
| 01 — Fundamentos (1/5) | hola-mundo, variables y tipos, operadores y condicionales, bucles, arrays, strings | [ejercicios/nivel-01-fundamentos/](ejercicios/nivel-01-fundamentos/) |
| 02 — Básico (2/5) | métodos, clases y objetos, propiedades, listas y diccionarios, excepciones, enums | [ejercicios/nivel-02-basico/](ejercicios/nivel-02-basico/) |
| 03 — Intermedio (3/5) | herencia, interfaces, genéricos, LINQ básico, delegados y eventos, nullables | [ejercicios/nivel-03-intermedio/](ejercicios/nivel-03-intermedio/) |
| 04 — Avanzado (4/5) | async/await, LINQ avanzado, extension methods, tuplas, testing, reflection | [ejercicios/nivel-04-avanzado/](ejercicios/nivel-04-avanzado/) |
| 05 — Experto (5/5) | gestor de tareas CLI, servidor HTTP, API REST mínima, caché LRU, mini proyecto, patrones | [ejercicios/nivel-05-experto/](ejercicios/nivel-05-experto/) |

## Proyectos integradores

[Ver proyectos](ejercicios/proyectos/README.md) — 3 proyectos por fases, del más simple al **[PROYECTO FINAL](ejercicios/proyectos/proyecto-final/README.md)**: sistema de gestión completo con LINQ, async/await, persistencia y tests.

## Cómo ejecutar C#

> **Nota:** en esta máquina **no está instalado el .NET SDK**, por lo que los tests no se han podido ejecutar aquí. El código es C# 10+ válido y está pensado para ejecutarse tal cual.

Hay dos caminos:

1. **Con el .NET SDK (recomendado):** en la carpeta del ejercicio crea un proyecto de consola y ejecuta:
   ```bash
   dotnet new console -o . --force
   rm Program.cs        # evita el conflicto con el entry point de *_test.cs
   dotnet run
   ```
2. **Con el compilador `csc` (Mono):** compila el stub y el test juntos y ejecuta el `.exe`:
   ```bash
   csc ejercicio-01-hola-mundo.cs ejercicio-01-hola-mundo_test.cs
   mono ejercicio-01-hola-mundo_test.exe
   ```

Ambos comandos aparecen documentados en la sección **Requisitos** de cada ejercicio.