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

$porTres = multiplicador(3);
check(is_callable($porTres), 'multiplicador debe devolver una closure invocable');
check($porTres(4) === 12, 'multiplicador(3)(4) debe ser 12');
check(multiplicador(2)(5) === 10, 'multiplicador(2)(5) debe ser 10');
check($porTres(10) === 30, 'la closure debe recordar el factor capturado');

check(aplicarA([1, 2, 3], fn ($n) => $n ** 2) === [1, 4, 9], 'aplicarA con cuadrados');
check(aplicarA([2, 4], fn ($n) => $n + 1) === [3, 5], 'aplicarA con suma');

check(filtrarPares([1, 2, 3, 4, 5]) === [2, 4], 'filtrarPares debe dejar solo pares');
check(filtrarPares([1, 3, 5]) === [], 'filtrarPares sin pares debe ser []');

$contar = crearContador();
check($contar() === 1, 'primera llamada del contador debe ser 1');
check($contar() === 2, 'segunda llamada del contador debe ser 2');
check($contar() === 3, 'tercera llamada del contador debe ser 3');

if ($errores !== []) {
    fwrite(STDERR, implode(PHP_EOL, $errores) . PHP_EOL);
    exit(1);
}

echo "OK: todas las aserciones pasaron." . PHP_EOL;
exit(0);