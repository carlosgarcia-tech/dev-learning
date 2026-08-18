# 01 — Fundamentos de C#

## Objetivos

- [ ] Entender qué es C# y el ecosistema .NET.
- [ ] Instalar y configurar el entorno (SDK de .NET y/o Mono).
- [ ] Escribir y ejecutar tu primer programa en C# (`Main` como entry point).
- [ ] Declarar variables con tipos explícitos, `var` y constantes.
- [ ] Distinguir tipos de valor (`int`, `double`, `bool`, structs) de tipos de referencia (`string`, clases, arrays).
- [ ] Aplicar operadores aritméticos, de comparación, lógicos y de asignación.
- [ ] Escribir condicionales `if/else` y `switch` (clásico y como expresión).
- [ ] Usar los bucles `for`, `while`, `do-while` y `foreach` con `break` y `continue`.
- [ ] Trabajar con arrays, strings y sus métodos más usados.
- [ ] Leer entrada por consola e interpolar strings con `$"..."`.
- [ ] Compilar con `dotnet` y con `csc` (Mono).

## Apuntes

### ¿Qué es C#?

C# es un lenguaje de programación **fuertemente tipado, orientado a objetos y multiplataforma** creado por Microsoft (Anders Hejlsberg) en el año 2000, diseñado junto con la plataforma **.NET**. Su filosofía es similar a Java en cuanto a gestión de memoria (Garbage Collector), pero con más azúcar sintáctico.

#### Características principales:
- **Fuertemente tipado**: el compilador verifica los tipos en tiempo de compilación.
- **Multiplataforma**: con .NET Core/.NET 5+ el código compilado se ejecuta en Windows, Linux y macOS.
- **Orientado a objetos y funcional**: clases, herencia, interfaces y también funciones de primera clase (delegados, LINQ, records).
- **Seguro**: gestión automática de memoria, excepciones y *nullable reference types*.
- **Ecosistema unificado**: el mismo `dotnet` CLI compila, ejecuta, prueba y publica.
- **Versátil**: consola, web (ASP.NET Core), escritorio, móvil (MAUI), juegos (Unity).

### El ecosistema .NET

1. **Código fuente** (`.cs`) → **compilador** (`csc`/`dotnet build`) → **IL** (Intermediate Language, `.dll`/`.exe`)
2. El **Common Language Runtime (CLR)** ejecuta el IL y hace *Just-In-Time* (JIT) a código nativo.
3. La **BCL** (Base Class Library) es la biblioteca estándar: colecciones, E/S, JSON, HTTP, etc.

Existen dos formas de compilar en esta ruta:

| Toolchain | Comando | Cuándo usarla |
|---|---|---|
| .NET SDK | `dotnet run` | La recomendada; gestiona paquetes, versiones y tests |
| Mono/csc | `csc Program.cs` + `mono Program.exe` | Sin instalación del SDK; compilación directa de archivos |

Ambas son válidas para los ejercicios de la ruta; cada ejercicio documenta los dos comandos.

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

Los espacios de nombres (`namespace`) agrupan tipos. Las clases usadas desde otro espacio de nombres se importan con `using`:

```csharp
using System.Collections.Generic;   // List<T>, Dictionary<,>
using System.Linq;                 // Where, Select, ...
using System.Text;                 // StringBuilder
using System.IO;                   // File, Directory
using System.Threading.Tasks;      // Task, async/await
```

> `Console`, `string`, `Math`, `Exception` y los tipos básicos viven en `System`, que se importa implícitamente en los proyectos `dotnet new console`. En compilaciones manuales con `csc` conviene escribirlo explícitamente.

### Instalación y entorno

**Opción A — .NET SDK (recomendada):**

```bash
# Debian/Ubuntu
sudo apt install dotnet-sdk-8.0

# O desde el instalador oficial
# https://dotnet.microsoft.com/download
```

Verificar: `dotnet --version` y `dotnet --list-sdks`.

**Opción B — Mono (compilador csc y runtime):**

```bash
sudo apt install mono-devel
mono --version        # runtime
csc --version         # compilador de C#
```

> Nota: en esta máquina el SDK de .NET no está instalado; los ejercicios se pueden ejecutar igualmente con Mono (`csc` + `mono`).

### Compilar y ejecutar

**Con .NET SDK:**

