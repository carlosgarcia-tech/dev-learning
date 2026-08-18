<?php

declare(strict_types=1);

class Configuracion
{
    private static ?Configuracion $instancia = null;
    private array $valores;

    private function __construct(array $valores)
    {
        $this->valores = $valores;
    }

    public static function instancia(array $valores = []): Configuracion
    {
        // TODO: crea la instancia una sola vez.
        throw new Exception("TODO: implementar Configuracion::instancia()");
    }

    public function obtener(string $clave): mixed
    {
        // TODO: devuelve el valor o null.
        throw new Exception("TODO: implementar Configuracion::obtener()");
    }
}

interface MetodoPago
{
    public function procesar(float $monto): string;
}

class PagoTarjeta implements MetodoPago
{
    public function procesar(float $monto): string
    {
        // TODO: "Pagado <monto> con tarjeta".
        throw new Exception("TODO: implementar PagoTarjeta::procesar()");
    }
}

class PagoTransferencia implements MetodoPago
{
    public function procesar(float $monto): string
    {
        // TODO: "Pagado <monto> por transferencia".
        throw new Exception("TODO: implementar PagoTransferencia::procesar()");
    }
}

class FabricaPagos
{
    public static function crear(string $tipo): MetodoPago
    {
        // TODO: devuelve el pago según el tipo o lanza InvalidArgumentException.
        throw new Exception("TODO: implementar FabricaPagos::crear()");
    }
}

interface Envio
{
    public function calcularCosto(float $peso): float;
}

class CorreoEnvio implements Envio
{
    public function calcularCosto(float $peso): float
    {
        // TODO: peso * 2.
        throw new Exception("TODO: implementar CorreoEnvio::calcularCosto()");
    }
}

class MensajeroEnvio implements Envio
{
    public function calcularCosto(float $peso): float
    {
        // TODO: peso * 5 + 10.
        throw new Exception("TODO: implementar MensajeroEnvio::calcularCosto()");
    }
}

class CotizadorEnvio
{
    public function __construct(private Envio $estrategia)
    {
    }

    public function cambiarEstrategia(Envio $estrategia): void
    {
        // TODO
        throw new Exception("TODO: implementar CotizadorEnvio::cambiarEstrategia()");
    }

    public function cotizar(float $peso): float
    {
        // TODO: usa la estrategia actual.
        throw new Exception("TODO: implementar CotizadorEnvio::cotizar()");
    }
}