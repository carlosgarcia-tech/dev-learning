using System;
using System.Collections.Generic;

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
        Check("NombreDeLaClase(new ReflexionDemo()) devuelve 'ReflexionDemo'",
            () => Ejercicio06.NombreDeLaClase(new ReflexionDemo()) == "ReflexionDemo");
        Check("NombreDeLaClase(42) devuelve 'Int32'",
            () => Ejercicio06.NombreDeLaClase(42) == "Int32");

        var metodos = Ejercicio06.NombresDeMetodos(typeof(ReflexionDemo));
        Check("NombresDeMetodos incluye 'Saludar'", () => metodos.Contains("Saludar"));
        Check("NombresDeMetodos incluye métodos heredados como 'GetType'", () => metodos.Contains("GetType"));

        var props = Ejercicio06.NombresDePropiedades(typeof(ReflexionDemo));
        Check("NombresDePropiedades incluye 'Valor'", () => props.Contains("Valor"));

        Check("TienePropiedad('Valor') es true", () => Ejercicio06.TienePropiedad(typeof(ReflexionDemo), "Valor"));
        Check("TienePropiedad('NoExiste') es false", () => !Ejercicio06.TienePropiedad(typeof(ReflexionDemo), "NoExiste"));

        object? instancia = Ejercicio06.CrearInstancia(typeof(ReflexionDemo));
        Check("CrearInstancia crea una instancia de ReflexionDemo no null",
            () => instancia is ReflexionDemo);

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