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
        Check("DuplicarAsync(21) devuelve 42",
            () => Ejercicio01.DuplicarAsync(21).GetAwaiter().GetResult() == 42);
        Check("DuplicarAsync(0) devuelve 0",
            () => Ejercicio01.DuplicarAsync(0).GetAwaiter().GetResult() == 0);

        Check("ConcatenarAsync(\"Hola \", \"mundo\") devuelve \"Hola mundo\"",
            () => Ejercicio01.ConcatenarAsync("Hola ", "mundo").GetAwaiter().GetResult() == "Hola mundo");

        Check("SumarConRetrasoAsync(2, 3) devuelve 5",
            () => Ejercicio01.SumarConRetrasoAsync(2, 3).GetAwaiter().GetResult() == 5);

        Check("DuplicarTodosAsync([1,2,3]) devuelve [2,4,6]",
            () => Ejercicio01.DuplicarTodosAsync(new List<int> { 1, 2, 3 }).GetAwaiter().GetResult()
                .SequenceEqual(new List<int> { 2, 4, 6 }));

        Check("DuplicarTodosAsync con lista vacía devuelve lista vacía",
            () => Ejercicio01.DuplicarTodosAsync(new List<int>()).GetAwaiter().GetResult().Count == 0);

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