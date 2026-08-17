# Ejercicio 02 — Interfaces

- **Nivel:** 3/5
- **Tema:** `interface`, implementación múltiple, polimorfismo con interfaces, `is`
- **Tiempo estimado:** 30 min

## Enunciado

Completa `ejercicio-02-interfaces.cs`. Define:

1. `IReproducible` con `string Reproducir()`.
2. `IDescribible` con `string Describir()`.
3. `Cancion : IReproducible, IDescribible` — `Reproducir()` → `Reproduciendo: <Titulo> de <Artista>`; `Describir()` → `Canción: <Titulo>`.
4. `Pelicula : IReproducible, IDescribible` — `Reproducir()` → `Reproduciendo película: <Titulo>`; `Describir()` → `Película: <Titulo>`.
5. `SonidoDeAmbiente : IReproducible` — solo reproduce `Sonido ambiente` (ya implementado).

En `Ejercicio02`:

6. `string ReproducirTodo(IReproducible[] elementos)` — une las reproducciones con `\n`.
7. `string Describir(IReproducible elemento)` — si el elemento es `IDescribible` usa `Describir()`; si no, devuelve `No describible`.

Salida esperada de ejemplo:

```
[OK]   ReproducirTodo([cancion, pelicula]) devuelve las dos líneas separadas por salto de línea
[OK]   Describir(cancion) devuelve "Canción: Imagine"
[OK]   Describir(SonidoDeAmbiente) devuelve "No describible"
```

## Requisitos

- [ ] `Cancion` y `Pelicula` implementan ambas interfaces.
- [ ] `ReproducirTodo` devuelve las reproducciones unidas por `\n`.
- [ ] `Describir` usa `elemento is IDescribible` para decidir.
- [ ] Los tests pasan: `csc ejercicio-02-interfaces.cs ejercicio-02-interfaces_test.cs && mono ejercicio-02-interfaces_test.exe` (si tienes Mono/csc).
- [ ] Los tests pasan: `dotnet run` (al instalar el .NET SDK).

> **Nota:** el .NET SDK **no está instalado** en esta máquina. Con el SDK instalado:
> ```bash
> dotnet new console -o . --force
> rm Program.cs
> dotnet run
> ```
> Con Mono/csc: `csc ejercicio-02-interfaces.cs ejercicio-02-interfaces_test.cs` y `mono ejercicio-02-interfaces_test.exe`.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `elemento is IDescribible describible` combina comprobación y conversión.
- `string.Join("\n", array)` une elementos con un separador.
- Los strings con `\n` (salto de línea) se escriben como `"\n"` o `Environment.NewLine`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````csharp
using System;

public interface IReproducible
{
    string Reproducir();
}

public interface IDescribible
{
    string Describir();
}

public class Cancion : IReproducible, IDescribible
{
    public string Titulo { get; }
    public string Artista { get; }

    public Cancion(string titulo, string artista)
    {
        Titulo = titulo;
        Artista = artista;
    }

    public string Reproducir() => $"Reproduciendo: {Titulo} de {Artista}";
    public string Describir() => $"Canción: {Titulo}";
}

public class Pelicula : IReproducible, IDescribible
{
    public string Titulo { get; }

    public Pelicula(string titulo)
    {
        Titulo = titulo;
    }

    public string Reproducir() => $"Reproduciendo película: {Titulo}";
    public string Describir() => $"Película: {Titulo}";
}

public class SonidoDeAmbiente : IReproducible
{
    public string Reproducir() => "Sonido ambiente";
}

public static class Ejercicio02
{
    public static string ReproducirTodo(IReproducible[] elementos)
    {
        string[] lineas = new string[elementos.Length];
        for (int i = 0; i < elementos.Length; i++)
        {
            lineas[i] = elementos[i].Reproducir();
        }
        return string.Join("\n", lineas);
    }

    public static string Describir(IReproducible elemento)
    {
        if (elemento is IDescribible describible)
        {
            return describible.Describir();
        }
        return "No describible";
    }
}
````

</details>