```bash
dotnet new console -n MiPrograma     # crea el proyecto
cd MiPrograma
dotnet run                           # compila y ejecuta
dotnet build                         # solo compila
```

**Con Mono/csc:**

```bash
csc Programa.cs -out:Programa.exe    # compila a ejecutable
mono Programa.exe                    # ejecuta
```

Cuando un ejercicio tiene `Program.cs` y `ProgramTest.cs`, la ejecución con csc incluye ambos archivos:

```bash
csc Program.cs ProgramTest.cs -out:ProgramTest.exe
mono ProgramTest.exe
```

> La regla es sencilla: el archivo que contiene `Main` determina el programa que se ejecuta. El runner de tests (`ProgramTest.cs`) contiene su propio `Main`.

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

Tipos numéricos adicionales: `byte` (0–255), `short` (−32.768–32.767), `float` (coma flotante simple, sufijo `f`), `uint`/`ulong` (sin signo), `nint`/`nuint` (nativo). Los separadores `_` mejoran la legibilidad de números grandes: `1_000_000`.

```csharp
int maximo = 2_147_483_647;
long poblacion = 8_000_000_000L;
float peso = 72.5f;
decimal precio = 19.99m;      // recomendado para dinero
```

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

Las **constantes** no se pueden reasignar: `const double IVA = 0.21;`. Para valores que solo se asignan una vez en tiempo de ejecución existe `readonly`.

```csharp
const int DIAS_SEMANA = 7;      // constante de compilación
readonly int _baseDatosId = CargarId(); // asignable solo en constructor/campo
```

`var` infiere el tipo sin repetirlo; úsalo cuando el tipo es obvio por el valor o el constructor:

```csharp
var numero = 42;            // int
var texto = "Hola";         // string
var lista = new List<int>(); // List<int>
// var sinInicializador;     // ❌ error: var exige inicialización
```

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

Formatos dentro de la interpolación:

```csharp
double precio = 1234.5678;
Console.WriteLine($"{precio:F2}");   // 1234,57  (2 decimales)
Console.WriteLine($"{precio:C}");    // moneda según cultura
Console.WriteLine($"{precio:N0}");   // 1.235     (miles, sin decimales)
int codigo = 42;
Console.WriteLine($"{codigo:D5}");   // 00042     (relleno con ceros)
```

Entrada numérica robusta con `TryParse`:

```csharp
Console.Write("Edad: ");
if (int.TryParse(Console.ReadLine(), out int edad))
{
    Console.WriteLine($"Tienes {edad} años.");
}
else
{
    Console.WriteLine("Eso no era un número.");
}
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
switch (dia)
{
    case "sábado":
    case "domingo":
        Console.WriteLine("Fin de semana");
        break;
    case "lunes":
    case "martes":
    case "miércoles":
    case "jueves":
    case "viernes":
        Console.WriteLine("Día laboral");
        break;
    default:
        Console.WriteLine("Día desconocido");
        break;
}
```

