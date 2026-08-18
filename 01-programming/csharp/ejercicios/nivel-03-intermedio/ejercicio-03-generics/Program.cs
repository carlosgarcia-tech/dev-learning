using System;
using System.Collections.Generic;

public class Caja<T>
{
    public T Valor { get; }

    public Caja(T valor)
    {
        Valor = valor;
    }
}

public static class Ejercicio03
{
    public static T Mayor<T>(T a, T b) where T : IComparable<T>
    {
        // TODO: devuelve el mayor de a y b usando a.CompareTo(b).
        throw new NotImplementedException("TODO: implementar Mayor<T>(T, T)");
    }

    public static Caja<T> CrearCaja<T>(T valor)
    {
        // TODO: devuelve new Caja<T>(valor).
        throw new NotImplementedException("TODO: implementar CrearCaja<T>(T)");
    }

    public static int Contar<T>(List<T> lista, T elemento)
    {
        // TODO: cuenta cuántas veces aparece elemento usando EqualityComparer<T>.Default.
        throw new NotImplementedException("TODO: implementar Contar<T>(List<T>, T)");
    }

    public static T Ultimo<T>(List<T> lista)
    {
        // TODO: devuelve el último elemento; lanza InvalidOperationException si la lista está vacía.
        throw new NotImplementedException("TODO: implementar Ultimo<T>(List<T>)");
    }
}