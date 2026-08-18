using System;

public class CuentaBancaria
{
    private double _saldo;

    public CuentaBancaria(double saldoInicial)
    {
        // TODO: valida que saldoInicial >= 0 (si no, lanza ArgumentException) y asígnalo a _saldo.
        _saldo = saldoInicial;
    }

    public double Saldo
    {
        get
        {
            // TODO: devuelve _saldo.
            throw new NotImplementedException("TODO: implementar Saldo");
        }
    }

    public void Depositar(double monto)
    {
        // TODO: valida que monto > 0 y súmalo a _saldo.
        throw new NotImplementedException("TODO: implementar Depositar(double)");
    }

    public void Retirar(double monto)
    {
        // TODO: valida monto > 0 y que haya saldo suficiente; resta de _saldo.
        throw new NotImplementedException("TODO: implementar Retirar(double)");
    }

    public bool PuedeRetirar(double monto)
    {
        // TODO: devuelve true si monto > 0 y monto <= _saldo.
        throw new NotImplementedException("TODO: implementar PuedeRetirar(double)");
    }
}

public static class Ejercicio03
{
    public static CuentaBancaria CrearCuenta(double saldoInicial)
    {
        // TODO: devuelve new CuentaBancaria(saldoInicial).
        throw new NotImplementedException("TODO: implementar CrearCuenta(double)");
    }
}