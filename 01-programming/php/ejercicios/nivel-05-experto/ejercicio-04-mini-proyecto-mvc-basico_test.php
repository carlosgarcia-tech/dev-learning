<?php

declare(strict_types=1);

require __DIR__ . '/ejercicio-04-mini-proyecto-mvc-basico.php';

$errores = [];

function check(bool $condicion, string $mensaje): void
{
    global $errores;
    if (!$condicion) {
        $errores[] = $mensaje;
    }
}

$enrutador = new Enrutador();
$enrutador->get('/inicio', 'inicio');
$enrutador->get('/articulo/{id}', 'mostrarArticulo');
$enrutador->post('/articulo', 'crearArticulo');

check($enrutador->rutaCoincide('/articulo/{id}', '/articulo/7') === ['id' => '7'], 'rutaCoincide debe capturar {id}');
check($enrutador->rutaCoincide('/articulo/{id}', '/otra') === null, 'rutaCoincide debe rechazar URIs distintas');
check($enrutador->rutaCoincide('/inicio', '/inicio') === [], 'sin parámetros devuelve array vacío');

$inicio = $enrutador->despachar('GET', '/inicio');
check($inicio['status'] === 200 && $inicio['vista'] === 'inicio', 'despachar GET /inicio debe llamar a inicio()');

$articulo = $enrutador->despachar('GET', '/articulo/7');
check($articulo['status'] === 200 && $articulo['vista'] === 'articulo', 'despachar debe resolver la ruta con parámetro');
check($articulo['datos']['id'] === '7', 'el controlador debe recibir el parámetro capturado');

$creado = $enrutador->despachar('POST', '/articulo');
check($creado['status'] === 201, 'POST /articulo debe llamar a crearArticulo()');

check($enrutador->despachar('GET', '/articulo')['status'] === 404, 'GET /articulo (sin POST registrado para GET) debe ser 404');
check($enrutador->despachar('GET', '/no-existe')['status'] === 404, 'una ruta inexistente debe ser 404');
check($enrutador->despachar('PUT', '/inicio')['status'] === 404, 'un método no registrado debe ser 404');

$vista = new Vista();
check($vista->renderizar('Hola {{nombre}}', ['nombre' => 'Ana']) === 'Hola Ana', 'renderizar debe reemplazar {{nombre}}');
check($vista->renderizar('{{a}}-{{b}}', ['a' => 1, 'b' => 2]) === '1-2', 'renderizar debe manejar varios marcadores');
check($vista->renderizar('sin marcadores') === 'sin marcadores', 'sin marcadores no cambia nada');

if ($errores !== []) {
    fwrite(STDERR, implode(PHP_EOL, $errores) . PHP_EOL);
    exit(1);
}

echo "OK: todas las aserciones pasaron." . PHP_EOL;
exit(0);