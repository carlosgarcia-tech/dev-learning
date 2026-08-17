# Ejercicio 01 — Gestor de tareas (CLI)

- **Nivel:** 5/5
- **Tema:** diseño de clases, CRUD en memoria, LINQ, mini CLI
- **Tiempo estimado:** 45 min

## Enunciado

Completa `ejercicio-01-gestor-de-tareas-cli.cs`. Este es el núcleo de una **aplicación CLI de tareas**: clases y lógica desacopladas de la consola para poder testearlas.

Clase `Tarea` (ya definida): `Id`, `Titulo`, `Completada`.

Clase `GestorTareas`:

1. `Tarea Agregar(string titulo)` — valida el título (si está vacío lanza `ArgumentException`), crea la tarea con `id` autoincremental (1, 2, 3…) y la añade.
2. `bool MarcarCompletada(int id)` — marca como completada; `false` si no existe.
3. `List<Tarea> Pendientes()` — tareas no completadas.
4. `List<Tarea> Completadas()` — tareas completadas.
5. `int Total()` — número total.
6. `bool Eliminar(int id)` — elimina la tarea; `false` si no existe.
7. `string Resumen()` — `Total: X, pendientes: Y, completadas: Z`.

`Ejercicio01.CrearGestor()` devuelve una instancia.

> **Mini CLI:** cuando el núcleo pase los tests, conviértelo en un CLI real leyendo comandos de `Console.ReadLine()` (p. ej. `agregar <titulo>`, `listar`, `completar <id>`, `eliminar <id>`, `resumen`).

Salida esperada de ejemplo:

```
[OK]   Agregar asigna ids incrementales (1, 2, ...)
[OK]   MarcarCompletada(1) mueve la tarea a Completadas
[OK]   Resumen() devuelve "Total: X, pendientes: Y, completadas: Z"
```

## Requisitos

- [ ] `Agregar` asigna ids incrementales y lanza `ArgumentException` con títulos vacíos.
- [ ] `MarcarCompletada` devuelve `false` con un id inexistente.
- [ ] `Pendientes()` y `Completadas()` filtran correctamente.
- [ ] `Eliminar` devuelve `false` con un id inexistente.
- [ ] `Resumen()` sigue el formato exacto indicado.
- [ ] Los tests pasan: `csc ejercicio-01-gestor-de-tareas-cli.cs ejercicio-01-gestor-de-tareas-cli_test.cs && mono ejercicio-01-gestor-de-tareas-cli_test.exe` (si tienes Mono/csc).
- [ ] Los tests pasan: `dotnet run` (al instalar el .NET SDK).

> **Nota:** el .NET SDK **no está instalado** en esta máquina. Con el SDK instalado:
> ```bash
> dotnet new console -o . --force
> rm Program.cs
> dotnet run
> ```
> Con Mono/csc: `csc ejercicio-01-gestor-de-tareas-cli.cs ejercicio-01-gestor-de-tareas-cli_test.cs` y `mono ejercicio-01-gestor-de-tareas-cli_test.exe`.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Guarda el siguiente id en un campo `int _siguienteId = 1;` e increméntalo tras crear cada tarea.
- Usa LINQ para los filtros: `_tareas.Where(t => !t.Completada).ToList()`.
- Para buscar por id puedes usar `FirstOrDefault` y comprobar `== null`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````csharp
using System;
using System.Collections.Generic;
using System.Linq;

public class Tarea
{
    public int Id { get; }
    public string Titulo { get; }
    public bool Completada { get; set; }

    public Tarea(int id, string titulo)
    {
        Id = id;
        Titulo = titulo;
        Completada = false;
    }
}

public class GestorTareas
{
    private readonly List<Tarea> _tareas = new List<Tarea>();
    private int _siguienteId = 1;

    public Tarea Agregar(string titulo)
    {
        if (string.IsNullOrWhiteSpace(titulo))
            throw new ArgumentException("El título de la tarea es obligatorio.");

        Tarea tarea = new Tarea(_siguienteId, titulo);
        _siguienteId++;
        _tareas.Add(tarea);
        return tarea;
    }

    public bool MarcarCompletada(int id)
    {
        Tarea tarea = _tareas.FirstOrDefault(t => t.Id == id);
        if (tarea == null) return false;
        tarea.Completada = true;
        return true;
    }

    public List<Tarea> Pendientes() => _tareas.Where(t => !t.Completada).ToList();

    public List<Tarea> Completadas() => _tareas.Where(t => t.Completada).ToList();

    public int Total() => _tareas.Count;

    public bool Eliminar(int id)
    {
        Tarea tarea = _tareas.FirstOrDefault(t => t.Id == id);
        if (tarea == null) return false;
        _tareas.Remove(tarea);
        return true;
    }

    public string Resumen()
        => $"Total: {Total()}, pendientes: {Pendientes().Count}, completadas: {Completadas().Count}";
}

public static class Ejercicio01
{
    public static GestorTareas CrearGestor() => new GestorTareas();
}
````

</details>