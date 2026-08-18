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
        Persona ana = Ejercicio02.CrearPersona("Ana", 30);
        Check("CrearPersona devuelve una instancia no null", () => ana != null);
        Check("CrearPersona(\"Ana\", 30).Nombre es 'Ana'", () => ana.Nombre == "Ana");
        Check("CrearPersona(\"Ana\", 30).Edad es 30", () => ana.Edad == 30);

        Check("Saludar() devuelve 'Hola, soy Ana'", () => ana.Saludar() == "Hola, soy Ana");
        Check("Saludar() refleja otros nombres", () => Ejercicio02.CrearPersona("Luis", 20).Saludar() == "Hola, soy Luis");

        Check("EsMayorDeEdad() es true con 30", () => ana.EsMayorDeEdad());
        Check("EsMayorDeEdad() es false con 17", () => !Ejercicio02.CrearPersona("Sofía", 17).EsMayorDeEdad());
        Check("EsMayorDeEdad() es true con 18", () => Ejercicio02.CrearPersona("Pepe", 18).EsMayorDeEdad());

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