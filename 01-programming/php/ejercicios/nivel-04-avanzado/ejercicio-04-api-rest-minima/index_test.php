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

check(coincideRuta('/api/usuarios/{id}', '/api/usuarios/5') === ['id' => '5'], 'coincideRuta debe capturar {id}');
check(coincideRuta('/api/usuarios/{id}', '/api/usuarios/abc') === ['id' => 'abc'], 'coincideRuta captura cualquier valor');
check(coincideRuta('/api/usuarios/{id}', '/api/pedidos/5') === null, 'segmentos estáticos distintos no coinciden');
check(coincideRuta('/api/usuarios/{id}', '/api/usuarios/5/extra') === null, 'distinto número de segmentos no coincide');
check(coincideRuta('/api/usuarios', '/api/usuarios') === [], 'sin parámetros devuelve array vacío');

$r = jsonRespuesta(['ok' => true], 200);
check($r['codigo'] === 200 && $r['cuerpo'] === '{"ok":true}', 'jsonRespuesta debe codificar el cuerpo');

$lista = rutear('GET', '/api/usuarios');
check($lista['codigo'] === 200, 'GET /api/usuarios debe ser 200');
check(json_decode($lista['cuerpo'], true)['usuarios'][0]['nombre'] === 'Ana', 'la lista debe incluir a Ana');

$creado = rutear('POST', '/api/usuarios', ['nombre' => 'Luis', 'email' => 'luis@mail.com']);
check($creado['codigo'] === 201, 'POST válido debe ser 201');
check(json_decode($creado['cuerpo'], true)['nombre'] === 'Luis', 'el usuario creado debe aparecer');

$mal = rutear('POST', '/api/usuarios', ['nombre' => '']);
check($mal['codigo'] === 400, 'POST sin nombre debe ser 400');
check(str_contains($mal['cuerpo'], 'obligatorios'), 'el error 400 debe tener mensaje');

$uno = rutear('GET', '/api/usuarios/1');
check($uno['codigo'] === 200 && json_decode($uno['cuerpo'], true)['id'] === 1, 'GET de un usuario existente debe ser 200');

$ninguno = rutear('GET', '/api/usuarios/99');
check($ninguno['codigo'] === 404, 'GET de usuario inexistente debe ser 404');

$borrado = rutear('DELETE', '/api/usuarios/2');
check($borrado['codigo'] === 204 && $borrado['cuerpo'] === '', 'DELETE existente debe ser 204 sin cuerpo');
check(rutear('DELETE', '/api/usuarios/99')['codigo'] === 404, 'DELETE inexistente debe ser 404');

check(rutear('GET', '/otra-cosa')['codigo'] === 404, 'ruta fuera de /api debe ser 404');
check(rutear('PATCH', '/api/usuarios')['codigo'] === 404, 'método no soportado debe ser 404');

if ($errores !== []) {
    fwrite(STDERR, implode(PHP_EOL, $errores) . PHP_EOL);
    exit(1);
}

echo "OK: todas las aserciones pasaron." . PHP_EOL;
exit(0);