# 02 — Programación Orientada a Objetos (OOP)

## Objetivos

- [ ] Declarar clases y crear objetos con inicializadores.
- [ ] Organizar el código con namespaces y `using`.
- [ ] Distinguir campos, propiedades y métodos, y aplicar encapsulación.
- [ ] Escribir constructores (incluidos estáticos) y validar el estado inicial.
- [ ] Usar auto-propiedades, propiedades `init`, de solo lectura y calculadas.
- [ ] Aplicar herencia, `virtual`/`override`, `base` y `sealed`.
- [ ] Aplicar polimorfismo y clases abstractas.
- [ ] Definir e implementar interfaces, y saber cuándo usarlas.
- [ ] Trabajar con genéricos, `struct` y `record`.
- [ ] Usar `enum`, tipos nullable (`int?`, `string?`) y `record`.

## Apuntes

### Namespaces y organización del código

Un **namespace** agrupa tipos relacionados y evita colisiones de nombres:

```csharp
namespace Biblioteca.Modelos
{
    public class Libro { }
    public class Miembro { }
}

// En otro archivo:
using Biblioteca.Modelos;
var libro = new Libro();
```

Reglas habituales:
- Un namespace por "tema": `Biblioteca.Modelos`, `Biblioteca.Datos`, `Biblioteca.Servicios`.
- Un archivo `.cs` por clase (no obligatorio, pero recomendable).
- En un proyecto `dotnet new console`, el namespace por defecto es el nombre del proyecto.

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

`init` permite usar el inicializador pero no reasignar después:

```csharp
var libro = new Libro { Titulo = "El Quijote", Autor = "Cervantes" };
// libro.Titulo = "Otro";  // ❌ error de compilación: la propiedad es init
```

### Encapsulación

- `public`: accesible desde cualquier parte.
- `private`: solo dentro de la clase.
- `protected`: dentro de la clase y sus derivadas.
- `internal`: dentro del mismo ensamblado.
- `private protected`: dentro de la misma clase y derivadas del mismo ensamblado.

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

Convención de nombres: campos privados con `_camelCase`; propiedades y métodos `PascalCase`. El proyecto final de la ruta aplica esta convención en todo `Biblioteca`.

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
- **`params`**: acepta un número variable de argumentos (`SumarVarios(1, 2, 3, 4)`).
- **`out`**: devuelve un valor adicional por parámetro; el método debe asignarlo.
- **`ref`**: permite modificar el argumento del llamador por referencia.

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
- Un método derivado puede llamar a la versión base con `base.Metodo()`.

Regla de oro: **prefiere composición sobre herencia** salvo que exista una relación real "es-un" y la base aporte estado o comportamiento reutilizable.

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

### Genéricos

Los **genéricos** permiten escribir código que funciona con cualquier tipo sin perder el tipado:

```csharp
public class Caja<T>
{
    public T Contenido { get; set; }

    public Caja(T contenido) { Contenido = contenido; }
}

var cajaEnteros = new Caja<int>(42);
var cajaTexto = new Caja<string>("Hola");
```

Métodos genéricos con restricciones:

```csharp
public static T Mayor<T>(T a, T b) where T : IComparable<T>
    => a.CompareTo(b) >= 0 ? a : b;

// Restricciones habituales:
//   where T : class        -> tipo de referencia
//   where T : struct       -> tipo de valor
//   where T : IFoo         -> implementa la interfaz
//   where T : new()        -> tiene constructor sin parámetros
```

En la colección de ejercicios y en el proyecto final aparecen genéricos en `IRepositorio<T>` y en las listas de modelos. El framework `System.Collections.Generic` (que se importa con `using System.Collections.Generic;`) es la librería genérica por excelencia.

### Structs

Un `struct` es un **tipo de valor**: se copia al asignar y no se comparte referencia:

```csharp
public struct Punto
{
    public int X { get; set; }
    public int Y { get; set; }

    public Punto(int x, int y) { X = x; Y = y; }
}

Punto p1 = new Punto(3, 4);
Punto p2 = p1;      // copia independiente
p2.X = 99;          // p1.X sigue siendo 3
```

