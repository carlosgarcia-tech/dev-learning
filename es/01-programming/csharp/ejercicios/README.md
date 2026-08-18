# Ejercicios de C# — Índice

30 ejercicios progresivos (6 por nivel) + 3 proyectos integradores. Cada ejercicio contiene:

- `README.md` — enunciado, requisitos, pistas y solución
- `Program.cs` — stub con `TODO`s para completar (o la solución, según el ejercicio)
- `ProgramTest.cs` — runner de tests con `[OK]`/`[FALL]` y código de salida `0`/`1`

## Cómo ejecutar los tests

Desde la carpeta del ejercicio:

```bash
# Con el .NET SDK
dotnet run

# Con Mono/csc
csc Program.cs ProgramTest.cs -out:ProgramTest.exe
mono ProgramTest.exe
```

> El .NET SDK **no está instalado** en esta máquina; los tests no se han podido verificar aquí (revisión manual del código C# 10+). Ambos comandos aparecen documentados en la sección **Requisitos** de cada ejercicio.

El runner imprime `[OK]`/`[FALL]` por check y termina con código de salida `0` (todo pasa) o `1` (hay fallos).

## Nivel 01 — Fundamentos (1/5)

Variables, tipos, operadores, condicionales, bucles, arrays y strings.

| # | Ejercicio | Carpeta |
|---|-----------|---------|
| 01 | Hola mundo | [`nivel-01-fundamentos/ejercicio-01-hola-mundo`](./nivel-01-fundamentos/ejercicio-01-hola-mundo/) |
| 02 | Variables y tipos | [`nivel-01-fundamentos/ejercicio-02-variables-y-tipos`](./nivel-01-fundamentos/ejercicio-02-variables-y-tipos/) |
| 03 | Operadores y condicionales | [`nivel-01-fundamentos/ejercicio-03-operadores-y-condicionales`](./nivel-01-fundamentos/ejercicio-03-operadores-y-condicionales/) |
| 04 | Bucles | [`nivel-01-fundamentos/ejercicio-04-bucles`](./nivel-01-fundamentos/ejercicio-04-bucles/) |
| 05 | Arrays básicos | [`nivel-01-fundamentos/ejercicio-05-arrays-basicos`](./nivel-01-fundamentos/ejercicio-05-arrays-basicos/) |
| 06 | Strings | [`nivel-01-fundamentos/ejercicio-06-strings`](./nivel-01-fundamentos/ejercicio-06-strings/) |

## Nivel 02 — Básico (2/5)

Métodos, clases y objetos, propiedades y encapsulación, listas y diccionarios, excepciones y enums.

| # | Ejercicio | Carpeta |
|---|-----------|---------|
| 07 | Métodos | [`nivel-02-basico/ejercicio-01-metodos`](./nivel-02-basico/ejercicio-01-metodos/) |
| 08 | Clases y objetos | [`nivel-02-basico/ejercicio-02-clases-y-objetos`](./nivel-02-basico/ejercicio-02-clases-y-objetos/) |
| 09 | Propiedades | [`nivel-02-basico/ejercicio-03-propiedades`](./nivel-02-basico/ejercicio-03-propiedades/) |
| 10 | Listas y diccionarios | [`nivel-02-basico/ejercicio-04-listas-y-diccionarios`](./nivel-02-basico/ejercicio-04-listas-y-diccionarios/) |
| 11 | Excepciones | [`nivel-02-basico/ejercicio-05-excepciones`](./nivel-02-basico/ejercicio-05-excepciones/) |
| 12 | Enums | [`nivel-02-basico/ejercicio-06-enums`](./nivel-02-basico/ejercicio-06-enums/) |

## Nivel 03 — Intermedio (3/5)

Herencia y polimorfismo, interfaces, genéricos, LINQ básico, delegados y eventos, nullables.

| # | Ejercicio | Carpeta |
|---|-----------|---------|
| 13 | Herencia | [`nivel-03-intermedio/ejercicio-01-herencia`](./nivel-03-intermedio/ejercicio-01-herencia/) |
| 14 | Interfaces | [`nivel-03-intermedio/ejercicio-02-interfaces`](./nivel-03-intermedio/ejercicio-02-interfaces/) |
| 15 | Genéricos | [`nivel-03-intermedio/ejercicio-03-generics`](./nivel-03-intermedio/ejercicio-03-generics/) |
| 16 | LINQ básico | [`nivel-03-intermedio/ejercicio-04-linq-basico`](./nivel-03-intermedio/ejercicio-04-linq-basico/) |
| 17 | Delegados y eventos | [`nivel-03-intermedio/ejercicio-05-delegados-y-eventos`](./nivel-03-intermedio/ejercicio-05-delegados-y-eventos/) |
| 18 | Nullables | [`nivel-03-intermedio/ejercicio-06-nullables`](./nivel-03-intermedio/ejercicio-06-nullables/) |

## Nivel 04 — Avanzado (4/5)

Async/await, LINQ avanzado, extension methods, tuplas, testing y reflection.

| # | Ejercicio | Carpeta |
|---|-----------|---------|
| 19 | Async/await | [`nivel-04-avanzado/ejercicio-01-async-await`](./nivel-04-avanzado/ejercicio-01-async-await/) |
| 20 | LINQ avanzado | [`nivel-04-avanzado/ejercicio-02-linq-avanzado`](./nivel-04-avanzado/ejercicio-02-linq-avanzado/) |
| 21 | Extension methods | [`nivel-04-avanzado/ejercicio-03-extension-methods`](./nivel-04-avanzado/ejercicio-03-extension-methods/) |
| 22 | Tuplas | [`nivel-04-avanzado/ejercicio-04-tuplas`](./nivel-04-avanzado/ejercicio-04-tuplas/) |
| 23 | Testing | [`nivel-04-avanzado/ejercicio-05-testing`](./nivel-04-avanzado/ejercicio-05-testing/) |
| 24 | Reflection | [`nivel-04-avanzado/ejercicio-06-reflection`](./nivel-04-avanzado/ejercicio-06-reflection/) |

## Nivel 05 — Experto (5/5)

Gestor de tareas CLI, servidor HTTP, API REST mínima, caché LRU, mini proyecto y patrones de diseño.

| # | Ejercicio | Carpeta |
|---|-----------|---------|
| 25 | Gestor de tareas CLI | [`nivel-05-experto/ejercicio-01-gestor-de-tareas-cli`](./nivel-05-experto/ejercicio-01-gestor-de-tareas-cli/) |
| 26 | Servidor HTTP | [`nivel-05-experto/ejercicio-02-servidor-http`](./nivel-05-experto/ejercicio-02-servidor-http/) |
| 27 | API REST mínima | [`nivel-05-experto/ejercicio-03-api-rest-minima`](./nivel-05-experto/ejercicio-03-api-rest-minima/) |
| 28 | Caché LRU | [`nivel-05-experto/ejercicio-04-cache-lru`](./nivel-05-experto/ejercicio-04-cache-lru/) |
| 29 | Mini proyecto (biblioteca) | [`nivel-05-experto/ejercicio-05-mini-proyecto`](./nivel-05-experto/ejercicio-05-mini-proyecto/) |
| 30 | Patrones de diseño | [`nivel-05-experto/ejercicio-06-patrones-de-diseno`](./nivel-05-experto/ejercicio-06-patrones-de-diseno/) |

## Proyecto Final

[**Sistema de Gestión de Biblioteca**](proyectos/proyecto-final/README.md) — LINQ, async/await,
persistencia JSON, validaciones, reportes y tests. Incluye `starter/` con el andamiaje
(Program.cs, modelos, servicios y repositorios con `TODO`s) y `tests/` con una suite de
tests de referencia.