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

$coche = new Coche('Toyota');
check($coche instanceof Vehiculo, 'Coche debe ser instancia de Vehiculo');
check($coche instanceof Coche, 'Coche debe ser instancia de Coche');
check($coche->describir() === 'Vehículo de marca Toyota con 4 ruedas', 'Coche::describir debe combinar la base');

$moto = new Moto('Honda');
check($moto->describir() === 'Vehículo de marca Honda con 2 ruedas', 'Moto::describir debe indicar 2 ruedas');

check((new Circulo(1))->area() === 3.14, 'area de círculo de radio 1 debe ser 3.14');
check((new Rectangulo(4, 3))->area() === 12.0, 'area de rectángulo 4x3 debe ser 12');
check((new Circulo(2))->area() === 12.57, 'area de círculo de radio 2 debe ser 12.57');

check((new Rectangulo(4, 3)) instanceof Figura, 'Rectangulo debe ser instancia de Figura');

if ($errores !== []) {
    fwrite(STDERR, implode(PHP_EOL, $errores) . PHP_EOL);
    exit(1);
}

echo "OK: todas las aserciones pasaron." . PHP_EOL;
exit(0);