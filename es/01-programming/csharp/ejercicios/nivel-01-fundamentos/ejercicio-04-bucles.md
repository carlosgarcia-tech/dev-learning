# Ejercicio 04 — Bucles

- **Nivel:** 1/5
- **Tema:** `for`, `foreach`, `while`, contadores
- **Tiempo estimado:** 20 min

## Enunciado

Completa `ejercicio-04-bucles.cs` para que `Ejercicio04` implemente:

1. `int Sumar1aN(int n)` — suma los enteros del 1 a `n` (con un bucle `for`).
2. `int Factorial(int n)` — producto de 1 × 2 × … × `n` (el factorial de 0 es 1).
3. `int[] TablaDel(int n)` — array de 10 elementos con `{ n*1, n*2, …, n*10 }`.
4. `int ContarVocales(string texto)` — cuenta `a`, `e`, `i`, `o`, `u` (sin distinguir mayúsculas).
5. `int ContarPares(int[] numeros)` — cuenta cuántos números son pares (con `foreach`).

Salida esperada de ejemplo:

```
[OK]   Sumar1aN(5) devuelve 15
[OK]   Factorial(5) devuelve 120
[OK]   TablaDel(3) tiene 10 elementos y empieza en 3
[OK]   ContarVocales("Hola Mundo") devuelve 4
```

## Requisitos

- [ ] `Sumar1aN` usa un bucle (`for` o `while`).
- [ ] `Factorial(0)` devuelve 1.
- [ ] `TablaDel(3)[0] == 3` y `TablaDel(3)[9] == 30`.
- [ ] `ContarVocales` ignora mayúsculas/minúsculas.
- [ ] `ContarPares` usa `foreach`.
- [ ] Los tests pasan: `csc ejercicio-04-bucles.cs ejercicio-04-bucles_test.cs && mono ejercicio-04-bucles_test.exe` (si tienes Mono/csc).
- [ ] Los tests pasan: `dotnet run` (al instalar el .NET SDK).

> **Nota:** el .NET SDK **no está instalado** en esta máquina. Con el SDK instalado:
> ```bash
> dotnet new console -o . --force
> rm Program.cs
> dotnet run
> ```
> Con Mono/csc: `csc ejercicio-04-bucles.cs ejercicio-04-bucles_test.cs` y `mono ejercicio-04-bucles_test.exe`.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Para recorrer un string puedes usar `foreach (char c in texto)`.
- Compara caracteres en minúsculas: `char.ToLower(c)` o convierte todo el texto antes.
- La tabla tiene tamaño fijo: `new int[10]`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````csharp
using System;

public static class Ejercicio04
{
    public static int Sumar1aN(int n)
    {
        int total = 0;
        for (int i = 1; i <= n; i++)
        {
            total += i;
        }
        return total;
    }

    public static int Factorial(int n)
    {
        int resultado = 1;
        for (int i = 2; i <= n; i++)
        {
            resultado *= i;
        }
        return resultado;
    }

    public static int[] TablaDel(int n)
    {
        int[] tabla = new int[10];
        for (int i = 0; i < 10; i++)
        {
            tabla[i] = n * (i + 1);
        }
        return tabla;
    }

    public static int ContarVocales(string texto)
    {
        int contador = 0;
        foreach (char c in texto.ToLower())
        {
            if (c == 'a' || c == 'e' || c == 'i' || c == 'o' || c == 'u')
            {
                contador++;
            }
        }
        return contador;
    }

    public static int ContarPares(int[] numeros)
    {
        int contador = 0;
        foreach (int n in numeros)
        {
            if (n % 2 == 0)
            {
                contador++;
            }
        }
        return contador;
    }
}
````

</details>