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
        Check("Suma([1,2,3,4]) devuelve 10", () => Ejercicio05.Suma(new[] { 1, 2, 3, 4 }) == 10);
        Check("Suma([10]) devuelve 10", () => Ejercicio05.Suma(new[] { 10 }) == 10);

        Check("Maximo([3,9,2]) devuelve 9", () => Ejercicio05.Maximo(new[] { 3, 9, 2 }) == 9);
        Check("Maximo([-1,-5]) devuelve -1", () => Ejercicio05.Maximo(new[] { -1, -5 }) == -1);

        Check("Invertir([1,2,3]) devuelve [3,2,1]",
            () => Ejercicio05.Invertir(new[] { 1, 2, 3 }).SequenceEqual(new[] { 3, 2, 1 }));

        int[] original = { 1, 2, 3 };
        Ejercicio05.Invertir(original);
        Check("Invertir no modifica el array original", () => original.SequenceEqual(new[] { 1, 2, 3 }));

        Check("FiltrarPares([1,2,3,4,5,6]) devuelve [2,4,6]",
            () => Ejercicio05.FiltrarPares(new[] { 1, 2, 3, 4, 5, 6 }).SequenceEqual(new[] { 2, 4, 6 }));
        Check("FiltrarPares([1,3,5]) está vacío",
            () => Ejercicio05.FiltrarPares(new[] { 1, 3, 5 }).Length == 0);

        Check("Promedio([2,4,6]) devuelve 4.0", () => Ejercicio05.Promedio(new[] { 2, 4, 6 }) == 4.0);
        Check("Promedio([1,2,3,4]) devuelve 2.5", () => Ejercicio05.Promedio(new[] { 1, 2, 3, 4 }) == 2.5);

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