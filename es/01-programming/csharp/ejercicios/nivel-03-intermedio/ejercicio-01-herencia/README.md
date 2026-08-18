# Ejercicio 01 — Herencia y polimorfismo

- **Nivel:** 3/5
- **Tema:** `class` derivada, `virtual`/`override`, `base`, polimorfismo
- **Tiempo estimado:** 30 min

## Enunciado

Completa `Program.cs`. Define la jerarquía:

1. `Animal` — con `string Nombre` (constructor) y método `virtual string HacerSonido()` que devuelve `Sonido genérico`.
2. `Perro : Animal` — `override HacerSonido()` devuelve `Guau`.
3. `Gato : Animal` — `override HacerSonido()` devuelve `Miau`.

En `Ejercicio01` implementa:

4. `Animal CrearAnimal(string tipo, string nombre)` — `"perro"` → `Perro`, `"gato"` → `Gato`, cualquier otro → `Animal`.
5. `string SonidoDe(Animal animal)` — devuelve `animal.HacerSonido()`.

Salida esperada de ejemplo:

```
[OK]   CrearAnimal("perro", "Rex") es una instancia de Perro
[OK]   SonidoDe(perro) devuelve "Guau"
[OK]   SonidoDe(gato) devuelve "Miau"
[OK]   SonidoDe(Animal("Fido")) devuelve "Sonido genérico"
```

## Requisitos

- [ ] `Perro` y `Gato` heredan de `Animal` y usan `base(nombre)`.
- [ ] `HacerSonido` es `virtual` en la base y `override` en las derivadas.
- [ ] El polimorfismo funciona: llamar `SonidoDe` con un `Animal` devuelve el sonido real de la instancia.
- [ ] `CrearAnimal` distingue por el string `tipo` (comparación sin distinguir mayúsculas recomendada).
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

- `tipo.ToLower() == "perro"` para comparar sin distinguir mayúsculas.
- `animal is Perro` comprueba si la instancia es de ese tipo (útil en los tests).
- En el test, `SonidoDe` recibe un `Animal` pero la instancia real es `Perro`/`Gato` (polimorfismo).

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````csharp
using System;

public class Animal
{
    public string Nombre { get; }

    public Animal(string nombre)
    {
        Nombre = nombre;
    }

    public virtual string HacerSonido() => "Sonido genérico";
}

public class Perro : Animal
{
    public Perro(string nombre) : base(nombre) { }

    public override string HacerSonido() => "Guau";
}

public class Gato : Animal
{
    public Gato(string nombre) : base(nombre) { }

    public override string HacerSonido() => "Miau";
}

public static class Ejercicio01
{
    public static Animal CrearAnimal(string tipo, string nombre)
    {
        switch (tipo.ToLower())
        {
            case "perro": return new Perro(nombre);
            case "gato": return new Gato(nombre);
            default: return new Animal(nombre);
        }
    }

    public static string SonidoDe(Animal animal) => animal.HacerSonido();
}
````

</details>