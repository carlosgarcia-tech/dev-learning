using System;
using System.Collections.Generic;

public class Tarea
{
    public int Id { get; }
    public string Titulo { get; }
    public bool Completada { get; set; }

    public Tarea(int id, string titulo)
    {
        Id = id;
        Titulo = titulo;
        Completada = false;
    }
}

public class GestorTareas
{
    private readonly List<Tarea> _tareas = new List<Tarea>();
    private int _siguienteId = 1;

    public Tarea Agregar(string titulo)
    {
        // TODO: valida el título (ArgumentException si está vacío), crea la tarea con el siguiente id e increméntalo.
        throw new NotImplementedException("TODO: implementar Agregar(string)");
    }

    public bool MarcarCompletada(int id)
    {
        // TODO: marca la tarea como completada; devuelve false si no existe.
        throw new NotImplementedException("TODO: implementar MarcarCompletada(int)");
    }

    public List<Tarea> Pendientes()
    {
        // TODO: devuelve las tareas no completadas.
        throw new NotImplementedException("TODO: implementar Pendientes()");
    }

    public List<Tarea> Completadas()
    {
        // TODO: devuelve las tareas completadas.
        throw new NotImplementedException("TODO: implementar Completadas()");
    }

    public int Total()
    {
        // TODO: devuelve el número total de tareas.
        throw new NotImplementedException("TODO: implementar Total()");
    }

    public bool Eliminar(int id)
    {
        // TODO: elimina la tarea con ese id; devuelve false si no existe.
        throw new NotImplementedException("TODO: implementar Eliminar(int)");
    }

    public string Resumen()
    {
        // TODO: devuelve "Total: X, pendientes: Y, completadas: Z".
        throw new NotImplementedException("TODO: implementar Resumen()");
    }
}

public static class Ejercicio01
{
    public static GestorTareas CrearGestor()
    {
        // TODO: devuelve new GestorTareas().
        throw new NotImplementedException("TODO: implementar CrearGestor()");
    }
}