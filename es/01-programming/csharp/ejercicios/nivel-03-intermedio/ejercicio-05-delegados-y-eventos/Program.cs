using System;
using System.Collections.Generic;

public class Termometro
{
    public event EventHandler<int>? TemperaturaCambio;

    private int _temperatura;
    public int Temperatura => _temperatura;

    public void SetTemperatura(int valor)
    {
        // TODO: si valor != _temperatura, actualiza la temperatura y dispara TemperaturaCambio?.Invoke(this, valor).
        throw new NotImplementedException("TODO: implementar SetTemperatura(int)");
    }
}

public static class Ejercicio05
{
    public static int Aplicar(Func<int, int, int> operacion, int a, int b)
    {
        // TODO: devuelve operacion(a, b).
        throw new NotImplementedException("TODO: implementar Aplicar(Func<int,int,int>, int, int)");
    }

    public static List<int> Mapear(List<int> lista, Func<int, int> transformacion)
    {
        // TODO: devuelve una nueva lista con la transformación aplicada a cada elemento.
        throw new NotImplementedException("TODO: implementar Mapear(List<int>, Func<int,int>)");
    }

    public static List<int> Filtrar(List<int> lista, Predicate<int> condicion)
    {
        // TODO: devuelve solo los elementos que cumplen la condición.
        throw new NotImplementedException("TODO: implementar Filtrar(List<int>, Predicate<int>)");
    }

    public static Termometro CrearTermometro()
    {
        // TODO: devuelve new Termometro().
        throw new NotImplementedException("TODO: implementar CrearTermometro()");
    }
}