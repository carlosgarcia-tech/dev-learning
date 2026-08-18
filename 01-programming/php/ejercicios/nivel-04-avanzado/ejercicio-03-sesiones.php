<?php

declare(strict_types=1);

function escribirEnSesion(array &$sesion, string $clave, mixed $valor): void
{
    // TODO: guarda el valor en la sesión.
    throw new Exception("TODO: implementar escribirEnSesion()");
}

function leerDeSesion(array $sesion, string $clave): mixed
{
    // TODO: devuelve el valor o null.
    throw new Exception("TODO: implementar leerDeSesion()");
}

function iniciarSesionUsuario(array &$sesion, int $usuarioId): void
{
    // TODO: marca usuario_id y autenticado => true.
    throw new Exception("TODO: implementar iniciarSesionUsuario()");
}

function estaAutenticado(array $sesion): bool
{
    // TODO: true solo si autenticado es true y existe usuario_id.
    throw new Exception("TODO: implementar estaAutenticado()");
}

function cerrarSesion(array &$sesion): void
{
    // TODO: elimina los datos de usuario y los mensajes flash.
    throw new Exception("TODO: implementar cerrarSesion()");
}

function marcarFlash(array &$sesion, string $clave, mixed $valor): void
{
    // TODO: guarda un mensaje flash bajo "flash_<clave>".
    throw new Exception("TODO: implementar marcarFlash()");
}

function consumirFlash(array &$sesion, string $clave): mixed
{
    // TODO: devuelve el valor una sola vez y lo elimina.
    throw new Exception("TODO: implementar consumirFlash()");
}