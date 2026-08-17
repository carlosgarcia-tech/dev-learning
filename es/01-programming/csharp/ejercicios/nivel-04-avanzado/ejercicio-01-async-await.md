# Ejercicio 01 — Async/await

- **Nivel:** 4/5
- **Tema:** `async`, `await`, `Task<T>`, `Task.Delay`, `Task.WhenAll`
- **Tiempo estimado:** 35 min

## Enunciado

Completa `ejercicio-01-async-await.cs` para que `Ejercicio01` implemente:

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
- [ ] Los tests pasan: `csc ejercicio-01-async-await.cs ejercicio-01-async-await_test.cs && mono ejercicio-01-async-await_test.exe` (si tienes Mono/csc).
- [ ] Los tests pasan: `dotnet run` (al instalar el .NET SDK).

> **Nota:** el .NET SDK **no está instalado** en esta máquina. Con el SDK instalado:
> ```bash
> dotnet new console -o . --force
> rm Program.cs
> dotnet run
> ```
> Con Mono/csc: `csc ejercicio-01-async-await.cs ejercicio-01-async-await_test.cs` y `mono ejercicio-01-async-await_test.exe`.

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