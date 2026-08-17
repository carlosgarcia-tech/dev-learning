# Ejercicio 06 — Reflection

- **Nivel:** 4/5
- **Tema:** `Type`, `GetMethods`, `GetProperties`, `Activator.CreateInstance`
- **Tiempo estimado:** 35 min

## Enunciado

Completa `ejercicio-06-reflection.cs`. Se define `ReflexionDemo` (con la propiedad `Valor` y el método `Saludar`). Implementa en `Ejercicio06`:

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
- [ ] Los tests pasan: `csc ejercicio-06-reflection.cs ejercicio-06-reflection_test.cs && mono ejercicio-06-reflection_test.exe` (si tienes Mono/csc).
- [ ] Los tests pasan: `dotnet run` (al instalar el .NET SDK).

> **Nota:** el .NET SDK **no está instalado** en esta máquina. Con el SDK instalado:
> ```bash
> dotnet new console -o . --force
> rm Program.cs
> dotnet run
> ```
> Con Mono/csc: `csc ejercicio-06-reflection.cs ejercicio-06-reflection_test.cs` y `mono ejercicio-06-reflection_test.exe`.

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