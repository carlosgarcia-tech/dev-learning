# 04 — Async/await

## Objetivos

- [ ] Entender por qué la asincronía evita bloquear el hilo principal.
- [ ] Distinguir `Task` (sin resultado) de `Task<T>` (con resultado).
- [ ] Escribir métodos `async` con `await` y conocer las reglas de retorno.
- [ ] Lanzar y esperar varias tareas con `Task.WhenAll` y `Task.WhenAny`.
- [ ] Manejar errores en métodos asíncronos con `try/catch`.
- [ ] Hacer llamadas HTTP con `HttpClient` de forma asíncrona.
- [ ] Leer y escribir archivos de forma asíncrona y persistir con `System.Text.Json`.
- [ ] Cancelar tareas con `CancellationToken`.
- [ ] Usar `async Task<int> Main` en aplicaciones de consola.

## Apuntes

### ¿Por qué asincronía?

Si una operación tarda mucho (descargar un archivo, leer un JSON, consultar una API), el programa quedaría **bloqueado** esperándola. Con `async/await`, el hilo queda libre mientras la operación termina.

- Las operaciones lentas devuelven `Task` (sin resultado) o `Task<T>` (con resultado).
- `await` "suspende" el método asíncrono hasta que el `Task` termina, **sin bloquear** el hilo.
- Todo lo anterior a `await` se ejecuta de forma síncrona; lo posterior se reanuda cuando termina la tarea.

Ejemplo mental:

```csharp
public static async Task ProcesarAsync()
{
    Console.WriteLine("1. Empiezo");          // síncrono
    await Task.Delay(1000);                   // el hilo queda libre 1 s
    Console.WriteLine("2. Continúo");         // se reanuda al terminar
}
```

La UI/consola no se congela; mientras `await` espera, el proceso puede atender otras cosas.

### `Task` y `Task<T>`

```csharp
public static async Task<string> ObtenerSaludoAsync()
{
    await Task.Delay(1000);          // simula una operación lenta
    return "Hola, mundo";
}

Task tarea = Task.Delay(500);                    // espera 500 ms
Task<int> resultado = Task.FromResult(42);       // tarea ya completada
Task<int> calculo = Task.Run(() => CalcularAlgo()); // hilo de pool
```

> Evita `.Wait()` / `.Result` en código real: pueden producir *deadlocks*. Usa `await`.

### Reglas de `async`/`await`

- Un método `async` contiene al menos un `await`.
- El tipo de retorno debe ser `Task`, `Task<T>` o `void` (solo event handlers).
- Por convención los métodos asíncronos terminan en `Async`.

```csharp
public static async Task<int> DuplicarAsync(int x)
{
    await Task.Delay(10);   // simulamos trabajo
    return x * 2;
}

public static async Task<int> CalcularTotalAsync(int a, int b)
{
    int duplicado = await DuplicarAsync(a);
    return duplicado + b;
}
```

Para métodos que devuelven un valor ya conocido sin `await`, usa `Task.FromResult`:

```csharp
public static Task<int> RespuestaRapida() => Task.FromResult(42);
```

### `Task.WhenAll` y `Task.WhenAny`

```csharp
public static async Task<List<int>> DuplicarTodosAsync(List<int> numeros)
{
    var tareas = numeros.Select(n => DuplicarAsync(n)).ToList();
    int[] resultados = await Task.WhenAll(tareas);   // espera TODAS
    return resultados.ToList();
}

var tarea1 = DescargarAsync("https://a.com");
var tarea2 = DescargarAsync("https://b.com");
Task<string> primera = await Task.WhenAny(tarea1, tarea2); // espera la PRIMERA
```

- `Task.WhenAll` espera todas y agrupa resultados; si alguna falla, la excepción se propaga.
- `Task.WhenAny` espera la primera que termine (útil para timeouts y carreras).
- Las tareas deben **lanzarse antes** de `WhenAll` para que corran en paralelo; si haces `await` una a una, van secuenciales.

```csharp
// En paralelo:
var tareas = urls.Select(u => DescargarAsync(u)).ToList();
var todos = await Task.WhenAll(tareas);

// Secuencial (no es lo que queremos):
var resultados = new List<string>();
foreach (var url in urls) resultados.Add(await DescargarAsync(url));
```

### Manejo de errores

`try/catch/finally` funciona igual en métodos asíncronos. Si la tarea esperada lanza una excepción, esta se propaga en el punto del `await`:

```csharp
public static async Task<int> DividirAsync(int a, int b)
{
    try
    {
        await Task.Delay(10);
        return a / b;
    }
    catch (DivideByZeroException)
    {
        Console.WriteLine("No se puede dividir por cero.");
        return 0;
    }
}
```

Con varias tareas en `WhenAll`, puedes capturar el agregado o inspeccionar cada una:

```csharp
try
{
    await Task.WhenAll(tareas);
}
catch (Exception ex)
{
    // ex es la primera excepción; Task.WhenAll preserva las demás
    Console.WriteLine("Fallo: " + ex.Message);
}
```

### Cancelación con `CancellationToken`

Una operación larga puede cooperar con la cancelación:

```csharp
public static async Task<string> DescargarAsync(string url, CancellationToken ct)
{
    using var cliente = new HttpClient();
    return await cliente.GetStringAsync(url, ct);   // respeta la cancelación
}

// Con timeout:
using var cts = new CancellationTokenSource(TimeSpan.FromSeconds(5));
try
{
    var contenido = await DescargarAsync("https://api.ejemplo.com/datos", cts.Token);
}
catch (OperationCanceledException)
{
    Console.WriteLine("La operación se canceló por timeout.");
}
```

