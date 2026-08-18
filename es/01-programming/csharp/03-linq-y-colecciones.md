# 03 — LINQ y colecciones

## Objetivos

- [ ] Usar `List<T>`, `Dictionary<K, V>` y `HashSet<T>`.
- [ ] Elegir la colección adecuada para cada caso (`List`, `Dictionary`, `HashSet`, `Queue`, `Stack`).
- [ ] Escribir consultas LINQ con sintaxis de método y de consulta.
- [ ] Filtrar, proyectar, ordenar, agrupar y reducir colecciones (`Where`, `Select`, `OrderBy`, `GroupBy`, `Sum`…).
- [ ] Aplanar y combinar colecciones (`SelectMany`, `Join`, `Zip`).
- [ ] Usar delegados (`Func`, `Action`, `Predicate`) y lambdas.
- [ ] Suscribirse a eventos con `event EventHandler<T>`.
- [ ] Crear extension methods con el modificador `this`.
- [ ] Usar tuplas con nombres para devolver varios valores.

## Apuntes

### Colecciones principales

```csharp
using System.Collections.Generic;

List<int> numeros = new List<int> { 10, 5, 8 };
numeros.Add(7);
numeros.Remove(5);
numeros.Contains(8);   // true
numeros.Sort();

Dictionary<string, int> edades = new Dictionary<string, int>();
edades["Ana"] = 30;
edades.Add("Luis", 25);

if (edades.TryGetValue("Ana", out int e))  // evita KeyNotFoundException
{
    Console.WriteLine(e);
}

HashSet<int> set = new HashSet<int> { 1, 2, 3 };
set.Add(3);           // ya existe, no se añade
```

| Colección | Para qué sirve | Acceso | Orden |
|---|---|---|---|
| `List<T>` | colección ordenada dinámica | por índice / iteración | inserción |
| `Dictionary<K,V>` | pares clave→valor | por clave (`O(1)`) | sin orden |
| `HashSet<T>` | elementos únicos, operaciones de conjuntos | por elemento | sin orden |
| `Queue<T>` | FIFO (primero en entrar, primero en salir) | `Enqueue`/`Dequeue` | inserción |
| `Stack<T>` | LIFO (último en entrar, primero en salir) | `Push`/`Pop` | inserción inversa |

```csharp
Queue<string> cola = new Queue<string>();
cola.Enqueue("A"); cola.Enqueue("B");
string primero = cola.Dequeue();   // "A"

Stack<int> pila = new Stack<int>();
pila.Push(1); pila.Push(2);
int ultimo = pila.Pop();           // 2
```

Operaciones de conjuntos con `HashSet`:

```csharp
HashSet<int> a = new HashSet<int> { 1, 2, 3 };
HashSet<int> b = new HashSet<int> { 3, 4, 5 };
a.UnionWith(b);     // {1, 2, 3, 4, 5}
a.IntersectWith(b); // intersección
a.ExceptWith(b);    // diferencia
```

### ¿Qué es LINQ?

LINQ (Language Integrated Query) permite consultar colecciones con sintaxis integrada. Requiere `using System.Linq;`. Se escribe con **sintaxis de método** (la más usada) o **sintaxis de consulta**:

```csharp
int[] numeros = { 3, 1, 4, 1, 5, 9 };

var pares = numeros.Where(n => n % 2 == 0);          // método
var pares2 = from n in numeros                        // consulta (equivalente)
             where n % 2 == 0
             select n;
```

> **Importante:** LINQ es **diferido** (lazy): las consultas se ejecutan al recorrerlas o materializarlas (`ToList()`, `ToArray()`, `Count()`).

### Operaciones básicas

```csharp
// Filtrar
var pares = numeros.Where(n => n % 2 == 0);

// Proyectar
var cuadrados = numeros.Select(n => n * n);

// Ordenar
var ordenados = numeros.OrderBy(n => n);
var porEdadNombre = personas.OrderBy(p => p.Edad).ThenBy(p => p.Nombre);

// Agrupar
var porInicial = nombres.GroupBy(n => n[0]);

// Reducir
numeros.Sum(); numeros.Count(); numeros.Average(); numeros.Max(); numeros.Min();

// Primeros/últimos
var primero = numeros.First();            // lanza si está vacía
var oDefault = numeros.FirstOrDefault();  // 0 si está vacía

// Comprobar
bool hayPares = numeros.Any(n => n % 2 == 0);
bool todosPositivos = numeros.All(n => n > 0);

// Paginar y quitar duplicados
var pagina2 = numeros.Skip(5).Take(5);
var unicos = repetidos.Distinct();

// Materializar
List<int> lista = numeros.Where(n => n > 2).ToList();
Dictionary<string, int> dicc = personas.ToDictionary(p => p.Nombre, p => p.Edad);
```

