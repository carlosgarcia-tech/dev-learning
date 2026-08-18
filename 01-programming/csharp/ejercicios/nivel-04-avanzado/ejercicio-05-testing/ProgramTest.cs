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
        Check("Sumar(2, 2) devuelve 4", () => Ejercicio05.Sumar(2, 2) == 4);
        Check("Restar(10, 4) devuelve 6", () => Ejercicio05.Restar(10, 4) == 6);
        Check("Multiplicar(3, 4) devuelve 12", () => Ejercicio05.Multiplicar(3, 4) == 12);

        Check("EjecutarTest con prueba true devuelve Paso = true",
            () => Ejercicio05.EjecutarTest("ok", () => true).Paso);
        Check("EjecutarTest con prueba false devuelve Paso = false",
            () => !Ejercicio05.EjecutarTest("mal", () => false).Paso);
        Check("EjecutarTest captura excepciones y devuelve Paso = false",
            () => !Ejercicio05.EjecutarTest("error", () => { throw new InvalidOperationException("boom"); }).Paso);

        var suite = Ejercicio05.EjecutarSuite();
        Check("EjecutarSuite devuelve 4 tests", () => suite.Count == 4);
        Check("Todos los tests de EjecutarSuite pasan",
            () => suite.TrueForAll(r => r.Paso));
        Check("ContarAprobados de la suite es 4",
            () => Ejercicio05.ContarAprobados(suite) == 4);

        Check("CasiIgual(0.1 + 0.2, 0.3) es true",
            () => Ejercicio05.CasiIgual(0.1 + 0.2, 0.3));
        Check("CasiIgual(1.0, 2.0) es false",
            () => !Ejercicio05.CasiIgual(1.0, 2.0));

        var mixto = new List<ResultadoTest>
        {
            new ResultadoTest("uno", true),
            new ResultadoTest("dos", false),
            new ResultadoTest("tres", true)
        };
        Check("ContarAprobados cuenta solo los que pasan",
            () => Ejercicio05.ContarAprobados(mixto) == 2);

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