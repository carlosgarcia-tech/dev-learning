<?php

declare(strict_types=1);

function multiplicador(int $factor): callable
{
    // TODO: devuelve una closure que multiplique por $factor (usa use).
    throw new Exception("TODO: implementar multiplicador()");
}

function aplicarA(array $numeros, callable $fn): array
{
    // TODO: aplica $fn a cada elemento con array_map.
    throw new Exception("TODO: implementar aplicarA()");
}

function filtrarPares(array $numeros): array
{
    // TODO: devuelve solo los pares con array_filter.
    throw new Exception("TODO: implementar filtrarPares()");
}

function crearContador(): callable
{
    // TODO: devuelve una closure con una variable static que incremente 1, 2, 3...
    throw new Exception("TODO: implementar crearContador()");
}