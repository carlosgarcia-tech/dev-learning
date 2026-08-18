using System;
using System.Collections.Generic;

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
        // TODO: valida título y autor (ArgumentException si están vacíos) y añade el libro.
        throw new NotImplementedException("TODO: implementar AgregarLibro(string, string)");
    }

    public void Prestar(string titulo)
    {
        // TODO: busca por título; KeyNotFoundException si no existe; InvalidOperationException si no está disponible; si no, márcalo no disponible.
        throw new NotImplementedException("TODO: implementar Prestar(string)");
    }

    public void Devolver(string titulo)
    {
        // TODO: busca por título; KeyNotFoundException si no existe; si no, márcalo disponible.
        throw new NotImplementedException("TODO: implementar Devolver(string)");
    }

    public List<Libro> Buscar(string texto)
    {
        // TODO: devuelve los libros cuyo título o autor contengan el texto (sin distinguir mayúsculas).
        throw new NotImplementedException("TODO: implementar Buscar(string)");
    }

    public List<Libro> LibrosDisponibles()
    {
        // TODO: devuelve los libros con Disponible = true.
        throw new NotImplementedException("TODO: implementar LibrosDisponibles()");
    }

    public List<Libro> LibrosPrestados()
    {
        // TODO: devuelve los libros con Disponible = false.
        throw new NotImplementedException("TODO: implementar LibrosPrestados()");
    }

    public int TotalLibros() => _libros.Count;

    public string Resumen()
    {
        // TODO: devuelve "Total: X, disponibles: Y, prestados: Z".
        throw new NotImplementedException("TODO: implementar Resumen()");
    }
}

public static class Ejercicio05
{
    public static Biblioteca CrearBiblioteca()
    {
        // TODO: devuelve new Biblioteca().
        throw new NotImplementedException("TODO: implementar CrearBiblioteca()");
    }
}