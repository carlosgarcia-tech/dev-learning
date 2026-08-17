# Ejercicio 02 — Clases y objetos

- **Nivel:** 2/5
- **Tema:** clases, constructores, propiedades de solo lectura, instancias
- **Tiempo estimado:** 25 min

## Enunciado

Completa `ejercicio-02-clases-y-objetos.cs`. Define la clase `Persona` con:

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
- [ ] Los tests pasan: `csc ejercicio-02-clases-y-objetos.cs ejercicio-02-clases-y-objetos_test.cs && mono ejercicio-02-clases-y-objetos_test.exe` (si tienes Mono/csc).
- [ ] Los tests pasan: `dotnet run` (al instalar el .NET SDK).

> **Nota:** el .NET SDK **no está instalado** en esta máquina. Con el SDK instalado:
> ```bash
> dotnet new console -o . --force
> rm Program.cs
> dotnet run
> ```
> Con Mono/csc: `csc ejercicio-02-clases-y-objetos.cs ejercicio-02-clases-y-objetos_test.cs` y `mono ejercicio-02-clases-y-objetos_test.exe`.

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