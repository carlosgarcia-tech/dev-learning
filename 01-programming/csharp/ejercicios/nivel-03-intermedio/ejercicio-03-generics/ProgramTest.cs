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
        Check("Mayor(3, 5) devuelve 5", () => Ejercicio03.Mayor(3, 5) == 5);
        Check("Mayor(9, 2) devuelve 9", () => Ejercicio03.Mayor(9, 2) == 9);
        Check("Mayor(\"abc\", \"abd\") devuelve \"abd\"", () => Ejercicio03.Mayor("abc", "abd") == "abd");
        Check("Mayor(5, 5) devuelve 5 (iguales)", () => Ejercicio03.Mayor(5, 5) == 5);

        Check("CrearCaja(42).Valor es 42", () => Ejercicio03.CrearCaja(42).Valor == 42);
        Check("CrearCaja(\"hola\").Valor es \"hola\"", () => Ejercicio03.CrearCaja("hola").Valor == "hola");

        Check("Contar([1,2,1,3,1], 1) devuelve 3",
            () => Ejercicio03.Contar(new List<int> { 1, 2, 1, 3, 1 }, 1) == 3);
        Check("Contar([\"a\",\"b\"], \"x\") devuelve 0",
            () => Ejercicio03.Contar(new List<string> { "a", "b" }, "x") == 0);

        Check("Ultimo([1,2,3]) devuelve 3", () => Ejercicio03.Ultimo(new List<int> { 1, 2, 3 }) == 3);
        Check("Ultimo([\"a\"]) devuelve \"a\"", () => Ejercicio03.Ultimo(new List<string> { "a" }) == "a");

        Check("Ultimo(lista vacía) lanza InvalidOperationException",
            () =>
            {
                try { Ejercicio03.Ultimo(new List<int>()); return false; }
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