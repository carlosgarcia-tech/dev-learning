# Ejercicio 04 — Tuplas

- **Nivel:** 4/5
- **Tema:** `ValueTuple`, tuplas con nombre, deconstruction
- **Tiempo estimado:** 30 min

## Enunciado

Completa `Program.cs` para que `Ejercicio04` implemente:

1. `(int menor, int mayor) MinimoYMaximo(int[] numeros)` — el mínimo y el máximo.
2. `(string nombre, int edad) CrearPersona(string nombre, int edad)` — devuelve ambos valores.
3. `(int suma, int cuenta, double promedio) Estadisticas(List<int> numeros)` — suma, cantidad y media (0.0 si la lista está vacía).
4. `(int cociente, int resto) DividirConResto(int a, int b)` — división entera con resto.

Los tests usan **deconstruction**: `var (menor, mayor) = ...`.

Salida esperada de ejemplo:

```
[OK]   MinimoYMaximo([4,9,2,7]) devuelve (2, 9)
[OK]   CrearPersona("Ana", 30).edad devuelve 30
[OK]   DividirConResto(17, 5) devuelve (3, 2)
```

## Requisitos

- [ ] Las tuplas usan nombres de campo (`menor`, `mayor`, `nombre`, `edad`, …).
- [ ] `Estadisticas` devuelve un promedio correcto y `0.0` para lista vacía.
- [ ] `DividirConResto(17, 5)` devuelve `(3, 2)`.
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

- Para devolver una tupla con nombre: `return (numeros.Min(), numeros.Max());` y el tipo declara los nombres.
- Deconstruction: `var (menor, mayor) = Ejercicio04.MinimoYMaximo(arr);`.
- `(double)suma / cuenta` fuerza división decimal; en `Estadisticas` evita dividir entre 0.

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
    public static (int menor, int mayor) MinimoYMaximo(int[] numeros)
        => (numeros.Min(), numeros.Max());

    public static (string nombre, int edad) CrearPersona(string nombre, int edad)
        => (nombre, edad);

    public static (int suma, int cuenta, double promedio) Estadisticas(List<int> numeros)
    {
        int suma = numeros.Sum();
        int cuenta = numeros.Count;
        double promedio = cuenta > 0 ? (double)suma / cuenta : 0.0;
        return (suma, cuenta, promedio);
    }

    public static (int cociente, int resto) DividirConResto(int a, int b)
        => (a / b, a % b);
}
````

</details>