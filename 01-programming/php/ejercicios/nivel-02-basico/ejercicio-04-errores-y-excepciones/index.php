<?php

declare(strict_types=1);

class EdadInvalidaException extends Exception
{
}

function dividirSeguro(int $a, int $b): float
{
    // TODO: devuelve $a / $b; lanza InvalidArgumentException si $b es 0.
    throw new Exception("TODO: implementar dividirSeguro()");
}

function validarEdad(int $edad): string
{
    // TODO: lanza EdadInvalidaException fuera del rango 0-150; si no "Mayor de edad"/"Menor de edad".
    throw new Exception("TODO: implementar validarEdad()");
}

function procesarConSeguridad(callable $fn): mixed
{
    // TODO: try/catch(Throwable); devuelve el resultado o null.
    throw new Exception("TODO: implementar procesarConSeguridad()");
}

function conReintentos(callable $operacion, int $intentos = 3): mixed
{
    // TODO: reintenta hasta $intentos veces; al agotarse, lanza la última excepción.
    throw new Exception("TODO: implementar conReintentos()");
}