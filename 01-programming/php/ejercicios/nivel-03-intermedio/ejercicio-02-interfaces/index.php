<?php

declare(strict_types=1);

interface Pagable
{
    public function calcularTotal(): float;
    public function descripcion(): string;
}

class Factura implements Pagable
{
    public function __construct(private array $lineas)
    {
    }

    public function calcularTotal(): float
    {
        // TODO: suma los 'precio' de las líneas.
        throw new Exception("TODO: implementar Factura::calcularTotal()");
    }

    public function descripcion(): string
    {
        // TODO: devuelve "Factura".
        throw new Exception("TODO: implementar Factura::descripcion()");
    }
}

class Suscripcion implements Pagable
{
    public function __construct(private float $precioMensual, private int $meses)
    {
    }

    public function calcularTotal(): float
    {
        // TODO: precioMensual * meses.
        throw new Exception("TODO: implementar Suscripcion::calcularTotal()");
    }

    public function descripcion(): string
    {
        // TODO: devuelve "Suscripción".
        throw new Exception("TODO: implementar Suscripcion::descripcion()");
    }
}

function procesarPago(Pagable $pagable): float
{
    // TODO: devuelve el total del pago.
    throw new Exception("TODO: implementar procesarPago()");
}

function sumarTotales(array $pagables): float
{
    // TODO: suma calcularTotal() solo de los elementos Pagable.
    throw new Exception("TODO: implementar sumarTotales()");
}