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
        Check("LongitudDe(\"Hola\") devuelve '4'", () => Ejercicio06.LongitudDe("Hola") == "4");
        Check("LongitudDe(null) devuelve 'null'", () => Ejercicio06.LongitudDe(null) == "null");

        Check("SumaSegura(3, 4) devuelve 7", () => Ejercicio06.SumaSegura(3, 4) == 7);
        Check("SumaSegura(null, 4) es null", () => !Ejercicio06.SumaSegura(null, 4).HasValue);
        Check("SumaSegura(null, null) es null", () => !Ejercicio06.SumaSegura(null, null).HasValue);

        Check("ValorODefecto(\"x\", \"d\") devuelve 'x'", () => Ejercicio06.ValorODefecto("x", "d") == "x");
        Check("ValorODefecto(null, \"d\") devuelve 'd'", () => Ejercicio06.ValorODefecto(null, "d") == "d");

        Check("EsVacia(null) es true", () => Ejercicio06.EsVacia(null));
        Check("EsVacia(\"\") es true", () => Ejercicio06.EsVacia(""));
        Check("EsVacia(\"x\") es false", () => !Ejercicio06.EsVacia("x"));

        Check("TotalConCeros(null, 5) devuelve 5", () => Ejercicio06.TotalConCeros(null, 5) == 5);
        Check("TotalConCeros(null, null) devuelve 0", () => Ejercicio06.TotalConCeros(null, null) == 0);
        Check("TotalConCeros(2, 3) devuelve 5", () => Ejercicio06.TotalConCeros(2, 3) == 5);

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