# 06 — Introducción a ASP.NET Core (Minimal APIs)

## Objetivos

- [ ] Entender qué es ASP.NET Core y el hosting de aplicaciones web.
- [ ] Crear un proyecto web con `dotnet new web`.
- [ ] Definir endpoints con el enrutado de Minimal APIs (`MapGet`, `MapPost`, …).
- [ ] Leer parámetros de ruta, query y cuerpo de la petición.
- [ ] Devolver respuestas JSON con códigos de estado correctos.
- [ ] Usar el patrón de inyección de dependencias con `WebApplicationBuilder`.
- [ ] Validar la entrada y manejar errores de forma centralizada.
- [ ] Conocer la diferencia con los controllers MVC y cuándo usar cada uno.

## Apuntes

### ¿Qué es ASP.NET Core?

ASP.NET Core es el framework web de .NET para construir APIs REST y aplicaciones web,
multiplataforma y de alto rendimiento. Sustituyó a ASP.NET (Framework clásico) y su
filosofía es similar a Spring Boot: **convención sobre configuración**, un **servidor
embebido** (Kestrel por defecto), **inyección de dependencias** integrada y gestión de
paquetes vía NuGet.

Existen dos estilos de escribir endpoints:

| Estilo | Cuándo usarlo |
|---|---|
| **Minimal APIs** | Endpoints simples y legibles en un solo `Program.cs`; ideal para aprender y para APIs pequeñas |
| **Controllers MVC** | Aplicaciones grandes o que necesitan atributos de ruta/validación avanzada; inspirado en `@RestController` de Spring |

En esta guía usamos **Minimal APIs**: un solo archivo `Program.cs` registra los endpoints
con lambdas, similar a los lambdas que ya conoces de la guía 03.

### Crear un proyecto

```bash
dotnet new web -n BibliotecaApi        # plantilla de Minimal APIs
cd BibliotecaApi
dotnet run                             # arranca en http://localhost:5xxx
```

La plantilla crea un `Program.cs` mínimo:

```csharp
var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

app.MapGet("/", () => "Hola, mundo");

app.Run();
```

Estructura recomendada para una API con servicios:

```
BibliotecaApi/
├── Program.cs          (construcción, endpoints y registro de servicios)
├── BibliotecaApi.csproj
├── Models/             (records/modelos)
├── Services/           (lógica de negocio: BibliotecaService, ReportesService…)
└── appsettings.json    (configuración)
```

### Inyección de dependencias

El `WebApplicationBuilder` tiene un contenedor de DI integrado. Se registran servicios
con `builder.Services` y se inyectan en las lambdas de los endpoints por parámetro:

```csharp
var builder = WebApplication.CreateBuilder(args);

// Registro de servicios (una instancia por petición: AddScoped)
builder.Services.AddSingleton<SaludoService>();
builder.Services.AddScoped<BibliotecaService>();

var app = builder.Build();

// El servicio se inyecta como parámetro de la lambda
app.MapGet("/saludo/{nombre}", (string nombre, SaludoService saludo) =>
    saludo.Saludar(nombre));

app.Run();
```

Ciclos de vida habituales:

| Método | Ciclo de vida | Uso |
|---|---|---|
| `AddSingleton<T>()` | una instancia para toda la app | estado compartido, config, `HttpClient` |
| `AddScoped<T>()` | una instancia por petición HTTP | repositorios y servicios por request |
| `AddTransient<T>()` | una instancia por resolución | objetos ligeros sin estado |

### Endpoints y verbos HTTP

Minimal APIs mapean cada verbo con `MapGet`, `MapPost`, `MapPut`, `MapDelete`, `MapPatch`.
Cada endpoint es una lambda que devuelve el dato (se serializa a JSON) o un `Results`:

```csharp
app.MapGet("/libros", (BibliotecaService servicio) => servicio.ListarLibrosAsync());

app.MapGet("/libros/{id}", async (int id, BibliotecaService servicio) =>
{
    var libro = await servicio.ObtenerPorIdAsync(id);
    return libro is null
        ? Results.NotFound(new { error = $"Libro no encontrado: {id}" })
        : Results.Ok(libro);
});

app.MapPost("/libros", async (LibroNuevoDto dto, BibliotecaService servicio) =>
{
    var creado = await servicio.CrearLibroAsync(dto);
    return Results.Created($"/libros/{creado.Id}", creado);
});

app.MapPut("/libros/{id}", async (int id, LibroNuevoDto dto, BibliotecaService servicio) =>
{
    await servicio.ActualizarAsync(id, dto);
    return Results.NoContent();
});

app.MapDelete("/libros/{id}", async (int id, BibliotecaService servicio) =>
{
    await servicio.EliminarAsync(id);
    return Results.NoContent();
});
```

`Results` devuelve respuestas con el código de estado correcto:

| Resultado | HTTP |
|---|---|
| `Results.Ok(x)` | 200 |
| `Results.Created(uri, x)` | 201 |
| `Results.NoContent()` | 204 |
| `Results.NotFound(x)` | 404 |
| `Results.BadRequest(x)` | 400 |
| `Results.Json(x, statusCode: 500)` | 500 |

### Parámetros de ruta, query y cuerpo

```csharp
// Parámetro de ruta: /libros/7
app.MapGet("/libros/{id}", (int id) => $"Libro {id}");

// Query string: /buscar?termino=quijote&limite=10
app.MapGet("/buscar", (string? termino, int limite = 10) =>
    $"Buscando '{termino}' con límite {limite}");

// Cuerpo JSON: se deserializa automáticamente al record
app.MapPost("/libros", (LibroNuevoDto dto) => $"Recibido: {dto.Titulo}");
```

