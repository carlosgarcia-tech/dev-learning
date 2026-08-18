# Ejercicio 03 — API REST mínima

- **Nivel:** 5/5
- **Tema:** enrutado REST, códigos HTTP (200/404/405), `Func<string,string>`
- **Tiempo estimado:** 45 min

## Enunciado

Completa `Program.cs`. Construye un **router REST mínimo** (sin framework) con la clase `RouterApi`:

1. `void Get(string ruta, Func<string,string> handler)` — registra una ruta GET.
2. `void Post(string ruta, Func<string,string> handler)` — registra una ruta POST.
3. `(int Codigo, string Cuerpo) Procesar(string metodo, string ruta, string cuerpo = "")`:
   - Ruta y método coinciden → `(200, handler(cuerpo))`.
   - La ruta existe pero el método no coincide → `(405, "Método no permitido")`.
   - La ruta no existe → `(404, "Ruta no encontrada")`.

`Ejercicio03.CrearRouter()` devuelve una instancia.

Salida esperada de ejemplo:

```
[OK]   GET /api/saludo devuelve (200, "Hola")
[OK]   GET /api/inexistente devuelve (404, "Ruta no encontrada")
[OK]   POST /api/saludo devuelve (405, "Método no permitido")
[OK]   POST /api/productos con cuerpo "laptop" devuelve (200, "creado: laptop")
```

## Requisitos

- [ ] `Get` y `Post` registran rutas con su método.
- [ ] El handler recibe el `cuerpo` y su resultado es la respuesta.
- [ ] Método incorrecto sobre una ruta existente devuelve `405`.
- [ ] Ruta inexistente devuelve `404`.
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

- `FirstOrDefault(r => r.Ruta == ruta)` busca por ruta; el valor por defecto de la tupla tiene `Handler == null`.
- Compara `coincidencia.Metodo != metodo` para el 405.
- `_rutas.Add(("GET", ruta, handler));` — las tuplas se guardan como en `_rutas`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````csharp
using System;
using System.Collections.Generic;
using System.Linq;

public class RouterApi
{
    private readonly List<(string Metodo, string Ruta, Func<string, string> Handler)> _rutas
        = new List<(string Metodo, string Ruta, Func<string, string> Handler)>();

    public void Get(string ruta, Func<string, string> handler)
        => _rutas.Add(("GET", ruta, handler));

    public void Post(string ruta, Func<string, string> handler)
        => _rutas.Add(("POST", ruta, handler));

    public (int Codigo, string Cuerpo) Procesar(string metodo, string ruta, string cuerpo = "")
    {
        var coincidencia = _rutas.FirstOrDefault(r => r.Ruta == ruta);
        if (coincidencia.Handler == null)
            return (404, "Ruta no encontrada");
        if (coincidencia.Metodo != metodo)
            return (405, "Método no permitido");
        return (200, coincidencia.Handler(cuerpo));
    }
}

public static class Ejercicio03
{
    public static RouterApi CrearRouter() => new RouterApi();
}
````

</details>