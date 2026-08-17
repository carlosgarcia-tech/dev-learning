# Ejercicio 02 — Variables y tipos

- **Nivel:** 1/5
- **Tema:** variables, tipos básicos (`string`, `int`, `bool`), `typeof`, interpolación
- **Tiempo estimado:** 15 min

## Enunciado

Completa `ejercicio-02-variables-y-tipos.cs` para que `Ejercicio02` implemente:

1. `string Nombre()` — devuelve un nombre (p. ej. `Ana`).
2. `string Ciudad()` — devuelve una ciudad de nacimiento (p. ej. `Lima`).
3. `int Edad()` — devuelve una edad numérica (p. ej. `30`).
4. `bool EstudiaProgramacion()` — devuelve `true`.
5. `string TipoDe(object valor)` — devuelve el **nombre del tipo** de `valor` en .NET (`String`, `Int32`, `Boolean`).
6. `string FormatearDescripcion(string nombre, string ciudad, int edad, bool programacion)` — devuelve con interpolación:
   `Soy <nombre>, tengo <edad> años, nací en <ciudad> y es <programacion> que estudio programación.`

Salida esperada (ejemplo de checks):

```
[OK]   TipoDe("hola") devuelve "String"
[OK]   TipoDe(42) devuelve "Int32"
[OK]   FormatearDescripcion(Ana, Lima, 30, true) coincide con el patrón esperado
```

## Requisitos

- [ ] `Nombre()`, `Ciudad()`, `Edad()` y `EstudiaProgramacion()` devuelven los valores de ejemplo.
- [ ] `TipoDe` usa `valor.GetType().Name` para obtener el nombre del tipo.
- [ ] `FormatearDescripcion` usa interpolación de strings con `${...}` de C# (`$"..."`).
- [ ] Los tests pasan: `csc ejercicio-02-variables-y-tipos.cs ejercicio-02-variables-y-tipos_test.cs && mono ejercicio-02-variables-y-tipos_test.exe` (si tienes Mono/csc).
- [ ] Los tests pasan: `dotnet run` (al instalar el .NET SDK).

> **Nota:** el .NET SDK **no está instalado** en esta máquina; los tests no se pueden verificar aquí. Con el SDK instalado, desde la carpeta del ejercicio:
> ```bash
> dotnet new console -o . --force
> rm Program.cs
> dotnet run
> ```
> Con Mono/csc: `csc ejercicio-02-variables-y-tipos.cs ejercicio-02-variables-y-tipos_test.cs` y luego `mono ejercicio-02-variables-y-tipos_test.exe`. El runner devuelve `0` si todos pasan.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `valor.GetType().Name` devuelve `"String"` para un `string`, `"Int32"` para un `int`, `"Boolean"` para un `bool`.
- Al interpolar un `bool` con `$"..."`, C# escribe `True` o `False` (con mayúscula).
- Un método de un solo `return` puede escribirse con cuerpo de expresión: `public static string Nombre() => "Ana";`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````csharp
using System;

public static class Ejercicio02
{
    public static string Nombre() => "Ana";

    public static string Ciudad() => "Lima";

    public static int Edad() => 30;

    public static bool EstudiaProgramacion() => true;

    public static string TipoDe(object valor) => valor.GetType().Name;

    public static string FormatearDescripcion(string nombre, string ciudad, int edad, bool programacion)
        => $"Soy {nombre}, tengo {edad} años, nací en {ciudad} y es {programacion} que estudio programación.";
}
````

</details>