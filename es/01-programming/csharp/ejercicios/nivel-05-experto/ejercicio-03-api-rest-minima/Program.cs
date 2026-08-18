using System;
using System.Collections.Generic;

public class RouterApi
{
    private readonly List<(string Metodo, string Ruta, Func<string, string> Handler)> _rutas
        = new List<(string Metodo, string Ruta, Func<string, string> Handler)>();

    public void Get(string ruta, Func<string, string> handler)
    {
        // TODO: añade (metodo = "GET", ruta, handler).
        throw new NotImplementedException("TODO: implementar Get(string, Func<string,string>)");
    }

    public void Post(string ruta, Func<string, string> handler)
    {
        // TODO: añade (metodo = "POST", ruta, handler).
        throw new NotImplementedException("TODO: implementar Post(string, Func<string,string>)");
    }

    public (int Codigo, string Cuerpo) Procesar(string metodo, string ruta, string cuerpo = "")
    {
        // TODO: busca una ruta que coincida.
        //   Coincide ruta y método  -> (200, handler(cuerpo)).
        //   Coincide ruta, no método -> (405, "Método no permitido").
        //   No existe la ruta        -> (404, "Ruta no encontrada").
        throw new NotImplementedException("TODO: implementar Procesar(string, string, string)");
    }
}

public static class Ejercicio03
{
    public static RouterApi CrearRouter()
    {
        // TODO: devuelve new RouterApi().
        throw new NotImplementedException("TODO: implementar CrearRouter()");
    }
}