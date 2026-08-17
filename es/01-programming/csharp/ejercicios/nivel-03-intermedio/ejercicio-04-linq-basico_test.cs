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
        Check("NombresLargos(['Ana','Roberto','Laura'], 5) devuelve ['Roberto','Laura']",
            () => Ejercicio04.NombresLargos(new List<string> { "Ana", "Roberto", "Laura" }, 5)
                .SequenceEqual(new List<string> { "Roberto", "Laura" }));
        Check("NombresLargos con longitud mínima alta devuelve lista vacía",
            () => Ejercicio04.NombresLargos(new List<string> { "Ana", "Iván" }, 10).Count == 0);

        Check("ParesOrdenados([7,2,8,1,4]) devuelve [2,4,8]",
            () => Ejercicio04.ParesOrdenados(new[] { 7, 2, 8, 1, 4 }).SequenceEqual(new[] { 2, 4, 8 }));
        Check("ParesOrdenados([1,3,5]) está vacío",
            () => Ejercicio04.ParesOrdenados(new[] { 1, 3, 5 }).Length == 0);

        Check("SumaDeCuadrados([1,2,3]) devuelve 14", () => Ejercicio04.SumaDeCuadrados(new List<int> { 1, 2, 3 }) == 14);
        Check("SumaDeCuadrados([2,4]) devuelve 20", () => Ejercicio04.SumaDeCuadrados(new List<int> { 2, 4 }) == 20);

        Check("ContarPorInicial(['Ana','Alicia','Luis']) agrupa {A:2, L:1}",
            () =>
            {
                var grupos = Ejercicio04.ContarPorInicial(new List<string> { "Ana", "Alicia", "Luis" });
                return grupos.Count == 2 && grupos["A"] == 2 && grupos["L"] == 1;
            });

        Check("NombreMasLargo(['Ana','Roberto','Iván']) devuelve 'Roberto'",
            () => Ejercicio04.NombreMasLargo(new List<string> { "Ana", "Roberto", "Iván" }) == "Roberto");

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