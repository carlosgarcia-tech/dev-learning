<?php

declare(strict_types=1);

require __DIR__ . '/ejercicio-01-pdo-basico.php';

$errores = [];

function check(bool $condicion, string $mensaje): void
{
    global $errores;
    if (!$condicion) {
        $errores[] = $mensaje;
    }
}

$pdo = crearConexion('sqlite::memory:');
check($pdo instanceof PDO, 'crearConexion debe devolver un PDO');

crearTablaUsuarios($pdo);
check(contarUsuarios($pdo) === 0, 'la tabla nueva debe estar vacía');

$idAna = insertarUsuario($pdo, 'Ana', 'ana@mail.com');
$idPablo = insertarUsuario($pdo, 'Pablo', 'pablo@mail.com');
check($idAna === 1, 'el primer id debe ser 1');
check($idPablo === 2, 'el segundo id debe ser 2');

check(contarUsuarios($pdo) === 2, 'contarUsuarios debe devolver 2');

$usuarios = listarUsuarios($pdo);
check(count($usuarios) === 2, 'listarUsuarios debe devolver 2 filas');
check($usuarios[0]['nombre'] === 'Ana', 'el primer usuario debe ser Ana');
check($usuarios[1]['email'] === 'pablo@mail.com', 'el segundo email debe ser pablo@mail.com');

try {
    insertarUsuario($pdo, 'Clon', 'ana@mail.com');
    check(false, 'insertar un email duplicado debe lanzar PDOException');
} catch (PDOException $e) {
    check(true, 'el email único se respeta');
}

if ($errores !== []) {
    fwrite(STDERR, implode(PHP_EOL, $errores) . PHP_EOL);
    exit(1);
}

echo "OK: todas las aserciones pasaron." . PHP_EOL;
exit(0);