Variantes "OrDefault" y orden descendente:

```csharp
numeros.OrderByDescending(n => n);
numeros.SingleOrDefault();          // lanza si hay más de un elemento
numeros.LastOrDefault();
numeros.ElementAtOrDefault(10);     // default si el índice no existe
```

Agrupaciones reales: `GroupBy` devuelve `IGrouping<Clave, Elemento>`, con `Key` y la colección de elementos:

```csharp
var porInicial = nombres.GroupBy(n => n[0]);
foreach (var grupo in porInicial)
{
    Console.WriteLine($"Letra {grupo.Key}: {grupo.Count()} nombres");
}
```

### LINQ avanzado

```csharp
// SelectMany: aplanar colecciones anidadas
int[][] matriz = { new[] { 1, 2 }, new[] { 3, 4 } };
var todos = matriz.SelectMany(m => m); // 1, 2, 3, 4

// Join: combinar dos colecciones por una clave
var pedidosConCliente = pedidos.Join(clientes,
    pedido => pedido.ClienteId,
    cliente => cliente.Id,
    (pedido, cliente) => new { pedido.Id, cliente.Nombre });

// Zip: combinar por posición
var c = a.Zip(b, (letra, num) => letra + num); // "a1", "b2"

// ToLookup: agrupar con acceso rápido por clave
var porLetra = nombres.ToLookup(n => n[0]);

// Encadenar consultas
var resultado = numeros
    .Where(n => n > 0)
    .Select(n => n * 2)
    .OrderByDescending(n => n)
    .Take(3)
    .ToList();

// yield return: iteradores propios
public static IEnumerable<int> GenerarPares(int maximo)
{
    for (int i = 0; i <= maximo; i += 2) yield return i;
}
```

`yield return` implementa un iterador diferido: el método "pausa" entre valores y no materializa todo en memoria:

```csharp
public static IEnumerable<int> SecuenciaFinita()
{
    yield return 1;
    yield return 2;
    yield return 3;   // no hay return final: termina aquí
}
```

Comparaciones con `Equals` y cultura: al agrupar/ordenar strings, LINQ usa la comparación ordinal por defecto. Para ignorar mayúsculas:

```csharp
var grupos = nombres.GroupBy(n => n.ToLower());
var ordenados = nombres.OrderBy(n => n, StringComparer.OrdinalIgnoreCase);
```

### Delegados y lambdas

Un **delegado** es un tipo que referencia a un método (puntero a función con tipo):

```csharp
public delegate int Operacion(int a, int b);
Operacion sumar = (a, b) => a + b;

Func<int, int, int> suma = (a, b) => a + b;   // devuelve un valor
Action<string> imprimir = s => Console.WriteLine(s); // no devuelve valor
Predicate<int> esPar = n => n % 2 == 0;        // devuelve bool

public static int Aplicar(Func<int, int, int> op, int a, int b) => op(a, b);
int r = Aplicar((x, y) => x * y, 6, 7); // 42
```

| Tipo | Firma | Uso |
|---|---|---|
| `Func<T, TResult>` | recibe valores, devuelve uno | proyecciones, cálculos |
| `Action<T>` | recibe valores, devuelve `void` | efectos secundarios, callbacks |
| `Predicate<T>` | recibe valor, devuelve `bool` | filtros |
| `Func<Task<T>>` | devuelve una tarea | asincronía (guía 04) |

Lambdas con cuerpo y sin cuerpo:

```csharp
Func<int, int> cuadrado = x => x * x;              // expresión
Action<int> imprimirDetalle = x =>
{
    Console.Write("Número: ");
    Console.WriteLine(x);
};                                                   // bloque
```

Usar un delegado como parámetro (estrategia):

```csharp
public static List<int> Filtrar(List<int> numeros, Predicate<int> condicion)
    => numeros.Where(n => condicion(n)).ToList();

var positivos = Filtrar(numeros, n => n > 0);
```

### Eventos

Un **evento** permite a una clase avisar a otras cuando algo ocurre. `EventHandler<TEventArgs>` es el patrón estándar (`sender`, `eventArgs`):

```csharp
public class Termometro
{
    public event EventHandler<int>? TemperaturaCambio;
    private int _temperatura;
    public int Temperatura => _temperatura;

    public void SetTemperatura(int valor)
    {
        if (valor == _temperatura) return;
        _temperatura = valor;
        TemperaturaCambio?.Invoke(this, valor);
    }
}

var termometro = new Termometro();
termometro.TemperaturaCambio += (sender, valor) =>
    Console.WriteLine($"¡La temperatura subió a {valor}!");
termometro.SetTemperatura(22); // imprime
termometro.SetTemperatura(22); // no imprime (no cambió)
```