Usa `struct` para datos pequeños e inmutables; usa `class` para el resto. Para datos inmutables con igualdad por valor, `record` suele ser mejor opción (ver más abajo).

### Enums

```csharp
public enum DiaSemana { Lunes, Martes, Miercoles, Jueves, Viernes, Sabado, Domingo }
public enum Nivel { Bajo = 1, Medio = 2, Alto = 3 }

DiaSemana hoy = DiaSemana.Miercoles;
int numero = (int)DiaSemana.Miercoles;   // 2 (empieza en 0)
string nombre = hoy.ToString();          // "Miercoles"
DiaSemana parsed = Enum.Parse<DiaSemana>("Lunes");

// Validar si un valor existe en el enum
bool esValido = Enum.IsDefined(typeof(DiaSemana), "Lunes");

// Iterar todos los valores
foreach (DiaSemana d in Enum.GetValues<DiaSemana>())
    Console.WriteLine(d);
```

Los `enum` se usan para representar opciones cerradas: estado de un préstamo, tipo de usuario, nivel, etc. Evita guardar "magic numbers"; dale nombre con el enum.

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

Variantes y combinación con OOP:

```csharp
public record Persona(string Nombre, int Edad);          // record posicional
public record struct PersonaStruct(string Nombre);       // record struct (valor)

// record con miembros adicionales
public record Libro(string Titulo, string Autor)
{
    public string Referencia => $"{Titulo} ({Autor})";
}
```

En el proyecto final los modelos (`Libro`, `Miembro`, `Prestamo`) son `record`: al ser igualdad por valor, comparar dos libros con los mismos datos devuelve `true`, y `with` permite crear copias sin mutar el original.

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
- Aplica estos conceptos en el [PROYECTO FINAL](../ejercicios/proyectos/proyecto-final/README.md): modelos como `record`, servicios como clases con interfaces, y validaciones en los constructores.

## Errores comunes

- **Olvidar `base(...)` en el constructor de una clase derivada** → el compilador exige llamar al constructor base cuando no hay uno sin parámetros.
- **Marcar todo `public` sin encapsular** → se pierde el control sobre el estado (validaciones, invariantes).
- **Sobrescribir sin `virtual`/`override`** → el método se "oculta" en lugar de polimorfizar; C# avisa con un warning.
- **Instanciar una clase abstracta o una interfaz** → error de compilación. Usa una clase concreta derivada.
- **Confundir `??` con `?.`** → `??` da un valor por defecto; `?.` evita el acceso a un objeto null.
- **Comparar records por referencia** → los records comparan por valor, no por referencia.
- **Asignar `null` a un `int`** → los tipos de valor no admiten null salvo que lo declares nullable (`int?`).
- **Usar `struct` para objetos grandes o mutables** → cada asignación copia todo el dato; para eso mejor `class` o `record`.
- **Confundir `class` y `record`** → el `record` gana igualdad por valor y `with`, pero ambos son tipos de referencia.

## Recursos

- [Microsoft Learn — Tutorial: OOP en C#](https://learn.microsoft.com/es-es/dotnet/csharp/fundamentals/tutorials/oop)
- [Microsoft Learn — Herencia en C#](https://learn.microsoft.com/es-es/dotnet/csharp/fundamentals/object-oriented/inheritance)
- [Microsoft Learn — Interfaces](https://learn.microsoft.com/es-es/dotnet/csharp/fundamentals/types/interfaces)
- [Microsoft Learn — Genéricos](https://learn.microsoft.com/es-es/dotnet/csharp/fundamentals/types/generics)
- [Microsoft Learn — Nullable reference types](https://learn.microsoft.com/es-es/dotnet/csharp/nullable-references)
- [Microsoft Learn — Records](https://learn.microsoft.com/es-es/dotnet/csharp/language-reference/builtin-types/record)