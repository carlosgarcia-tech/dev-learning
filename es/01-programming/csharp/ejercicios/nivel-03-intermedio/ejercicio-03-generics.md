# Ejercicio 03 — Genéricos

- **Nivel:** 3/5
- **Tema:** `T`, restricciones (`where T : IComparable<T>`), `EqualityComparer<T>`
- **Tiempo estimado:** 30 min

## Enunciado

Completa `ejercicio-03-generics.cs`. Se define la clase genérica `Caja<T>` (ya implementada). Implementa en `Ejercicio03`:

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
- [ ] Los tests pasan: `csc ejercicio-03-generics.cs ejercicio-03-generics_test.cs && mono ejercicio-03-generics_test.exe` (si tienes Mono/csc).
- [ ] Los tests pasan: `dotnet run` (al instalar el .NET SDK).

> **Nota:** el .NET SDK **no está instalado** en esta máquina. Con el SDK instalado:
> ```bash
> dotnet new console -o . --force
> rm Program.cs
> dotnet run
> ```
> Con Mono/csc: `csc ejercicio-03-generics.cs ejercicio-03-generics_test.cs` y `mono ejercicio-03-generics_test.exe`.

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