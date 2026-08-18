<?php

declare(strict_types=1);

require __DIR__ . '/ejercicio-03-traits.php';

$errores = [];

function check(bool $condicion, string $mensaje): void
{
    global $errores;
    if (!$condicion) {
        $errores[] = $mensaje;
    }
}

$articulo = new Articulo('Mi primer post');
check($articulo->titulo() === 'Mi primer post', 'Articulo::titulo debe devolver el título');
check($articulo->creadoEn() === '', 'creadoEn() debe ser "" antes de marcarCreado');
$articulo->marcarCreado();
check($articulo->creadoEn() !== '', 'creadoEn() no debe ser "" después de marcarCreado');
check(preg_match('/^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}$/', $articulo->creadoEn()) === 1, 'creadoEn() debe tener formato fecha-hora');

$comentario = new Comentario('Gran artículo');
check($comentario->contenido() === 'Gran artículo', 'Comentario::contenido debe devolver el contenido');
$comentario->marcarCreado();
check($comentario->creadoEn() !== '', 'Comentario debe usar Timestampable');
$comentario->registrar('publicado');
$comentario->registrar('editado');
check(count($comentario->log()) === 2, 'Comentario::log debe registrar 2 entradas');
check(str_contains($comentario->log()[0], 'publicado'), 'la primera entrada debe contener "publicado"');
check(str_starts_with($comentario->log()[0], '['), 'cada entrada debe empezar con la fecha entre corchetes');

$metodos = get_class_methods(Articulo::class);
check(in_array('marcarCreado', $metodos, true), 'Articulo debe heredar los métodos del trait');

if ($errores !== []) {
    fwrite(STDERR, implode(PHP_EOL, $errores) . PHP_EOL);
    exit(1);
}

echo "OK: todas las aserciones pasaron." . PHP_EOL;
exit(0);