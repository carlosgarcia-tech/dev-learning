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
        var (menor, mayor) = Ejercicio04.MinimoYMaximo(new[] { 4, 9, 2, 7 });
        Check("MinimoYMaximo([4,9,2,7]) devuelve (menor=2, mayor=9)", () => menor == 2 && mayor == 9);

        var persona = Ejercicio04.CrearPersona("Ana", 30);
        Check("CrearPersona(\"Ana\", 30).nombre es 'Ana'", () => persona.nombre == "Ana");
        Check("CrearPersona(\"Ana\", 30).edad es 30", () => persona.edad == 30);

        var est = Ejercicio04.Estadisticas(new List<int> { 1, 2, 3 });
        Check("Estadisticas([1,2,3]) devuelve suma 6, cuenta 3, promedio 2.0",
            () => est.suma == 6 && est.cuenta == 3 && est.promedio == 2.0);

        var vacia = Ejercicio04.Estadisticas(new List<int>());
        Check("Estadisticas(lista vacía) devuelve (0, 0, 0.0)",
            () => vacia.suma == 0 && vacia.cuenta == 0 && vacia.promedio == 0.0);

        var (cociente, resto) = Ejercicio04.DividirConResto(17, 5);
        Check("DividirConResto(17, 5) devuelve (3, 2)", () => cociente == 3 && resto == 2);

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