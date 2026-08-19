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

$usuarios = [
    ['id' => 1, 'nombre' => 'Ana', 'email' => 'ana@mail.com'],
    ['id' => 2, 'nombre' => 'Pablo', 'email' => 'pablo@mail.com'],
];
$encontrado = buscarPorEmail($usuarios, 'pablo@mail.com');
check($encontrado !== null && $encontrado['nombre'] === 'Pablo', 'buscarPorEmail debe encontrar a Pablo');
check(buscarPorEmail($usuarios, 'no@existe.com') === null, 'buscarPorEmail debe devolver null si no existe');

$productos = [
    ['nombre' => 'Mouse', 'precio' => 25],
    ['nombre' => 'Laptop', 'precio' => 1200],
    ['nombre' => 'Teclado', 'precio' => 40],
];
$ordenados = ordenarPorPrecio($productos);
check($ordenados[0]['nombre'] === 'Mouse', 'ordenarPorPrecio: el más barato primero');
check($ordenados[2]['nombre'] === 'Laptop', 'ordenarPorPrecio: el más caro al final');
check(count($ordenados) === 3, 'ordenarPorPrecio debe conservar todos los productos');

$conCategorias = [
    ['nombre' => 'Laptop', 'categoria' => 'tecnologia'],
    ['nombre' => 'Silla', 'categoria' => 'hogar'],
    ['nombre' => 'Mouse', 'categoria' => 'tecnologia'],
];
$grupos = agruparPorCategoria($conCategorias);
check(count($grupos['tecnologia']) === 2, 'agruparPorCategoria: tecnología tiene 2 productos');
check(count($grupos['hogar']) === 1, 'agruparPorCategoria: hogar tiene 1 producto');

$frec = contarFrecuencias('hola mundo hola');
check($frec['hola'] === 2, 'contarFrecuencias: "hola" debe aparecer 2 veces');
check($frec['mundo'] === 1, 'contarFrecuencias: "mundo" debe aparecer 1 vez');
check(contarFrecuencias('Hola HOLA hola')['hola'] === 3, 'contarFrecuencias no debe distinguir mayúsculas');

if ($errores !== []) {
    fwrite(STDERR, implode(PHP_EOL, $errores) . PHP_EOL);
    exit(1);
}

echo "OK: todas las aserciones pasaron." . PHP_EOL;
exit(0);