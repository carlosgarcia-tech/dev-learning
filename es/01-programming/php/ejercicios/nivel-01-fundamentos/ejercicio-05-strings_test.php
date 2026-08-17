<?php

declare(strict_types=1);

require __DIR__ . '/ejercicio-05-strings.php';

$errores = [];

function check(bool $condicion, string $mensaje): void
{
    global $errores;
    if (!$condicion) {
        $errores[] = $mensaje;
    }
}

check(limpiarYCaps('  hola mundo  ') === 'Hola mundo', 'limpiarYCaps debe limpiar y capitalizar');
check(limpiarYCaps('  ANÁLISIS  ') === 'Análisis', 'limpiarYCaps debe normalizar mayúsculas');

check(contarPalabras('hola mundo de php') === 4, 'contarPalabras debe contar 4 palabras');
check(contarPalabras('') === 0, 'contarPalabras("") debe ser 0');
check(contarPalabras('solo') === 1, 'contarPalabras("solo") debe ser 1');

check(revertirPalabras('hola mundo') === 'mundo hola', 'revertirPalabras("hola mundo") debe ser "mundo hola"');
check(revertirPalabras('a b c') === 'c b a', 'revertirPalabras("a b c") debe ser "c b a"');

check(esPalindromo('Anita lava la tina') === true, 'esPalindromo debe ignorar espacios y mayúsculas');
check(esPalindromo('reconocer') === true, 'esPalindromo("reconocer") debe ser true');
check(esPalindromo('hola') === false, 'esPalindromo("hola") debe ser false');

check(reemplazarVocales('casa') === 'c*s*', 'reemplazarVocales("casa") debe ser "c*s*"');
check(reemplazarVocales('AEIOU') === '*****', 'reemplazarVocales("AEIOU") debe ser "*****"');

if ($errores !== []) {
    fwrite(STDERR, implode(PHP_EOL, $errores) . PHP_EOL);
    exit(1);
}

echo "OK: todas las aserciones pasaron." . PHP_EOL;
exit(0);