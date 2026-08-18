# Ejercicio 05 — Delegados y eventos

- **Nivel:** 3/5
- **Tema:** `Func`, `Predicate`, lambdas, `event EventHandler<T>`
- **Tiempo estimado:** 35 min

## Enunciado

Completa `Program.cs`. La clase `Termometro` expone el evento `EventHandler<int>? TemperaturaCambio`. Implementa:

1. `Termometro.SetTemperatura(int valor)` — si `valor != _temperatura`, actualiza y dispara `TemperaturaCambio?.Invoke(this, valor)`.
2. `int Aplicar(Func<int,int,int> operacion, int a, int b)` — `operacion(a, b)`.
3. `List<int> Mapear(List<int> lista, Func<int,int> transformacion)` — nueva lista con la transformación.
4. `List<int> Filtrar(List<int> lista, Predicate<int> condicion)` — solo los que cumplen la condición.
5. `Termometro CrearTermometro()` — devuelve una instancia.

Salida esperada de ejemplo:

```
[OK]   Aplicar((a,b) => a*b, 6, 7) devuelve 42
[OK]   Mapear([1,2,3], n => n*10) devuelve [10,20,30]
[OK]   El evento solo dispara cuando la temperatura cambia
```

## Requisitos

- [ ] `SetTemperatura` no dispara el evento si el valor no cambió.
- [ ] `Aplicar`, `Mapear` y `Filtrar` usan los delegados recibidos.
- [ ] El evento envía el nuevo valor en el segundo argumento (`EventArgs`).
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

- `TemperaturaCambio?.Invoke(this, valor)` dispara el evento solo si hay suscriptores.
- `lista.Select(transformacion).ToList()` y `lista.Where(x => condicion(x)).ToList()` (con `using System.Linq;`).
- En el test se suscriben con `+= (sender, valor) => { ... }`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````csharp
using System;
using System.Collections.Generic;
using System.Linq;

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

public static class Ejercicio05
{
    public static int Aplicar(Func<int, int, int> operacion, int a, int b)
        => operacion(a, b);

    public static List<int> Mapear(List<int> lista, Func<int, int> transformacion)
        => lista.Select(transformacion).ToList();

    public static List<int> Filtrar(List<int> lista, Predicate<int> condicion)
        => lista.Where(x => condicion(x)).ToList();

    public static Termometro CrearTermometro() => new Termometro();
}
````

</details>