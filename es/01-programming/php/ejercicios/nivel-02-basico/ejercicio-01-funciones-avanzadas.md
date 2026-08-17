# Ejercicio 01 — Funciones avanzadas

- **Nivel:** 2/5
- **Tema:** parámetros variádicos, por referencia, argumentos con nombre y arrow functions
- **Tiempo estimado:** 20 min

## Enunciado

Completa las funciones en `ejercicio-01-funciones-avanzadas.php`:

1. `sumaVariadica(int ...$numeros)`: suma todos los argumentos (array variádico).
2. `incrementarRef(int &$n)`: incrementa `$n` en 1 (paso por referencia).
3. `aplicarDescuento(float $precio, float $porcentaje = 10.0)`: devuelve el precio tras restar el porcentaje, redondeado a 2 decimales.
4. `duplicarConFn(array $numeros)`: devuelve cada número por 2 usando una **arrow function** con `array_map`.

## Requisitos

- [ ] `sumaVariadica(1, 2, 3, 4)` es `10`; `sumaVariadica()` es `0`.
- [ ] `incrementarRef` modifica la variable original.
- [ ] `aplicarDescuento(100.0)` es `90.0`; `aplicarDescuento(precio: 100.0, porcentaje: 25.0)` es `75.0` (argumentos con nombre).
- [ ] `duplicarConFn([1, 2, 3])` es `[2, 4, 6]` y usa `fn`.
- [ ] Los tests pasan: `php ejercicio-01-funciones-avanzadas_test.php`.

> **Nota:** PHP no está instalado en este entorno de aprendizaje. Ejecuta el comando localmente con PHP 8 o superior.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `array_sum(...)` con `...$numeros`.
- La referencia se marca en el parámetro y en la llamada: `incrementarRef($x)`.
- Argumentos con nombre: `aplicarDescuento(precio: 100.0, porcentaje: 25.0)`.
- Arrow function: `fn (int $n): int => $n * 2`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````php
function sumaVariadica(int ...$numeros): int
{
    return array_sum($numeros);
}

function incrementarRef(int &$n): void
{
    $n++;
}

function aplicarDescuento(float $precio, float $porcentaje = 10.0): float
{
    return round($precio * (1 - $porcentaje / 100), 2);
}

function duplicarConFn(array $numeros): array
{
    return array_map(fn (int $n): int => $n * 2, $numeros);
}
````

</details>