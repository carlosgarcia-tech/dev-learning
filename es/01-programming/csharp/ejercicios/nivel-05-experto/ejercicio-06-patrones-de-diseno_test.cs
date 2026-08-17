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
        Check("ObtenerConfiguracion devuelve SIEMPRE la misma instancia (Singleton)",
            () => ReferenceEquals(Ejercicio06.ObtenerConfiguracion(), Ejercicio06.ObtenerConfiguracion()));
        Check("Configuracion.NombreAplicacion es 'MiniApp'",
            () => Ejercicio06.ObtenerConfiguracion().NombreAplicacion == "MiniApp");

        Check("CrearVehiculo(\"coche\") es un Coche", () => Ejercicio06.CrearVehiculo("coche") is Coche);
        Check("CrearVehiculo(\"MOTO\") es una Moto (sin distinguir mayúsculas)",
            () => Ejercicio06.CrearVehiculo("MOTO") is Moto);
        Check("Coche.Describir() devuelve 'Coche de 4 ruedas'",
            () => Ejercicio06.CrearVehiculo("coche").Describir() == "Coche de 4 ruedas");
        Check("Moto.Describir() devuelve 'Moto de 2 ruedas'",
            () => Ejercicio06.CrearVehiculo("moto").Describir() == "Moto de 2 ruedas");
        Check("CrearVehiculo(\"avion\") lanza ArgumentException",
            () =>
            {
                try { Ejercicio06.CrearVehiculo("avion"); return false; }
                catch (ArgumentException) { return true; }
            });

        CalculadoraEnvio estandar = Ejercicio06.CrearCalculadora("estandar");
        Check("Envío estándar de 10 kg cuesta 50", () => estandar.Calcular(10) == 50.0);
        Check("NombreEstrategia del envío estándar es 'Estándar'", () => estandar.NombreEstrategia == "Estándar");

        CalculadoraEnvio express = Ejercicio06.CrearCalculadora("express");
        Check("Envío express de 10 kg cuesta 100", () => express.Calcular(10) == 100.0);
        Check("NombreEstrategia del envío express es 'Express'", () => express.NombreEstrategia == "Express");

        Check("CrearCalculadora(\"barco\") lanza ArgumentException",
            () =>
            {
                try { Ejercicio06.CrearCalculadora("barco"); return false; }
                catch (ArgumentException) { return true; }
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