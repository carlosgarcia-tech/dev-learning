<?php

declare(strict_types=1);

class Vehiculo
{
    public function __construct(protected string $marca)
    {
    }

    public function describir(): string
    {
        // TODO: devuelve "Vehículo de marca <marca>".
        throw new Exception("TODO: implementar Vehiculo::describir()");
    }
}

class Coche extends Vehiculo
{
    public function describir(): string
    {
        // TODO: parent::describir() . " con 4 ruedas".
        throw new Exception("TODO: implementar Coche::describir()");
    }
}

class Moto extends Vehiculo
{
    public function describir(): string
    {
        // TODO: parent::describir() . " con 2 ruedas".
        throw new Exception("TODO: implementar Moto::describir()");
    }
}

abstract class Figura
{
    abstract public function area(): float;
}

class Circulo extends Figura
{
    public function __construct(private float $radio)
    {
    }

    public function area(): float
    {
        // TODO: pi * radio^2 redondeado a 2 decimales.
        throw new Exception("TODO: implementar Circulo::area()");
    }
}

class Rectangulo extends Figura
{
    public function __construct(private float $base, private float $altura)
    {
    }

    public function area(): float
    {
        // TODO: base * altura.
        throw new Exception("TODO: implementar Rectangulo::area()");
    }
}