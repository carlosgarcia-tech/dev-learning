# Ejercicio 06 — Nullables

- **Nivel:** 3/5
- **Tema:** `int?`, `string?`, `??`, aritmética con nullables, `#nullable enable`
- **Tiempo estimado:** 30 min

## Enunciado

Completa `ejercicio-06-nullables.cs`. El archivo comienza con `#nullable enable`. Implementa en `Ejercicio06`:

1. `string LongitudDe(string? s)` — longitud como texto, o `"null"` si `s` es null.
2. `int? SumaSegura(int? a, int? b)` — `a + b` (si alguno es null, el resultado es null).
3. `string ValorODefecto(string? s, string defecto)` — `s ?? defecto`.
4. `bool EsVacia(string? s)` — `string.IsNullOrEmpty(s)`.
5. `int TotalConCeros(int? a, int? b)` — `(a ?? 0) + (b ?? 0)`.

Salida esperada de ejemplo:

```
[OK]   LongitudDe(null) devuelve "null"
[OK]   SumaSegura(null, 4) es null
[OK]   ValorODefecto(null, "d") devuelve "d"
[OK]   TotalConCeros(null, 5) devuelve 5
```

## Requisitos

- [ ] `LongitudDe(null)` devuelve `"null"` (el texto).
- [ ] `SumaSegura` usa la propagación null de `int? + int?`.
- [ ] `ValorODefecto` usa el operador `??`.
- [ ] `EsVacia(null)` y `EsVacia("")` son `true`.
- [ ] `TotalConCeros` trata null como 0.
- [ ] Los tests pasan: `csc ejercicio-06-nullables.cs ejercicio-06-nullables_test.cs && mono ejercicio-06-nullables_test.exe` (si tienes Mono/csc).
- [ ] Los tests pasan: `dotnet run` (al instalar el .NET SDK).

> **Nota:** el .NET SDK **no está instalado** en esta máquina. Con el SDK instalado:
> ```bash
> dotnet new console -o . --force
> rm Program.cs
> dotnet run
> ```
> Con Mono/csc: `csc ejercicio-06-nullables.cs ejercicio-06-nullables_test.cs` y `mono ejercicio-06-nullables_test.exe`.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `int? + int?` devuelve null si cualquiera de los dos es null.
- `?.` y `??` son los operadores de null-safe y de valor por defecto.
- Un `int?` tiene `HasValue` y `Value`; el test usa `!.HasValue` para comprobar null.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````csharp
#nullable enable
using System;

public static class Ejercicio06
{
    public static string LongitudDe(string? s)
        => s is null ? "null" : s.Length.ToString();

    public static int? SumaSegura(int? a, int? b)
        => a + b;

    public static string ValorODefecto(string? s, string defecto)
        => s ?? defecto;

    public static bool EsVacia(string? s)
        => string.IsNullOrEmpty(s);

    public static int TotalConCeros(int? a, int? b)
        => (a ?? 0) + (b ?? 0);
}
````

</details>