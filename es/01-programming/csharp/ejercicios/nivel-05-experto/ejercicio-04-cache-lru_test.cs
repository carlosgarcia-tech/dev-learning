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
        Check("CrearCache(0) lanza ArgumentException",
            () =>
            {
                try { Ejercicio04.CrearCache(0); return false; }
                catch (ArgumentException) { return true; }
            });

        CacheLru basico = Ejercicio04.CrearCache(3);
        basico.Set("a", "1");
        basico.Set("b", "2");
        Check("Set/Get básicos funcionan", () => basico.Get("a") == "1" && basico.Get("b") == "2");
        Check("Contiene devuelve true para claves existentes", () => basico.Contiene("a"));
        Check("Contiene devuelve false para claves inexistentes", () => !basico.Contiene("z"));
        Check("Get de una clave inexistente devuelve null", () => basico.Get("z") == null);
        Check("Count refleja las claves", () => basico.Count == 2);

        basico.Set("a", "10");
        Check("Actualizar una clave existente no incrementa Count", () => basico.Count == 2 && basico.Get("a") == "10");

        Check("Al llenar la caché se elimina la clave menos usada",
            () =>
            {
                CacheLru cache = Ejercicio04.CrearCache(2);
                cache.Set("a", "1");
                cache.Set("b", "2");
                cache.Get("a");
                cache.Set("c", "3");
                return cache.Contiene("a")
                    && !cache.Contiene("b")
                    && cache.Contiene("c")
                    && cache.Count == 2;
            });

        Check("Tras el primer desalojo, la siguiente clave menos usada es la correcta",
            () =>
            {
                CacheLru cache = Ejercicio04.CrearCache(2);
                cache.Set("a", "1");
                cache.Set("b", "2");
                cache.Set("c", "3");   // elimina "a"
                cache.Set("d", "4");   // elimina "b"
                return !cache.Contiene("a") && !cache.Contiene("b")
                    && cache.Contiene("c") && cache.Contiene("d");
            });

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