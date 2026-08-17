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
        Check("Dividir(10, 2) devuelve 5", () => Ejercicio05.Dividir(10, 2) == 5.0);

        Check("Dividir(10, 0) lanza ArgumentException",
            () =>
            {
                try { Ejercicio05.Dividir(10, 0); return false; }
                catch (ArgumentException) { return true; }
            });

        Check("ParsearEntero(\"42\") devuelve 42", () => Ejercicio05.ParsearEntero("42") == 42);

        Check("ParsearEntero(\"abc\") lanza FormatException",
            () =>
            {
                try { Ejercicio05.ParsearEntero("abc"); return false; }
                catch (FormatException) { return true; }
            });

        var config = new Dictionary<string, string> { { "puerto", "3000" }, { "host", "localhost" } };
        Check("ObtenerConfiguracion devuelve el valor de una clave existente",
            () => Ejercicio05.ObtenerConfiguracion(config, "puerto") == "3000");

        Check("ObtenerConfiguracion con clave inexistente lanza KeyNotFoundException",
            () =>
            {
                try { Ejercicio05.ObtenerConfiguracion(config, "clave"); return false; }
                catch (KeyNotFoundException) { return true; }
            });

        Check("Calcular(\"+\", 2, 3) devuelve 5", () => Ejercicio05.Calcular("+", 2, 3) == 5);
        Check("Calcular(\"-\", 10, 4) devuelve 6", () => Ejercicio05.Calcular("-", 10, 4) == 6);
        Check("Calcular(\"*\", 3, 4) devuelve 12", () => Ejercicio05.Calcular("*", 3, 4) == 12);
        Check("Calcular(\"/\", 10, 2) devuelve 5", () => Ejercicio05.Calcular("/", 10, 2) == 5);

        Check("Calcular(\"/\", 10, 0) lanza ArgumentException",
            () =>
            {
                try { Ejercicio05.Calcular("/", 10, 0); return false; }
                catch (ArgumentException) { return true; }
            });

        Check("Calcular(\"%\", 1, 2) lanza InvalidOperationException",
            () =>
            {
                try { Ejercicio05.Calcular("%", 1, 2); return false; }
                catch (InvalidOperationException) { return true; }
            });

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