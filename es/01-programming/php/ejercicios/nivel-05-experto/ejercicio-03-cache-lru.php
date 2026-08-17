<?php

declare(strict_types=1);

class CacheLru
{
    private array $items = [];

    public function __construct(private int $capacidad)
    {
        // TODO: valida que la capacidad sea >= 1.
        throw new Exception("TODO: implementar CacheLru::__construct()");
    }

    public function poner(string $clave, mixed $valor): void
    {
        // TODO: guarda el valor como el más reciente y expulsa el LRU si hace falta.
        throw new Exception("TODO: implementar CacheLru::poner()");
    }

    public function obtener(string $clave): mixed
    {
        // TODO: devuelve el valor (marcándolo como reciente) o null.
        throw new Exception("TODO: implementar CacheLru::obtener()");
    }

    public function tiene(string $clave): bool
    {
        // TODO
        throw new Exception("TODO: implementar CacheLru::tiene()");
    }

    public function tamano(): int
    {
        // TODO
        throw new Exception("TODO: implementar CacheLru::tamano()");
    }

    public function capacidad(): int
    {
        // TODO
        throw new Exception("TODO: implementar CacheLru::capacidad()");
    }
}