# Ejercicio 06 — Patrones de diseño

- **Nivel:** 5/5
- **Tema:** Singleton, Factory, Strategy, interfaces y composición
- **Tiempo estimado:** 60 min

## Enunciado

Completa `ejercicio-06-patrones-de-diseno.cs` implementando tres patrones clásicos:

**Singleton — `Configuracion`** (clase `sealed`, constructor privado, campo `_instancia` ya declarado):
1. `Configuracion.Instancia` — devuelve siempre la misma instancia (`_instancia`).

**Factory — vehículos:**
2. `Coche.Describir()` → `Coche de 4 ruedas`; `Moto.Describir()` → `Moto de 2 ruedas`.
3. `FabricaVehiculos.Crear(string tipo)` — `"coche"` → `Coche`, `"moto"` → `Moto` (sin distinguir mayúsculas); otro → `ArgumentException`.

**Strategy — envíos:**
4. `EnvioEstandar.CalcularCosto(peso)` → `peso * 5`; `EnvioExpress.CalcularCosto(peso)` → `peso * 10`.
5. `CalculadoraEnvio.Calcular(peso)` → delega en la estrategia.

**`Ejercicio06`:**
6. `ObtenerConfiguracion()` → `Configuracion.Instancia`.
7. `CrearVehiculo(string tipo)` → `FabricaVehiculos.Crear(tipo)`.
8. `CrearCalculadora(string tipo)` — `"estandar"`/`"express"` crean la calculadora con la estrategia correspondiente; otro → `ArgumentException`.

Salida esperada de ejemplo:

```
[OK]   ObtenerConfiguracion devuelve SIEMPRE la misma instancia (Singleton)
[OK]   CrearVehiculo("coche") es un Coche
[OK]   Envío estándar de 10 kg cuesta 50 y el express 100
```

## Requisitos

- [ ] `Instancia` devuelve la misma referencia en cada llamada (Singleton).
- [ ] `FabricaVehiculos.Crear` no distingue mayúsculas y lanza `ArgumentException` con tipos desconocidos.
- [ ] Los costos de envío son correctos (`estándar` = peso × 5, `express` = peso × 10).
- [ ] `CrearCalculadora` expone `NombreEstrategia` correcto.
- [ ] Los tests pasan: `csc ejercicio-06-patrones-de-diseno.cs ejercicio-06-patrones-de-diseno_test.cs && mono ejercicio-06-patrones-de-diseno_test.exe` (si tienes Mono/csc).
- [ ] Los tests pasan: `dotnet run` (al instalar el .NET SDK).

> **Nota:** el .NET SDK **no está instalado** en esta máquina. Con el SDK instalado:
> ```bash
> dotnet new console -o . --force
> rm Program.cs
> dotnet run
> ```
> Con Mono/csc: `csc ejercicio-06-patrones-de-diseno.cs ejercicio-06-patrones-de-diseno_test.cs` y `mono ejercicio-06-patrones-de-diseno_test.exe`.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Para comprobar el Singleton en el test: `ReferenceEquals(instancia1, instancia2)`.
- `tipo.ToLower() == "coche"` para la fábrica sin distinguir mayúsculas.
- La estrategia se inyecta por constructor: `new CalculadoraEnvio(new EnvioEstandar())`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````csharp
using System;

public sealed class Configuracion
{
    private static readonly Configuracion _instancia = new Configuracion();

    public static Configuracion Instancia => _instancia;

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
    public string Describir() => "Coche de 4 ruedas";
}

public class Moto : IVehiculo
{
    public string Tipo => "Moto";
    public string Describir() => "Moto de 2 ruedas";
}

public class FabricaVehiculos
{
    public static IVehiculo Crear(string tipo)
    {
        switch (tipo.ToLower())
        {
            case "coche": return new Coche();
            case "moto": return new Moto();
            default: throw new ArgumentException("Tipo de vehículo desconocido: " + tipo);
        }
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
    public double CalcularCosto(double peso) => peso * 5;
}

public class EnvioExpress : IEnvioStrategy
{
    public string Nombre => "Express";
    public double CalcularCosto(double peso) => peso * 10;
}

public class CalculadoraEnvio
{
    private readonly IEnvioStrategy _estrategia;

    public CalculadoraEnvio(IEnvioStrategy estrategia)
    {
        _estrategia = estrategia;
    }

    public double Calcular(double peso) => _estrategia.CalcularCosto(peso);
    public string NombreEstrategia => _estrategia.Nombre;
}

public static class Ejercicio06
{
    public static Configuracion ObtenerConfiguracion() => Configuracion.Instancia;

    public static IVehiculo CrearVehiculo(string tipo) => FabricaVehiculos.Crear(tipo);

    public static CalculadoraEnvio CrearCalculadora(string tipo)
    {
        switch (tipo.ToLower())
        {
            case "estandar": return new CalculadoraEnvio(new EnvioEstandar());
            case "express": return new CalculadoraEnvio(new EnvioExpress());
            default: throw new ArgumentException("Tipo de envío desconocido: " + tipo);
        }
    }
}
````

</details>