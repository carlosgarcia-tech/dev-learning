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
        Check("Ordenar([3,1,2]) devuelve [1,2,3]",
            () => Ejercicio04.Ordenar(new List<int> { 3, 1, 2 }).SequenceEqual(new List<int> { 1, 2, 3 }));

        List<int> original = new List<int> { 3, 1, 2 };
        Ejercicio04.Ordenar(original);
        Check("Ordenar no modifica la lista original", () => original.SequenceEqual(new List<int> { 3, 1, 2 }));

        Check("ContarPalabras('hola hola mundo') cuenta hola 2 veces",
            () =>
            {
                var conteo = Ejercicio04.ContarPalabras("hola hola mundo");
                return conteo.Count == 2 && conteo["hola"] == 2 && conteo["mundo"] == 1;
            });

        Check("ContarPalabras normaliza mayúsculas ('Hola hola')",
            () => Ejercicio04.ContarPalabras("Hola hola")["hola"] == 2);

        Check("ExisteClave devuelve true para una clave existente",
            () => Ejercicio04.ExisteClave(new Dictionary<string, int> { { "a", 1 } }, "a"));
        Check("ExisteClave devuelve false para una clave inexistente",
            () => !Ejercicio04.ExisteClave(new Dictionary<string, int> { { "a", 1 } }, "b"));

        Check("ClavesOrdenadas ordena alfabéticamente",
            () => Ejercicio04.ClavesOrdenadas(new Dictionary<string, int> { { "b", 1 }, { "a", 2 } })
                .SequenceEqual(new List<string> { "a", "b" }));

        var dicc = new Dictionary<string, int> { { "edad", 30 } };
        Check("ObtenerValorODefecto devuelve el valor existente",
            () => Ejercicio04.ObtenerValorODefecto(dicc, "edad", 0) == 30);
        Check("ObtenerValorODefecto devuelve el defecto si la clave no existe",
            () => Ejercicio04.ObtenerValorODefecto(dicc, "peso", -1) == -1);

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