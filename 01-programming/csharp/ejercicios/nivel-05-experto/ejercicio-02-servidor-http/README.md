# Ejercicio 02 — Servidor HTTP

- **Nivel:** 5/5
- **Tema:** HTTP básico, enrutado, servidores y testing de rutas
- **Tiempo estimado:** 45 min

## Enunciado

Completa `Program.cs`. En C# puro un servidor HTTP real se levanta con `HttpListener` (o un socket), pero las **rutas** se pueden testear sin red. La clase `ServidorHttp` expone `ProcesarRuta(string ruta)` con esta lógica:

| Ruta | Respuesta |
|---|---|
| `/` | `<h1>Inicio</h1>` |
| `/saludo` | `<h1>Hola, bienvenido</h1>` |
| `/saludo?nombre=X` | `<h1>Hola, X</h1>` |
| `/api/hora` | `DateTime.Now.ToString("HH:mm:ss")` |
| cualquier otra | `404 No encontrado` |

`Ejercicio02.CrearServidor(int puerto)` crea la instancia con su puerto.

> **Para un servidor real:** levanta un `HttpListener` en `http://localhost:<puerto>/`, llama a `ProcesarRuta(context.Request.Url.AbsolutePath + context.Request.Url.Query)` y escribe la respuesta. Mantén la lógica de rutas en `ProcesarRuta` para que siga siendo testeable.

Salida esperada de ejemplo:

```
[OK]   ProcesarRuta("/") devuelve "<h1>Inicio</h1>"
[OK]   ProcesarRuta("/saludo?nombre=Ana") devuelve "<h1>Hola, Ana</h1>"
[OK]   ProcesarRuta("/nope") devuelve "404 No encontrado"
```

## Requisitos

- [ ] `/` y `/saludo` devuelven las respuestas exactas.
- [ ] `/saludo?nombre=X` inserta el valor de `X` en la respuesta.
- [ ] `/api/hora` devuelve una hora con formato `HH:mm:ss` (8 caracteres con `:`).
- [ ] Cualquier otra ruta devuelve `404 No encontrado`.
- [ ] Los tests pasan: `csc Program.cs ProgramTest.cs && mono ProgramTest.exe` (si tienes Mono/csc).
- [ ] Los tests pasan: `dotnet run` (con el .NET SDK instalado).

> **Cómo ejecutar los tests**
>
> Con el **.NET SDK** (recomendado), desde la carpeta del ejercicio:
>
> ```bash
> dotnet run
> ```
>
> Con **Mono/csc**:
>
> ```bash
> csc Program.cs ProgramTest.cs
> mono ProgramTest.exe
> ```
>
> El runner devuelve `0` si todos los tests pasan y `1` si falla alguno.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `ruta.StartsWith("/saludo?nombre=")` detecta el parámetro.
- `ruta.Substring("/saludo?nombre=".Length)` extrae el nombre.
- `DateTime.Now.ToString("HH:mm:ss")` da una hora con formato de 24 h.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````csharp
using System;

public class ServidorHttp
{
    private readonly int _puerto;
    public int Puerto => _puerto;

    public ServidorHttp(int puerto)
    {
        _puerto = puerto;
    }

    public string ProcesarRuta(string ruta)
    {
        if (ruta == "/") return "<h1>Inicio</h1>";

        if (ruta.StartsWith("/saludo"))
        {
            if (ruta.StartsWith("/saludo?nombre="))
            {
                string nombre = ruta.Substring("/saludo?nombre=".Length);
                return $"<h1>Hola, {nombre}</h1>";
            }
            return "<h1>Hola, bienvenido</h1>";
        }

        if (ruta == "/api/hora") return DateTime.Now.ToString("HH:mm:ss");

        return "404 No encontrado";
    }
}

public static class Ejercicio02
{
    public static ServidorHttp CrearServidor(int puerto) => new ServidorHttp(puerto);
}
````

</details>