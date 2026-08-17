<?php

declare(strict_types=1);

// Envoltorio de sesión. Si se construye sin argumentos se vincula a $_SESSION
// (uso web). Si se construye con un array, trabaja sobre esa variable
// (uso en tests, sin tocar la sesión real).
class Sesion
{
    private array $datos;

    public function __construct(?array &$referencia = null)
    {
        if ($referencia === null) {
            if (session_status() === PHP_SESSION_NONE) {
                session_start();
            }
            $this->datos = &$_SESSION;
        } else {
            $this->datos = &$referencia;
        }
    }

    public function get(string $clave, mixed $default = null): mixed
    {
        // TODO: devuelve $this->datos[$clave] ?? $default.
        throw new Exception("TODO: implementar Sesion::get()");
    }

    public function set(string $clave, mixed $valor): void
    {
        // TODO: guarda $valor bajo $clave.
        throw new Exception("TODO: implementar Sesion::set()");
    }

    public function olvidar(string $clave): void
    {
        // TODO: elimina la clave de la sesión.
        throw new Exception("TODO: implementar Sesion::olvidar()");
    }

    public function destruir(): void
    {
        // TODO: vacía todos los datos de la sesión.
        throw new Exception("TODO: implementar Sesion::destruir()");
    }
}