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

$cache = new CacheLru(2);
check($cache->capacidad() === 2, 'la capacidad debe ser 2');
check($cache->tamano() === 0, 'el caché debe empezar vacío');

$cache->poner('a', 1);
$cache->poner('b', 2);
$cache->poner('c', 3);
check($cache->tiene('a') === false, 'con capacidad 2, "a" debe ser expulsada');
check($cache->tiene('b') === true, '"b" debe seguir en el caché');
check($cache->tiene('c') === true, '"c" debe estar en el caché');
check($cache->tamano() === 2, 'el tamaño no debe superar la capacidad');
check($cache->obtener('a') === null, 'obtener de una clave expulsada debe ser null');

$cache2 = new CacheLru(2);
$cache2->poner('a', 1);
$cache2->poner('b', 2);
check($cache2->obtener('a') === 1, 'obtener("a") debe devolver el valor');
$cache2->poner('c', 3);
check($cache2->tiene('b') === false, 'al usar "a", "b" pasa a ser la LRU y se expulsa');
check($cache2->tiene('a') === true, '"a" (la más reciente) debe sobrevivir');
check($cache2->tiene('c') === true, '"c" debe estar presente');

$cache3 = new CacheLru(3);
$cache3->poner('x', 10);
$cache3->poner('x', 99);
check($cache3->obtener('x') === 99, 'poner sobre una clave existente debe actualizarla');
check($cache3->tamano() === 1, 'actualizar no debe duplicar la clave');

try {
    new CacheLru(0);
    check(false, 'una capacidad de 0 debe lanzar InvalidArgumentException');
} catch (InvalidArgumentException $e) {
    check(true, 'la capacidad mínima es 1');
}

if ($errores !== []) {
    fwrite(STDERR, implode(PHP_EOL, $errores) . PHP_EOL);
    exit(1);
}

echo "OK: todas las aserciones pasaron." . PHP_EOL;
exit(0);