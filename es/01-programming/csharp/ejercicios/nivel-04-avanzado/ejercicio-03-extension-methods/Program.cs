using System;
using System.Collections.Generic;

public static class ExtensionesString
{
    public static int ContarPalabras(this string s)
    {
        // TODO: cuenta las palabras separadas por espacios (ignora espacios sobrantes).
        throw new NotImplementedException("TODO: implementar ExtensionesString.ContarPalabras()");
    }

    public static string AlReves(this string s)
    {
        // TODO: devuelve el string invertido.
        throw new NotImplementedException("TODO: implementar ExtensionesString.AlReves()");
    }
}

public static class ExtensionesNumeros
{
    public static bool EsPar(this int n)
    {
        // TODO: devuelve true si n es par.
        throw new NotImplementedException("TODO: implementar ExtensionesNumeros.EsPar()");
    }

    public static int Cuadrado(this int n)
    {
        // TODO: devuelve n * n.
        throw new NotImplementedException("TODO: implementar ExtensionesNumeros.Cuadrado()");
    }
}

public static class Ejercicio03
{
    public static int ContarPalabras(string s)
    {
        // TODO: usa la extensión s.ContarPalabras().
        throw new NotImplementedException("TODO: implementar ContarPalabras(string)");
    }

    public static List<int> CuadradosPares(List<int> numeros)
    {
        // TODO: usa las extensiones n.EsPar() y n.Cuadrado() para devolver los cuadrados de los pares.
        throw new NotImplementedException("TODO: implementar CuadradosPares(List<int>)");
    }

    public static int[] FiltrarPares(int[] numeros)
    {
        // TODO: usa la extensión n.EsPar() para filtrar los pares.
        throw new NotImplementedException("TODO: implementar FiltrarPares(int[])");
    }
}