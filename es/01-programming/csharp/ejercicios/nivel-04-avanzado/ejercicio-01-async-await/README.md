# Ejercicio 01 — Async/await

- **Nivel:** 4/5
- **Tema:** `async`, `await`, `Task<T>`, `Task.Delay`, `Task.WhenAll`
- **Tiempo estimado:** 35 min

## Enunciado

Completa `Program.cs` para que `Ejercicio01` implemente:

1. `async Task<int> DuplicarAsync(int x)` — espera `Task.Delay(10)` y devuelve `x * 2`.
2. `async Task<string> ConcatenarAsync(string a, string b)` — espera `Task.Delay(10)` y devuelve `a + b`.
3. `async Task<int> SumarConRetrasoAsync(int a, int b)` — espera `Task.Delay(10)` y devuelve `a + b`.
4. `async Task<List<int>> DuplicarTodosAsync(List<int> numeros)` — lanza todas las `DuplicarAsync` en paralelo y las espera con `Task.WhenAll`.

Los tests esperan cada `Task` de forma bloqueante con `.GetAwaiter().GetResult()`.

Salida esperada de ejemplo:

```
[OK]   DuplicarAsync(21) devuelve 42
[OK]   ConcatenarAsync("Hola ", "mundo") devuelve "Hola mundo"
[OK]   DuplicarTodosAsync([1,2,3]) devuelve [2,4,6]
```

## Requisitos

- [ ] Cada método asíncrono usa `await Task.Delay(10)`.
- [ ] `DuplicarTodosAsync` usa `Task.WhenAll` (no espera uno a uno).
- [ ] Los tipos de retorno son `Task<int>`, `Task<string>` y `Task<List<int>>`.
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

- `numeros.Select(DuplicarAsync).ToList()` crea todas las tareas sin esperarlas.
- `await Task.WhenAll(tareas)` espera que terminen todas y devuelve `int[]`.
- `tareas.Select(n => DuplicarAsync(n))` necesita `using System.Linq;`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````csharp
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

public static class Ejercicio01
{
    public static async Task<int> DuplicarAsync(int x)
    {
        await Task.Delay(10);
        return x * 2;
    }

    public static async Task<string> ConcatenarAsync(string a, string b)
    {
        await Task.Delay(10);
        return a + b;
    }

    public static async Task<int> SumarConRetrasoAsync(int a, int b)
    {
        await Task.Delay(10);
        return a + b;
    }

    public static async Task<List<int>> DuplicarTodosAsync(List<int> numeros)
    {
        var tareas = numeros.Select(DuplicarAsync).ToList();
        int[] resultados = await Task.WhenAll(tareas);
        return resultados.ToList();
    }
}
````

</details>