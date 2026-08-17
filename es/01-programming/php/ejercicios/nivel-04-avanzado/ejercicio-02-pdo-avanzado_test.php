<?php

declare(strict_types=1);

require __DIR__ . '/ejercicio-02-pdo-avanzado.php';

$errores = [];

function check(bool $condicion, string $mensaje): void
{
    global $errores;
    if (!$condicion) {
        $errores[] = $mensaje;
    }
}

$pdo = new PDO('sqlite::memory:');
$pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
$pdo->setAttribute(PDO::ATTR_DEFAULT_FETCH_MODE, PDO::FETCH_ASSOC);

crearEsquema($pdo);
$pdo->exec("INSERT INTO cuentas (titular, saldo) VALUES ('Ana', 1000), ('Pablo', 500)");

transferirSaldo($pdo, 1, 2, 300.0);
$saldos = $pdo->query("SELECT saldo FROM cuentas ORDER BY id")->fetchAll();
check((float) $saldos[0]['saldo'] === 700.0, 'el saldo de origen debe quedar en 700');
check((float) $saldos[1]['saldo'] === 800.0, 'el saldo de destino debe quedar en 800');
check((int) $pdo->query("SELECT COUNT(*) AS n FROM movimientos")->fetch()['n'] === 2, 'debe haber 2 movimientos');

$antes = $pdo->query("SELECT saldo FROM cuentas WHERE id = 1")->fetch()['saldo'];
try {
    transferirSaldo($pdo, 1, 2, 99999.0);
    check(false, 'una transferencia sin saldo debe lanzar RuntimeException');
} catch (RuntimeException $e) {
    check(true, 'transferirSaldo lanza RuntimeException sin saldo');
}
$despues = $pdo->query("SELECT saldo FROM cuentas WHERE id = 1")->fetch()['saldo'];
check((float) $antes === (float) $despues, 'un fallo debe hacer rollBack y conservar los saldos');

check(count(buscarConFiltros($pdo, ['titular' => 'Ana'])) === 1, 'buscar por titular debe devolver 1 cuenta');
check(count(buscarConFiltros($pdo, ['saldo_min' => 800])) === 1, 'buscar por saldo_min debe devolver 1 cuenta');
check(count(buscarConFiltros($pdo, [])) === 2, 'sin filtros debe devolver todas');

$cuenta = obtenerCuentaConMovimientos($pdo, 1);
check($cuenta !== null, 'obtenerCuentaConMovimientos debe encontrar la cuenta 1');
check($cuenta['titular'] === 'Ana', 'la cuenta debe ser la de Ana');
check(count($cuenta['movimientos']) === 1, 'la cuenta debe tener 1 movimiento');
check($cuenta['movimientos'][0]['tipo'] === 'debito', 'el movimiento debe ser de tipo debito');
check(obtenerCuentaConMovimientos($pdo, 999) === null, 'una cuenta inexistente debe devolver null');

if ($errores !== []) {
    fwrite(STDERR, implode(PHP_EOL, $errores) . PHP_EOL);
    exit(1);
}

echo "OK: todas las aserciones pasaron." . PHP_EOL;
exit(0);