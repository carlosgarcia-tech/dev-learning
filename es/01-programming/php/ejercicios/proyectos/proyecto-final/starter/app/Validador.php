<?php

declare(strict_types=1);

// Validaciones centralizadas del dominio. Todas lanzan ValidacionException.
class Validador
{
    public static function validarTitulo(string $titulo): void
    {
        // TODO: el título es obligatorio y no supera los 100 caracteres.
        throw new Exception("TODO: implementar Validador::validarTitulo()");
    }

    public static function validarContenido(string $contenido): void
    {
        // TODO: el contenido es obligatorio y tiene al menos 10 caracteres.
        throw new Exception("TODO: implementar Validador::validarContenido()");
    }

    public static function validarComentario(string $texto): void
    {
        // TODO: el comentario no puede estar vacío ni superar los 500 caracteres.
        throw new Exception("TODO: implementar Validador::validarComentario()");
    }

    public static function validarCredenciales(string $nombre, string $clave): void
    {
        // TODO: nombre obligatorio (3-20 alfanuméricos o guion bajo)
        // y contraseña de al menos 6 caracteres.
        throw new Exception("TODO: implementar Validador::validarCredenciales()");
    }

    public static function validarEmail(string $email): bool
    {
        // TODO: devuelve true si $email es un correo válido (filter_var).
        throw new Exception("TODO: implementar Validador::validarEmail()");
    }

    public static function normalizarTitulo(string $titulo): string
    {
        // TODO: devuelve $titulo con trim().
        throw new Exception("TODO: implementar Validador::normalizarTitulo()");
    }

    public static function normalizarContenido(string $contenido): string
    {
        // TODO: devuelve $contenido con trim().
        throw new Exception("TODO: implementar Validador::normalizarContenido()");
    }
}