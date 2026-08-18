# Ejercicio 05 — Excepciones

- **Nivel:** 2/5
- **Tema:** `try/catch`, `throw`, excepciones del framework
- **Tiempo estimado:** 25 min

## Enunciado

Completa `Program.cs` para que `Ejercicio05` implemente:

1. `double Dividir(double a, double b)` — si `b == 0` lanza `ArgumentException`; si no, `a / b`.
2. `int ParsearEntero(string texto)` — `int.Parse(texto)` (deja que `FormatException` salga naturalmente con texto inválido).
3. `string ObtenerConfiguracion(Dictionary<string,string> config, string clave)` — si la clave no existe lanza `KeyNotFoundException`; si no, devuelve su valor.
4. `int Calcular(string operacion, int a, int b)`:
   - `"+"` suma, `"-"` resta, `"*"` multiplica.
   - `"/"` divide (lanza `ArgumentException` si `b == 0`).
   - Cualquier otra operación lanza `InvalidOperationException`.

Salida esperada de ejemplo:

```
[OK]   Dividir(10, 2) devuelve 5
[OK]   Dividir(10, 0) lanza ArgumentException
[OK]   ParsearEntero("42") devuelve 42
[OK]   ParsearEntero("abc") lanza FormatException
```

## Requisitos

- [ ] `Dividir` lanza `ArgumentException` con divisor cero.
- [ ] `ParsearEntero("abc")` lanza `FormatException`.
- [ ] `ObtenerConfiguracion` con clave inexistente lanza `KeyNotFoundException`.
- [ ] `Calcular` con operación desconocida lanza `InvalidOperationException`.
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

- `throw new ArgumentException("mensaje");` crea y lanza la excepción.
- `int.Parse` ya lanza `FormatException` cuando el texto no es numérico.
- Para verificar excepciones en el test se usa `try/catch` y se comprueba el tipo capturado.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````csharp
using System;
using System.Collections.Generic;

public static class Ejercicio05
{
    public static double Dividir(double a, double b)
    {
        if (b == 0)
            throw new ArgumentException("No se puede dividir por cero.");
        return a / b;
    }

    public static int ParsearEntero(string texto) => int.Parse(texto);

    public static string ObtenerConfiguracion(Dictionary<string, string> config, string clave)
    {
        if (!config.ContainsKey(clave))
            throw new KeyNotFoundException("Clave no encontrada: " + clave);
        return config[clave];
    }

    public static int Calcular(string operacion, int a, int b)
    {
        switch (operacion)
        {
            case "+":
                return a + b;
            case "-":
                return a - b;
            case "*":
                return a * b;
            case "/":
                if (b == 0)
                    throw new ArgumentException("No se puede dividir por cero.");
                return a / b;
            default:
                throw new InvalidOperationException("Operación desconocida: " + operacion);
        }
    }
}
````

</details>