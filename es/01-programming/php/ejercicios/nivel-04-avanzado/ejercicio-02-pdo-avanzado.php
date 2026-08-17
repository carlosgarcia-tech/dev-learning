<?php

declare(strict_types=1);

function crearEsquema(PDO $pdo): void
{
    // TODO: crea las tablas cuentas y movimientos.
    throw new Exception("TODO: implementar crearEsquema()");
}

function transferirSaldo(PDO $pdo, int $origen, int $destino, float $monto): void
{
    // TODO: transacción con comprobación de saldo, update doble y movimientos.
    throw new Exception("TODO: implementar transferirSaldo()");
}

function buscarConFiltros(PDO $pdo, array $filtros): array
{
    // TODO: WHERE dinámico con :titular y/o :saldo_min.
    throw new Exception("TODO: implementar buscarConFiltros()");
}

function obtenerCuentaConMovimientos(PDO $pdo, int $cuentaId): ?array
{
    // TODO: devuelve la cuenta con 'movimientos' o null si no existe.
    throw new Exception("TODO: implementar obtenerCuentaConMovimientos()");
}