# Ejercicio 06 — Enums

- **Nivel:** 2/5
- **Tema:** `enum`, `switch`, conversión a entero
- **Tiempo estimado:** 25 min

## Enunciado

Completa `Program.cs`. Se definen los enums `DiaSemana` (Lunes→Domingo) y `EstadoPedido` (Pendiente, Enviado, Entregado, Cancelado). Implementa en `Ejercicio06`:

1. `bool EsFinDeSemana(DiaSemana dia)` — `true` para `Sabado` o `Domingo`.
2. `DiaSemana Siguiente(DiaSemana dia)` — el día siguiente (de `Domingo` vuelve a `Lunes`).
3. `EstadoPedido SiguienteEstado(EstadoPedido estado)` — `Pendiente → Enviado`, `Enviado → Entregado`; con `Entregado` o `Cancelado` lanza `InvalidOperationException`.
4. `string NombreEnEspanol(DiaSemana dia)` — el nombre con acentos (`Miércoles`, `Sábado`, …).

Salida esperada de ejemplo:

```
[OK]   EsFinDeSemana(Sabado) es true
[OK]   Siguiente(Domingo) devuelve Lunes
[OK]   SiguienteEstado(Enviado) devuelve Entregado
[OK]   NombreEnEspanol(Miercoles) devuelve "Miércoles"
```

## Requisitos

- [ ] `EsFinDeSemana` solo es `true` para sábado y domingo.
- [ ] `Siguiente(Domingo)` devuelve `Lunes` (usa el módulo `% 7` o un `switch`).
- [ ] `SiguienteEstado` lanza `InvalidOperationException` en estados finales.
- [ ] `NombreEnEspanol` devuelve los nombres con acentos.
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

- `(int)dia` da el valor numérico del enum (empieza en 0); `(DiaSemana)numero` lo convierte de vuelta.
- `((int)dia + 1) % 7` avanza un día y vuelve a `Lunes` tras `Domingo`.
- Para `NombreEnEspanol` puedes usar un `switch`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````csharp
using System;

public enum DiaSemana
{
    Lunes,
    Martes,
    Miercoles,
    Jueves,
    Viernes,
    Sabado,
    Domingo
}

public enum EstadoPedido
{
    Pendiente,
    Enviado,
    Entregado,
    Cancelado
}

public static class Ejercicio06
{
    public static bool EsFinDeSemana(DiaSemana dia)
        => dia == DiaSemana.Sabado || dia == DiaSemana.Domingo;

    public static DiaSemana Siguiente(DiaSemana dia)
        => (DiaSemana)(((int)dia + 1) % 7);

    public static EstadoPedido SiguienteEstado(EstadoPedido estado)
    {
        switch (estado)
        {
            case EstadoPedido.Pendiente:
                return EstadoPedido.Enviado;
            case EstadoPedido.Enviado:
                return EstadoPedido.Entregado;
            default:
                throw new InvalidOperationException("El pedido está en estado final: " + estado);
        }
    }

    public static string NombreEnEspanol(DiaSemana dia)
    {
        switch (dia)
        {
            case DiaSemana.Lunes: return "Lunes";
            case DiaSemana.Martes: return "Martes";
            case DiaSemana.Miercoles: return "Miércoles";
            case DiaSemana.Jueves: return "Jueves";
            case DiaSemana.Viernes: return "Viernes";
            case DiaSemana.Sabado: return "Sábado";
            case DiaSemana.Domingo: return "Domingo";
            default: return "Desconocido";
        }
    }
}
````

</details>