# C# — Curso Completo desde Cero hasta Experto con ASP.NET Core

Curso completo de C# en español: fundamentos, POO, LINQ, async/await,
errores y testing, y ASP.NET Core (Minimal APIs), con 30 ejercicios
progresivos y un proyecto final.

## Estructura

```
es/01-programming/csharp/
├── README.md                     (este archivo)
├── 01-fundamentos.md
├── 02-oop.md
├── 03-linq-y-colecciones.md
├── 04-async-await.md
├── 05-errores-y-testing.md
├── 06-aspnet-core.md
├── ejercicios/
│   ├── README.md
│   ├── nivel-01-fundamentos/     (6 ejercicios)
│   ├── nivel-02-basico/          (6 ejercicios)
│   ├── nivel-03-intermedio/      (6 ejercicios)
│   ├── nivel-04-avanzado/        (6 ejercicios)
│   ├── nivel-05-experto/         (6 ejercicios)
│   └── proyectos/
│       ├── README.md
│       └── proyecto-final/       (Sistema de Biblioteca)
└── resources/
```

## Guías de estudio

| # | Guía | Contenido |
|---|------|-----------|
| 1 | [Fundamentos](./01-fundamentos.md) | .NET, dotnet/csc, variables, tipos, operadores, control de flujo, arrays, strings |
| 2 | [OOP](./02-oop.md) | Clases, encapsulación, herencia, polimorfismo, interfaces, genéricos, records |
| 3 | [LINQ y colecciones](./03-linq-y-colecciones.md) | List, Dictionary, HashSet, LINQ, delegados, eventos, extension methods, tuplas |
| 4 | [Async/await](./04-async-await.md) | Task, async/await, WhenAll/WhenAny, HttpClient, JSON, cancellation tokens |
| 5 | [Errores y testing](./05-errores-y-testing.md) | Excepciones, try/catch/throw, mini framework de tests, TDD, reflection |
| 6 | [ASP.NET Core](./06-aspnet-core.md) | Minimal APIs, DI, endpoints REST, validación, manejo de errores |

## Ejercicios (30 en total, 6 por nivel)

Ver el índice completo en [`ejercicios/README.md`](./ejercicios/README.md).

| Nivel | Carpeta | Tema |
|-------|---------|------|
| 1 — Fundamentos | `ejercicios/nivel-01-fundamentos/` | Sintaxis básica |
| 2 — Básico | `ejercicios/nivel-02-basico/` | Métodos, clases, colecciones |
| 3 — Intermedio | `ejercicios/nivel-03-intermedio/` | Herencia, interfaces, LINQ |
| 4 — Avanzado | `ejercicios/nivel-04-avanzado/` | Async/await, LINQ, testing |
| 5 — Experto | `ejercicios/nivel-05-experto/` | Proyectos integradores |

Cada ejercicio incluye:
- `README.md` — enunciado, requisitos, pistas y solución
- `Program.cs` — stub con `TODO`s para completar
- `ProgramTest.cs` — suite de tests ejecutable
- `<ejercicio>.csproj` — configuración del proyecto (net8.0)

## Proyecto final

[**Sistema de Gestión de Biblioteca**](./ejercicios/proyectos/proyecto-final/README.md) —
sistema completo con modelos, repositorios, servicios, LINQ, async/await,
persistencia JSON, validaciones, reportes y tests. Incluye `starter/` (andamiaje
con `TODO`s) y `tests/` (suite de tests de referencia).

## Cómo ejecutar C#

Hay dos caminos, ambos documentados en cada ejercicio y en las guías:

```bash
# 1. Con el .NET SDK (recomendado): desde la carpeta del ejercicio
dotnet run

# 2. Con Mono/csc: compila el stub y el test juntos
csc Program.cs ProgramTest.cs -out:ProgramTest.exe
mono ProgramTest.exe
```

> **Nota:** en esta máquina **no está instalado el .NET SDK**, por lo que los tests no se han podido ejecutar aquí. El código es C# 10+ válido y está pensado para ejecutarse tal cual con el SDK o con Mono.

## Scripts

`../../../scripts/new-exercise-csharp.sh` — genera el andamiaje (README + stub + test) para un nuevo ejercicio.

## Al terminar el curso serás capaz de

1. Programar en C# con confianza
2. Aplicar POO y records en proyectos reales
3. Consultar colecciones con LINQ y delegados
4. Escribir código asíncrono con async/await
5. Desarrollar APIs REST con ASP.NET Core (Minimal APIs)
6. Escribir tests para garantizar la calidad del código