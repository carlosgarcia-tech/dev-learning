<?php

declare(strict_types=1);

require __DIR__ . '/ejercicio-05-clases-basicas.php';

$errores = [];

function check(bool $condicion, string $mensaje): void
{
    global $errores;
    if (!$condicion) {
        $errores[] = $mensaje;
    }
}

$laptop = new Producto('Laptop', 1200.0, 5);
check($laptop->nombre() === 'Laptop', 'Producto::nombre() debe devolver el nombre');
check($laptop->precio() === 1200.0, 'Producto::precio() debe devolver el precio');
check($laptop->hayStock() === true, 'Producto::hayStock() debe ser true con stock 5');
check(new Producto('X', 1.0)->hayStock() === false, 'Producto sin stock debe tener hayStock() false');

check($laptop->descontar(2) === true, 'descontar(2) debe ser true con stock 5');
check($laptop->hayStock() === true, 'después de descontar 2 debe quedar stock');
check($laptop->descontar(99) === false, 'descontar más que el stock debe ser false');
check((string) new Producto('Laptop', 1200.0) === 'Laptop (1200)', '__toString debe ser "Laptop (1200)"');

$cuenta = new CuentaBancaria();
check($cuenta->saldo() === 0.0, 'saldo inicial debe ser 0');
$cuenta->depositar(500.0);
check($cuenta->saldo() === 500.0, 'depositar debe sumar al saldo');
check($cuenta->retirar(200.0) === true, 'retirar(200) debe ser true con saldo 500');
check($cuenta->saldo() === 300.0, 'el saldo debe quedar en 300');
check($cuenta->retirar(1000.0) === false, 'retirar más del saldo debe ser false');
check($cuenta->saldo() === 300.0, 'un retiro fallido no debe cambiar el saldo');

if ($errores !== []) {
    fwrite(STDERR, implode(PHP_EOL, $errores) . PHP_EOL);
    exit(1);
}

echo "OK: todas las aserciones pasaron." . PHP_EOL;
exit(0);