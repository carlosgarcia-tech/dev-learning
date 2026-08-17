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
        Animal perro = Ejercicio01.CrearAnimal("perro", "Rex");
        Check("CrearAnimal(\"perro\", \"Rex\") es una instancia de Perro", () => perro is Perro);
        Check("CrearAnimal(\"gato\", \"Misu\") es una instancia de Gato", () => Ejercicio01.CrearAnimal("gato", "Misu") is Gato);
        Check("CrearAnimal(\"pajaro\", \"Pío\") es una instancia de Animal", () => Ejercicio01.CrearAnimal("pajaro", "Pío") is Animal);

        Check("SonidoDe(perro) devuelve 'Guau'", () => Ejercicio01.SonidoDe(perro) == "Guau");
        Check("SonidoDe(gato) devuelve 'Miau'", () => Ejercicio01.SonidoDe(Ejercicio01.CrearAnimal("gato", "Misu")) == "Miau");
        Check("SonidoDe(Animal) devuelve 'Sonido genérico'", () => Ejercicio01.SonidoDe(new Animal("Fido")) == "Sonido genérico");

        Check("El nombre se conserva en las clases derivadas", () => perro.Nombre == "Rex");

        Check("Polimorfismo: los sonidos difieren por instancia",
            () =>
            {
                Animal[] animales =
                {
                    Ejercicio01.CrearAnimal("perro", "Rex"),
                    Ejercicio01.CrearAnimal("gato", "Misu")
                };
                string s1 = Ejercicio01.SonidoDe(animales[0]);
                string s2 = Ejercicio01.SonidoDe(animales[1]);
                return s1 == "Guau" && s2 == "Miau" && s1 != s2;
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