<?php

declare(strict_types=1);

function rutaPsr4(string $clase): string
{
    // TODO: convierte App\Nucleo\Usuario en App/Nucleo/Usuario.php.
    throw new Exception("TODO: implementar rutaPsr4()");
}

function autoloadCorrecto(string $jsonComposer): bool
{
    // TODO: true si el JSON tiene autoload.psr-4.
    throw new Exception("TODO: implementar autoloadCorrecto()");
}

function generarAutoloader(string $raiz): callable
{
    // TODO: closure que incluya $raiz/rutaPsr4($clase) si existe (true) o devuelva false.
    throw new Exception("TODO: implementar generarAutoloader()");
}

function instalarAutoloader(string $raiz): callable
{
    // TODO: registra el autoloader con spl_autoload_register y lo devuelve.
    throw new Exception("TODO: implementar instalarAutoloader()");
}