using System;

public interface IReproducible
{
    string Reproducir();
}

public interface IDescribible
{
    string Describir();
}

public class Cancion : IReproducible, IDescribible
{
    public string Titulo { get; }
    public string Artista { get; }

    public Cancion(string titulo, string artista)
    {
        Titulo = titulo;
        Artista = artista;
    }

    public string Reproducir()
    {
        // TODO: devuelve "Reproduciendo: <Titulo> de <Artista>".
        throw new NotImplementedException("TODO: implementar Cancion.Reproducir()");
    }

    public string Describir()
    {
        // TODO: devuelve "Canción: <Titulo>".
        throw new NotImplementedException("TODO: implementar Cancion.Describir()");
    }
}

public class Pelicula : IReproducible, IDescribible
{
    public string Titulo { get; }

    public Pelicula(string titulo)
    {
        Titulo = titulo;
    }

    public string Reproducir()
    {
        // TODO: devuelve "Reproduciendo película: <Titulo>".
        throw new NotImplementedException("TODO: implementar Pelicula.Reproducir()");
    }

    public string Describir()
    {
        // TODO: devuelve "Película: <Titulo>".
        throw new NotImplementedException("TODO: implementar Pelicula.Describir()");
    }
}

public class SonidoDeAmbiente : IReproducible
{
    public string Reproducir() => "Sonido ambiente";
}

public static class Ejercicio02
{
    public static string ReproducirTodo(IReproducible[] elementos)
    {
        // TODO: devuelve las reproducciones de todos los elementos unidas por "\n".
        throw new NotImplementedException("TODO: implementar ReproducirTodo(IReproducible[])");
    }

    public static string Describir(IReproducible elemento)
    {
        // TODO: si el elemento es IDescribible usa Describir(); si no, "No describible".
        throw new NotImplementedException("TODO: implementar Describir(IReproducible)");
    }
}