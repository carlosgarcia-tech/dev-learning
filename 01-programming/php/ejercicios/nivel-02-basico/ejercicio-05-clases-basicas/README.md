# Ejercicio 05 — Clases básicas

- **Nivel:** 2/5
- **Tema:** clases, propiedades, constructor, promoción, visibilidad y `__toString`
- **Tiempo estimado:** 25 min

## Enunciado

Completa las clases en `index.php`:

1. **`Producto`** con `nombre` (string), `precio` (float) y `stock` (int, por defecto 0), usando promoción de propiedades en el constructor. Métodos:
   - `nombre(): string`, `precio(): float`, `hayStock(): bool`.
   - `descontar(int $cantidad): bool` — reduce el stock y devuelve `true`; si no hay suficiente, no lo reduce y devuelve `false`.
   - `__toString(): string` — devuelve `"<nombre> (<precio>)"`.
2. **`CuentaBancaria`** con saldo inicial (por defecto 0):
   - `depositar(float $monto): void` — suma al saldo.
   - `retirar(float $monto): bool` — devuelve `false` si no hay saldo suficiente; si no, resta y devuelve `true`.
   - `saldo(): float`.

## Requisitos

- [ ] `new Producto("Laptop", 1200.0, 5)` expone nombre, precio y `hayStock() === true`.
- [ ] `descontar` reduce el stock correctamente y devuelve `false` si no alcanza.
- [ ] `(string) $producto` produce `"Laptop (1200)"`.
- [ ] `CuentaBancaria` deposita, retira y bloquea retiros sin saldo.
- [ ] Los tests pasan: `php index_test.php`.

> **Nota:** PHP no está instalado en este entorno de aprendizaje. Ejecuta el comando localmente con PHP 8 o superior.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Promoción: `public function __construct(private string $nombre, private float $precio, private int $stock = 0) {}`.
- `$this->stock` accede a la propiedad.
- `__toString` debe devolver un string; usa interpolación con `round($this->precio, 2)`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````php
class Producto
{
    public function __construct(
        private string $nombre,
        private float $precio,
        private int $stock = 0
    ) {
    }

    public function nombre(): string
    {
        return $this->nombre;
    }

    public function precio(): float
    {
        return $this->precio;
    }

    public function hayStock(): bool
    {
        return $this->stock > 0;
    }

    public function descontar(int $cantidad): bool
    {
        if ($cantidad > $this->stock) {
            return false;
        }
        $this->stock -= $cantidad;
        return true;
    }

    public function __toString(): string
    {
        return "{$this->nombre} ({$this->precio})";
    }
}

class CuentaBancaria
{
    private float $saldo;

    public function __construct(float $saldoInicial = 0.0)
    {
        $this->saldo = $saldoInicial;
    }

    public function depositar(float $monto): void
    {
        $this->saldo += $monto;
    }

    public function retirar(float $monto): bool
    {
        if ($monto > $this->saldo) {
            return false;
        }
        $this->saldo -= $monto;
        return true;
    }

    public function saldo(): float
    {
        return $this->saldo;
    }
}
````

</details>