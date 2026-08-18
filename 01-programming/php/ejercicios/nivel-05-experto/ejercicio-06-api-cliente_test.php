<?php

declare(strict_types=1);

require __DIR__ . '/ejercicio-06-api-cliente.php';

$errores = [];

function check(bool $condicion, string $mensaje): void
{
    global $errores;
    if (!$condicion) {
        $errores[] = $mensaje;
    }
}

check(parsearJson('{"a":1}') === ['a' => 1], 'parsearJson debe decodificar un objeto');
check(parsearJson('[1,2,3]') === [1, 2, 3], 'parsearJson debe decodificar un array');
check(parsearJson('{"nombre":"Ana","edad":30}')['nombre'] === 'Ana', 'parsearJson debe permitir acceder a las claves');

try {
    parsearJson('{invalido');
    check(false, 'parsearJson debe lanzar JsonException con JSON inválido');
} catch (JsonException $e) {
    check(true, 'JSON inválido lanza JsonException');
}

check(str_contains(mensajeErrorHTTP(401), 'No autorizado'), '401 debe mencionar no autorizado');
check(str_contains(mensajeErrorHTTP(404), '404'), '404 debe incluir el código');
check(str_contains(mensajeErrorHTTP(500), 'Error interno'), '500 debe mencionar error interno');
check(str_contains(mensajeErrorHTTP(418), '418'), 'códigos no mapeados deben incluir el código');

check(manejarEstadoHTTP(['codigo' => 200, 'cuerpo' => 'ok']) === ['codigo' => 200, 'cuerpo' => 'ok'], '200 no lanza y devuelve la respuesta');
try {
    manejarEstadoHTTP(['codigo' => 404, 'cuerpo' => '{}']);
    check(false, '404 debe lanzar RuntimeException');
} catch (RuntimeException $e) {
    check(str_contains($e->getMessage(), '404'), 'el error 404 debe incluir el código');
}

$fake = function (string $url, array $opciones = []) {
    return ['codigo' => 200, 'cuerpo' => '{"usuarios":[{"id":1,"nombre":"Ana"}]}'];
};
$datos = consumirAPI('https://api.ejemplo.test/usuarios', [], $fake);
check($datos['usuarios'][0]['nombre'] === 'Ana', 'consumirAPI debe devolver el JSON parseado');

$fake404 = fn () => ['codigo' => 404, 'cuerpo' => '{"error":"No encontrado"}'];
try {
    consumirAPI('https://api.ejemplo.test/usuarios/99', [], $fake404);
    check(false, 'consumirAPI debe lanzar con HTTP 404');
} catch (RuntimeException $e) {
    check(str_contains($e->getMessage(), '404'), 'consumirAPI debe propagar el código 404');
}

$fakeInvalido = fn () => ['codigo' => 200, 'cuerpo' => 'no-json'];
try {
    consumirAPI('https://api.ejemplo.test/x', [], $fakeInvalido);
    check(false, 'consumirAPI debe lanzar con JSON inválido');
} catch (JsonException $e) {
    check(true, 'consumirAPI propaga el error de JSON');
}

$vistas = [];
$capturar = function (string $url, array $opciones = []) use (&$vistas) {
    $vistas[] = $url;
    $vistas[] = $opciones;
    return ['codigo' => 200, 'cuerpo' => '{"ok":true}'];
};
consumirAPI('https://api.ejemplo.test/login', ['metodo' => 'POST', 'cuerpo' => '{"usuario":"ana"}'], $capturar);
check($vistas[0] === 'https://api.ejemplo.test/login', 'consumirAPI debe pasar la URL al transporte');
check(($vistas[1]['metodo'] ?? '') === 'POST', 'consumirAPI debe pasar las opciones al transporte');
check(($vistas[1]['cuerpo'] ?? '') === '{"usuario":"ana"}', 'el cuerpo debe viajar en las opciones');

if ($errores !== []) {
    fwrite(STDERR, implode(PHP_EOL, $errores) . PHP_EOL);
    exit(1);
}

echo "OK: todas las aserciones pasaron." . PHP_EOL;
exit(0);