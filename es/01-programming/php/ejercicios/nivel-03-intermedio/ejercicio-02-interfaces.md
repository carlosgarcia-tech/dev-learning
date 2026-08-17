# Ejercicio 02 — Interfaces

- **Nivel:** 3/5
- **Tema:** `interface`, `implements`, múltiples interfaces y tipado por interfaz
- **Tiempo estimado:** 30 min

## Enunciado

Completa el código en `ejercicio-02-interfaces.php`:

1. **`Pagable`** (interfaz): métodos `calcularTotal(): float` y `descripcion(): string`.
2. **`Factura implements Pagable`**: recibe un array de `lineas` (cada una con `precio`); `calcularTotal()` suma los precios y `descripcion()` devuelve `"Factura"`.
3. **`Suscripcion implements Pagable`**: recibe `precioMensual` y `meses`; `calcularTotal()` = precio * meses; `descripcion()` devuelve `"Suscripción"`.
4. **`procesarPago(Pagable $pagable)`**: devuelve `calcularTotal()`.
5. **`sumarTotales(array $pagables)`**: suma `calcularTotal()` de todos los elementos que sean `Pagable`.

## Requisitos

- [ ] `Factura` y `Suscripcion` implementan `Pagable`.
- [ ] `(new Factura([...]))->calcularTotal()` suma las líneas.
- [ ] `(new Suscripcion(10.0, 12))->calcularTotal()` es `120.0`.
- [ ] `procesarPago` funciona con cualquier `Pagable`.
- [ ] `sumarTotales` suma solo los elementos `Pagable`.
- [ ] Los tests pasan: `php ejercicio-02-interfaces_test.php`.

> **Nota:** PHP no está instalado en este entorno de aprendizaje. Ejecuta el comando localmente con PHP 8 o superior.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `interface Pagable { public function calcularTotal(): float; public function descripcion(): string; }`.
- `class Factura implements Pagable { ... }` debe implementar **todos** los métodos.
- Suma con `array_sum(array_column($this->lineas, 'precio'))`.
- `instanceof Pagable` filtra en `sumarTotales`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````php
interface Pagable
{
    public function calcularTotal(): float;
    public function descripcion(): string;
}

class Factura implements Pagable
{
    public function __construct(private array $lineas)
    {
    }

    public function calcularTotal(): float
    {
        return array_sum(array_column($this->lineas, 'precio'));
    }

    public function descripcion(): string
    {
        return "Factura";
    }
}

class Suscripcion implements Pagable
{
    public function __construct(private float $precioMensual, private int $meses)
    {
    }

    public function calcularTotal(): float
    {
        return $this->precioMensual * $this->meses;
    }

    public function descripcion(): string
    {
        return "Suscripción";
    }
}

function procesarPago(Pagable $pagable): float
{
    return $pagable->calcularTotal();
}

function sumarTotales(array $pagables): float
{
    $total = 0.0;
    foreach ($pagables as $pagable) {
        if ($pagable instanceof Pagable) {
            $total += $pagable->calcularTotal();
        }
    }
    return $total;
}
````

</details>