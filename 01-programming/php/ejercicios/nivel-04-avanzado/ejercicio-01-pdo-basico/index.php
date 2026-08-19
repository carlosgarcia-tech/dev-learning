<?php

declare(strict_types=1);

function crearConexion(string $dsn): PDO
{
    // TODO: crea el PDO y activa ERRMODE_EXCEPTION y FETCH_ASSOC.
    throw new Exception("TODO: implementar crearConexion()");
}

function crearTablaUsuarios(PDO $pdo): void
{
    // TODO: CREATE TABLE IF NOT EXISTS usuarios.
    throw new Exception("TODO: implementar crearTablaUsuarios()");
}

function insertarUsuario(PDO $pdo, string $nombre, string $email): int
{
    // TODO: INSERT con placeholders nombrados; devuelve lastInsertId.
    throw new Exception("TODO: implementar insertarUsuario()");
}

function listarUsuarios(PDO $pdo): array
{
    // TODO: SELECT * FROM usuarios ORDER BY id.
    throw new Exception("TODO: implementar listarUsuarios()");
}

function contarUsuarios(PDO $pdo): int
{
    // TODO: COUNT(*) de usuarios.
    throw new Exception("TODO: implementar contarUsuarios()");
}