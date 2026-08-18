using System;
using System.Collections.Generic;
using System.Linq;

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
        GestorTareas gestor = Ejercicio01.CrearGestor();
        Check("CrearGestor devuelve un gestor vacío", () => gestor.Total() == 0);

        Tarea t1 = gestor.Agregar("Comprar pan");
        Tarea t2 = gestor.Agregar("Estudiar C#");
        Check("Agregar asigna ids incrementales", () => t1.Id == 1 && t2.Id == 2);
        Check("Agregar guarda el título y queda pendiente", () => t1.Titulo == "Comprar pan" && !t1.Completada);
        Check("Total() refleja las tareas añadidas", () => gestor.Total() == 2);

        Check("Agregar con título vacío lanza ArgumentException",
            () =>
            {
                try { gestor.Agregar("   "); return false; }
                catch (ArgumentException) { return true; }
            });

        Check("MarcarCompletada(1) es true", () => gestor.MarcarCompletada(1));
        Check("MarcarCompletada(999) es false", () => !gestor.MarcarCompletada(999));
        Check("Completadas() contiene la tarea 1", () => gestor.Completadas().Count == 1 && gestor.Completadas()[0].Id == 1);
        Check("Pendientes() contiene la tarea 2", () => gestor.Pendientes().Count == 1 && gestor.Pendientes()[0].Id == 2);

        Check("Eliminar(2) es true", () => gestor.Eliminar(2));
        Check("Eliminar(999) es false", () => !gestor.Eliminar(999));
        Check("Total() decrece al eliminar", () => gestor.Total() == 1);

        Check("Resumen() tiene el formato exacto",
            () => gestor.Resumen() == "Total: 1, pendientes: 0, completadas: 1");

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