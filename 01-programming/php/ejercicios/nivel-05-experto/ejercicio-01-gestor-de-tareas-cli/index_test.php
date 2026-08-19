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

$tareas = agregarTarea([], 'Aprender PHP');
$tareas = agregarTarea($tareas, 'Practicar PDO');
check(count($tareas) === 2, 'debe haber 2 tareas');
check($tareas[0]['id'] === 1, 'la primera tarea debe tener id 1');
check($tareas[1]['id'] === 2, 'la segunda tarea debe tener id 2');
check($tareas[1]['descripcion'] === 'Practicar PDO', 'la descripción debe conservarse');
check($tareas[1]['completada'] === false, 'las tareas nuevas no deben estar completadas');

$completadas = completarTarea($tareas, 1);
check($completadas[0]['completada'] === true, 'completarTarea debe marcar la tarea 1');
check($completadas[1]['completada'] === false, 'la tarea 2 no debe cambiar');
check($tareas[0]['completada'] === false, 'completarTarea no debe mutar la original');

$archivo = sys_get_temp_dir() . '/php-tareas-' . bin2hex(random_bytes(4)) . '.json';
persistirTareas($archivo, $tareas);
$recuperadas = cargarTareas($archivo);
check($recuperadas === $tareas, 'persistir + cargar deben conservar las tareas');
check(cargarTareas($archivo . '-no-existe') === [], 'cargar de un archivo inexistente debe devolver []');
unlink($archivo);

if ($errores !== []) {
    fwrite(STDERR, implode(PHP_EOL, $errores) . PHP_EOL);
    exit(1);
}

echo "OK: todas las aserciones pasaron." . PHP_EOL;
exit(0);