# Ejercicio 01 — Métodos

- **Nivel:** 2/5
- **Tema:** parámetros opcionales, `params`, `out`, sobrecarga, cuerpos de expresión
- **Tiempo estimado:** 20 min

## Enunciado

Completa `Program.cs` para que `Ejercicio01` implemente:

1. `int Cuadrado(int x)` — devuelve `x * x`.
2. `int Duplicar(int x)` — devuelve `x * 2`.
3. `int SumarVarios(params int[] numeros)` — suma todos los números recibidos (con `params`).
4. `int SumarConOpcional(int a, int b = 10)` — suma usando el valor por defecto si no se pasa `b`.
5. `bool TryConvertir(string texto, out int resultado)` — usa `int.TryParse` para devolver el valor vía `out`.

Salida esperada de ejemplo:

```
[OK]   Cuadrado(5) devuelve 25
[OK]   SumarVarios(1,2,3) devuelve 6
[OK]   SumarConOpcional(5) usa el valor por defecto 10 -> 15
```

## Requisitos

- [ ] `Cuadrado(5)` devuelve 25.
- [ ] `SumarVarios(1, 2, 3)` devuelve 6 y `SumarVarios()` devuelve 0.
- [ ] `SumarConOpcional(5)` devuelve 15 (usa `b = 10`).
- [ ] `TryConvertir("42", out int r)` devuelve `true` con `r == 42`.
- [ ] `TryConvertir("abc", out _)` devuelve `false`.
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

- `params int[] numeros` permite llamar `SumarVarios(1, 2, 3)`.
- `int.TryParse(texto, out resultado)` devuelve `bool` y asigna `resultado` si tiene éxito.
- El sufijo `_` en `out _` descarta el valor de salida.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````csharp
using System;

public static class Ejercicio01
{
    public static int Cuadrado(int x) => x * x;

    public static int Duplicar(int x) => x * 2;

    public static int SumarVarios(params int[] numeros)
    {
        int total = 0;
        foreach (int n in numeros)
        {
            total += n;
        }
        return total;
    }

    public static int SumarConOpcional(int a, int b = 10) => a + b;

    public static bool TryConvertir(string texto, out int resultado)
    {
        return int.TryParse(texto, out resultado);
    }
}
````

</details>