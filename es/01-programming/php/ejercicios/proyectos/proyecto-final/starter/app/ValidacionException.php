<?php

declare(strict_types=1);

// Excepción de dominio para cualquier validación fallida.
// La lanza Validador, Blog y Auth; el front controller la captura para mostrar el error.
class ValidacionException extends RuntimeException
{
}