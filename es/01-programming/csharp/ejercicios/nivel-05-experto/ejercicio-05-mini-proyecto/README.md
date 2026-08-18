# Ejercicio 05 — Mini proyecto: biblioteca

- **Nivel:** 5/5
- **Tema:** integración de clases, colecciones, LINQ, validaciones y excepciones
- **Tiempo estimado:** 60 min

## Enunciado

Este mini proyecto integra lo aprendido en un **sistema de gestión de biblioteca**. Completa `Program.cs`.

Clase `Libro` (ya definida): `Titulo`, `Autor`, `Disponible`.

Clase `Biblioteca`:

1. `void AgregarLibro(string titulo, string autor)` — `ArgumentException` si algún campo está vacío; añade el libro disponible.
2. `void Prestar(string titulo)` — `KeyNotFoundException` si no existe; `InvalidOperationException` si no está disponible; si no, lo marca no disponible.
3. `void Devolver(string titulo)` — `KeyNotFoundException` si no existe; si no, lo marca disponible.
4. `List<Libro> Buscar(string texto)` — libros cuyo título **o** autor contengan el texto (sin distinguir mayúsculas).
5. `List<Libro> LibrosDisponibles()` y `List<Libro> LibrosPrestados()`.
6. `int TotalLibros()` — ya implementado.
7. `string Resumen()` — `Total: X, disponibles: Y, prestados: Z`.

Salida esperada de ejemplo:

```
[OK]   Buscar("quijote") encuentra "El Quijote" (sin distinguir mayúsculas)
[OK]   Prestar un libro dos veces lanza InvalidOperationException
[OK]   Resumen() devuelve "Total: 2, disponibles: 1, prestados: 1"
```

## Requisitos

- [ ] `AgregarLibro` valida campos vacíos.
- [ ] `Prestar` lanza `KeyNotFoundException` y `InvalidOperationException` en los casos indicados.
- [ ] `Buscar` no distingue mayúsculas y busca en título y autor.
- [ ] `Resumen()` sigue el formato exacto.
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

- `string.IndexOf(texto, StringComparison.OrdinalIgnoreCase) >= 0` comprueba si un string contiene otro sin distinguir mayúsculas.
- Un método privado `BuscarPorTitulo` evita repetir la búsqueda en `Prestar`/`Devolver`.
- Usa LINQ para `Buscar`, `LibrosDisponibles` y `LibrosPrestados`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````csharp
using System;
using System.Collections.Generic;
using System.Linq;

public class Libro
{
    public string Titulo { get; }
    public string Autor { get; }
    public bool Disponible { get; set; }

    public Libro(string titulo, string autor)
    {
        Titulo = titulo;
        Autor = autor;
        Disponible = true;
    }
}

public class Biblioteca
{
    private readonly List<Libro> _libros = new List<Libro>();

    public void AgregarLibro(string titulo, string autor)
    {
        if (string.IsNullOrWhiteSpace(titulo))
            throw new ArgumentException("El título es obligatorio.");
        if (string.IsNullOrWhiteSpace(autor))
            throw new ArgumentException("El autor es obligatorio.");
        _libros.Add(new Libro(titulo, autor));
    }

    public void Prestar(string titulo)
    {
        Libro libro = BuscarPorTitulo(titulo);
        if (!libro.Disponible)
            throw new InvalidOperationException("El libro no está disponible: " + titulo);
        libro.Disponible = false;
    }

    public void Devolver(string titulo)
    {
        Libro libro = BuscarPorTitulo(titulo);
        libro.Disponible = true;
    }

    public List<Libro> Buscar(string texto)
        => _libros.Where(l =>
                l.Titulo.IndexOf(texto, StringComparison.OrdinalIgnoreCase) >= 0
                || l.Autor.IndexOf(texto, StringComparison.OrdinalIgnoreCase) >= 0)
            .ToList();

    public List<Libro> LibrosDisponibles() => _libros.Where(l => l.Disponible).ToList();

    public List<Libro> LibrosPrestados() => _libros.Where(l => !l.Disponible).ToList();

    public int TotalLibros() => _libros.Count;

    public string Resumen()
        => $"Total: {TotalLibros()}, disponibles: {LibrosDisponibles().Count}, prestados: {LibrosPrestados().Count}";

    private Libro BuscarPorTitulo(string titulo)
    {
        foreach (Libro libro in _libros)
        {
            if (libro.Titulo.Equals(titulo, StringComparison.OrdinalIgnoreCase))
                return libro;
        }
        throw new KeyNotFoundException("Libro no encontrado: " + titulo);
    }
}

public static class Ejercicio05
{
    public static Biblioteca CrearBiblioteca() => new Biblioteca();
}
````

</details>