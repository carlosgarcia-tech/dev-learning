<?php

declare(strict_types=1);

class Producto
{
    public function __construct(
        private string $nombre,
        private float $precio,
        private int $stock = 0
    ) {
        // TODO: promoción de propiedades ya declarada; implementa los métodos de abajo.
    }

    public function nombre(): string
    {
        // TODO
        throw new Exception("TODO: implementar Producto::nombre()");
    }

    public function precio(): float
    {
        // TODO
        throw new Exception("TODO: implementar Producto::precio()");
    }

    public function hayStock(): bool
    {
        // TODO
        throw new Exception("TODO: implementar Producto::hayStock()");
    }

    public function descontar(int $cantidad): bool
    {
        // TODO: reduce stock y devuelve true; false si no alcanza.
        throw new Exception("TODO: implementar Producto::descontar()");
    }

    public function __toString(): string
    {
        // TODO: devuelve "<nombre> (<precio>)".
        throw new Exception("TODO: implementar Producto::__toString()");
    }
}

class CuentaBancaria
{
    private float $saldo;

    public function __construct(float $saldoInicial = 0.0)
    {
        $this->saldo = $saldoInicial;
    }

    public function depositar(float $monto): void
    {
        // TODO
        throw new Exception("TODO: implementar CuentaBancaria::depositar()");
    }

    public function retirar(float $monto): bool
    {
        // TODO: false si no hay saldo; si no, resta y devuelve true.
        throw new Exception("TODO: implementar CuentaBancaria::retirar()");
    }

    public function saldo(): float
    {
        // TODO
        throw new Exception("TODO: implementar CuentaBancaria::saldo()");
    }
}