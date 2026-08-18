# Ejercicio 06 — Patrones de diseño

- **Nivel:** 4/5
- **Tema:** Singleton, Factory y Strategy
- **Tiempo estimado:** 40 min

## Enunciado

Completa las clases en `ejercicio-06-patrones.php`:

1. **Singleton `Configuracion`**: propiedad estática privada que conserva la única instancia; `instancia(array $valores = [])` la crea una sola vez (ignora `$valores` en llamadas posteriores) y `obtener(string $clave)` devuelve un valor o `null`.
2. **Factory `FabricaPagos`**: `crear(string $tipo)` devuelve un `PagoTarjeta` para `"tarjeta"`, un `PagoTransferencia` para `"transferencia"`, y lanza `InvalidArgumentException` para otros. Ambas clases implementan la interfaz `MetodoPago` con `procesar(float $monto): string`.
3. **Strategy**: interfaz `Envio` con `calcularCosto(float $peso): float`; `CorreoEnvio` (peso * 2) y `MensajeroEnvio` (peso * 5 + 10). `CotizadorEnvio` permite `cambiarEstrategia(Envio $estrategia)` y `cotizar(float $peso)` usa la estrategia actual.

## Requisitos

- [ ] `Configuracion::instancia()` devuelve siempre el mismo objeto.
- [ ] `obtener('db')` recupera el valor fijado en la primera llamada.
- [ ] `FabricaPagos::crear('tarjeta')` y `('transferencia')` devuelven el tipo correcto; un tipo desconocido lanza `InvalidArgumentException`.
- [ ] `CotizadorEnvio` cambia de estrategia y cotiza según la activa.
- [ ] Los tests pasan: `php ejercicio-06-patrones_test.php`.

> **Nota:** PHP no está instalado en este entorno de aprendizaje. Ejecuta el comando localmente con PHP 8 o superior.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Singleton: `private static ?Configuracion $instancia = null;` y `if (self::$instancia === null) { self::$instancia = new self(...); }`.
- `match ($tipo) { 'tarjeta' => new PagoTarjeta(), ... default => throw ... }`.
- Strategy: guarda la interfaz en una propiedad y delega en `cambiarEstrategia`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````php
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
        if (self::$instancia === null) {
            self::$instancia = new self($valores);
        }
        return self::$instancia;
    }

    public function obtener(string $clave): mixed
    {
        return $this->valores[$clave] ?? null;
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
        return "Pagado {$monto} con tarjeta";
    }
}

class PagoTransferencia implements MetodoPago
{
    public function procesar(float $monto): string
    {
        return "Pagado {$monto} por transferencia";
    }
}

class FabricaPagos
{
    public static function crear(string $tipo): MetodoPago
    {
        return match ($tipo) {
            'tarjeta' => new PagoTarjeta(),
            'transferencia' => new PagoTransferencia(),
            default => throw new InvalidArgumentException("Tipo de pago desconocido: {$tipo}"),
        };
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
        return $peso * 2;
    }
}

class MensajeroEnvio implements Envio
{
    public function calcularCosto(float $peso): float
    {
        return $peso * 5 + 10;
    }
}

class CotizadorEnvio
{
    public function __construct(private Envio $estrategia)
    {
    }

    public function cambiarEstrategia(Envio $estrategia): void
    {
        $this->estrategia = $estrategia;
    }

    public function cotizar(float $peso): float
    {
        return $this->estrategia->calcularCosto($peso);
    }
}
````

</details>