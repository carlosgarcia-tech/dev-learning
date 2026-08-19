<?php

declare(strict_types=1);

namespace App\Pruebas;

require __DIR__ . '/index.php';

class Usuario
{
    public string $rol = 'lector';
}

class Nodo
{
    public int $valor = 7;
}

$errores = [];

function check(bool $condicion, string $mensaje): void
{
    global $errores;
    if (!$condicion) {
        $errores[] = $mensaje;
    }
}

check(\App\Ejercicios\rutaCompleta('Usuario') === 'App\\Ejercicios\\Usuario', 'rutaCompleta debe anteponer el namespace');

check(\App\Ejercicios\importarComo('App\\Pruebas\\Usuario') === 'Usuario', 'importarComo debe devolver la última parte');
check(\App\Ejercicios\importarComo('Usuario') === 'Usuario', 'importarComo sin barra devuelve el mismo nombre');

$usuario = \App\Ejercicios\instanciar('App\\Pruebas\\Usuario');
check($usuario instanceof Usuario, 'instanciar debe crear la clase indicada');
check($usuario->rol === 'lector', 'la instancia debe ser funcional');

$nodo = \App\Ejercicios\instanciar('App\\Pruebas\\Nodo');
check($nodo instanceof Nodo, 'instanciar debe crear Nodo');
check($nodo->valor === 7, 'la segunda clase debe instanciarse correctamente');

if ($errores !== []) {
    fwrite(STDERR, implode(PHP_EOL, $errores) . PHP_EOL);
    exit(1);
}

echo "OK: todas las aserciones pasaron." . PHP_EOL;
exit(0);