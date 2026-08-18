# Ejercicio 03 — Genéricos

- **Nivel:** 3/5
- **Tema:** `T`, restricciones (`where T : IComparable<T>`), `EqualityComparer<T>`
- **Tiempo estimado:** 30 min

## Enunciado

Completa `Program.cs`. Se define la clase genérica `Caja<T>` (ya implementada). Implementa en `Ejercicio03`:

1. `T Mayor<T>(T a, T b) where T : IComparable<T>` — devuelve el mayor usando `a.CompareTo(b)`.
2. `Caja<T> CrearCaja<T>(T valor)` — envuelve el valor en una caja.
3. `int Contar<T>(List<T> lista, T elemento)` — cuenta las coincidencias con `EqualityComparer<T>.Default.Equals(...)`.
4. `T Ultimo<T>(List<T> lista)` — último elemento, o `InvalidOperationException` si está vacía.

Salida esperada de ejemplo:

```
[OK]   Mayor(3, 5) devuelve 5
[OK]   Mayor("abc", "abd") devuelve "abd"
[OK]   CrearCaja(42).Valor es 42
[OK]   Contar([1,2,1,3,1], 1) devuelve 3
[OK]   Ultimo(lista vacía) lanza InvalidOperationException
```

## Requisitos

- [ ] `Mayor` funciona con `int` y con `string`.
- [ ] `CrearCaja` devuelve una `Caja<T>` con el valor correcto.
- [ ] `Contar` funciona con `int` y con `string`.
- [ ] `Ultimo` lanza `InvalidOperationException` con listas vacías.
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

- `a.CompareTo(b) >= 0` significa que `a` es mayor o igual que `b`.
- `EqualityComparer<T>.Default` sirve para comparar valores de cualquier tipo `T`.
- `lista[lista.Count - 1]` accede al último elemento.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````csharp
using System;
using System.Collections.Generic;
using System.Linq;

public class Caja<T>
{
    public T Valor { get; }

    public Caja(T valor)
    {
        Valor = valor;
    }
}

public static class Ejercicio03
{
    public static T Mayor<T>(T a, T b) where T : IComparable<T>
        => a.CompareTo(b) >= 0 ? a : b;

    public static Caja<T> CrearCaja<T>(T valor) => new Caja<T>(valor);

    public static int Contar<T>(List<T> lista, T elemento)
        => lista.Count(x => EqualityComparer<T>.Default.Equals(x, elemento));

    public static T Ultimo<T>(List<T> lista)
    {
        if (lista.Count == 0)
            throw new InvalidOperationException("La lista está vacía.");
        return lista[lista.Count - 1];
    }
}
````

</details>