<?php

declare(strict_types=1);

require __DIR__ . '/ejercicio-06-include-require.php';

$errores = [];

function check(bool $condicion, string $mensaje): void
{
    global $errores;
    if (!$condicion) {
        $errores[] = $mensaje;
    }
}

$dir = sys_get_temp_dir() . '/php-ejercicio-include-' . bin2hex(random_bytes(4));
mkdir($dir);

$archivoValores = $dir . '/valores.php';
file_put_contents($archivoValores, "<?php return ['clave' => 'valor', 'n' => 42];");

$archivoFunciones = $dir . '/funciones.php';
file_put_contents(
    $archivoFunciones,
    "<?php\nfunction saludar_temp(string \$nombre): string { return 'Hola ' . \$nombre; }"
);

$archivoMarca = $dir . '/marca.php';
file_put_contents($archivoMarca, "<?php const MARCA_INCLUIDA = 'incluido';");

check(cargarValores($archivoValores) === ['clave' => 'valor', 'n' => 42], 'cargarValores debe devolver los valores retornados');
check(cargarValores($dir . '/sin-array.php') === [], 'cargarValores debe devolver [] si el archivo no retorna un array');

check(invocarIncluido($archivoFunciones, 'saludar_temp', 'Ana') === 'Hola Ana', 'invocarIncluido debe llamar a la función incluida');

try {
    invocarIncluido($archivoValores, 'no_existe_funcion');
    check(false, 'invocarIncluido debe lanzar RuntimeException si la función no existe');
} catch (RuntimeException $e) {
    check(true, 'invocarIncluido lanza RuntimeException');
}

check(incluirMarcador($archivoMarca) === 'incluido', 'incluirMarcador debe devolver la constante');

array_map('unlink', glob($dir . '/*'));
rmdir($dir);

if ($errores !== []) {
    fwrite(STDERR, implode(PHP_EOL, $errores) . PHP_EOL);
    exit(1);
}

echo "OK: todas las aserciones pasaron." . PHP_EOL;
exit(0);