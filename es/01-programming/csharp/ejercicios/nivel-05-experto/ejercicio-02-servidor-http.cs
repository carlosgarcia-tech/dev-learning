using System;

public class ServidorHttp
{
    private readonly int _puerto;
    public int Puerto => _puerto;

    public ServidorHttp(int puerto)
    {
        _puerto = puerto;
    }

    public string ProcesarRuta(string ruta)
    {
        // TODO: enruta la petición sin red:
        //   "/"                -> "<h1>Inicio</h1>"
        //   "/saludo"          -> "<h1>Hola, bienvenido</h1>"
        //   "/saludo?nombre=X" -> "<h1>Hola, X</h1>"
        //   "/api/hora"        -> DateTime.Now.ToString("HH:mm:ss")
        //   cualquier otra     -> "404 No encontrado"
        throw new NotImplementedException("TODO: implementar ProcesarRuta(string)");
    }
}

public static class Ejercicio02
{
    public static ServidorHttp CrearServidor(int puerto)
    {
        // TODO: devuelve new ServidorHttp(puerto).
        throw new NotImplementedException("TODO: implementar CrearServidor(int)");
    }
}