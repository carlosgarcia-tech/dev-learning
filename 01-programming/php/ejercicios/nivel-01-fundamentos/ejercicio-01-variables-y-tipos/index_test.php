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

$datos = crearDatos();
check(is_string($datos['nombre'] ?? null), 'crearDatos: "nombre" debe ser un string');
check(is_string($datos['ciudad'] ?? null), 'crearDatos: "ciudad" debe ser un string');
check(is_int($datos['edad'] ?? null), 'crearDatos: "edad" debe ser un int');
check(is_bool($datos['programacion'] ?? null), 'crearDatos: "programacion" debe ser un bool');

check(tipoDe(42) === 'int', 'tipoDe(42) debe devolver "int"');
check(tipoDe(3.14) === 'float', 'tipoDe(3.14) debe devolver "float"');
check(tipoDe('hola') === 'string', 'tipoDe("hola") debe devolver "string"');
check(tipoDe(true) === 'bool', 'tipoDe(true) debe devolver "bool"');
check(tipoDe([1, 2]) === 'array', 'tipoDe([1, 2]) debe devolver "array"');
check(tipoDe(null) === 'null', 'tipoDe(null) debe devolver "null"');

$frase = formatearDescripcion($datos);
check(is_string($frase), 'formatearDescripcion debe devolver un string');
check(str_contains($frase, $datos['nombre']), 'la frase debe incluir el nombre');
check(str_contains($frase, (string) $datos['edad']), 'la frase debe incluir la edad');
check(str_contains($frase, $datos['ciudad']), 'la frase debe incluir la ciudad');
check(str_contains($frase, 'true'), 'la frase debe incluir "true" cuando programacion es true');

$frase2 = formatearDescripcion(['nombre' => 'Pablo', 'ciudad' => 'Bogotá', 'edad' => 25, 'programacion' => false]);
check(str_contains($frase2, 'Pablo'), 'la frase debe reflejar otro nombre');
check(str_contains($frase2, '25'), 'la frase debe reflejar otra edad');
check(str_contains($frase2, 'Bogotá'), 'la frase debe reflejar otra ciudad');
check(str_contains($frase2, 'false'), 'la frase debe incluir "false" cuando programacion es false');

if ($errores !== []) {
    fwrite(STDERR, implode(PHP_EOL, $errores) . PHP_EOL);
    exit(1);
}

echo "OK: todas las aserciones pasaron." . PHP_EOL;
exit(0);