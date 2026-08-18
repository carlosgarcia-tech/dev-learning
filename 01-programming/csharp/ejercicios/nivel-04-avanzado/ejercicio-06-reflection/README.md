# Ejercicio 06 — Reflection

- **Nivel:** 4/5
- **Tema:** `Type`, `GetMethods`, `GetProperties`, `Activator.CreateInstance`
- **Tiempo estimado:** 35 min

## Enunciado

Completa `Program.cs`. Se define `ReflexionDemo` (con la propiedad `Valor` y el método `Saludar`). Implementa en `Ejercicio06`:

1. `string NombreDeLaClase(object objeto)` — `objeto.GetType().Name`.
2. `List<string> NombresDeMetodos(Type tipo)` — nombres de los métodos públicos, sin duplicados y ordenados.
3. `List<string> NombresDePropiedades(Type tipo)` — nombres de las propiedades públicas, ordenados.
4. `bool TienePropiedad(Type tipo, string nombre)` — `tipo.GetProperty(nombre) != null`.
5. `object? CrearInstancia(Type tipo)` — `Activator.CreateInstance(tipo)`.

Salida esperada de ejemplo:

```
[OK]   NombreDeLaClase(new ReflexionDemo()) devuelve "ReflexionDemo"
[OK]   NombresDeMetodos(typeof(ReflexionDemo)) incluye "Saludar"
[OK]   TienePropiedad(typeof(ReflexionDemo), "Valor") es true
[OK]   CrearInstancia(typeof(ReflexionDemo)) crea una instancia válida
```

## Requisitos

- [ ] `NombresDeMetodos` usa `Distinct()` y ordena alfabéticamente.
- [ ] `TienePropiedad` devuelve `false` para nombres inexistentes.
- [ ] `CrearInstancia` devuelve una instancia real del tipo (no null).
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

- `tipo.GetMethods()` incluye métodos heredados de `object` (`GetType`, `ToString`, …) y los *getters/setters* de las propiedades.
- `typeof(ReflexionDemo)` obtiene el `Type` en tiempo de compilación.
- Usa `using System.Linq;` para `Select`, `Distinct` y `OrderBy`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````csharp
#nullable enable
using System;
using System.Collections.Generic;
using System.Linq;

public class ReflexionDemo
{
    public int Valor { get; set; }
    public void Saludar() { }
}

public static class Ejercicio06
{
    public static string NombreDeLaClase(object objeto) => objeto.GetType().Name;

    public static List<string> NombresDeMetodos(Type tipo)
        => tipo.GetMethods().Select(m => m.Name).Distinct().OrderBy(n => n).ToList();

    public static List<string> NombresDePropiedades(Type tipo)
        => tipo.GetProperties().Select(p => p.Name).OrderBy(n => n).ToList();

    public static bool TienePropiedad(Type tipo, string nombre)
        => tipo.GetProperty(nombre) != null;

    public static object? CrearInstancia(Type tipo)
        => Activator.CreateInstance(tipo);
}
````

</details>