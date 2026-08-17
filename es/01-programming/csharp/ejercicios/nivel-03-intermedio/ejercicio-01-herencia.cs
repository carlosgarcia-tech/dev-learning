using System;

public class Animal
{
    public string Nombre { get; }

    public Animal(string nombre)
    {
        Nombre = nombre;
    }

    public virtual string HacerSonido()
    {
        // TODO: devuelve "Sonido genérico".
        throw new NotImplementedException("TODO: implementar Animal.HacerSonido()");
    }
}

public class Perro : Animal
{
    public Perro(string nombre) : base(nombre) { }

    public override string HacerSonido()
    {
        // TODO: devuelve "Guau".
        throw new NotImplementedException("TODO: implementar Perro.HacerSonido()");
    }
}

public class Gato : Animal
{
    public Gato(string nombre) : base(nombre) { }

    public override string HacerSonido()
    {
        // TODO: devuelve "Miau".
        throw new NotImplementedException("TODO: implementar Gato.HacerSonido()");
    }
}

public static class Ejercicio01
{
    public static Animal CrearAnimal(string tipo, string nombre)
    {
        // TODO: "perro" -> new Perro(nombre); "gato" -> new Gato(nombre); otro -> new Animal(nombre).
        throw new NotImplementedException("TODO: implementar CrearAnimal(string, string)");
    }

    public static string SonidoDe(Animal animal)
    {
        // TODO: devuelve animal.HacerSonido().
        throw new NotImplementedException("TODO: implementar SonidoDe(Animal)");
    }
}