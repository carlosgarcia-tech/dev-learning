# Ejercicio 03 — Operadores y condicionales

- **Nivel:** 1/5
- **Tema:** operadores aritméticos, `%`, condicionales, operador ternario
- **Tiempo estimado:** 20 min

## Enunciado

Completa `Program.cs` para que `Ejercicio03` implemente:

1. `int Sumar(int a, int b)` — suma dos números.
2. `bool EsPar(int n)` — devuelve `true` si `n` es divisible entre 2 (`n % 2 == 0`).
3. `string Clasificar(int n)` — devuelve `Positivo`, `Negativo` o `Cero` según el signo.
4. `int MayorDeTres(int a, int b, int c)` — devuelve el mayor de los tres.
5. `bool PuedeConducir(int edad)` — `true` si la edad es mayor o igual a 18.

Salida esperada de ejemplo:

```
[OK]   Sumar(2, 3) devuelve 5
[OK]   EsPar(4) es true
[OK]   EsPar(7) es false
[OK]   Clasificar(0) devuelve "Cero"
```

## Requisitos

- [ ] `Sumar` usa el operador `+`.
- [ ] `EsPar` usa el operador módulo `%`.
- [ ] `Clasificar` usa `if/else if/else` o un `switch` con pattern matching.
- [ ] `MayorDeTres` funciona con el mayor en cualquier posición.
- [ ] `PuedeConducir` devuelve `true` a partir de 18 años.
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

- `n % 2` devuelve 0 para pares.
- `Math.Max(a, b)` devuelve el mayor de dos números; anida dos llamadas para tres.
- Puedes usar el ternario: `edad >= 18 ? true : false` (aunque basta con `edad >= 18`).

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````csharp
using System;

public static class Ejercicio03
{
    public static int Sumar(int a, int b) => a + b;

    public static bool EsPar(int n) => n % 2 == 0;

    public static string Clasificar(int n)
    {
        if (n > 0) return "Positivo";
        if (n < 0) return "Negativo";
        return "Cero";
    }

    public static int MayorDeTres(int a, int b, int c)
        => Math.Max(Math.Max(a, b), c);

    public static bool PuedeConducir(int edad) => edad >= 18;
}
````

</details>