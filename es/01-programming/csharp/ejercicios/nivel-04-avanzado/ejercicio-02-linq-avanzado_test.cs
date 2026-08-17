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
        Check("GenerarPares(10) devuelve [0,2,4,6,8,10]",
            () => Ejercicio02.GenerarPares(10).SequenceEqual(new[] { 0, 2, 4, 6, 8, 10 }));
        Check("GenerarPares(1) devuelve [0]",
            () => Ejercicio02.GenerarPares(1).SequenceEqual(new[] { 0 }));

        Check("Aplanar([[1,2],[3,4]]) devuelve [1,2,3,4]",
            () => Ejercicio02.Aplanar(new[] { new[] { 1, 2 }, new[] { 3, 4 } })
                .SequenceEqual(new[] { 1, 2, 3, 4 }));

        Check("UnirConComa(['a','b','c']) devuelve 'a, b, c'",
            () => Ejercicio02.UnirConComa(new List<string> { "a", "b", "c" }) == "a, b, c");
        Check("UnirConComa con lista vacía devuelve ''",
            () => Ejercicio02.UnirConComa(new List<string>()) == "");

        Check("AgruparPorLongitud(['hola','adiós','sol','mar']) agrupa por longitud",
            () =>
            {
                var grupos = Ejercicio02.AgruparPorLongitud(new List<string> { "hola", "adiós", "sol", "mar" });
                return grupos.ContainsKey(3)
                    && grupos[3].SequenceEqual(new List<string> { "sol", "mar" })
                    && grupos[4].SequenceEqual(new List<string> { "hola" })
                    && grupos[5].SequenceEqual(new List<string> { "adiós" });
            });

        Check("TopPalabras('hola hola mundo hola luna', 2) devuelve ['hola','luna']",
            () => Ejercicio02.TopPalabras("hola hola mundo hola luna", 2)
                .SequenceEqual(new List<string> { "hola", "luna" }));
        Check("TopPalabras normaliza mayúsculas ('Hola HOLA')",
            () => Ejercicio02.TopPalabras("Hola HOLA", 1).SequenceEqual(new List<string> { "hola" }));

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