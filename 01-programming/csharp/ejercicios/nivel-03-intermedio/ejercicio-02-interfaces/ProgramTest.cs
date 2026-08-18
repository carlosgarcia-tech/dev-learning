using System;

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
        var cancion = new Cancion("Imagine", "John Lennon");
        var pelicula = new Pelicula("Inception");
        var ambiente = new SonidoDeAmbiente();

        Check("Cancion.Reproducir() devuelve 'Reproduciendo: Imagine de John Lennon'",
            () => cancion.Reproducir() == "Reproduciendo: Imagine de John Lennon");
        Check("Pelicula.Reproducir() devuelve 'Reproduciendo película: Inception'",
            () => pelicula.Reproducir() == "Reproduciendo película: Inception");

        Check("ReproducirTodo une las reproducciones con \\n",
            () => Ejercicio02.ReproducirTodo(new IReproducible[] { cancion, pelicula })
                == "Reproduciendo: Imagine de John Lennon\nReproduciendo película: Inception");

        Check("Describir(cancion) devuelve 'Canción: Imagine'", () => Ejercicio02.Describir(cancion) == "Canción: Imagine");
        Check("Describir(pelicula) devuelve 'Película: Inception'", () => Ejercicio02.Describir(pelicula) == "Película: Inception");
        Check("Describir(SonidoDeAmbiente) devuelve 'No describible'", () => Ejercicio02.Describir(ambiente) == "No describible");

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