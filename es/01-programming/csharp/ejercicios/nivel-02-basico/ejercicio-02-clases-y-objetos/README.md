# Ejercicio 02 — Clases y objetos

- **Nivel:** 2/5
- **Tema:** clases, constructores, propiedades de solo lectura, instancias
- **Tiempo estimado:** 25 min

## Enunciado

Completa `Program.cs`. Define la clase `Persona` con:

1. Propiedades `string Nombre` y `int Edad` (solo lectura, asignadas en el constructor).
2. `Persona(string nombre, int edad)` — constructor que asigna las propiedades.
3. `string Saludar()` — devuelve `Hola, soy <Nombre>`.
4. `bool EsMayorDeEdad()` — `true` si `Edad >= 18`.

Además, `Ejercicio02` debe exponer:

5. `Persona CrearPersona(string nombre, int edad)` — crea y devuelve una nueva `Persona`.

Salida esperada de ejemplo:

```
[OK]   CrearPersona("Ana", 30).Nombre es "Ana"
[OK]   CrearPersona("Ana", 30).Saludar() devuelve "Hola, soy Ana"
[OK]   EsMayorDeEdad() es true con 30 y false con 17
```

## Requisitos

- [ ] `Nombre` y `Edad` se asignan en el constructor.
- [ ] `Saludar()` usa interpolación.
- [ ] `EsMayorDeEdad()` devuelve `true` para 18 o más.
- [ ] `CrearPersona` devuelve una instancia con los datos indicados.
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

- Las propiedades de solo lectura se declaran con `{ get; }` y se asignan solo en el constructor.
- El constructor se llama igual que la clase y no lleva tipo de retorno.
- Para crear la instancia: `return new Persona(nombre, edad);`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````csharp
using System;

public class Persona
{
    public string Nombre { get; }
    public int Edad { get; }

    public Persona(string nombre, int edad)
    {
        Nombre = nombre;
        Edad = edad;
    }

    public string Saludar() => $"Hola, soy {Nombre}";

    public bool EsMayorDeEdad() => Edad >= 18;
}

public static class Ejercicio02
{
    public static Persona CrearPersona(string nombre, int edad)
        => new Persona(nombre, edad);
}
````

</details>