Como expresión (C# 8+):

```csharp
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

```csharp
// break: salir al encontrar el primer negativo
int[] datos = { 3, 5, -1, 9 };
foreach (int d in datos)
{
    if (d < 0) break;
    Console.WriteLine(d); // 3, 5
}

// continue: saltarse los pares
for (int i = 1; i <= 6; i++)
{
    if (i % 2 == 0) continue;
    Console.WriteLine(i); // 1, 3, 5
}
```

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

Recorrer un array:

```csharp
int[] notas = { 7, 9, 5, 8 };

// con foreach (recomendado si no necesitas el índice)
int suma = 0;
foreach (int n in notas) suma += n;

// con for (necesitas el índice)
for (int i = 0; i < notas.Length; i++)
    Console.WriteLine($"notas[{i}] = {notas[i]}");
```

Métodos y helpers de arrays:

```csharp
Array.Sort(notas);             // ordena en el lugar
Array.Reverse(notas);          // invierte en el lugar
Array.IndexOf(notas, 8);       // índice del valor (o -1)
int[] copia = (int[])notas.Clone(); // copia independiente
string texto = string.Join(", ", notas);
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

| Método | Qué hace | Ejemplo |
|---|---|---|
| `Length` | nº de caracteres (propiedad) | `"Hola".Length` → 4 |
| `ToUpper()`/`ToLower()` | convierte mayúsculas/minúsculas | `"Ana".ToUpper()` → `"ANA"` |
| `Trim()`/`TrimStart()`/`TrimEnd()` | elimina espacios de los extremos | `" x ".Trim()` → `"x"` |
| `Contains(x)` | ¿contiene la subcadena? | `"abc".Contains("b")` → true |
| `StartsWith(x)`/`EndsWith(x)` | ¿empieza/termina por? | `"Ana".StartsWith("A")` → true |
| `IndexOf(x)` | posición de la subcadena (−1 si no existe) | `"abc".IndexOf("b")` → 1 |
| `Substring(i, n)` | extrae `n` caracteres desde `i` | `"Hola".Substring(1, 2)` → `"ol"` |
| `Split(x)` | divide en partes por un separador | `"a,b".Split(',')` → `["a","b"]` |
| `Replace(a, b)` | sustituye ocurrencias | `"aa".Replace("a", "b")` → `"bb"` |
| `IsNullOrWhiteSpace(s)` | ¿es null o solo espacios? | `"   "` → true |
| `Join(sep, items)` | une una colección con separador | `string.Join(", ", nums)` |

Los strings son **inmutables**: los métodos devuelven un *nuevo* string y no modifican el original. Para construir texto repetidamente usa `StringBuilder`:

```csharp
var sb = new StringBuilder();
for (int i = 1; i <= 10; i++)
{
    sb.Append(i).Append(i < 10 ? ", " : "");
}
Console.WriteLine(sb); // "1, 2, 3, ..., 10"
```

Comparación ignorando mayúsculas/minúsculas:

```csharp
string a = "Ana";
Console.WriteLine(a == "ana");                       // false
Console.WriteLine(a.Equals("ana", StringComparison.OrdinalIgnoreCase)); // true
```

### Métodos y funciones

Un **método** agrupa lógica reutilizable con un nombre, parámetros y un tipo de retorno:

```csharp
public static double CalcularIMC(double pesoKg, double alturaM)
{
    return pesoKg / (alturaM * alturaM);
}

public static void Saludar(string nombre)  // void: no devuelve nada
{
    Console.WriteLine($"Hola, {nombre}!");
}
```

Llamada: `double imc = CalcularIMC(72, 1.75);`

- Parámetros con **valor por defecto** (opcionales) van al final: `double Calcular(double x, double y = 10)`.
- **Sobrecarga**: el mismo nombre con distintas firmas es válido: `Sumar(int, int)` y `Sumar(double, double)`.
- Cuerpos de expresión para métodos cortos: `public static int Doble(int x) => x * 2;`.

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
- Cada ejercicio tiene `Program.cs` (solución) y `ProgramTest.cs` (runner de tests). Para ejecutarlos: `dotnet run` o `csc Program.cs ProgramTest.cs && mono ProgramTest.exe`.

## Errores comunes

- **Usar `int.Parse` con texto no numérico** → lanza `FormatException`. Usa `int.TryParse` si no estás seguro.
- **Confundir división entera y real** → `7 / 3` es `2`; usa `7.0 / 3` para obtener `2.33`.
- **Pensar que asignar un array copia el array** → las variables de referencia comparten el mismo objeto.
- **Índices fuera de rango** → acceder a `arr[arr.Length]` lanza `IndexOutOfRangeException`.
- **Olvidar el `break` en un `switch` clásico** → el código "cae" al siguiente caso.
- **Usar `==` con strings esperando ignorar mayúsculas** → usa `Equals(..., StringComparison.OrdinalIgnoreCase)`.
- **Desbordamiento silencioso de enteros** → `int.MaxValue + 1` desborda a `int.MinValue`; usa `long` o `checked` si importa.
- **`Console.ReadLine()` devuelve `null` al final de la entrada** → encadena `?? ""` para evitar `NullReferenceException`.

## Recursos

- [Microsoft Learn — Guía de C#](https://learn.microsoft.com/es-es/dotnet/csharp/)
- [Microsoft Learn — Tipos integrados de C#](https://learn.microsoft.com/es-es/dotnet/csharp/language-reference/builtin-types/built-in-types)
- [Microsoft Learn — Interpolación de cadenas](https://learn.microsoft.com/es-es/dotnet/csharp/language-reference/tokens/interpolated)
- [Microsoft Learn — Bucles de C#](https://learn.microsoft.com/es-es/dotnet/csharp/language-reference/statements/iteration-statements)
- [Descargar el .NET SDK](https://dotnet.microsoft.com/es-es/download)