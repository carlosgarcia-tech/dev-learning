# Ejercicio 03 — Extension methods

- **Nivel:** 4/5
- **Tema:** extension methods (`this`), clases estáticas, encadenado
- **Tiempo estimado:** 30 min

## Enunciado

Completa `Program.cs`. Crea:

1. `ExtensionesString.ContarPalabras(this string s)` — cuenta palabras separadas por espacios.
2. `ExtensionesString.AlReves(this string s)` — el string invertido.
3. `ExtensionesNumeros.EsPar(this int n)` — `true` si `n % 2 == 0`.
4. `ExtensionesNumeros.Cuadrado(this int n)` — `n * n`.

Y en `Ejercicio03`:

5. `int ContarPalabras(string s)` — delega en `s.ContarPalabras()`.
6. `List<int> CuadradosPares(List<int> numeros)` — usa `n.EsPar()` y `n.Cuadrado()`.
7. `int[] FiltrarPares(int[] numeros)` — usa `n.EsPar()`.

Salida esperada de ejemplo:

```
[OK]   "Hola mundo cruel".ContarPalabras() devuelve 3
[OK]   "hola".AlReves() devuelve "aloh"
[OK]   4.EsPar() es true y 7.EsPar() es false
[OK]   CuadradosPares([2,3,4]) devuelve [4,16]
```

## Requisitos

- [ ] La clase de extensiones es `static` y el primer parámetro lleva `this`.
- [ ] `CuadradosPares` usa las extensiones `EsPar` y `Cuadrado`.
- [ ] `FiltrarPares` usa la extensión `EsPar`.
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

- Las extensiones viven en el espacio de nombres global de este archivo, así que el test las ve directamente.
- En el test se llaman como método normal: `"hola".AlReves()`.
- Para `CuadradosPares`: `Where(n => n.EsPar()).Select(n => n.Cuadrado())`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````csharp
using System;
using System.Collections.Generic;
using System.Linq;

public static class ExtensionesString
{
    public static int ContarPalabras(this string s)
    {
        if (string.IsNullOrWhiteSpace(s)) return 0;
        return s.Split(' ', StringSplitOptions.RemoveEmptyEntries).Length;
    }

    public static string AlReves(this string s) => new string(s.Reverse().ToArray());
}

public static class ExtensionesNumeros
{
    public static bool EsPar(this int n) => n % 2 == 0;
    public static int Cuadrado(this int n) => n * n;
}

public static class Ejercicio03
{
    public static int ContarPalabras(string s) => s.ContarPalabras();

    public static List<int> CuadradosPares(List<int> numeros)
        => numeros.Where(n => n.EsPar()).Select(n => n.Cuadrado()).ToList();

    public static int[] FiltrarPares(int[] numeros)
        => numeros.Where(n => n.EsPar()).ToArray();
}
````

</details>