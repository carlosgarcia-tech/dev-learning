# 01 — Fundamentos de C#

## Objetivos

- [ ] Escribir y ejecutar tu primer programa en C# (`Main` como entry point).
- [ ] Declarar variables con tipos explícitos, `var` y constantes.
- [ ] Distinguir tipos de valor (`int`, `double`, `bool`, structs) de tipos de referencia (`string`, clases, arrays).
- [ ] Aplicar operadores aritméticos, de comparación, lógicos y de asignación.
- [ ] Escribir condicionales `if/else` y `switch` (clásico y como expresión).
- [ ] Usar los bucles `for`, `while`, `do-while` y `foreach` con `break` y `continue`.
- [ ] Trabajar con arrays, strings y sus métodos más usados.
- [ ] Leer entrada por consola e interpolar strings con `$"..."`.

## Apuntes

### Estructura de un programa

- El código fuente son archivos `.cs`. Se compila con `dotnet build`/`dotnet run` o con `csc` (Mono).
- `using System;` importa el espacio de nombres con clases básicas (`Console`, `Math`, `String`…).
- El **entry point** es `Main`. Puede devolver `int` (0 = éxito) o `void`.

```csharp
using System;

public class Programa
{
    public static int Main()
    {
        Console.WriteLine("Todo en orden");
        return 0; // 0 = el programa terminó correctamente
    }
}
```

### Variables y tipos

C# es **fuertemente tipado**. Puedes declarar el tipo explícitamente o usar `var` (el compilador lo infiere).

| Tipo | Descripción | Ejemplo |
|---|---|---|
| `int` | entero de 32 bits | `42` |
| `long` | entero de 64 bits | `1_000_000_000L` |
| `double` | coma flotante (precisión doble) | `3.1416` |
| `decimal` | precisión decimal (dinero) | `9.99m` |
| `bool` | `true` / `false` | `true` |
| `char` | un carácter | `'A'` |
| `string` | cadena de texto | `"Hola"` |

- **Tipo de valor** (`int`, `double`, `bool`, `char`, structs): la variable guarda el dato; asignar copia el valor.
- **Tipo de referencia** (`string`, clases, arrays, listas): la variable guarda una referencia; asignar comparte el objeto.

```csharp
int a = 5;
int b = a;   // copia el valor
b = 10;      // a sigue siendo 5

int[] x = { 1, 2, 3 };
int[] y = x; // ambas apuntan al MISMO array
y[0] = 99;   // x[0] también es 99
```

Las **constantes** no se pueden reasignar: `const double IVA = 0.21;`.

### Entrada y salida por consola

```csharp
Console.WriteLine("Texto con salto de línea");
Console.Write("Sin salto de línea");
string nombre = Console.ReadLine();        // lee una línea
int edad = int.Parse(Console.ReadLine());  // convierte a int
```

La **interpolación de strings** (`$"..."`) es la forma recomendada de construir texto:

```csharp
string nombre = "Ana";
int edad = 30;
Console.WriteLine($"Soy {nombre} y tengo {edad} años.");
```

### Operadores

```csharp
int suma = 7 + 3;      // 10
int div = 7 / 3;       // 2  (división entera)
double div2 = 7.0 / 3; // 2.333...
int mod = 7 % 3;       // 1  (resto)

==  !=  <  >  <=  >=     // devuelven bool
&&  ||  !                // and, or, not

string? s = null;
string t = s ?? "valor por defecto"; // ?? = si es null usa el otro
int x = 5 > 3 ? 100 : 0;             // ternario -> 100
```

### Condicionales

```csharp
int nota = 85;
if (nota >= 90)
{
    Console.WriteLine("Excelente");
}
else if (nota >= 70)
{
    Console.WriteLine("Aprobado");
}
else
{
    Console.WriteLine("Reprobado");
}
```

