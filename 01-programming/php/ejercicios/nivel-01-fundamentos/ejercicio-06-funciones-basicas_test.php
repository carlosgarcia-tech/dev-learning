<?php

declare(strict_types=1);

require __DIR__ . '/ejercicio-06-funciones-basicas.php';

$errores = [];

function check(bool $condicion, string $mensaje): void
{
    global $errores;
    if (!$condicion) {
        $errores[] = $mensaje;
    }
}

check(saludar('Ana') === 'Hola, Ana!', 'saludar("Ana") debe usar el saludo por defecto');
check(saludar('Ana', 'Buenos días') === 'Buenos días, Ana!', 'saludar con saludo propio');
check(saludar('Pablo') === 'Hola, Pablo!', 'saludar("Pablo") debe ser "Hola, Pablo!"');

check(areaCirculo(1) === 3.14, 'areaCirculo(1) debe ser 3.14');
check(areaCirculo(10) === 314.16, 'areaCirculo(10) debe ser 314.16');

check(esMayorDeEdad(18) === true, 'esMayorDeEdad(18) debe ser true');
check(esMayorDeEdad(30) === true, 'esMayorDeEdad(30) debe ser true');
check(esMayorDeEdad(17) === false, 'esMayorDeEdad(17) debe ser false');

check(potencia(3) === 9, 'potencia(3) debe usar exponente por defecto 2');
check(potencia(2, 10) === 1024, 'potencia(2, 10) debe ser 1024');
check(potencia(5, 0) === 1, 'potencia(5, 0) debe ser 1');

check(clasificarEdad(10) === 'Niño', 'clasificarEdad(10) debe ser "Niño"');
check(clasificarEdad(15) === 'Adolescente', 'clasificarEdad(15) debe ser "Adolescente"');
check(clasificarEdad(30) === 'Adulto', 'clasificarEdad(30) debe ser "Adulto"');

if ($errores !== []) {
    fwrite(STDERR, implode(PHP_EOL, $errores) . PHP_EOL);
    exit(1);
}

echo "OK: todas las aserciones pasaron." . PHP_EOL;
exit(0);