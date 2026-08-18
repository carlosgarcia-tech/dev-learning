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
        Check("Cuadrado(5) devuelve 25", () => Ejercicio01.Cuadrado(5) == 25);
        Check("Cuadrado(0) devuelve 0", () => Ejercicio01.Cuadrado(0) == 0);
        Check("Duplicar(7) devuelve 14", () => Ejercicio01.Duplicar(7) == 14);

        Check("SumarVarios(1,2,3) devuelve 6", () => Ejercicio01.SumarVarios(1, 2, 3) == 6);
        Check("SumarVarios() devuelve 0", () => Ejercicio01.SumarVarios() == 0);
        Check("SumarVarios(5) devuelve 5", () => Ejercicio01.SumarVarios(5) == 5);

        Check("SumarConOpcional(5) usa el valor por defecto y devuelve 15", () => Ejercicio01.SumarConOpcional(5) == 15);
        Check("SumarConOpcional(5, 3) devuelve 8", () => Ejercicio01.SumarConOpcional(5, 3) == 8);

        Check("TryConvertir(\"42\", out r) es true con r == 42",
            () =>
            {
                bool ok = Ejercicio01.TryConvertir("42", out int r);
                return ok && r == 42;
            });
        Check("TryConvertir(\"abc\", out _) es false", () => !Ejercicio01.TryConvertir("abc", out _));

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