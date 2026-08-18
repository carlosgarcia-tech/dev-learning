using System;

public enum DiaSemana
{
    Lunes,
    Martes,
    Miercoles,
    Jueves,
    Viernes,
    Sabado,
    Domingo
}

public enum EstadoPedido
{
    Pendiente,
    Enviado,
    Entregado,
    Cancelado
}

public static class Ejercicio06
{
    public static bool EsFinDeSemana(DiaSemana dia)
    {
        // TODO: true si dia es Sabado o Domingo.
        throw new NotImplementedException("TODO: implementar EsFinDeSemana(DiaSemana)");
    }

    public static DiaSemana Siguiente(DiaSemana dia)
    {
        // TODO: devuelve el día siguiente (Domingo -> Lunes).
        throw new NotImplementedException("TODO: implementar Siguiente(DiaSemana)");
    }

    public static EstadoPedido SiguienteEstado(EstadoPedido estado)
    {
        // TODO: Pendiente -> Enviado, Enviado -> Entregado. Entregado/Cancelado lanzan InvalidOperationException.
        throw new NotImplementedException("TODO: implementar SiguienteEstado(EstadoPedido)");
    }

    public static string NombreEnEspanol(DiaSemana dia)
    {
        // TODO: devuelve el nombre con acentos: "Lunes", "Martes", "Miércoles", ..., "Domingo".
        throw new NotImplementedException("TODO: implementar NombreEnEspanol(DiaSemana)");
    }
}