using System;

public sealed class Configuracion
{
    private static readonly Configuracion _instancia = new Configuracion();

    public static Configuracion Instancia
    {
        get
        {
            // TODO: devuelve _instancia (patrón Singleton).
            throw new NotImplementedException("TODO: implementar Configuracion.Instancia");
        }
    }

    public string NombreAplicacion { get; } = "MiniApp";

    private Configuracion() { }
}

public interface IVehiculo
{
    string Tipo { get; }
    string Describir();
}

public class Coche : IVehiculo
{
    public string Tipo => "Coche";

    public string Describir()
    {
        // TODO: devuelve "Coche de 4 ruedas".
        throw new NotImplementedException("TODO: implementar Coche.Describir()");
    }
}

public class Moto : IVehiculo
{
    public string Tipo => "Moto";

    public string Describir()
    {
        // TODO: devuelve "Moto de 2 ruedas".
        throw new NotImplementedException("TODO: implementar Moto.Describir()");
    }
}

public class FabricaVehiculos
{
    public static IVehiculo Crear(string tipo)
    {
        // TODO: "coche" -> new Coche(); "moto" -> new Moto(); cualquier otro -> ArgumentException.
        throw new NotImplementedException("TODO: implementar FabricaVehiculos.Crear(string)");
    }
}

public interface IEnvioStrategy
{
    string Nombre { get; }
    double CalcularCosto(double peso);
}

public class EnvioEstandar : IEnvioStrategy
{
    public string Nombre => "Estándar";

    public double CalcularCosto(double peso)
    {
        // TODO: devuelve peso * 5.
        throw new NotImplementedException("TODO: implementar EnvioEstandar.CalcularCosto(double)");
    }
}

public class EnvioExpress : IEnvioStrategy
{
    public string Nombre => "Express";

    public double CalcularCosto(double peso)
    {
        // TODO: devuelve peso * 10.
        throw new NotImplementedException("TODO: implementar EnvioExpress.CalcularCosto(double)");
    }
}

public class CalculadoraEnvio
{
    private readonly IEnvioStrategy _estrategia;

    public CalculadoraEnvio(IEnvioStrategy estrategia)
    {
        _estrategia = estrategia;
    }

    public double Calcular(double peso)
    {
        // TODO: devuelve _estrategia.CalcularCosto(peso).
        throw new NotImplementedException("TODO: implementar CalculadoraEnvio.Calcular(double)");
    }

    public string NombreEstrategia => _estrategia.Nombre;
}

public static class Ejercicio06
{
    public static Configuracion ObtenerConfiguracion()
    {
        // TODO: devuelve Configuracion.Instancia (Singleton).
        throw new NotImplementedException("TODO: implementar ObtenerConfiguracion()");
    }

    public static IVehiculo CrearVehiculo(string tipo)
    {
        // TODO: delega en FabricaVehiculos.Crear(tipo).
        throw new NotImplementedException("TODO: implementar CrearVehiculo(string)");
    }

    public static CalculadoraEnvio CrearCalculadora(string tipo)
    {
        // TODO: "estandar" -> new CalculadoraEnvio(new EnvioEstandar()); "express" -> new CalculadoraEnvio(new EnvioExpress()).
        throw new NotImplementedException("TODO: implementar CrearCalculadora(string)");
    }
}