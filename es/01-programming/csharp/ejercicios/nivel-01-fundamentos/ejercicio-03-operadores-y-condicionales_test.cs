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
        Check("Sumar(2, 3) devuelve 5", () => Ejercicio03.Sumar(2, 3) == 5);
        Check("Sumar(-5, 5) devuelve 0", () => Ejercicio03.Sumar(-5, 5) == 0);
        Check("Sumar(0, 0) devuelve 0", () => Ejercicio03.Sumar(0, 0) == 0);

        Check("EsPar(4) es true", () => Ejercicio03.EsPar(4));
        Check("EsPar(7) es false", () => !Ejercicio03.EsPar(7));
        Check("EsPar(0) es true", () => Ejercicio03.EsPar(0));

        Check("Clasificar(5) devuelve 'Positivo'", () => Ejercicio03.Clasificar(5) == "Positivo");
        Check("Clasificar(-3) devuelve 'Negativo'", () => Ejercicio03.Clasificar(-3) == "Negativo");
        Check("Clasificar(0) devuelve 'Cero'", () => Ejercicio03.Clasificar(0) == "Cero");

        Check("MayorDeTres(1, 9, 4) devuelve 9", () => Ejercicio03.MayorDeTres(1, 9, 4) == 9);
        Check("MayorDeTres(9, 1, 4) devuelve 9", () => Ejercicio03.MayorDeTres(9, 1, 4) == 9);
        Check("MayorDeTres(4, 9, 1) devuelve 9", () => Ejercicio03.MayorDeTres(4, 9, 1) == 9);
        Check("MayorDeTres(-1, -2, -3) devuelve -1", () => Ejercicio03.MayorDeTres(-1, -2, -3) == -1);

        Check("PuedeConducir(18) es true", () => Ejercicio03.PuedeConducir(18));
        Check("PuedeConducir(17) es false", () => !Ejercicio03.PuedeConducir(17));

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