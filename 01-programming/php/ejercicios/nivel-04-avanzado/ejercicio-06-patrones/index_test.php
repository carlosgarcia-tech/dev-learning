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

$a = Configuracion::instancia(['db' => 'sqlite', 'debug' => false]);
$b = Configuracion::instancia(['db' => 'mysql']);
check($a === $b, 'Configuracion::instancia debe devolver siempre la misma instancia');
check($a->obtener('db') === 'sqlite', 'el valor debe ser el de la primera llamada');
check($a->obtener('no_existe') === null, 'obtener debe devolver null para claves ausentes');

check(FabricaPagos::crear('tarjeta') instanceof PagoTarjeta, 'crear("tarjeta") debe devolver PagoTarjeta');
check(FabricaPagos::crear('transferencia') instanceof PagoTransferencia, 'crear("transferencia") debe devolver PagoTransferencia');
check(FabricaPagos::crear('tarjeta') instanceof MetodoPago, 'los pagos deben implementar MetodoPago');
try {
    FabricaPagos::crear('cripto');
    check(false, 'crear("cripto") debe lanzar InvalidArgumentException');
} catch (InvalidArgumentException $e) {
    check(true, 'FabricaPagos lanza InvalidArgumentException para tipos desconocidos');
}
check(FabricaPagos::crear('tarjeta')->procesar(100.0) === 'Pagado 100 con tarjeta', 'procesar debe describir el pago');

$cotizador = new CotizadorEnvio(new CorreoEnvio());
check($cotizador->cotizar(10) === 20.0, 'con CorreoEnvio el costo de 10 kg es 20');
$cotizador->cambiarEstrategia(new MensajeroEnvio());
check($cotizador->cotizar(10) === 60.0, 'tras cambiar, el costo de 10 kg es 60');

if ($errores !== []) {
    fwrite(STDERR, implode(PHP_EOL, $errores) . PHP_EOL);
    exit(1);
}

echo "OK: todas las aserciones pasaron." . PHP_EOL;
exit(0);