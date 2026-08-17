using System;
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
        Check("Sumar1aN(5) devuelve 15", () => Ejercicio04.Sumar1aN(5) == 15);
        Check("Sumar1aN(10) devuelve 55", () => Ejercicio04.Sumar1aN(10) == 55);
        Check("Sumar1aN(0) devuelve 0", () => Ejercicio04.Sumar1aN(0) == 0);
        Check("Sumar1aN(1) devuelve 1", () => Ejercicio04.Sumar1aN(1) == 1);

        Check("Factorial(5) devuelve 120", () => Ejercicio04.Factorial(5) == 120);
        Check("Factorial(0) devuelve 1", () => Ejercicio04.Factorial(0) == 1);
        Check("Factorial(3) devuelve 6", () => Ejercicio04.Factorial(3) == 6);

        Check("TablaDel(3) tiene 10 elementos", () => Ejercicio04.TablaDel(3).Length == 10);
        Check("TablaDel(3)[0] es 3", () => Ejercicio04.TablaDel(3)[0] == 3);
        Check("TablaDel(3)[9] es 30", () => Ejercicio04.TablaDel(3)[9] == 30);

        Check("ContarVocales('Hola Mundo') devuelve 4", () => Ejercicio04.ContarVocales("Hola Mundo") == 4);
        Check("ContarVocales('bcdfg') devuelve 0", () => Ejercicio04.ContarVocales("bcdfg") == 0);
        Check("ContarVocales('AEIOU') devuelve 5", () => Ejercicio04.ContarVocales("AEIOU") == 5);

        Check("ContarPares([1,2,3,4,5,6]) devuelve 3", () => Ejercicio04.ContarPares(new[] { 1, 2, 3, 4, 5, 6 }) == 3);
        Check("ContarPares([1,3,5]) devuelve 0", () => Ejercicio04.ContarPares(new[] { 1, 3, 5 }) == 0);

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