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
        Check("Mayusculas('hola') devuelve 'HOLA'", () => Ejercicio06.Mayusculas("hola") == "HOLA");
        Check("Mayusculas('Ya') devuelve 'YA'", () => Ejercicio06.Mayusculas("Ya") == "YA");

        Check("ContarPalabras('Hola mundo cruel') devuelve 3", () => Ejercicio06.ContarPalabras("Hola mundo cruel") == 3);
        Check("ContarPalabras('a  b') devuelve 2", () => Ejercicio06.ContarPalabras("a  b") == 2);
        Check("ContarPalabras('   ') devuelve 0", () => Ejercicio06.ContarPalabras("   ") == 0);
        Check("ContarPalabras('') devuelve 0", () => Ejercicio06.ContarPalabras("") == 0);

        Check("Revertir('hola') devuelve 'aloh'", () => Ejercicio06.Revertir("hola") == "aloh");
        Check("Revertir('') devuelve ''", () => Ejercicio06.Revertir("") == "");

        Check("EsPalindromo('Anita lava la tina') es true", () => Ejercicio06.EsPalindromo("Anita lava la tina"));
        Check("EsPalindromo('reconocer') es true", () => Ejercicio06.EsPalindromo("reconocer"));
        Check("EsPalindromo('hola') es false", () => !Ejercicio06.EsPalindromo("hola"));

        Check("Capitalizar('hOLA') devuelve 'Hola'", () => Ejercicio06.Capitalizar("hOLA") == "Hola");
        Check("Capitalizar('ana') devuelve 'Ana'", () => Ejercicio06.Capitalizar("ana") == "Ana");

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