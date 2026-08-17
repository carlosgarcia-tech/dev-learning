# 02 — Programación Orientada a Objetos (OOP)

## Objetivos

- [ ] Declarar clases y crear objetos con inicializadores.
- [ ] Distinguir campos, propiedades y métodos, y aplicar encapsulación.
- [ ] Escribir constructores (incluidos estáticos) y validar el estado inicial.
- [ ] Usar auto-propiedades, propiedades `init`, de solo lectura y calculadas.
- [ ] Aplicar herencia, `virtual`/`override`, `base` y `sealed`.
- [ ] Aplicar polimorfismo y clases abstractas.
- [ ] Definir e implementar interfaces, y saber cuándo usarlas.
- [ ] Usar `enum`, tipos nullable (`int?`, `string?`) y `record`.

## Apuntes

### Clases, objetos y propiedades

Una **clase** es un plano; un **objeto** es una instancia. Un **campo** es una variable dentro de la clase; una **propiedad** expone acceso controlado al estado (`get` / `set`).

```csharp
public class Persona
{
    public string Nombre { get; set; }
    public int Edad { get; set; } = 0;   // valor inicial
}

Persona luis = new Persona { Nombre = "Luis", Edad = 25 }; // inicializador
```

Propiedades de solo lectura, `init` y con cuerpo de expresión:

```csharp
public class Libro
{
    public string Titulo { get; init; }     // solo se asigna al crear
    public string Autor { get; }
    public Libro(string titulo, string autor) { Titulo = titulo; Autor = autor; }
}

public class Circulo
{
    public double Radio { get; set; }
    public double Area => Math.PI * Radio * Radio; // getter calculado
}
```

### Encapsulación

- `public`: accesible desde cualquier parte.
- `private`: solo dentro de la clase.
- `protected`: dentro de la clase y sus derivadas.
- `internal`: dentro del mismo ensamblado.

Regla práctica: mantén los campos **privados** y expón solo lo necesario mediante propiedades y métodos.

```csharp
public class Cuenta
{
    private double _saldo;            // campo privado

    public double Saldo => _saldo;    // propiedad de solo lectura

    public void Depositar(double monto)
    {
        if (monto <= 0)
            throw new ArgumentException("El monto debe ser positivo.");
        _saldo += monto;
    }
}
```

### Métodos y sobrecarga

```csharp
public class Calculadora
{
    public int Sumar(int a, int b) => a + b;
    public int SumarVarios(params int[] numeros) // params
    {
        int total = 0;
        foreach (int n in numeros) total += n;
        return total;
    }
    public int SumarConOpcional(int a, int b = 10) => a + b; // opcional
    public bool TryParseInt(string texto, out int resultado)  // out
        => int.TryParse(texto, out resultado);
}
```

- **Sobrecarga**: mismo nombre con firmas distintas (`Imprimir(string)` y `Imprimir(string, int)`).
- **Estáticos**: pertenecen a la clase, no a la instancia (`Utilidades.Cuadrado(5)`).

### Constructores

```csharp
public class Producto
{
    public string Nombre { get; }
    public double Precio { get; }

    public Producto(string nombre, double precio)
    {
        if (string.IsNullOrWhiteSpace(nombre))
            throw new ArgumentException("El nombre es obligatorio.");
        if (precio < 0)
            throw new ArgumentException("El precio no puede ser negativo.");
        Nombre = nombre;
        Precio = precio;
    }
}
```

Un **constructor estático** se ejecuta una sola vez (`static Config() { Version = "1.0.0"; }`).

### Herencia y polimorfismo

```csharp
public class Animal
{
    public string Nombre { get; }
    public Animal(string nombre) { Nombre = nombre; }
    public virtual string HacerSonido() => "Sonido genérico";
}

public class Perro : Animal
{
    public Perro(string nombre) : base(nombre) { }
    public override string HacerSonido() => "Guau";
}

public class Gato : Animal
{
    public Gato(string nombre) : base(nombre) { }
    public override string HacerSonido() => "Miau";
}

Animal miMascota = new Perro("Rex");
Console.WriteLine(miMascota.HacerSonido()); // "Guau"
```

- `virtual` permite sobrescribir; `override` sobrescribe una implementación `virtual`/`abstract`.
- `base(...)` llama al constructor base; `base.Metodo()` llama al método base.
- `sealed` impide heredar (o `sealed override` impide sobrescribir más abajo).

### Clases abstractas e interfaces

Una **clase abstracta** no se puede instanciar y sirve como base con estado y comportamiento compartido:

```csharp
public abstract class Forma
{
    public abstract double Area(); // las derivadas DEBEN implementarla
    public virtual string Nombre() => "Forma";
}

public class Cuadrado : Forma
{
    private readonly double _lado;
    public Cuadrado(double lado) { _lado = lado; }
    public override double Area() => _lado * _lado;
}
```

