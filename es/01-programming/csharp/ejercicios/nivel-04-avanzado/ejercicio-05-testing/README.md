# Ejercicio 05 — Testing

- **Nivel:** 4/5
- **Tema:** mini framework de tests, `Func<bool>`, tolerancia de comparación, TDD
- **Tiempo estimado:** 35 min

## Enunciado

Completa `Program.cs`. Este ejercicio construye un **mini framework de tests** similar al runner que usas en todos los ejercicios.

1. `int Sumar(int a, int b)`, `int Restar(int a, int b)`, `int Multiplicar(int a, int b)` — operaciones básicas.
2. `ResultadoTest EjecutarTest(string nombre, Func<bool> prueba)` — ejecuta la prueba y devuelve `Paso = true/false`; si lanza excepción, devuelve `Paso = false`.
3. `List<ResultadoTest> EjecutarSuite()` — devuelve 4 tests que **deben pasar**: suma, resta, multiplicación y una comparación aproximada (`10.0 / 3.0 ≈ 3.3333`).
4. `bool CasiIgual(double a, double b, double tolerancia = 0.0001)` — `Math.Abs(a - b) <= tolerancia`.
5. `int ContarAprobados(List<ResultadoTest> resultados)` — cuenta los `Paso = true`.

Salida esperada de ejemplo:

```
[OK]   EjecutarSuite() devuelve 4 tests y todos pasan
[OK]   CasiIgual(0.1 + 0.2, 0.3) es true
[OK]   ContarAprobados cuenta solo los que pasan
```

## Requisitos

- [ ] `EjecutarTest` captura excepciones y las convierte en `Paso = false`.
- [ ] `EjecutarSuite` devuelve exactamente 4 resultados y todos con `Paso = true`.
- [ ] `CasiIgual(0.1 + 0.2, 0.3)` es `true` (los `double` no se comparan con `==`).
- [ ] `ContarAprobados` solo cuenta los que pasan.
- [ ] Los tests pasan: `csc Program.cs ProgramTest.cs && mono ProgramTest.exe` (si tienes Mono/csc).
- [ ] Los tests pasan: `dotnet run` (con el .NET SDK instalado).

> **Cómo ejecutar los tests**
>
> Con el **.NET SDK** (recomendado), desde la carpeta del ejercicio:
>
> ```bash
> dotnet run
> ```
>
> Con **Mono/csc**:
>
> ```bash
> csc Program.cs ProgramTest.cs
> mono ProgramTest.exe
> ```
>
> El runner devuelve `0` si todos los tests pasan y `1` si falla alguno.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `Math.Abs(a - b) <= tolerancia` evita errores de redondeo de los `double`.
- En `EjecutarSuite`, cada elemento es `EjecutarTest("Nombre", () => Condicion())`.
- `resultados.Count(r => r.Paso)` cuenta los aprobados (con `using System.Linq;`).

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````csharp
using System;
using System.Collections.Generic;
using System.Linq;

public class ResultadoTest
{
    public string Nombre { get; }
    public bool Paso { get; }

    public ResultadoTest(string nombre, bool paso)
    {
        Nombre = nombre;
        Paso = paso;
    }
}

public static class Ejercicio05
{
    public static int Sumar(int a, int b) => a + b;
    public static int Restar(int a, int b) => a - b;
    public static int Multiplicar(int a, int b) => a * b;

    public static ResultadoTest EjecutarTest(string nombre, Func<bool> prueba)
    {
        try
        {
            return new ResultadoTest(nombre, prueba());
        }
        catch (Exception)
        {
            return new ResultadoTest(nombre, false);
        }
    }

    public static List<ResultadoTest> EjecutarSuite()
    {
        return new List<ResultadoTest>
        {
            EjecutarTest("Suma: 2 + 2 = 4", () => Sumar(2, 2) == 4),
            EjecutarTest("Resta: 10 - 4 = 6", () => Restar(10, 4) == 6),
            EjecutarTest("Multiplicación: 3 * 4 = 12", () => Multiplicar(3, 4) == 12),
            EjecutarTest("División aproximada: 10/3 ≈ 3.3333", () => CasiIgual(10.0 / 3.0, 3.3333, 0.001))
        };
    }

    public static bool CasiIgual(double a, double b, double tolerancia = 0.0001)
        => Math.Abs(a - b) <= tolerancia;

    public static int ContarAprobados(List<ResultadoTest> resultados)
        => resultados.Count(r => r.Paso);
}
````

</details>