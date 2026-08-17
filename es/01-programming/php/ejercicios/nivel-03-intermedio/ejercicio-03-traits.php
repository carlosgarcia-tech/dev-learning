<?php

declare(strict_types=1);

trait Timestampable
{
    private string $creadoEn = "";

    public function marcarCreado(): void
    {
        // TODO: guarda date("Y-m-d H:i:s") en $creadoEn.
        throw new Exception("TODO: implementar Timestampable::marcarCreado()");
    }

    public function creadoEn(): string
    {
        // TODO
        throw new Exception("TODO: implementar Timestampable::creadoEn()");
    }
}

trait Loggable
{
    private array $log = [];

    public function registrar(string $mensaje): void
    {
        // TODO: añade "[fecha] mensaje" a $log.
        throw new Exception("TODO: implementar Loggable::registrar()");
    }

    public function log(): array
    {
        // TODO
        throw new Exception("TODO: implementar Loggable::log()");
    }
}

class Articulo
{
    use Timestampable;

    public function __construct(private string $titulo)
    {
    }

    public function titulo(): string
    {
        return $this->titulo;
    }
}

class Comentario
{
    use Timestampable;
    use Loggable;

    public function __construct(private string $contenido)
    {
    }

    public function contenido(): string
    {
        return $this->contenido;
    }
}