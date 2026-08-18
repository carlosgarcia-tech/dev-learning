#nullable enable
using System;
using System.Collections.Generic;

public class CacheLru
{
    private readonly int _capacidad;
    private readonly Dictionary<string, string> _valores = new Dictionary<string, string>();
    private readonly LinkedList<string> _orden = new LinkedList<string>();

    public CacheLru(int capacidad)
    {
        // TODO: valida que capacidad > 0 (si no, ArgumentException) y asígnala a _capacidad.
        _capacidad = capacidad;
    }

    public int Count => _valores.Count;

    public void Set(string clave, string valor)
    {
        // TODO: añade o actualiza la clave. Si ya existe, muévela al final del orden.
        //       Si la caché está llena, elimina la menos usada (la primera del orden).
        throw new NotImplementedException("TODO: implementar Set(string, string)");
    }

    public string? Get(string clave)
    {
        // TODO: devuelve el valor o null si no existe. Si existe, muévela al final del orden (más reciente).
        throw new NotImplementedException("TODO: implementar Get(string)");
    }

    public bool Contiene(string clave)
    {
        // TODO: devuelve true si la clave está en la caché.
        throw new NotImplementedException("TODO: implementar Contiene(string)");
    }
}

public static class Ejercicio04
{
    public static CacheLru CrearCache(int capacidad)
    {
        // TODO: devuelve new CacheLru(capacidad).
        throw new NotImplementedException("TODO: implementar CrearCache(int)");
    }
}