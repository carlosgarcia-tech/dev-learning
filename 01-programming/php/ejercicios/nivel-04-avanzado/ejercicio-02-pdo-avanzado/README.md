# Ejercicio 02 — PDO avanzado

- **Nivel:** 4/5
- **Tema:** transacciones, `commit`, `rollBack`, filtros dinámicos y `JOIN`
- **Tiempo estimado:** 40 min

## Enunciado

Completa las funciones en `index.php`:

1. `crearEsquema(PDO $pdo)`: crea las tablas `cuentas (id, titular, saldo)` y `movimientos (id, cuenta_id, tipo, monto, fecha)`.
2. `transferirSaldo(PDO $pdo, int $origen, int $destino, float $monto)`: dentro de una **transacción** comprueba que el saldo de origen alcance (si no, `RuntimeException` y `rollBack`), descuenta, suma en destino e inserta un movimiento en ambas cuentas. Después hace `commit`.
3. `buscarConFiltros(PDO $pdo, array $filtros)`: construye un `WHERE` dinámico con placeholders nombrados a partir de `titular` y/o `saldo_min` y devuelve las filas.
4. `obtenerCuentaConMovimientos(PDO $pdo, int $cuentaId)`: devuelve la cuenta con sus movimientos (`LEFT JOIN`), o `null` si no existe.

## Requisitos

- [ ] `transferirSaldo` mueve el saldo y registra movimientos.
- [ ] Una transferencia con saldo insuficiente lanza `RuntimeException` y **no modifica** los saldos.
- [ ] `buscarConFiltros` filtra por titular y por saldo mínimo.
- [ ] `obtenerCuentaConMovimientos` incluye la lista de movimientos.
- [ ] Los tests pasan: `php index_test.php`.

> **Nota:** PHP no está instalado en este entorno de aprendizaje. Ejecuta el comando localmente con PHP 8 y `pdo_sqlite`.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `beginTransaction()`, `commit()`, `rollBack()`.
- Antes de descontar, `SELECT saldo` con placeholder y compara.
- Filtros dinámicos: `WHERE 1=1` y concatenar `AND titular = :titular`.
- `LEFT JOIN movimientos m ON m.cuenta_id = c.id` y agrupar manualmente.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````php
function crearEsquema(PDO $pdo): void
{
    $pdo->exec("CREATE TABLE IF NOT EXISTS cuentas (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        titular TEXT NOT NULL,
        saldo REAL NOT NULL DEFAULT 0
    )");
    $pdo->exec("CREATE TABLE IF NOT EXISTS movimientos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        cuenta_id INTEGER NOT NULL,
        tipo TEXT NOT NULL,
        monto REAL NOT NULL,
        fecha TEXT NOT NULL
    )");
}

function transferirSaldo(PDO $pdo, int $origen, int $destino, float $monto): void
{
    $pdo->beginTransaction();
    try {
        $stmt = $pdo->prepare("SELECT saldo FROM cuentas WHERE id = ?");
        $stmt->execute([$origen]);
        $fila = $stmt->fetch();
        if ($fila === false || (float) $fila['saldo'] < $monto) {
            throw new RuntimeException('Saldo insuficiente en la cuenta de origen');
        }

        $pdo->prepare("UPDATE cuentas SET saldo = saldo - ? WHERE id = ?")->execute([$monto, $origen]);
        $pdo->prepare("UPDATE cuentas SET saldo = saldo + ? WHERE id = ?")->execute([$monto, $destino]);

        $fecha = date('Y-m-d H:i:s');
        $pdo->prepare("INSERT INTO movimientos (cuenta_id, tipo, monto, fecha) VALUES (?, ?, ?, ?)")
            ->execute([$origen, 'debito', $monto, $fecha]);
        $pdo->prepare("INSERT INTO movimientos (cuenta_id, tipo, monto, fecha) VALUES (?, ?, ?, ?)")
            ->execute([$destino, 'credito', $monto, $fecha]);

        $pdo->commit();
    } catch (Throwable $e) {
        $pdo->rollBack();
        throw $e;
    }
}

function buscarConFiltros(PDO $pdo, array $filtros): array
{
    $sql = "SELECT * FROM cuentas WHERE 1=1";
    $params = [];
    if (isset($filtros['titular'])) {
        $sql .= " AND titular = :titular";
        $params['titular'] = $filtros['titular'];
    }
    if (isset($filtros['saldo_min'])) {
        $sql .= " AND saldo >= :saldo_min";
        $params['saldo_min'] = $filtros['saldo_min'];
    }
    $stmt = $pdo->prepare($sql);
    $stmt->execute($params);
    return $stmt->fetchAll();
}

function obtenerCuentaConMovimientos(PDO $pdo, int $cuentaId): ?array
{
    $stmt = $pdo->prepare("SELECT c.* FROM cuentas c WHERE c.id = ?");
    $stmt->execute([$cuentaId]);
    $cuenta = $stmt->fetch();
    if ($cuenta === false) {
        return null;
    }

    $stmt = $pdo->prepare("SELECT tipo, monto, fecha FROM movimientos WHERE cuenta_id = ? ORDER BY id");
    $stmt->execute([$cuentaId]);
    $cuenta['movimientos'] = $stmt->fetchAll();
    return $cuenta;
}
````

</details>