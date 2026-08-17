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
        Check("HolaMundo devuelve 'Hola, mundo!'", () => Ejercicio01.HolaMundo() == "Hola, mundo!");
        Check("Saludar(\"Ana\") devuelve 'Hola, Ana!'", () => Ejercicio01.Saludar("Ana") == "Hola, Ana!");
        Check("Saludar(\"Luis\") devuelve 'Hola, Luis!'", () => Ejercicio01.Saludar("Luis") == "Hola, Luis!");
        Check("Despedirse(\"Ana\") devuelve 'Adiós, Ana!'", () => Ejercicio01.Despedirse("Ana") == "Adiós, Ana!");
        Check("Despedirse(\"Luis\") devuelve 'Adiós, Luis!'", () => Ejercicio01.Despedirse("Luis") == "Adiós, Luis!");
        Check("HolaMundo no es null", () => Ejercicio01.HolaMundo() != null);

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