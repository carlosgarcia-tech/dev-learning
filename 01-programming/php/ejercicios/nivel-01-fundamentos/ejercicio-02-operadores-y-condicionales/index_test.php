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

check(esPar(4) === true, 'esPar(4) debe ser true');
check(esPar(7) === false, 'esPar(7) debe ser false');
check(esPar(0) === true, 'esPar(0) debe ser true');
check(esPar(-3) === false, 'esPar(-3) debe ser false');

check(clasificarNota(95) === 'Excelente', 'clasificarNota(95) debe ser "Excelente"');
check(clasificarNota(90) === 'Excelente', 'clasificarNota(90) debe ser "Excelente"');
check(clasificarNota(75) === 'Aprobado', 'clasificarNota(75) debe ser "Aprobado"');
check(clasificarNota(50) === 'Reprobado', 'clasificarNota(50) debe ser "Reprobado"');

check(mayorDeTres(3, 9, 5) === 9, 'mayorDeTres(3, 9, 5) debe ser 9');
check(mayorDeTres(8, 2, 6) === 8, 'mayorDeTres(8, 2, 6) debe ser 8');
check(mayorDeTres(1, 1, 1) === 1, 'mayorDeTres(1, 1, 1) debe ser 1');

check(diaSemana(1) === 'Lunes', 'diaSemana(1) debe ser "Lunes"');
check(diaSemana(7) === 'Domingo', 'diaSemana(7) debe ser "Domingo"');
check(diaSemana(9) === 'Día inválido', 'diaSemana(9) debe ser "Día inválido"');
check(diaSemana(0) === 'Día inválido', 'diaSemana(0) debe ser "Día inválido"');

check(descuento(50.0, true) === 40.0, 'descuento(50, true) debe ser 40.0');
check(descuento(50.0, false) === 50.0, 'descuento(50, false) debe ser 50.0');
check(descuento(200.0, false) === 180.0, 'descuento(200, false) debe ser 180.0');
check(descuento(200.0, true) === 144.0, 'descuento(200, true) debe ser 144.0');

if ($errores !== []) {
    fwrite(STDERR, implode(PHP_EOL, $errores) . PHP_EOL);
    exit(1);
}

echo "OK: todas las aserciones pasaron." . PHP_EOL;
exit(0);