- `+=` suscribe un manejador; `-=` lo desuscribe.
- `?.Invoke` comprueba si hay suscriptores antes de notificar.
- `sender` es quien publica el evento; `eventArgs` lleva los datos.

### Extension methods

Un **extension method** añade métodos a tipos existentes sin modificarlos. La clase debe ser `static` y el primer parámetro lleva `this`:

```csharp
public static class ExtensionesString
{
    public static int ContarPalabras(this string s)
    {
        if (string.IsNullOrWhiteSpace(s)) return 0;
        return s.Split(' ', StringSplitOptions.RemoveEmptyEntries).Length;
    }

    public static bool EsPalindromo(this string s)
    {
        string limpio = s.ToLower().Replace(" ", "");
        return limpio == new string(limpio.Reverse().ToArray());
    }
}

public static class ExtensionesNumeros
{
    public static bool EsPar(this int n) => n % 2 == 0;
}

int palabras = "Hola mundo cruel".ContarPalabras(); // 3
bool par = 42.EsPar();                              // true
```

### Tuplas

```csharp
var persona = ("Ana", 30);
Console.WriteLine(persona.Item1); // Ana

var libro = (titulo: "El Quijote", paginas: 863);
Console.WriteLine(libro.titulo);

public static (int menor, int mayor) MinimoYMaximo(int[] numeros)
    => (numeros.Min(), numeros.Max());

var (menor, mayor) = MinimoYMaximo(new[] { 4, 9, 2, 7 }); // deconstruction
```

## Ejemplos de código

```csharp
using System;
using System.Collections.Generic;
using System.Linq;

public static class Programa
{
    public static int Main()
    {
        var personas = new List<(string Nombre, int Edad)>
        {
            ("Ana", 30), ("Luis", 25), ("Marta", 35), ("Pepe", 18)
        };

        var mayores = personas
            .Where(p => p.Edad >= 25)
            .OrderByDescending(p => p.Edad)
            .Select(p => p.Nombre)
            .ToList();

        Console.WriteLine(string.Join(", ", mayores)); // Marta, Ana
        return 0;
    }
}
```

## Ejercicios relacionados

- [nivel-03-intermedio](../ejercicios/nivel-03-intermedio/) — LINQ básico, delegados y eventos, genéricos.
- [nivel-04-avanzado](../ejercicios/nivel-04-avanzado/) — LINQ avanzado, extension methods, tuplas.
- En el [PROYECTO FINAL](../ejercicios/proyectos/proyecto-final/README.md) se usa LINQ para búsquedas y reportes (`LibrosMasPrestadosAsync`, búsquedas sin distinguir mayúsculas).

## Errores comunes

- **Usar `First()` sobre una colección vacía** → lanza `InvalidOperationException`. Usa `FirstOrDefault()`.
- **Indexar un `Dictionary` sin saber si existe la clave** → lanza `KeyNotFoundException`. Usa `TryGetValue` o `ContainsKey`.
- **Materializar demasiado pronto** → `ToList()`/`ToArray()` rompen la ejecución diferida de LINQ; materializa solo al final.
- **Olvidar `using System.Linq;`** → los métodos de extensión LINQ no están disponibles.
- **Modificar una colección mientras se recorre con `foreach`** → lanza `InvalidOperationException`. Recoge las eliminaciones y hazlas después.
- **Comparar `string` ignorando mayúsculas en LINQ** → usa `Equals(x, StringComparison.OrdinalIgnoreCase)`, no `==`.
- **`GroupBy` devuelve `IGrouping<,>`** → para acceder a los elementos usa `grupo.Key` y `grupo` como colección.
- **Confundir `Select` con `SelectMany`** → `Select` proyecta 1 a 1; `SelectMany` aplane colecciones anidadas.
- **`Single()` sobre una colección con varios elementos** → lanza `InvalidOperationException`; usa `SingleOrDefault` solo si el caso lo garantiza.

## Recursos

- [Microsoft Learn — Colecciones en C#](https://learn.microsoft.com/es-es/dotnet/csharp/language-reference/builtin-types/collections)
- [Microsoft Learn — LINQ](https://learn.microsoft.com/es-es/dotnet/csharp/linq/)
- [Microsoft Learn — LINQ: sintaxis de consulta](https://learn.microsoft.com/es-es/dotnet/csharp/language-reference/keywords/query-keywords)
- [Microsoft Learn — Delegados](https://learn.microsoft.com/es-es/dotnet/csharp/delegates-overview)
- [Microsoft Learn — Events](https://learn.microsoft.com/es-es/dotnet/csharp/events-overview)
- [Microsoft Learn — Tuplas](https://learn.microsoft.com/es-es/dotnet/csharp/language-reference/builtin-types/value-tuples)