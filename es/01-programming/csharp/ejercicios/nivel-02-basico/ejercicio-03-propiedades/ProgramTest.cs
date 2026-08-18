using System;

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
        Check("CrearCuenta(100).Saldo devuelve 100", () => Ejercicio03.CrearCuenta(100).Saldo == 100.0);
        Check("CrearCuenta(0).Saldo devuelve 0", () => Ejercicio03.CrearCuenta(0).Saldo == 0.0);

        Check("CrearCuenta(-5) lanza ArgumentException",
            () =>
            {
                try { Ejercicio03.CrearCuenta(-5); return false; }
                catch (ArgumentException) { return true; }
            });

        Check("Depositar(50) deja el saldo en 150",
            () =>
            {
                CuentaBancaria c = Ejercicio03.CrearCuenta(100);
                c.Depositar(50);
                return c.Saldo == 150.0;
            });

        Check("Retirar(40) deja el saldo en 110",
            () =>
            {
                CuentaBancaria c = Ejercicio03.CrearCuenta(150);
                c.Retirar(40);
                return c.Saldo == 110.0;
            });

        Check("Retirar más del saldo lanza InvalidOperationException",
            () =>
            {
                CuentaBancaria c = Ejercicio03.CrearCuenta(100);
                try { c.Retirar(200); return false; }
                catch (InvalidOperationException) { return true; }
            });

        Check("Depositar(0) lanza ArgumentException",
            () =>
            {
                try { Ejercicio03.CrearCuenta(10).Depositar(0); return false; }
                catch (ArgumentException) { return true; }
            });

        Check("PuedeRetirar(50) es true con saldo 100",
            () => Ejercicio03.CrearCuenta(100).PuedeRetirar(50));
        Check("PuedeRetirar(150) es false con saldo 100",
            () => !Ejercicio03.CrearCuenta(100).PuedeRetirar(150));

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