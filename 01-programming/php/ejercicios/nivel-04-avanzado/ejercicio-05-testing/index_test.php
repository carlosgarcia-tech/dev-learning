<?php

declare(strict_types=1);

require __DIR__ . '/index.php';

$errores = [];

function check(bool $condicion, string $mensaje): void
{
    global $errores;
    if (!$condicion) {
        $errores[] = $mensaje;
    }
}

check(esPalindromo('reconocer') === true, 'esPalindromo("reconocer") debe ser true');
check(esPalindromo('Anita lava la tina') === true, 'esPalindromo debe ignorar espacios y mayúsculas');
check(esPalindromo('Hola') === false, 'esPalindromo("Hola") debe ser false');
check(esPalindromo('') === false, 'esPalindromo("") debe ser false');

check(factorial(5) === 120, 'factorial(5) debe ser 120');
check(factorial(0) === 1, 'factorial(0) debe ser 1');
check(factorial(3) === 6, 'factorial(3) debe ser 6');
try {
    factorial(-1);
    check(false, 'factorial(-1) debe lanzar InvalidArgumentException');
} catch (InvalidArgumentException $e) {
    check(true, 'factorial lanza InvalidArgumentException para negativos');
}

check(celsiusAFahrenheit(0) === 32.0, 'celsiusAFahrenheit(0) debe ser 32.0');
check(celsiusAFahrenheit(100) === 212.0, 'celsiusAFahrenheit(100) debe ser 212.0');
check(celsiusAFahrenheit(37) === 98.6, 'celsiusAFahrenheit(37) debe ser 98.6');

check(esEmailValido('ana@mail.com') === true, 'esEmailValido("ana@mail.com") debe ser true');
check(esEmailValido('sin-arroba') === false, 'sin @ debe ser false');
check(esEmailValido('ana@sinpunto') === false, 'sin punto tras la @ debe ser false');
check(esEmailValido('') === false, 'vacío debe ser false');

if ($errores !== []) {
    fwrite(STDERR, implode(PHP_EOL, $errores) . PHP_EOL);
    exit(1);
}

echo "OK: todas las aserciones pasaron." . PHP_EOL;
exit(0);