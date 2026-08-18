# 05 — Errores y testing

## Objetivos

- [ ] Lanzar y capturar excepciones con `try/catch/finally` y `throw`.
- [ ] Conocer las excepciones comunes del framework y cuándo ocurren.
- [ ] Crear excepciones propias heredando de `Exception`.
- [ ] Entender el mini framework de tests de esta ruta (`ProgramTest.cs`).
- [ ] Aplicar el ciclo Red-Green-Refactor de TDD.
- [ ] Usar reflection para inspeccionar tipos en tiempo de ejecución.
- [ ] Escribir tests robustos (casos normales, límites y errores).

## Apuntes

### Excepciones

Una **excepción** interrumpe el flujo normal y salta a un bloque `catch` que la maneje:

```csharp
try
{
    int resultado = 10 / 0;
}
catch (DivideByZeroException ex)
{
    Console.WriteLine("Error: " + ex.Message);
}
finally
{
    Console.WriteLine("Esto se ejecuta siempre");
}
```

Jerarquía de `catch` (del más específico al más general) y re-lanzado preservando la pila:

```csharp
try { ProcesoRiesgoso(); }
catch (FormatException ex) { /* error de formato */ }
catch (ArgumentException ex) { /* argumento inválido */ }
catch (Exception ex) { /* cualquier otro error */ }
finally { LimpiarRecursos(); }
```

```csharp
try { ... }
catch (Exception ex)
{
    throw;            // re-lanza tal cual (preserva la pila)
    // throw ex;      // ❌ reinicia la pila de llamadas (evitar)
}
```

Lanzar excepciones propias o del framework:

```csharp
public static double Dividir(double a, double b)
{
    if (b == 0)
        throw new ArgumentException("No se puede dividir por cero.");
    return a / b;
}
```

`finally` se ejecuta siempre, incluso si hay `return` en el `try`. El patrón `using` es la alternativa idiomática para liberar recursos:

```csharp
using (var lector = new StreamReader("datos.txt"))   // se cierra al salir
{
    Console.WriteLine(lector.ReadToEnd());
}

// Equivalente (desde C# 8):
using var lector2 = new StreamReader("datos.txt");
Console.WriteLine(lector2.ReadToEnd());
```

### Excepciones comunes del framework

| Excepción | Cuándo ocurre |
|---|---|
| `FormatException` | falla `int.Parse("abc")` |
| `DivideByZeroException` | división por cero |
| `NullReferenceException` | accedes a un miembro de una referencia null |
| `IndexOutOfRangeException` | índice fuera de los límites de un array |
| `ArgumentException` | argumento inválido |
| `ArgumentNullException` | argumento null donde no se permite |
| `KeyNotFoundException` | clave inexistente en un diccionario |
| `InvalidOperationException` | operación inválida para el estado actual |
| `IOException` | error de E/S (archivos, red) |
| `TimeoutException` | una operación supera su tiempo límite |
| `JsonException` | el JSON no se puede deserializar |

Excepciones propias:

```csharp
public class StockInsuficienteException : Exception
{
    public StockInsuficienteException(string mensaje) : base(mensaje) { }
}

if (cantidad > stock)
    throw new StockInsuficienteException(
        $"Stock insuficiente de {nombre}: quedan {stock} unidades.");
```

Buenas prácticas con excepciones propias:
- Nombra con sufijo `Exception` y deriva de `Exception` (o `ApplicationException`).
- Envía un mensaje claro y accionable (`$"..."` con el contexto).
- Lanza excepciones para **casos excepcionales**, no para control de flujo.
- En el proyecto final, las excepciones propias de la biblioteca viven en `ExcepcionesBiblioteca.cs` (p. ej. `EmailDuplicadoException`, `LibroNoDisponibleException`).

### Mini framework de tests de esta ruta

Cada ejercicio vive en un directorio con `Program.cs` (el stub/solución) y `ProgramTest.cs` (el runner de tests). El runner ejecuta "checks" nombrados, imprime `[OK]` o `[FALL]` y devuelve **0** si todos pasan y **1** si alguno falla:

```csharp
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
        Check("Sumar(2, 3) es 5", () => Ejercicio01.Sumar(2, 3) == 5);
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
```

> El runner usa `Func<bool>` y captura excepciones, así el stub (que lanza `NotImplementedException`) se reporta como `[FALL]` en lugar de romper el programa.

Cómo ejecutar los tests de un ejercicio (desde su directorio):

```bash
# Con el .NET SDK
dotnet run

# Con Mono/csc
csc Program.cs ProgramTest.cs -out:ProgramTest.exe
mono ProgramTest.exe
```

> El **.NET SDK no está instalado** en esta máquina; usa la vía Mono (`csc` + `mono`) para verificar localmente.

Cómo escribir un test: un `Check` por comportamiento, con nombre descriptivo que diga **qué** se verifica y **qué** entrada:

