# Ejercicio 02 — LINQ avanzado

- **Nivel:** 4/5
- **Tema:** `SelectMany`, `yield return`, `GroupBy`, `OrderByDescending`, `ThenBy`
- **Tiempo estimado:** 35 min

## Enunciado

Completa `ejercicio-02-linq-avanzado.cs` para que `Ejercicio02` implemente:

1. `IEnumerable<int> GenerarPares(int maximo)` — con `yield return`, los pares `0, 2, 4, …, maximo`.
2. `int[] Aplanar(int[][] matrices)` — `SelectMany(m => m)`.
3. `string UnirConComa(List<string> items)` — `string.Join(", ", items)`.
4. `Dictionary<int, List<string>> AgruparPorLongitud(List<string> palabras)` — agrupa por `p.Length`.
5. `List<string> TopPalabras(string texto, int n)` — las `n` palabras más frecuentes (desempatando por orden alfabético).

Salida esperada de ejemplo:

```
[OK]   GenerarPares(10) devuelve [0,2,4,6,8,10]
[OK]   Aplanar([[1,2],[3,4]]) devuelve [1,2,3,4]
[OK]   UnirConComa(["a","b","c"]) devuelve "a, b, c"
[OK]   TopPalabras("hola hola mundo hola luna", 2) devuelve ["hola","luna"]
```

## Requisitos

- [ ] `GenerarPares` usa `yield return`.
- [ ] `Aplanar` usa `SelectMany`.
- [ ] `TopPalabras` normaliza a minúsculas y desempata alfabéticamente con `ThenBy`.
- [ ] Los tests pasan: `csc ejercicio-02-linq-avanzado.cs ejercicio-02-linq-avanzado_test.cs && mono ejercicio-02-linq-avanzado_test.exe` (si tienes Mono/csc).
- [ ] Los tests pasan: `dotnet run` (al instalar el .NET SDK).

> **Nota:** el .NET SDK **no está instalado** en esta máquina. Con el SDK instalado:
> ```bash
> dotnet new console -o . --force
> rm Program.cs
> dotnet run
> ```
> Con Mono/csc: `csc ejercicio-02-linq-avanzado.cs ejercicio-02-linq-avanzado_test.cs` y `mono ejercicio-02-linq-avanzado_test.exe`.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Un método con `yield return` NO usa `return lista`; va devolviendo de a uno.
- Para `TopPalabras`: `Split` → `Select(ToLower)` → `GroupBy` → `OrderByDescending(g.Count())` → `ThenBy(g.Key)` → `Take(n)` → `Select(g.Key)`.
- `ToDictionary(g => g.Key, g => g.ToList())` materializa el agrupamiento.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````csharp
using System;
using System.Collections.Generic;
using System.Linq;

public static class Ejercicio02
{
    public static IEnumerable<int> GenerarPares(int maximo)
    {
        for (int i = 0; i <= maximo; i += 2)
        {
            yield return i;
        }
    }

    public static int[] Aplanar(int[][] matrices)
        => matrices.SelectMany(m => m).ToArray();

    public static string UnirConComa(List<string> items)
        => string.Join(", ", items);

    public static Dictionary<int, List<string>> AgruparPorLongitud(List<string> palabras)
        => palabras.GroupBy(p => p.Length)
            .ToDictionary(g => g.Key, g => g.ToList());

    public static List<string> TopPalabras(string texto, int n)
        => texto
            .Split(' ', StringSplitOptions.RemoveEmptyEntries)
            .Select(p => p.ToLower())
            .GroupBy(p => p)
            .OrderByDescending(g => g.Count())
            .ThenBy(g => g.Key)
            .Take(n)
            .Select(g => g.Key)
            .ToList();
}
````

</details>