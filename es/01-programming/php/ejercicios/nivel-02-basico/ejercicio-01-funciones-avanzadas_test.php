<?php

declare(strict_types=1);

require __DIR__ . '/ejercicio-01-funciones-avanzadas.php';

$errores = [];

function check(bool $condicion, string $mensaje): void
{
    global $errores;
    if (!$condicion) {
        $errores[] = $mensaje;
    }
}

check(sumaVariadica(1, 2, 3, 4) === 10, 'sumaVariadica(1,2,3,4) debe ser 10');
check(sumaVariadica() === 0, 'sumaVariadica() debe ser 0');
check(sumaVariadica(5) === 5, 'sumaVariadica(5) debe ser 5');

$x = 5;
incrementarRef($x);
check($x === 6, 'incrementarRef debe modificar la variable original');

check(aplicarDescuento(100.0) === 90.0, 'aplicarDescuento(100) debe usar 10% por defecto');
check(aplicarDescuento(precio: 100.0, porcentaje: 25.0) === 75.0, 'aplicarDescuento con argumentos con nombre');
check(aplicarDescuento(200.0, 50.0) === 100.0, 'aplicarDescuento(200, 50) debe ser 100');

check(duplicarConFn([1, 2, 3]) === [2, 4, 6], 'duplicarConFn([1,2,3]) debe ser [2,4,6]');
check(duplicarConFn([]) === [], 'duplicarConFn([]) debe ser []');

if ($errores !== []) {
    fwrite(STDERR, implode(PHP_EOL, $errores) . PHP_EOL);
    exit(1);
}

echo "OK: todas las aserciones pasaron." . PHP_EOL;
exit(0);