```csharp
Check("LanzarStockInsuficiente si cantidad > stock",
    () =>
    {
        try
        {
            Almacen.Retirar("leche", 999);
            return false; // no lanzó: fallo
        }
        catch (StockInsuficienteException) { return true; }
    });
```

### TDD básico

Flujo clásico **Red-Green-Refactor**:

1. **Red:** escribe un test que falla (el comportamiento no existe o está incompleto).
2. **Green:** implementa la solución mínima para que el test pase.
3. **Refactor:** mejora el código sin romper los tests.

```csharp
// 1. Test que falla
Check("Sumar(2, 3) == 5", () => Calculadora.Sumar(2, 3) == 5);

// 2. Implementación mínima
public static int Sumar(int a, int b) => a + b;

// 3. Refactor (sin cambiar comportamiento): documentación, nombres claros, etc.
```

Buenas prácticas: un test por comportamiento con nombre descriptivo; prueba casos **normales**, **límites** (0, negativos, vacío, máximo) y **errores**; no modifiques los tests para que "pasen" con implementaciones incorrectas.

### Reflection

La **reflection** permite inspeccionar tipos en tiempo de ejecución: propiedades, métodos, atributos, etc.

```csharp
using System;
using System.Linq;
using System.Collections.Generic;

Type tipo = typeof(ReflexionDemo);   // o: objeto.GetType()

string nombre = tipo.Name;                     // "ReflexionDemo"
List<string> metodos = tipo.GetMethods()
    .Select(m => m.Name)
    .Distinct()
    .OrderBy(n => n)
    .ToList();

var props = tipo.GetProperties().Select(p => p.Name).ToList();
bool tieneValor = tipo.GetProperty("Valor") != null;
object? instancia = Activator.CreateInstance(tipo);
```

Casos de uso: serializadores, frameworks de tests, inyección de dependencias, herramientas de inspección. La reflection es potente pero más lenta que el código directo: úsala con criterio.

## Ejemplos de código

```csharp
using System;
using System.Collections.Generic;

public class Libro
{
    public string Titulo { get; }
    public bool Disponible { get; private set; }

    public Libro(string titulo) { Titulo = titulo; Disponible = true; }

    public void Prestar()
    {
        if (!Disponible)
            throw new InvalidOperationException($"'{Titulo}' ya está prestado.");
        Disponible = false;
    }
}

public static class Programa
{
    public static int Main()
    {
        var libro = new Libro("El Quijote");
        libro.Prestar();
        try
        {
            libro.Prestar(); // lanza InvalidOperationException
        }
        catch (InvalidOperationException ex)
        {
            Console.WriteLine("[OK] " + ex.Message);
            return 0;
        }
        return 1;
    }
}
```

## Ejercicios relacionados

- [nivel-02-basico/ejercicio-05-excepciones](../ejercicios/nivel-02-basico/ejercicio-05-excepciones.md)
- [nivel-04-avanzado/ejercicio-05-testing](../ejercicios/nivel-04-avanzado/ejercicio-05-testing.md)
- [nivel-04-avanzado/ejercicio-06-reflection](../ejercicios/nivel-04-avanzado/ejercicio-06-reflection.md)
- Suite de tests del [PROYECTO FINAL](../ejercicios/proyectos/proyecto-final/README.md) (en `tests/src/TestsBiblioteca.cs`).

## Errores comunes

- **Capturar excepciones para ignorarlas silenciosamente** (`catch {}`) → oculta bugs. Registra o re-lanza.
- **Lanzar excepciones para control de flujo normal** → usa condicionales; las excepciones son para casos excepcionales.
- **Usar `throw ex;` en vez de `throw;`** → `throw ex` pierde la pila de llamadas original.
- **Capturar `Exception` antes que tipos específicos** → ordena los `catch` del más específico al más general.
- **Modificar los tests para que pasen** → eso invalida la verificación. Cambia la implementación, no el test.
- **Olvidar `finally` o `using` para liberar recursos** → archivos/conexiones quedan abiertos.
- **Usar reflection donde basta el código directo** → es más lenta y menos segura.
- **Testear solo el caso feliz** → los bugs viven en los límites (vacío, cero, duplicados) y en los errores.

## Recursos

- [Microsoft Learn — Excepciones en C#](https://learn.microsoft.com/es-es/dotnet/csharp/fundamentals/exceptions/)
- [Microsoft Learn — Buenas prácticas para excepciones](https://learn.microsoft.com/es-es/dotnet/standard/exceptions/best-practices-for-exceptions)
- [Microsoft Learn — Unit testing en .NET](https://learn.microsoft.com/es-es/dotnet/core/testing/)
- [Microsoft Learn — Reflection](https://learn.microsoft.com/es-es/dotnet/fundamentals/reflection/reflection)
- [Microsoft Learn — xUnit](https://learn.microsoft.com/es-es/dotnet/core/testing/unit-testing-with-dotnet-test)