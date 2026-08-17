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
        Check("Aplicar((a,b) => a*b, 6, 7) devuelve 42",
            () => Ejercicio05.Aplicar((a, b) => a * b, 6, 7) == 42);
        Check("Aplicar((a,b) => a+b, 2, 3) devuelve 5",
            () => Ejercicio05.Aplicar((a, b) => a + b, 2, 3) == 5);

        Check("Mapear([1,2,3], n => n*10) devuelve [10,20,30]",
            () => Ejercicio05.Mapear(new List<int> { 1, 2, 3 }, n => n * 10)
                .SequenceEqual(new List<int> { 10, 20, 30 }));

        Check("Filtrar([1,2,3,4,5,6], par) devuelve [2,4,6]",
            () => Ejercicio05.Filtrar(new List<int> { 1, 2, 3, 4, 5, 6 }, n => n % 2 == 0)
                .SequenceEqual(new List<int> { 2, 4, 6 }));

        Check("El evento dispara solo cuando la temperatura cambia",
            () =>
            {
                Termometro t = Ejercicio05.CrearTermometro();
                int eventos = 0;
                int ultimoValor = 0;
                t.TemperaturaCambio += (sender, valor) => { eventos++; ultimoValor = valor; };

                t.SetTemperatura(22);
                t.SetTemperatura(22);
                t.SetTemperatura(30);

                return eventos == 2 && ultimoValor == 30 && t.Temperatura == 30;
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