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
        Check("'Hola mundo cruel'.ContarPalabras() devuelve 3",
            () => "Hola mundo cruel".ContarPalabras() == 3);
        Check("'   '.ContarPalabras() devuelve 0",
            () => "   ".ContarPalabras() == 0);

        Check("'hola'.AlReves() devuelve 'aloh'", () => "hola".AlReves() == "aloh");

        Check("4.EsPar() es true", () => 4.EsPar());
        Check("7.EsPar() es false", () => !7.EsPar());
        Check("5.Cuadrado() devuelve 25", () => 5.Cuadrado() == 25);

        Check("Ejercicio03.ContarPalabras('uno dos') devuelve 2",
            () => Ejercicio03.ContarPalabras("uno dos") == 2);

        Check("CuadradosPares([2,3,4]) devuelve [4,16]",
            () => Ejercicio03.CuadradosPares(new List<int> { 2, 3, 4 })
                .SequenceEqual(new List<int> { 4, 16 }));

        Check("FiltrarPares([1,2,3,4]) devuelve [2,4]",
            () => Ejercicio03.FiltrarPares(new[] { 1, 2, 3, 4 }).SequenceEqual(new[] { 2, 4 }));

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