Los tipos simples (`int`, `string`, `Guid`) se resuelven desde la ruta o el query;
los tipos complejos (`record`, clases) se deserializan del cuerpo JSON.

### Modelos y validación

Al igual que en el proyecto final, los modelos son `record` (igualdad por valor).
La validación se hace en el servicio o con un patrón de "guard":

```csharp
public record LibroNuevoDto(string Titulo, string Autor, string Isbn, int AnioPublicacion);

public record LibroDto(int Id, string Titulo, string Autor, string Isbn,
    int AnioPublicacion, bool Disponible);
```

Validación manual en el endpoint o en el servicio:

```csharp
app.MapPost("/libros", async (LibroNuevoDto dto, BibliotecaService servicio) =>
{
    if (string.IsNullOrWhiteSpace(dto.Titulo))
        return Results.BadRequest(new { error = "El título es obligatorio." });
    if (dto.AnioPublicacion is < 1450 or > 2100)
        return Results.BadRequest(new { error = "Año de publicación inválido." });

    var creado = await servicio.CrearLibroAsync(dto);
    return Results.Created($"/libros/{creado.Id}", creado);
});
```

### Manejo de errores centralizado

Excepciones propias (como las de `ExcepcionesBiblioteca.cs`) se traducen a respuestas
HTTP con `IExceptionHandler` (una única clase que centraliza el mapeo):

```csharp
public class ExcepcionesBibliotecaHandler : IExceptionHandler
{
    public async ValueTask<bool> TryHandleAsync(HttpContext context,
        Exception exception, CancellationToken ct)
    {
        var (status, mensaje) = exception switch
        {
            EmailDuplicadoException => (StatusCodes.Status409Conflict, exception.Message),
            LibroNoDisponibleException => (StatusCodes.Status409Conflict, exception.Message),
            KeyNotFoundException => (StatusCodes.Status404NotFound, exception.Message),
            ArgumentException => (StatusCodes.Status400BadRequest, exception.Message),
            _ => (StatusCodes.Status500InternalServerError, "Error interno del servidor.")
        };

        context.Response.StatusCode = status;
        await context.Response.WriteAsJsonAsync(new { error = mensaje }, ct);
        return true;   // la excepción ya está manejada
    }
}
```

Registro en `Program.cs`:

```csharp
builder.Services.AddExceptionHandler<ExcepcionesBibliotecaHandler>();
builder.Services.AddProblemDetails();

// ... después de construir la app
app.UseExceptionHandler();
```

Así, si un servicio lanza `EmailDuplicadoException`, la API responde `409 Conflict`
con un JSON `{ "error": "..." }` sin ensuciar cada endpoint.

### Configuración

`appsettings.json` y variables de entorno se leen con `builder.Configuration`:

```json
{
  "Logging": { "LogLevel": { "Default": "Information" } },
  "AllowedHosts": "*",
  "Biblioteca": { "ArchivoDatos": "biblioteca.json" }
}
```

```csharp
string archivo = builder.Configuration["Biblioteca:ArchivoDatos"] ?? "biblioteca.json";
```

> **Seguridad:** las claves secretas (contraseñas, tokens) nunca van en `appsettings.json`.
> Usa variables de entorno o *user secrets*.

### Comprobar la API

Con la app corriendo, prueba los endpoints con `curl`:

```bash
curl http://localhost:5000/libros
curl -X POST http://localhost:5000/libros \
  -H "Content-Type: application/json" \
  -d '{"titulo":"El Quijote","autor":"Cervantes","isbn":"9788420412140","anioPublicacion":1605}'
curl http://localhost:5000/libros/1
```

### Errores comunes

| Error | Causa | Solución |
|---|---|---|
| `404` al pedir `/libros` | el endpoint no está registrado o el prefijo difiere | Verifica `MapGet("/libros", …)` y el puerto de arranque |
| `400` al enviar JSON | el cuerpo no encaja con el `record` esperado | Revisa nombres y tipos de las propiedades |
| `InvalidOperationException: Unable to resolve service` | el servicio no está registrado | Añade `builder.Services.AddScoped<Servicio>()` |
| Excepción "cruda" devuelta al cliente | no hay manejador central | Registra `AddExceptionHandler` y `UseExceptionHandler` |
| `Results` olvidado: se devuelve `null` y sale `204` | el endpoint no construye respuesta | Devuelve `Results.NotFound`, `Results.Ok`, etc. |
| Endpoint síncrono bloqueando en async | falta `async`/`await` en la lambda | Marca la lambda `async` y `await` las llamadas `Async` |

## Ejercicios relacionados

- [Ejercicio 02: Servidor HTTP](./ejercicios/nivel-05-experto/ejercicio-02-servidor-http/) — monta un servidor HTTP básico sin framework.
- [Ejercicio 03: API REST mínima](./ejercicios/nivel-05-experto/ejercicio-03-api-rest-minima/) — aplica lo visto aquí sobre los modelos de la biblioteca.
- [Proyecto Final: Sistema de Biblioteca](./ejercicios/proyectos/proyecto-final/) — si decides exponer la biblioteca como API, esta guía es la base.

## Recursos

- [Microsoft Learn — Minimal APIs](https://learn.microsoft.com/es-es/aspnet/core/fundamentals/minimal-apis/overview)
- [Microsoft Learn — Inyección de dependencias](https://learn.microsoft.com/es-es/aspnet/core/fundamentals/dependency-injection)
- [Microsoft Learn — Handle errors in ASP.NET Core](https://learn.microsoft.com/es-es/aspnet/core/fundamentals/error-handling)
- [Microsoft Learn — WebApplicationBuilder](https://learn.microsoft.com/es-es/dotnet/api/microsoft.aspnetcore.builder.webapplicationbuilder)
- [Descargar el .NET SDK](https://dotnet.microsoft.com/es-es/download)