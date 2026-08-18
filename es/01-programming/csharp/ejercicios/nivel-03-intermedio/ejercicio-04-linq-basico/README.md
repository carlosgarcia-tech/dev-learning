# Ejercicio 04 — LINQ básico

- **Nivel:** 3/5
- **Tema:** `Where`, `Select`, `OrderBy`, `GroupBy`, `Sum`, `First`
- **Tiempo estimado:** 30 min

## Enunciado

Completa `Program.cs` para que `Ejercicio04` implemente usando **LINQ** (`using System.Linq;`):

1. `List<string> NombresLargos(List<string> nombres, int longitudMinima)` — `Where(n => n.Length >= longitudMinima)`.
2. `int[] ParesOrdenados(int[] numeros)` — `Where` + `OrderBy`.
3. `int SumaDeCuadrados(List<int> numeros)` — `Select(n => n * n).Sum()`.
4. `Dictionary<string,int> ContarPorInicial(List<string> nombres)` — `GroupBy` por primera letra y `Count`.
5. `string NombreMasLargo(List<string> nombres)` — `OrderByDescending(n => n.Length).First()`.

Salida esperada de ejemplo:

```
[OK]   NombresLargos(["Ana","Roberto","Laura"], 5) devuelve ["Roberto","Laura"]
[OK]   ParesOrdenados([7,2,8,1,4]) devuelve [2,4,8]
[OK]   SumaDeCuadrados([1,2,3]) devuelve 14
[OK]   NombreMasLargo(["Ana","Roberto","Iván"]) devuelve "Roberto"
```

## Requisitos

- [ ] `NombresLargos` usa `Where`.
- [ ] `ParesOrdenados` filtra pares y los ordena.
- [ ] `SumaDeCuadrados([1,2,3])` devuelve `1 + 4 + 9 = 14`.
- [ ] `ContarPorInicial` usa `GroupBy`.
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

- `n[0]` da la primera letra; `n[0].ToString()` la convierte a string para la clave.
- `ToDictionary(g => g.Key, g => g.Count())` materializa un `GroupBy` en diccionario.
- Recuerda materializar con `.ToList()` o `.ToArray()`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````csharp
using System;
using System.Collections.Generic;
using System.Linq;

public static class Ejercicio04
{
    public static List<string> NombresLargos(List<string> nombres, int longitudMinima)
        => nombres.Where(n => n.Length >= longitudMinima).ToList();

    public static int[] ParesOrdenados(int[] numeros)
        => numeros.Where(n => n % 2 == 0).OrderBy(n => n).ToArray();

    public static int SumaDeCuadrados(List<int> numeros)
        => numeros.Select(n => n * n).Sum();

    public static Dictionary<string, int> ContarPorInicial(List<string> nombres)
        => nombres.GroupBy(n => n[0].ToString())
            .ToDictionary(g => g.Key, g => g.Count());

    public static string NombreMasLargo(List<string> nombres)
        => nombres.OrderByDescending(n => n.Length).First();
}
````

</details>