# Ejercicio 06 — Strings

- **Nivel:** 1/5
- **Tema:** métodos de `string`, `ToUpper`, `Split`, `Reverse`, `Substring`
- **Tiempo estimado:** 20 min

## Enunciado

Completa `ejercicio-06-strings.cs` para que `Ejercicio06` implemente:

1. `string Mayusculas(string s)` — convierte todo a mayúsculas.
2. `int ContarPalabras(string s)` — cuenta las palabras separadas por espacios (ignora espacios sobrantes y strings vacíos).
3. `string Revertir(string s)` — devuelve el string al revés.
4. `bool EsPalindromo(string s)` — `true` si se lee igual al derecho y al revés (ignorando mayúsculas y espacios).
5. `string Capitalizar(string s)` — primera letra en mayúscula y el resto en minúscula.

Salida esperada de ejemplo:

```
[OK]   Mayusculas("hola") devuelve "HOLA"
[OK]   ContarPalabras("Hola mundo cruel") devuelve 3
[OK]   Revertir("hola") devuelve "aloh"
[OK]   EsPalindromo("Anita lava la tina") es true
```

## Requisitos

- [ ] `ContarPalabras("  ")` devuelve 0 y `ContarPalabras("a  b")` devuelve 2.
- [ ] `EsPalindromo` ignora mayúsculas y espacios.
- [ ] `Capitalizar("hOLA")` devuelve `Hola`.
- [ ] Los tests pasan: `csc ejercicio-06-strings.cs ejercicio-06-strings_test.cs && mono ejercicio-06-strings_test.exe` (si tienes Mono/csc).
- [ ] Los tests pasan: `dotnet run` (al instalar el .NET SDK).

> **Nota:** el .NET SDK **no está instalado** en esta máquina. Con el SDK instalado:
> ```bash
> dotnet new console -o . --force
> rm Program.cs
> dotnet run
> ```
> Con Mono/csc: `csc ejercicio-06-strings.cs ejercicio-06-strings_test.cs` y `mono ejercicio-06-strings_test.exe`.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `s.Split(' ', StringSplitOptions.RemoveEmptyEntries)` ignora espacios sobrantes.
- `new string(s.Reverse().ToArray())` invierte un string (necesitas `using System.Linq;`).
- Para el palíndromo: pon todo en minúsculas, quita espacios y compara con su versión invertida.
- `char.ToUpper(s[0]) + s.Substring(1).ToLower()` capitaliza.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````csharp
using System;
using System.Linq;

public static class Ejercicio06
{
    public static string Mayusculas(string s) => s.ToUpper();

    public static int ContarPalabras(string s)
    {
        if (string.IsNullOrWhiteSpace(s)) return 0;
        return s.Split(' ', StringSplitOptions.RemoveEmptyEntries).Length;
    }

    public static string Revertir(string s) => new string(s.Reverse().ToArray());

    public static bool EsPalindromo(string s)
    {
        string limpio = s.ToLower().Replace(" ", "");
        return limpio == new string(limpio.Reverse().ToArray());
    }

    public static string Capitalizar(string s)
    {
        if (string.IsNullOrWhiteSpace(s)) return s;
        return char.ToUpper(s[0]) + s.Substring(1).ToLower();
    }
}
````

</details>