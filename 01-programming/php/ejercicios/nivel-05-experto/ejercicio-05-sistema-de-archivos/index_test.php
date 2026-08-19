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

$dir = sys_get_temp_dir() . '/php-sistema-' . bin2hex(random_bytes(4));
mkdir($dir . '/docs/sub', 0777, true);
file_put_contents($dir . '/a.txt', 'abcd');                    // 4 bytes
file_put_contents($dir . '/docs/b.md', 'abcdef');              // 6 bytes
file_put_contents($dir . '/docs/sub/c.txt', 'abcdefgh');       // 8 bytes
file_put_contents($dir . '/docs/d.log', 'x');                  // 1 byte

check(tamanoDirectorio($dir) === 19, 'tamanoDirectorio debe sumar 4+6+8+1 = 19 bytes');

$txt = encontrarPorExtension($dir, 'txt');
check(count($txt) === 2, 'debe encontrar 2 archivos .txt');
check(str_ends_with($txt[0], 'a.txt') || str_ends_with($txt[0], 'c.txt'), 'el resultado debe ser una ruta .txt');
$log = encontrarPorExtension($dir, 'log');
check(count($log) === 1 && str_ends_with($log[0], 'd.log'), 'debe encontrar 1 archivo .log');

$copia = sys_get_temp_dir() . '/php-sistema-copia-' . bin2hex(random_bytes(4));
check(copiarRecursivo($dir, $copia) === true, 'copiarRecursivo debe devolver true');
check(tamanoDirectorio($copia) === 19, 'la copia debe tener el mismo tamaño');
check(is_dir($copia . '/docs/sub'), 'la copia debe replicar las subcarpetas');
check(file_get_contents($copia . '/docs/sub/c.txt') === 'abcdefgh', 'el contenido de los archivos debe copiarse');
check(copiarRecursivo($dir . '/no-existe', $copia . '/x') === false, 'copiar un origen inexistente debe ser false');

$arbol = arbolDeArchivos($dir);
$nombres = array_column($arbol, 'nombre');
check(in_array('a.txt', $nombres, true), 'el árbol debe incluir a.txt');
check(in_array('docs', $nombres, true), 'el árbol debe incluir la carpeta docs');
foreach ($arbol as $entrada) {
    if ($entrada['nombre'] === 'docs') {
        check($entrada['tipo'] === 'dir', 'docs debe ser de tipo dir');
        $hijos = array_column($entrada['hijos'], 'nombre');
        check(in_array('sub', $hijos, true), 'docs debe incluir sub');
        check(in_array('b.md', $hijos, true), 'docs debe incluir b.md');
    }
}

array_map('unlink', glob($dir . '/docs/sub/*'));
array_map('unlink', glob($dir . '/docs/*'));
array_map('unlink', glob($dir . '/*'));
rmdir($dir . '/docs/sub');
rmdir($dir . '/docs');
rmdir($dir);
array_map('unlink', glob($copia . '/docs/sub/*'));
array_map('unlink', glob($copia . '/docs/*'));
array_map('unlink', glob($copia . '/*'));
rmdir($copia . '/docs/sub');
rmdir($copia . '/docs');
rmdir($copia);

if ($errores !== []) {
    fwrite(STDERR, implode(PHP_EOL, $errores) . PHP_EOL);
    exit(1);
}

echo "OK: todas las aserciones pasaron." . PHP_EOL;
exit(0);