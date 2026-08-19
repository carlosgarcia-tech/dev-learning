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

$dir = sys_get_temp_dir() . '/php-ejercicio-archivos-' . bin2hex(random_bytes(4));
mkdir($dir);

$archivo = $dir . '/notas.txt';
file_put_contents($archivo, "hola mundo\nsegunda línea");

check(leerArchivo($archivo) === "hola mundo\nsegunda línea", 'leerArchivo debe devolver el contenido completo');
check(escribirArchivo($archivo, 'nuevo') === 5, 'escribirArchivo debe devolver los bytes escritos');
check(leerArchivo($archivo) === 'nuevo', 'leerArchivo debe reflejar el nuevo contenido');

file_put_contents($archivo, "línea1\nlínea2\n");
$lineas = leerLineas($archivo);
check($lineas === ['línea1', 'línea2'], 'leerLineas debe devolver las líneas sin saltos');

mkdir($dir . '/subcarpeta');
file_put_contents($dir . '/a.txt', 'a');
file_put_contents($dir . '/b.log', 'b');
file_put_contents($dir . '/subcarpeta/c.txt', 'c');
$archivos = listarArchivos($dir);
sort($archivos);
check($archivos === ['a.txt', 'b.log', 'notas.txt'], 'listarArchivos debe ignorar subcarpetas');

$nuevo = $dir . '/creado.txt';
check(crearSiNoExiste($nuevo) === true, 'crearSiNoExiste debe crear el archivo la primera vez');
check(file_exists($nuevo), 'crearSiNoExiste debe crear el archivo en disco');
check(crearSiNoExiste($nuevo) === false, 'crearSiNoExiste debe devolver false si ya existe');

try {
    leerArchivo($dir . '/no-existe.txt');
    check(false, 'leerArchivo debe lanzar una excepción para rutas inexistentes');
} catch (RuntimeException $e) {
    check(true, 'leerArchivo lanza RuntimeException');
}

array_map('unlink', glob($dir . '/*'));
array_map('unlink', glob($dir . '/subcarpeta/*'));
rmdir($dir . '/subcarpeta');
rmdir($dir);

if ($errores !== []) {
    fwrite(STDERR, implode(PHP_EOL, $errores) . PHP_EOL);
    exit(1);
}

echo "OK: todas las aserciones pasaron." . PHP_EOL;
exit(0);