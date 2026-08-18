<?php

declare(strict_types=1);

require __DIR__ . '/ejercicio-04-errores-y-excepciones.php';

$errores = [];

function check(bool $condicion, string $mensaje): void
{
    global $errores;
    if (!$condicion) {
        $errores[] = $mensaje;
    }
}

check(dividirSeguro(10, 2) === 5.0, 'dividirSeguro(10, 2) debe ser 5.0');
check(dividirSeguro(1, 4) === 0.25, 'dividirSeguro(1, 4) debe ser 0.25');

try {
    dividirSeguro(10, 0);
    check(false, 'dividirSeguro(10, 0) debe lanzar InvalidArgumentException');
} catch (InvalidArgumentException $e) {
    check(true, 'dividirSeguro lanza InvalidArgumentException');
}

check(validarEdad(20) === 'Mayor de edad', 'validarEdad(20) debe ser "Mayor de edad"');
check(validarEdad(15) === 'Menor de edad', 'validarEdad(15) debe ser "Menor de edad"');
try {
    validarEdad(200);
    check(false, 'validarEdad(200) debe lanzar EdadInvalidaException');
} catch (EdadInvalidaException $e) {
    check(true, 'validarEdad lanza EdadInvalidaException');
}
try {
    validarEdad(-1);
    check(false, 'validarEdad(-1) debe lanzar EdadInvalidaException');
} catch (EdadInvalidaException $e) {
    check(true, 'validarEdad lanza EdadInvalidaException para negativos');
}

check(procesarConSeguridad(fn () => 42) === 42, 'procesarConSeguridad devuelve el resultado');
check(procesarConSeguridad(fn () => throw new RuntimeException('boom')) === null, 'procesarConSeguridad devuelve null si falla');

$intentos = 0;
$resultado = conReintentos(function () use (&$intentos) {
    $intentos++;
    if ($intentos < 3) {
        throw new RuntimeException('fallo temporal');
    }
    return 'ok';
}, 3);
check($resultado === 'ok', 'conReintentos debe tener éxito tras reintentos');
check($intentos === 3, 'conReintentos debe haber intentado 3 veces');

try {
    conReintentos(fn () => throw new RuntimeException('siempre falla'), 2);
    check(false, 'conReintentos debe lanzar al agotar los intentos');
} catch (RuntimeException $e) {
    check(true, 'conReintentos lanza la última excepción');
}

if ($errores !== []) {
    fwrite(STDERR, implode(PHP_EOL, $errores) . PHP_EOL);
    exit(1);
}

echo "OK: todas las aserciones pasaron." . PHP_EOL;
exit(0);