`Task.Delay` también acepta un token: `await Task.Delay(1000, ct)`.

### `HttpClient` — llamadas HTTP asíncronas

`HttpClient` está diseñado para reutilizarse y trabajar de forma asíncrona:

```csharp
using System.Net.Http;

var json = await client.GetStringAsync("https://api.ejemplo.com/items");

using var respuesta = await client.GetAsync(url);
if (respuesta.IsSuccessStatusCode)
{
    var contenido = await respuesta.Content.ReadAsStringAsync();
}

using var content = new StringContent(json, System.Text.Encoding.UTF8, "application/json");
using var post = await client.PostAsync(url, content);
```

Deserializar/serializar JSON con `System.Text.Json` en las llamadas:

```csharp
using System.Text.Json;

// GET + deserializar
var items = await client.GetFromJsonAsync<List<ItemDto>>("https://api.ejemplo.com/items");

// POST con cuerpo serializado
var respuesta = await client.PostAsJsonAsync(url, nuevoItem);
```

> Crea **una** instancia de `HttpClient` y reutilízala. Crear uno por petición agota los sockets. En ASP.NET Core (guía 06) se inyecta con `IHttpClientFactory`.

### E/S asíncrona de archivos y JSON

```csharp
using System.IO;
using System.Text.Json;

public static async Task<string> LeerAsync(string ruta)
    => await File.ReadAllTextAsync(ruta);

public static async Task EscribirAsync(string ruta, string contenido)
    => await File.WriteAllTextAsync(ruta, contenido);

public static async Task GuardarDatosAsync<T>(string ruta, T datos)
{
    string json = JsonSerializer.Serialize(datos, new JsonSerializerOptions { WriteIndented = true });
    await File.WriteAllTextAsync(ruta, json);
}

public static async Task<T?> CargarDatosAsync<T>(string ruta)
{
    if (!File.Exists(ruta)) return default;
    string json = await File.ReadAllTextAsync(ruta);
    return JsonSerializer.Deserialize<T>(json);
}
```

### `async/await` en consola

`Main` puede ser `async Task<int>` o `async Task` (el runtime lo soporta desde C# 7.1):

```csharp
public static class Programa
{
    public static async Task<int> Main()
    {
        int resultado = await DuplicarAsync(21);
        Console.WriteLine(resultado); // 42
        return 0;
    }
}
```

## Ejemplos de código

```csharp
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

public static class Programa
{
    public static async Task<int> Main()
    {
        var numeros = new List<int> { 1, 2, 3, 4, 5 };
        var tareas = numeros.Select(n => CuadradoAsync(n)).ToList();
        int[] resultados = await Task.WhenAll(tareas);
        Console.WriteLine(string.Join(", ", resultados)); // 1, 4, 9, 16, 25
        return 0;
    }

    private static async Task<int> CuadradoAsync(int x)
    {
        await Task.Delay(10);
        return x * x;
    }
}
```

## Ejercicios relacionados

- [nivel-04-avanzado/ejercicio-01-async-await](../ejercicios/nivel-04-avanzado/ejercicio-01-async-await.md)
- Aplica async en el [PROYECTO FINAL](../ejercicios/proyectos/proyecto-final/README.md) (persistencia asíncrona con JSON).
- Las llamadas HTTP de la [guía 06 (ASP.NET Core)](06-aspnet-core.md) siguen los mismos patrones `async`/`await`.

## Errores comunes

- **Usar `.Result` o `.Wait()`** → bloquea el hilo y puede causar *deadlocks*. Usa `await`.
- **`async void`** → solo es válido en event handlers; en cualquier otro método dificulta el manejo de errores.
- **No propagar `Task` en la cadena** → mezclar síncrono y asíncrono "corta" la asincronía. Propaga `async` de arriba hacia abajo.
- **Esperar tareas de forma secuencial en vez de paralela** → si las tareas son independientes, usa `Task.WhenAll`.
- **No capturar excepciones en métodos `async`** → una excepción no manejada en un `Task` fallido puede terminar el proceso.
- **Crear un `HttpClient` nuevo por petición** → se agotan los sockets. Reutiliza una instancia (o usa un `IHttpClientFactory`).
- **Olvidar `using System.Threading.Tasks;`** → `Task`, `Task.WhenAll`, etc. no están disponibles.
- **Ignorar `CancellationToken`** → una operación larga que no lo respeta no puede cancelarse ni tener timeout.
- **`async` sin `await`** → el compilador avisa (CS1998) de que el método no hace nada asíncrono; elimina `async` o añade un `await`.

## Recursos

- [Microsoft Learn — Programación asíncrona](https://learn.microsoft.com/es-es/dotnet/csharp/asynchronous-programming/async-scenarios)
- [Microsoft Learn — Task-based Asynchronous Pattern (TAP)](https://learn.microsoft.com/es-es/dotnet/standard/asynchronous-programming-patterns/task-based-asynchronous-pattern-tap)
- [Microsoft Learn — HttpClient](https://learn.microsoft.com/es-es/dotnet/api/system.net.http.httpclient)
- [Microsoft Learn — System.Text.Json](https://learn.microsoft.com/es-es/dotnet/standard/serialization/system-text-json/how-to)
- [Microsoft Learn — `async Task<int> Main`](https://learn.microsoft.com/es-es/dotnet/csharp/fundamentals/program-structure/main-command-line)