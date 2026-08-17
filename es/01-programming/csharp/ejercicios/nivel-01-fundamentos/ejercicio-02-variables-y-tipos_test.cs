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
        Check("Nombre() es un string no vacío", () => !string.IsNullOrEmpty(Ejercicio02.Nombre()));
        Check("Ciudad() es un string no vacío", () => !string.IsNullOrEmpty(Ejercicio02.Ciudad()));
        Check("Edad() es un entero positivo", () => Ejercicio02.Edad() > 0);
        Check("EstudiaProgramacion() es true", () => Ejercicio02.EstudiaProgramacion());

        Check("TipoDe(\"hola\") devuelve 'String'", () => Ejercicio02.TipoDe("hola") == "String");
        Check("TipoDe(42) devuelve 'Int32'", () => Ejercicio02.TipoDe(42) == "Int32");
        Check("TipoDe(true) devuelve 'Boolean'", () => Ejercicio02.TipoDe(true) == "Boolean");

        Check("FormatearDescripcion con Ana/Lima/30/true es correcto",
            () => Ejercicio02.FormatearDescripcion("Ana", "Lima", 30, true)
                == "Soy Ana, tengo 30 años, nací en Lima y es True que estudio programación.");

        Check("FormatearDescripcion refleja otros valores de entrada",
            () =>
            {
                string f = Ejercicio02.FormatearDescripcion("Pablo", "Bogotá", 25, false);
                return f.Contains("Soy Pablo")
                    && f.Contains("25 años")
                    && f.Contains("Bogotá")
                    && f.Contains("False");
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