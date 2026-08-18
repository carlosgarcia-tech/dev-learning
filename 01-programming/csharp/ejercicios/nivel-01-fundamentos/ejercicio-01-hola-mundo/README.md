# Ejercicio 01 — Hola mundo

- **Nivel:** 1/5
- **Tema:** sintaxis básica, métodos estáticos, interpolación de strings
- **Tiempo estimado:** 15 min

## Enunciado

Completa el archivo `Program.cs` para que la clase estática `Ejercicio01` implemente estos métodos:

1. `string HolaMundo()` — devuelve el texto `Hola, mundo!`.
2. `string Saludar(string nombre)` — devuelve `Hola, <nombre>!`.
3. `string Despedirse(string nombre)` — devuelve `Adiós, <nombre>!`.

El archivo de tests (`ProgramTest.cs`) llama a esos métodos y verifica su salida. Con el stub actual lanza `NotImplementedException`; cuando lo completes, todos los checks deben pasar.

Salida esperada del runner de tests:

```
[OK]   HolaMundo devuelve 'Hola, mundo!'
[OK]   Saludar("Ana") devuelve 'Hola, Ana!'
...
Todos los tests pasaron.
```

## Requisitos

- [ ] La clase es `public static class Ejercicio01`.
- [ ] `HolaMundo()` devuelve exactamente `Hola, mundo!`.
- [ ] `Saludar("Ana")` devuelve `Hola, Ana!` (usa interpolación `$"..."` o concatenación).
- [ ] `Despedirse("Ana")` devuelve `Adiós, Ana!`.
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

- Usa `$"Hola, {nombre}!"` para interpolar la variable en el string.
- El carácter `á` es válido dentro de un string en C#.
- El método devuelve un `string`: usa `return` o cuerpo de expresión (`=>`).

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````csharp
using System;

public static class Ejercicio01
{
    public static string HolaMundo()
    {
        return "Hola, mundo!";
    }

    public static string Saludar(string nombre)
    {
        return $"Hola, {nombre}!";
    }

    public static string Despedirse(string nombre)
    {
        return $"Adiós, {nombre}!";
    }
}
````

</details>