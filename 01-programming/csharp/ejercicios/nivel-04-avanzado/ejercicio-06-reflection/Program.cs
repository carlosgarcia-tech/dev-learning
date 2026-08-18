#nullable enable
using System;
using System.Collections.Generic;

public class ReflexionDemo
{
    public int Valor { get; set; }
    public void Saludar() { }
}

public static class Ejercicio06
{
    public static string NombreDeLaClase(object objeto)
    {
        // TODO: devuelve objeto.GetType().Name.
        throw new NotImplementedException("TODO: implementar NombreDeLaClase(object)");
    }

    public static List<string> NombresDeMetodos(Type tipo)
    {
        // TODO: devuelve los nombres de los métodos públicos, sin duplicados y ordenados alfabéticamente.
        throw new NotImplementedException("TODO: implementar NombresDeMetodos(Type)");
    }

    public static List<string> NombresDePropiedades(Type tipo)
    {
        // TODO: devuelve los nombres de las propiedades públicas, ordenados alfabéticamente.
        throw new NotImplementedException("TODO: implementar NombresDePropiedades(Type)");
    }

    public static bool TienePropiedad(Type tipo, string nombre)
    {
        // TODO: devuelve true si el tipo tiene una propiedad pública con ese nombre.
        throw new NotImplementedException("TODO: implementar TienePropiedad(Type, string)");
    }

    public static object? CrearInstancia(Type tipo)
    {
        // TODO: devuelve Activator.CreateInstance(tipo).
        throw new NotImplementedException("TODO: implementar CrearInstancia(Type)");
    }
}