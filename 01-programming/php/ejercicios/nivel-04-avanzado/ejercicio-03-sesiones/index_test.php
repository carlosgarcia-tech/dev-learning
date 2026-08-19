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

$sesion = [];
escribirEnSesion($sesion, 'nombre', 'Ana');
check($sesion['nombre'] === 'Ana', 'escribirEnSesion debe guardar el valor');
check(leerDeSesion($sesion, 'nombre') === 'Ana', 'leerDeSesion debe recuperar el valor');
check(leerDeSesion($sesion, 'no_existe') === null, 'leerDeSesion debe devolver null si no existe');

check(estaAutenticado($sesion) === false, 'no debe estar autenticado al inicio');
iniciarSesionUsuario($sesion, 7);
check($sesion['usuario_id'] === 7, 'iniciarSesionUsuario debe guardar el usuario');
check(estaAutenticado($sesion) === true, 'debe estar autenticado tras el login');
check(estaAutenticado(['autenticado' => true]) === false, 'sin usuario_id no puede estar autenticado');

marcarFlash($sesion, 'exito', 'Guardado correctamente');
check(consumirFlash($sesion, 'exito') === 'Guardado correctamente', 'el flash debe leerse la primera vez');
check(consumirFlash($sesion, 'exito') === null, 'el flash debe ser null la segunda vez');

cerrarSesion($sesion);
check(estaAutenticado($sesion) === false, 'cerrarSesion debe desautenticar');
check(isset($sesion['usuario_id']) === false, 'cerrarSesion debe eliminar usuario_id');
check(isset($sesion['autenticado']) === false, 'cerrarSesion debe eliminar autenticado');

if ($errores !== []) {
    fwrite(STDERR, implode(PHP_EOL, $errores) . PHP_EOL);
    exit(1);
}

echo "OK: todas las aserciones pasaron." . PHP_EOL;
exit(0);