Una **interfaz** define un contrato (métodos/propiedades) que varios tipos no relacionados pueden cumplir:

```csharp
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
    public Cancion(string titulo) { Titulo = titulo; }
    public string Reproducir() => "Reproduciendo: " + Titulo;
    public string Describir() => "Canción: " + Titulo;
}

IReproducible cancion = new Cancion("Imagine");
Console.WriteLine(cancion.Reproducir());
```

**Cuándo usar cada una:** interfaz = contrato para múltiples implementaciones no relacionadas; clase abstracta = base con estado y comportamiento compartido.

### Enums

```csharp
public enum DiaSemana { Lunes, Martes, Miercoles, Jueves, Viernes, Sabado, Domingo }
public enum Nivel { Bajo = 1, Medio = 2, Alto = 3 }

DiaSemana hoy = DiaSemana.Miercoles;
int numero = (int)DiaSemana.Miercoles;   // 2 (empieza en 0)
string nombre = hoy.ToString();          // "Miercoles"
DiaSemana parsed = Enum.Parse<DiaSemana>("Lunes");
```

### Nullables

Por defecto los tipos de valor no admiten `null`. Se vuelven nullable con `?`:

```csharp
int? edad = null;
int total = edad ?? 0;              // ?? -> si es null usa 0

string? texto = null;
int? longitud = texto?.Length;      // ?. -> no lanza NullReferenceException
```

Para tipos de referencia, C# 8+ permite marcarlos como anulables con `#nullable enable`.

### Records (C# 9+)

Un `record` es una clase pensada para datos inmutables, con igualdad por valor:

```csharp
public record Punto(int X, int Y);

Punto p1 = new(3, 4);
Punto p2 = new(3, 4);
Console.WriteLine(p1 == p2);            // true (compara valores)

Punto p3 = p2 with { Y = 10 };          // copia con cambios (with)
```

## Ejemplos de código

```csharp
using System;
using System.Collections.Generic;

public class CuentaBancaria
{
    private double _saldo;

    public double Saldo => _saldo;

    public void Depositar(double monto)
    {
        if (monto <= 0) throw new ArgumentException("El monto debe ser positivo.");
        _saldo += monto;
    }

    public bool PuedeRetirar(double monto) => monto > 0 && monto <= _saldo;

    public void Retirar(double monto)
    {
        if (!PuedeRetirar(monto))
            throw new InvalidOperationException("No hay saldo suficiente.");
        _saldo -= monto;
    }
}

public class Programa
{
    public static int Main()
    {
        var cuenta = new CuentaBancaria();
        cuenta.Depositar(100);
        cuenta.Retirar(40);
        Console.WriteLine($"Saldo: {cuenta.Saldo}"); // 60
        return 0;
    }
}
```

## Ejercicios relacionados

- [nivel-02-basico](../ejercicios/nivel-02-basico/) — métodos, clases y objetos, propiedades, excepciones, enums.
- [nivel-03-intermedio](../ejercicios/nivel-03-intermedio/) — herencia, interfaces, genéricos, nullables.

## Errores comunes

- **Olvidar `base(...)` en el constructor de una clase derivada** → el compilador exige llamar al constructor base cuando no hay uno sin parámetros.
- **Marcar todo `public` sin encapsular** → se pierde el control sobre el estado (validaciones, invariantes).
- **Sobrescribir sin `virtual`/`override`** → el método se "oculta" en lugar de polimorfizar; C# avisa con un warning.
- **Instanciar una clase abstracta o una interfaz** → error de compilación. Usa una clase concreta derivada.
- **Confundir `??` con `?.`** → `??` da un valor por defecto; `?.` evita el acceso a un objeto null.
- **Comparar records por referencia** → los records comparan por valor, no por referencia.
- **Asignar `null` a un `int`** → los tipos de valor no admiten null salvo que lo declares nullable (`int?`).

## Recursos

- [Microsoft Learn — Tutorial: OOP en C#](https://learn.microsoft.com/es-es/dotnet/csharp/fundamentals/tutorials/oop)
- [Microsoft Learn — Herencia en C#](https://learn.microsoft.com/es-es/dotnet/csharp/fundamentals/object-oriented/inheritance)
- [Microsoft Learn — Interfaces](https://learn.microsoft.com/es-es/dotnet/csharp/fundamentals/types/interfaces)
- [Microsoft Learn — Nullable reference types](https://learn.microsoft.com/es-es/dotnet/csharp/nullable-references)
- [Microsoft Learn — Records](https://learn.microsoft.com/es-es/dotnet/csharp/language-reference/builtin-types/record)