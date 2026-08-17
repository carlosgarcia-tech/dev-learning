# Ejercicios — C#

30 ejercicios en 5 niveles de dificultad. Cada ejercicio tiene **enunciado, requisitos, pistas y solución** (plegable), además de un **stub** (`*.cs`) y su **runner de tests** (`*_test.cs`) que verifica la solución y devuelve `0` si todos los checks pasan.

## Cómo ejecutar los tests

> El .NET SDK **no está instalado** en esta máquina; los tests no se han podido verificar aquí (revisión manual del código C# 10+). Al instalar el **.NET SDK**:

```bash
# desde la carpeta del ejercicio
dotnet new console -o . --force
rm Program.cs        # evita el conflicto con el entry point de *_test.cs
dotnet run
```

> Si tienes **Mono/csc** compila ambos archivos y ejecuta el `.exe`:

```bash
csc ejercicio-01-hola-mundo.cs ejercicio-01-hola-mundo_test.cs
mono ejercicio-01-hola-mundo_test.exe
```

El runner imprime `[OK]`/`[FALL]` por check y termina con código de salida `0` (todo pasa) o `1` (hay fallos).

## Nivel 01 — Fundamentos (1/5)

Variables, tipos, operadores, condicionales, bucles, arrays y strings.

| # | Ejercicio | Enlace |
|---|---|---|
| 01 | Hola mundo | [ejercicio-01-hola-mundo.md](nivel-01-fundamentos/ejercicio-01-hola-mundo.md) |
| 02 | Variables y tipos | [ejercicio-02-variables-y-tipos.md](nivel-01-fundamentos/ejercicio-02-variables-y-tipos.md) |
| 03 | Operadores y condicionales | [ejercicio-03-operadores-y-condicionales.md](nivel-01-fundamentos/ejercicio-03-operadores-y-condicionales.md) |
| 04 | Bucles | [ejercicio-04-bucles.md](nivel-01-fundamentos/ejercicio-04-bucles.md) |
| 05 | Arrays básicos | [ejercicio-05-arrays-basicos.md](nivel-01-fundamentos/ejercicio-05-arrays-basicos.md) |
| 06 | Strings | [ejercicio-06-strings.md](nivel-01-fundamentos/ejercicio-06-strings.md) |

## Nivel 02 — Básico (2/5)

Métodos, clases y objetos, propiedades y encapsulación, listas y diccionarios, excepciones y enums.

| # | Ejercicio | Enlace |
|---|---|---|
| 01 | Métodos | [ejercicio-01-metodos.md](nivel-02-basico/ejercicio-01-metodos.md) |
| 02 | Clases y objetos | [ejercicio-02-clases-y-objetos.md](nivel-02-basico/ejercicio-02-clases-y-objetos.md) |
| 03 | Propiedades | [ejercicio-03-propiedades.md](nivel-02-basico/ejercicio-03-propiedades.md) |
| 04 | Listas y diccionarios | [ejercicio-04-listas-y-diccionarios.md](nivel-02-basico/ejercicio-04-listas-y-diccionarios.md) |
| 05 | Excepciones | [ejercicio-05-excepciones.md](nivel-02-basico/ejercicio-05-excepciones.md) |
| 06 | Enums | [ejercicio-06-enums.md](nivel-02-basico/ejercicio-06-enums.md) |

## Nivel 03 — Intermedio (3/5)

Herencia y polimorfismo, interfaces, genéricos, LINQ básico, delegados y eventos, nullables.

| # | Ejercicio | Enlace |
|---|---|---|
| 01 | Herencia | [ejercicio-01-herencia.md](nivel-03-intermedio/ejercicio-01-herencia.md) |
| 02 | Interfaces | [ejercicio-02-interfaces.md](nivel-03-intermedio/ejercicio-02-interfaces.md) |
| 03 | Genéricos | [ejercicio-03-generics.md](nivel-03-intermedio/ejercicio-03-generics.md) |
| 04 | LINQ básico | [ejercicio-04-linq-basico.md](nivel-03-intermedio/ejercicio-04-linq-basico.md) |
| 05 | Delegados y eventos | [ejercicio-05-delegados-y-eventos.md](nivel-03-intermedio/ejercicio-05-delegados-y-eventos.md) |
| 06 | Nullables | [ejercicio-06-nullables.md](nivel-03-intermedio/ejercicio-06-nullables.md) |

## Nivel 04 — Avanzado (4/5)

Async/await, LINQ avanzado, extension methods, tuplas, testing y reflection.

| # | Ejercicio | Enlace |
|---|---|---|
| 01 | Async/await | [ejercicio-01-async-await.md](nivel-04-avanzado/ejercicio-01-async-await.md) |
| 02 | LINQ avanzado | [ejercicio-02-linq-avanzado.md](nivel-04-avanzado/ejercicio-02-linq-avanzado.md) |
| 03 | Extension methods | [ejercicio-03-extension-methods.md](nivel-04-avanzado/ejercicio-03-extension-methods.md) |
| 04 | Tuplas | [ejercicio-04-tuplas.md](nivel-04-avanzado/ejercicio-04-tuplas.md) |
| 05 | Testing | [ejercicio-05-testing.md](nivel-04-avanzado/ejercicio-05-testing.md) |
| 06 | Reflection | [ejercicio-06-reflection.md](nivel-04-avanzado/ejercicio-06-reflection.md) |

## Nivel 05 — Experto (5/5)

Gestor de tareas CLI, servidor HTTP, API REST mínima, caché LRU, mini proyecto y patrones de diseño.

| # | Ejercicio | Enlace |
|---|---|---|
| 01 | Gestor de tareas CLI | [ejercicio-01-gestor-de-tareas-cli.md](nivel-05-experto/ejercicio-01-gestor-de-tareas-cli.md) |
| 02 | Servidor HTTP | [ejercicio-02-servidor-http.md](nivel-05-experto/ejercicio-02-servidor-http.md) |
| 03 | API REST mínima | [ejercicio-03-api-rest-minima.md](nivel-05-experto/ejercicio-03-api-rest-minima.md) |
| 04 | Caché LRU | [ejercicio-04-cache-lru.md](nivel-05-experto/ejercicio-04-cache-lru.md) |
| 05 | Mini proyecto (biblioteca) | [ejercicio-05-mini-proyecto.md](nivel-05-experto/ejercicio-05-mini-proyecto.md) |
| 06 | Patrones de diseño | [ejercicio-06-patrones-de-diseno.md](nivel-05-experto/ejercicio-06-patrones-de-diseno.md) |

## Proyectos integradores

[Proyectos integradores](proyectos/README.md) — 3 proyectos por fases: app CLI de inventario, API REST con persistencia y el **[PROYECTO FINAL: Sistema de Gestión de Biblioteca](proyectos/proyecto-final/README.md)** (LINQ, async/await, persistencia JSON, validaciones, reportes y tests).