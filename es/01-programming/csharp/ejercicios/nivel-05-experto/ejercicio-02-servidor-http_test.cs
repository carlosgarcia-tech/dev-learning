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
        ServidorHttp servidor = Ejercicio02.CrearServidor(8080);
        Check("CrearServidor(8080) guarda el puerto", () => servidor.Puerto == 8080);

        Check("ProcesarRuta(\"/\") devuelve '<h1>Inicio</h1>'",
            () => servidor.ProcesarRuta("/") == "<h1>Inicio</h1>");

        Check("ProcesarRuta(\"/saludo\") devuelve '<h1>Hola, bienvenido</h1>'",
            () => servidor.ProcesarRuta("/saludo") == "<h1>Hola, bienvenido</h1>");

        Check("ProcesarRuta(\"/saludo?nombre=Ana\") incluye 'Ana'",
            () => servidor.ProcesarRuta("/saludo?nombre=Ana") == "<h1>Hola, Ana</h1>");
        Check("ProcesarRuta(\"/saludo?nombre=Luis\") incluye 'Luis'",
            () => servidor.ProcesarRuta("/saludo?nombre=Luis") == "<h1>Hola, Luis</h1>");

        string hora = servidor.ProcesarRuta("/api/hora");
        Check("ProcesarRuta(\"/api/hora\") devuelve una hora HH:mm:ss",
            () => hora.Length == 8 && hora[2] == ':' && hora[5] == ':');

        Check("ProcesarRuta(\"/nope\") devuelve '404 No encontrado'",
            () => servidor.ProcesarRuta("/nope") == "404 No encontrado");
        Check("ProcesarRuta(\"\") devuelve '404 No encontrado'",
            () => servidor.ProcesarRuta("") == "404 No encontrado");

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