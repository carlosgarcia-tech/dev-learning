# Ejercicio 01 — Herencia y polimorfismo

- **Nivel:** 3/5
- **Tema:** `class` derivada, `virtual`/`override`, `base`, polimorfismo
- **Tiempo estimado:** 30 min

## Enunciado

Completa `ejercicio-01-herencia.cs`. Define la jerarquía:

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
- [ ] Los tests pasan: `csc ejercicio-01-herencia.cs ejercicio-01-herencia_test.cs && mono ejercicio-01-herencia_test.exe` (si tienes Mono/csc).
- [ ] Los tests pasan: `dotnet run` (al instalar el .NET SDK).

> **Nota:** el .NET SDK **no está instalado** en esta máquina. Con el SDK instalado:
> ```bash
> dotnet new console -o . --force
> rm Program.cs
> dotnet run
> ```
> Con Mono/csc: `csc ejercicio-01-herencia.cs ejercicio-01-herencia_test.cs` y `mono ejercicio-01-herencia_test.exe`.

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