`switch` clásico y **switch como expresión** (C# 8+):

```csharp
string dia = "sábado";
string resultado = dia switch
{
    "sábado" or "domingo" => "Fin de semana",
    "lunes" or "martes" or "miércoles" or "jueves" or "viernes" => "Día laboral",
    _ => "Día desconocido"
};

// Pattern matching en parámetros
string Clasificar(int n) => n switch
{
    > 0 => "Positivo",
    < 0 => "Negativo",
    _ => "Cero"
};
```

### Bucles

```csharp
for (int i = 1; i <= 5; i++) { Console.WriteLine(i); } // 1 2 3 4 5

int j = 1;
while (j <= 5) { Console.WriteLine(j); j++; }
int k = 1;
do { Console.WriteLine(k); k++; } while (k <= 5);

int[] numeros = { 10, 20, 30 };
foreach (int n in numeros) { Console.WriteLine(n); }
```

`break` termina el bucle; `continue` salta a la siguiente iteración.

### Arrays

```csharp
int[] numeros = new int[5];          // 5 ceros
int[] otros = { 1, 2, 3 };           // inicializado
string[] nombres = new string[] { "Ana", "Luis" };

numeros[0] = 42;
Console.WriteLine(numeros.Length);   // 5

int[,] matriz = { { 1, 2 }, { 3, 4 } };       // multidimensional
int[][] dentado = { new int[] { 1, 2 }, new int[] { 3 } }; // dentado
```

### Strings

```csharp
string s = "  Hola, Mundo  ";
s.ToUpper();                    // "  HOLA, MUNDO  "
s.Trim();                       // "Hola, Mundo"
s.Replace("o", "0");            // "  H0la, Mund0  "
s.Contains("Mundo");            // true
s.Split(", ");                  // ["  Hola", "Mundo  "]
s.Substring(2, 4);              // "Hola"
string.Join("-", "a", "b");     // "a-b"
string.IsNullOrWhiteSpace(s);   // false
```

## Ejemplos de código

```csharp
using System;

public class Programa
{
    public static int Main()
    {
        Console.Write("¿Cómo te llamas? ");
        string nombre = Console.ReadLine() ?? "";
        Console.WriteLine($"Hola, {nombre}!");

        int[] numeros = { 4, 7, 1, 9, 3 };
        int suma = 0;
        foreach (int n in numeros)
        {
            suma += n;
        }
        Console.WriteLine($"La suma es {suma} y hay {numeros.Length} números.");
        return 0;
    }
}
```

## Ejercicios relacionados

- [nivel-01-fundamentos](../ejercicios/nivel-01-fundamentos/) — hola mundo, variables y tipos, operadores y condicionales, bucles, arrays, strings.

## Errores comunes

- **Usar `int.Parse` con texto no numérico** → lanza `FormatException`. Usa `int.TryParse` si no estás seguro.
- **Confundir división entera y real** → `7 / 3` es `2`; usa `7.0 / 3` para obtener `2.33`.
- **Pensar que asignar un array copia el array** → las variables de referencia comparten el mismo objeto.
- **Índices fuera de rango** → acceder a `arr[arr.Length]` lanza `IndexOutOfRangeException`.
- **Olvidar el `break` en un `switch` clásico** → el código "cae" al siguiente caso.
- **Usar `==` con strings esperando ignorar mayúsculas** → usa `Equals(..., StringComparison.OrdinalIgnoreCase)`.

## Recursos

- [Microsoft Learn — Guía de C#](https://learn.microsoft.com/es-es/dotnet/csharp/)
- [Microsoft Learn — Tipos integrados de C#](https://learn.microsoft.com/es-es/dotnet/csharp/language-reference/builtin-types/built-in-types)
- [Microsoft Learn — Interpolación de cadenas](https://learn.microsoft.com/es-es/dotnet/csharp/language-reference/tokens/interpolated)
- [Microsoft Learn — Bucles de C#](https://learn.microsoft.com/es-es/dotnet/csharp/language-reference/statements/iteration-statements)
- [Descargar el .NET SDK](https://dotnet.microsoft.com/es-es/download)