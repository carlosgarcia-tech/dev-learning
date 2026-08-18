using System;
using System.Collections.Generic;
using System.Threading.Tasks;

public static class Ejercicio01
{
    public static async Task<int> DuplicarAsync(int x)
    {
        // TODO: espera Task.Delay(10) y devuelve x * 2.
        throw new NotImplementedException("TODO: implementar DuplicarAsync(int)");
    }

    public static async Task<string> ConcatenarAsync(string a, string b)
    {
        // TODO: espera Task.Delay(10) y devuelve a + b.
        throw new NotImplementedException("TODO: implementar ConcatenarAsync(string, string)");
    }

    public static async Task<int> SumarConRetrasoAsync(int a, int b)
    {
        // TODO: espera Task.Delay(10) y devuelve a + b.
        throw new NotImplementedException("TODO: implementar SumarConRetrasoAsync(int, int)");
    }

    public static async Task<List<int>> DuplicarTodosAsync(List<int> numeros)
    {
        // TODO: lanza DuplicarAsync para cada número, espera todas con Task.WhenAll y devuelve la lista de resultados.
        throw new NotImplementedException("TODO: implementar DuplicarTodosAsync(List<int>)");
    }
}