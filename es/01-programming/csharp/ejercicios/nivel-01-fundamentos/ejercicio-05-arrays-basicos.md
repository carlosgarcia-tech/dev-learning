# Ejercicio 05 — Arrays básicos

- **Nivel:** 1/5
- **Tema:** arrays, `Length`, LINQ (`Sum`, `Max`, `Reverse`, `Where`, `Average`)
- **Tiempo estimado:** 20 min

## Enunciado

Completa `ejercicio-05-arrays-basicos.cs` para que `Ejercicio05` implemente:

1. `int Suma(int[] numeros)` — suma de todos los elementos.
2. `int Maximo(int[] numeros)` — el mayor de la colección.
3. `int[] Invertir(int[] numeros)` — nuevo array con los elementos en orden inverso.
4. `int[] FiltrarPares(int[] numeros)` — solo los números pares, en el mismo orden.
5. `double Promedio(int[] numeros)` — la media aritmética.

Puedes usar LINQ (`using System.Linq;`): `Sum()`, `Max()`, `Reverse()`, `Where(...)`, `Average()`.

Salida esperada de ejemplo:

```
[OK]   Suma([1,2,3,4]) devuelve 10
[OK]   Maximo([3,9,2]) devuelve 9
[OK]   Invertir([1,2,3]) devuelve [3,2,1]
```

## Requisitos

- [ ] `Suma`, `Maximo` y `Promedio` funcionan con arrays de distintos tamaños.
- [ ] `Invertir` devuelve un **nuevo** array (no modifica el original).
- [ ] `FiltrarPares([1,2,3,4,5,6])` devuelve `[2,4,6]`.
- [ ] `Promedio([2,4,6])` devuelve `4.0`.
- [ ] Los tests pasan: `csc ejercicio-05-arrays-basicos.cs ejercicio-05-arrays-basicos_test.cs && mono ejercicio-05-arrays-basicos_test.exe` (si tienes Mono/csc).
- [ ] Los tests pasan: `dotnet run` (al instalar el .NET SDK).

> **Nota:** el .NET SDK **no está instalado** en esta máquina. Con el SDK instalado:
> ```bash
> dotnet new console -o . --force
> rm Program.cs
> dotnet run
> ```
> Con Mono/csc: `csc ejercicio-05-arrays-basicos.cs ejercicio-05-arrays-basicos_test.cs` y `mono ejercicio-05-arrays-basicos_test.exe`.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `numeros.Reverse().ToArray()` devuelve un array invertido sin tocar el original.
- `numeros.Where(n => n % 2 == 0).ToArray()` filtra pares.
- `Average()` devuelve `double`; compara con `4.0`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````csharp
using System.Linq;

public static class Ejercicio05
{
    public static int Suma(int[] numeros) => numeros.Sum();

    public static int Maximo(int[] numeros) => numeros.Max();

    public static int[] Invertir(int[] numeros) => numeros.Reverse().ToArray();

    public static int[] FiltrarPares(int[] numeros)
        => numeros.Where(n => n % 2 == 0).ToArray();

    public static double Promedio(int[] numeros) => numeros.Average();
}
````

</details>