<?php

declare(strict_types=1);

require __DIR__ . '/ejercicio-02-interfaces.php';

$errores = [];

function check(bool $condicion, string $mensaje): void
{
    global $errores;
    if (!$condicion) {
        $errores[] = $mensaje;
    }
}

$factura = new Factura([
    ['concepto' => 'Mouse', 'precio' => 25],
    ['concepto' => 'Teclado', 'precio' => 40],
]);
check($factura instanceof Pagable, 'Factura debe implementar Pagable');
check($factura->calcularTotal() === 65.0, 'Factura::calcularTotal debe sumar las líneas');
check($factura->descripcion() === 'Factura', 'Factura::descripcion debe ser "Factura"');

$suscripcion = new Suscripcion(10.0, 12);
check($suscripcion instanceof Pagable, 'Suscripcion debe implementar Pagable');
check($suscripcion->calcularTotal() === 120.0, 'Suscripcion::calcularTotal debe ser precio x meses');
check($suscripcion->descripcion() === 'Suscripción', 'Suscripcion::descripcion debe ser "Suscripción"');

check(procesarPago($factura) === 65.0, 'procesarPago debe devolver el total de la factura');
check(procesarPago($suscripcion) === 120.0, 'procesarPago debe devolver el total de la suscripción');

$mezcla = [$factura, $suscripcion, 'no pagable', 42, new Suscripcion(5.0, 2)];
check(sumarTotales($mezcla) === 195.0, 'sumarTotales debe sumar solo los Pagable');

if ($errores !== []) {
    fwrite(STDERR, implode(PHP_EOL, $errores) . PHP_EOL);
    exit(1);
}

echo "OK: todas las aserciones pasaron." . PHP_EOL;
exit(0);