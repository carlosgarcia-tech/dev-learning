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
        RouterApi router = Ejercicio03.CrearRouter();
        router.Get("/api/saludo", cuerpo => "Hola");
        router.Post("/api/productos", cuerpo => "creado: " + cuerpo);

        var saludo = router.Procesar("GET", "/api/saludo");
        Check("GET /api/saludo devuelve (200, 'Hola')", () => saludo.Codigo == 200 && saludo.Cuerpo == "Hola");

        var inexistente = router.Procesar("GET", "/api/inexistente");
        Check("GET /api/inexistente devuelve (404, 'Ruta no encontrada')",
            () => inexistente.Codigo == 404 && inexistente.Cuerpo == "Ruta no encontrada");

        var noPermitido = router.Procesar("POST", "/api/saludo");
        Check("POST /api/saludo devuelve (405, 'Método no permitido')",
            () => noPermitido.Codigo == 405 && noPermitido.Cuerpo == "Método no permitido");

        var creado = router.Procesar("POST", "/api/productos", "laptop");
        Check("POST /api/productos con cuerpo 'laptop' devuelve (200, 'creado: laptop')",
            () => creado.Codigo == 200 && creado.Cuerpo == "creado: laptop");

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