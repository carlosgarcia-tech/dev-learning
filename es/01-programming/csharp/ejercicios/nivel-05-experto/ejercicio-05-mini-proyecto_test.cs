using System;
using System.Collections.Generic;
using System.Linq;

public static class Programa
{
    private static int _fallos;

    private static void Check(string nombre, Func<bool> prueba)
    {
        try
        {
            if (prueba())
            {
                Console.WriteLine("[OK]   " + nombre);
            }
            else
            {
                Console.WriteLine("[FALL] " + nombre);
                _fallos++;
            }
        }
        catch (Exception ex)
        {
            Console.WriteLine("[FALL] " + nombre + " -> " + ex.GetType().Name + ": " + ex.Message);
            _fallos++;
        }
    }

    public static int Main()
    {
        Biblioteca biblioteca = Ejercicio05.CrearBiblioteca();
        Check("CrearBiblioteca devuelve una biblioteca vacía", () => biblioteca.TotalLibros() == 0);

        biblioteca.AgregarLibro("Cien años de soledad", "Gabriel García Márquez");
        biblioteca.AgregarLibro("El Quijote", "Miguel de Cervantes");
        Check("AgregarLibro añade y TotalLibros las cuenta", () => biblioteca.TotalLibros() == 2);

        Check("AgregarLibro con título vacío lanza ArgumentException",
            () =>
            {
                try { biblioteca.AgregarLibro("  ", "Autor"); return false; }
                catch (ArgumentException) { return true; }
            });

        Check("Buscar('quijote') no distingue mayúsculas",
            () => biblioteca.Buscar("quijote").Count == 1 && biblioteca.Buscar("quijote")[0].Titulo == "El Quijote");
        Check("Buscar('GARCÍA') busca también en el autor",
            () => biblioteca.Buscar("GARCÍA").Count == 1);
        Check("Buscar('inexistente') devuelve lista vacía",
            () => biblioteca.Buscar("inexistente").Count == 0);

        biblioteca.Prestar("El Quijote");
        Check("Prestar marca el libro como no disponible",
            () => biblioteca.LibrosPrestados().Count == 1 && biblioteca.LibrosDisponibles().Count == 1);

        Check("Prestar un libro no disponible lanza InvalidOperationException",
            () =>
            {
                try { biblioteca.Prestar("El Quijote"); return false; }
                catch (InvalidOperationException) { return true; }
            });

        Check("Prestar un libro inexistente lanza KeyNotFoundException",
            () =>
            {
                try { biblioteca.Prestar("No existe"); return false; }
                catch (KeyNotFoundException) { return true; }
            });

        biblioteca.Devolver("El Quijote");
        Check("Devolver vuelve a dejar el libro disponible",
            () => biblioteca.LibrosDisponibles().Count == 2);

        Check("Resumen() tiene el formato exacto",
            () => biblioteca.Resumen() == "Total: 2, disponibles: 2, prestados: 0");

        Console.WriteLine();
        if (_fallos == 0)
        {
            Console.WriteLine("Todos los tests pasaron.");
            return 0;
        }
        Console.WriteLine(_fallos + " test(s) fallaron.");
        return 1;
    }
}