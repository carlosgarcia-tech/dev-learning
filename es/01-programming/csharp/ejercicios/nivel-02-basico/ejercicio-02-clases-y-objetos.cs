using System;

public class Persona
{
    public string Nombre { get; }
    public int Edad { get; }

    public Persona(string nombre, int edad)
    {
        Nombre = nombre;
        Edad = edad;
    }

    public string Saludar()
    {
        // TODO: devuelve "Hola, soy <Nombre>".
        throw new NotImplementedException("TODO: implementar Persona.Saludar()");
    }

    public bool EsMayorDeEdad()
    {
        // TODO: devuelve true si Edad >= 18.
        throw new NotImplementedException("TODO: implementar Persona.EsMayorDeEdad()");
    }
}

public static class Ejercicio02
{
    public static Persona CrearPersona(string nombre, int edad)
    {
        // TODO: devuelve new Persona(nombre, edad).
        throw new NotImplementedException("TODO: implementar CrearPersona(string, int)");
    }
}