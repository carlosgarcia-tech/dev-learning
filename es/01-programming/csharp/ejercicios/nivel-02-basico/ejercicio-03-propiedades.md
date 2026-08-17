# Ejercicio 03 — Propiedades y encapsulación

- **Nivel:** 2/5
- **Tema:** campos privados, propiedades de solo lectura, encapsulación, validaciones
- **Tiempo estimado:** 25 min

## Enunciado

Completa `ejercicio-03-propiedades.cs`. Define la clase `CuentaBancaria`:

1. Campo privado `double _saldo`.
2. Propiedad `double Saldo` de **solo lectura** (devuelve `_saldo`).
3. `CuentaBancaria(double saldoInicial)` — si `saldoInicial < 0` lanza `ArgumentException`.
4. `void Depositar(double monto)` — si `monto <= 0` lanza `ArgumentException`; si no, suma al saldo.
5. `void Retirar(double monto)` — si `monto <= 0` lanza `ArgumentException`; si no hay saldo suficiente lanza `InvalidOperationException`; si no, resta del saldo.
6. `bool PuedeRetirar(double monto)` — `true` si `monto > 0 && monto <= Saldo`.

`Ejercicio03` expone `CuentaBancaria CrearCuenta(double saldoInicial)`.

Salida esperada de ejemplo:

```
[OK]   CrearCuenta(100).Saldo devuelve 100
[OK]   Depositar(50) deja el saldo en 150
[OK]   Retirar(40) deja el saldo en 110
[OK]   Retirar más del saldo lanza InvalidOperationException
```

## Requisitos

- [ ] `Saldo` es de solo lectura (sin `set` público).
- [ ] No se permite crear una cuenta con saldo inicial negativo.
- [ ] No se permite depositar o retirar montos <= 0.
- [ ] Retirar más del saldo lanza `InvalidOperationException`.
- [ ] `PuedeRetirar` refleja correctamente si el monto es retirable.
- [ ] Los tests pasan: `csc ejercicio-03-propiedades.cs ejercicio-03-propiedades_test.cs && mono ejercicio-03-propiedades_test.exe` (si tienes Mono/csc).
- [ ] Los tests pasan: `dotnet run` (al instalar el .NET SDK).

> **Nota:** el .NET SDK **no está instalado** en esta máquina. Con el SDK instalado:
> ```bash
> dotnet new console -o . --force
> rm Program.cs
> dotnet run
> ```
> Con Mono/csc: `csc ejercicio-03-propiedades.cs ejercicio-03-propiedades_test.cs` y `mono ejercicio-03-propiedades_test.exe`.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `throw new ArgumentException("mensaje");` interrumpe el método.
- La propiedad de solo lectura con cuerpo de expresión: `public double Saldo => _saldo;`.
- Usa `monto > _saldo` para detectar saldo insuficiente antes de restar.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````csharp
using System;

public class CuentaBancaria
{
    private double _saldo;

    public CuentaBancaria(double saldoInicial)
    {
        if (saldoInicial < 0)
            throw new ArgumentException("El saldo inicial no puede ser negativo.");
        _saldo = saldoInicial;
    }

    public double Saldo => _saldo;

    public void Depositar(double monto)
    {
        if (monto <= 0)
            throw new ArgumentException("El monto a depositar debe ser positivo.");
        _saldo += monto;
    }

    public void Retirar(double monto)
    {
        if (monto <= 0)
            throw new ArgumentException("El monto a retirar debe ser positivo.");
        if (monto > _saldo)
            throw new InvalidOperationException("Saldo insuficiente.");
        _saldo -= monto;
    }

    public bool PuedeRetirar(double monto) => monto > 0 && monto <= _saldo;
}

public static class Ejercicio03
{
    public static CuentaBancaria CrearCuenta(double saldoInicial)
        => new CuentaBancaria(saldoInicial);
}
````

</details>