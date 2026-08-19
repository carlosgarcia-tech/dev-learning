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

check(duplicar([1, 2, 3]) === [2, 4, 6], 'duplicar([1, 2, 3]) debe ser [2, 4, 6]');
check(duplicar([]) === [], 'duplicar([]) debe ser []');
check(duplicar([0, -1]) === [0, -2], 'duplicar([0, -1]) debe ser [0, -2]');

check(sumaArray([1, 2, 3, 4]) === 10, 'sumaArray([1, 2, 3, 4]) debe ser 10');
check(sumaArray([]) === 0, 'sumaArray([]) debe ser 0');
check(sumaArray([5]) === 5, 'sumaArray([5]) debe ser 5');

check(mayorYMenor([3, 9, 1, 7]) === ['mayor' => 9, 'menor' => 1], 'mayorYMenor([3, 9, 1, 7]) incorrecto');
check(mayorYMenor([5]) === ['mayor' => 5, 'menor' => 5], 'mayorYMenor([5]) debe devolver 5 en ambos');

$original = [1, 2, 3];
check(revertir($original) === [3, 2, 1], 'revertir([1, 2, 3]) debe ser [3, 2, 1]');
check($original === [1, 2, 3], 'revertir no debe mutar el array original');

$conteo = contarOcurrencias(['sol', 'luna', 'sol', 'mar']);
check($conteo['sol'] === 2, 'contarOcurrencias: "sol" debe aparecer 2 veces');
check($conteo['luna'] === 1, 'contarOcurrencias: "luna" debe aparecer 1 vez');
check(count($conteo) === 3, 'contarOcurrencias debe tener 3 palabras distintas');

if ($errores !== []) {
    fwrite(STDERR, implode(PHP_EOL, $errores) . PHP_EOL);
    exit(1);
}

echo "OK: todas las aserciones pasaron." . PHP_EOL;
exit(0);