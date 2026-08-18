using System;
using System.Collections.Generic;

public class ResultadoTest
{
    public string Nombre { get; }
    public bool Paso { get; }

    public ResultadoTest(string nombre, bool paso)
    {
        Nombre = nombre;
        Paso = paso;
    }
}

public static class Ejercicio05
{
    public static int Sumar(int a, int b)
    {
        // TODO: devuelve a + b.
        throw new NotImplementedException("TODO: implementar Sumar(int, int)");
    }

    public static int Restar(int a, int b)
    {
        // TODO: devuelve a - b.
        throw new NotImplementedException("TODO: implementar Restar(int, int)");
    }

    public static int Multiplicar(int a, int b)
    {
        // TODO: devuelve a * b.
        throw new NotImplementedException("TODO: implementar Multiplicar(int, int)");
    }

    public static ResultadoTest EjecutarTest(string nombre, Func<bool> prueba)
    {
        // TODO: devuelve new ResultadoTest(nombre, prueba()). Captura excepciones y devuelve Paso = false.
        throw new NotImplementedException("TODO: implementar EjecutarTest(string, Func<bool>)");
    }

    public static List<ResultadoTest> EjecutarSuite()
    {
        // TODO: devuelve una lista de 4 tests que deben pasar (suma, resta, multiplicación y una comparación aproximada).
        throw new NotImplementedException("TODO: implementar EjecutarSuite()");
    }

    public static bool CasiIgual(double a, double b, double tolerancia = 0.0001)
    {
        // TODO: devuelve true si |a - b| <= tolerancia.
        throw new NotImplementedException("TODO: implementar CasiIgual(double, double, double)");
    }

    public static int ContarAprobados(List<ResultadoTest> resultados)
    {
        // TODO: cuenta cuántos resultados tienen Paso = true.
        throw new NotImplementedException("TODO: implementar ContarAprobados(List<ResultadoTest>)");
    }
}