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
        Check("EsFinDeSemana(Sabado) es true", () => Ejercicio06.EsFinDeSemana(DiaSemana.Sabado));
        Check("EsFinDeSemana(Domingo) es true", () => Ejercicio06.EsFinDeSemana(DiaSemana.Domingo));
        Check("EsFinDeSemana(Lunes) es false", () => !Ejercicio06.EsFinDeSemana(DiaSemana.Lunes));
        Check("EsFinDeSemana(Viernes) es false", () => !Ejercicio06.EsFinDeSemana(DiaSemana.Viernes));

        Check("Siguiente(Lunes) devuelve Martes", () => Ejercicio06.Siguiente(DiaSemana.Lunes) == DiaSemana.Martes);
        Check("Siguiente(Viernes) devuelve Sabado", () => Ejercicio06.Siguiente(DiaSemana.Viernes) == DiaSemana.Sabado);
        Check("Siguiente(Domingo) devuelve Lunes", () => Ejercicio06.Siguiente(DiaSemana.Domingo) == DiaSemana.Lunes);

        Check("SiguienteEstado(Pendiente) devuelve Enviado",
            () => Ejercicio06.SiguienteEstado(EstadoPedido.Pendiente) == EstadoPedido.Enviado);
        Check("SiguienteEstado(Enviado) devuelve Entregado",
            () => Ejercicio06.SiguienteEstado(EstadoPedido.Enviado) == EstadoPedido.Entregado);

        Check("SiguienteEstado(Entregado) lanza InvalidOperationException",
            () =>
            {
                try { Ejercicio06.SiguienteEstado(EstadoPedido.Entregado); return false; }
                catch (InvalidOperationException) { return true; }
            });
        Check("SiguienteEstado(Cancelado) lanza InvalidOperationException",
            () =>
            {
                try { Ejercicio06.SiguienteEstado(EstadoPedido.Cancelado); return false; }
                catch (InvalidOperationException) { return true; }
            });

        Check("NombreEnEspanol(Miercoles) devuelve 'Miércoles'",
            () => Ejercicio06.NombreEnEspanol(DiaSemana.Miercoles) == "Miércoles");
        Check("NombreEnEspanol(Sabado) devuelve 'Sábado'",
            () => Ejercicio06.NombreEnEspanol(DiaSemana.Sabado) == "Sábado");
        Check("NombreEnEspanol(Lunes) devuelve 'Lunes'",
            () => Ejercicio06.NombreEnEspanol(DiaSemana.Lunes) == "Lunes");

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