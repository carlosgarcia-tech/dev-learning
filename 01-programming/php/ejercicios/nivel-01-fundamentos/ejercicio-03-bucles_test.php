<?php

declare(strict_types=1);

require __DIR__ . '/ejercicio-03-bucles.php';

$errores = [];

function check(bool $condicion, string $mensaje): void
{
    global $errores;
    if (!$condicion) {
        $errores[] = $mensaje;
    }
}

check(sumar1aN(5) === 15, 'sumar1aN(5) debe ser 15');
check(sumar1aN(10) === 55, 'sumar1aN(10) debe ser 55');
check(sumar1aN(0) === 0, 'sumar1aN(0) debe ser 0');
check(sumar1aN(1) === 1, 'sumar1aN(1) debe ser 1');

$tabla = tablaMultiplicar(7);
check(count($tabla) === 10, 'tablaMultiplicar(7) debe tener 10 líneas');
check($tabla[0] === '7 x 1 = 7', 'la primera línea debe ser "7 x 1 = 7"');
check($tabla[9] === '7 x 10 = 70', 'la última línea debe ser "7 x 10 = 70"');

check(esPrimo(2) === true, 'esPrimo(2) debe ser true');
check(esPrimo(3) === true, 'esPrimo(3) debe ser true');
check(esPrimo(17) === true, 'esPrimo(17) debe ser true');
check(esPrimo(1) === false, 'esPrimo(1) debe ser false');
check(esPrimo(4) === false, 'esPrimo(4) debe ser false');
check(esPrimo(9) === false, 'esPrimo(9) debe ser false');

$vocales = contarVocales('Hola mundo');
check(array_sum($vocales) === 4, 'contarVocales("Hola mundo") debe sumar 4 vocales');
check(contarVocales('aaa')['a'] === 3, "contarVocales('aaa')['a'] debe ser 3");
check(contarVocales('bcdf')['e'] === 0, 'las vocales ausentes deben contar 0');

check(numerosImpares(7) === [1, 3, 5, 7], 'numerosImpares(7) debe ser [1, 3, 5, 7]');
check(numerosImpares(1) === [1], 'numerosImpares(1) debe ser [1]');
check(numerosImpares(0) === [], 'numerosImpares(0) debe ser []');

if ($errores !== []) {
    fwrite(STDERR, implode(PHP_EOL, $errores) . PHP_EOL);
    exit(1);
}

echo "OK: todas las aserciones pasaron." . PHP_EOL;
exit(0);