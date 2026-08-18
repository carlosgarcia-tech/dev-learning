<?php

declare(strict_types=1);

require __DIR__ . '/ejercicio-02-blog-con-pdo.php';

$errores = [];

function check(bool $condicion, string $mensaje): void
{
    global $errores;
    if (!$condicion) {
        $errores[] = $mensaje;
    }
}

$pdo = new PDO('sqlite::memory:');
$pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
$pdo->setAttribute(PDO::ATTR_DEFAULT_FETCH_MODE, PDO::FETCH_ASSOC);

crearEsquemaBlog($pdo);
$id1 = crearArticulo($pdo, 'Hola PHP', 'Primer post sobre PHP', true);
$id2 = crearArticulo($pdo, 'Borrador', 'Contenido pendiente', false);

check($id1 === 1, 'el primer artículo debe tener id 1');
check($id2 === 2, 'el segundo artículo debe tener id 2');
check(count(listarArticulos($pdo)) === 2, 'debe haber 2 artículos');
check(count(listarPublicados($pdo)) === 1, 'solo 1 artículo publicado');
check(listarPublicados($pdo)[0]['titulo'] === 'Hola PHP', 'el publicado debe ser el primero');

check(obtenerArticulo($pdo, $id1)['titulo'] === 'Hola PHP', 'obtenerArticulo debe encontrar el artículo');
check(obtenerArticulo($pdo, 999) === null, 'obtenerArticulo de id inexistente debe ser null');

check(actualizarArticulo($pdo, $id1, 'Hola PHP 8', 'Contenido actualizado') === true, 'actualizar debe devolver true');
check(obtenerArticulo($pdo, $id1)['titulo'] === 'Hola PHP 8', 'el título debe haberse actualizado');
check(actualizarArticulo($pdo, 999, 'X', 'Y') === false, 'actualizar un id inexistente debe ser false');

check(eliminarArticulo($pdo, $id2) === true, 'eliminar debe devolver true');
check(count(listarArticulos($pdo)) === 1, 'debe quedar 1 artículo');
check(eliminarArticulo($pdo, $id2) === false, 'eliminar un id ya borrado debe ser false');

$c1 = agregarComentario($pdo, $id1, 'Ana', 'Gran artículo');
$c2 = agregarComentario($pdo, $id1, 'Pablo', 'Muy útil');
check($c1 === 1, 'el primer comentario debe tener id 1');
check($c2 === 2, 'el segundo comentario debe tener id 2');
check(contarComentarios($pdo, $id1) === 2, 'debe haber 2 comentarios');
check(contarComentarios($pdo, 999) === 0, 'un artículo inexistente tiene 0 comentarios');

check(count(buscarArticulos($pdo, 'PHP')) === 1, 'buscar por "PHP" debe encontrar 1 artículo');
check(count(buscarArticulos($pdo, 'no existe')) === 0, 'buscar sin resultados debe ser 0');

if ($errores !== []) {
    fwrite(STDERR, implode(PHP_EOL, $errores) . PHP_EOL);
    exit(1);
}

echo "OK: todas las aserciones pasaron." . PHP_EOL;
exit(0);