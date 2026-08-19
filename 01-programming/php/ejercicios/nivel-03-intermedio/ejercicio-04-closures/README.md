# Ejercicio 04 — Closures

- **Nivel:** 3/5
- **Tema:** funciones anónimas, `use`, arrow functions, callables y `array_map`/`array_filter`
- **Tiempo estimado:** 25 min

## Enunciado

Completa las funciones en `index.php`:

1. `multiplicador(int $factor)`: devuelve una closure que multiplica su argumento por `$factor` (capturado con `use`).
2. `aplicarA(array $numeros, callable $fn)`: devuelve el resultado de aplicar `$fn` a cada elemento con `array_map`.
3. `filtrarPares(array $numeros)`: devuelve solo los pares usando `array_filter` con una closure.
4. `crearContador()`: devuelve una closure que en cada llamada devuelve `1, 2, 3, ...` usando una variable estática `$n`.

## Requisitos

- [ ] `multiplicador(3)(4)` es `12`; `multiplicador(2)(5)` es `10`.
- [ ] `aplicarA([1, 2, 3], fn ($n) => $n ** 2)` es `[1, 4, 9]`.
- [ ] `filtrarPares([1, 2, 3, 4, 5])` es `[2, 4]`.
- [ ] `crearContador` devuelve 1, luego 2, luego 3 en llamadas sucesivas.
- [ ] Los tests pasan: `php index_test.php`.

> **Nota:** PHP no está instalado en este entorno de aprendizaje. Ejecuta el comando localmente con PHP 8 o superior.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `$closure = function (int $x) use ($factor): int { return $x * $factor; };`.
- `array_map($fn, $numeros)` aplica la función.
- `array_filter($numeros, $fn)` conserva los que cumplen la condición.
- Una variable `static $n = 0;` dentro de la closure persiste entre llamadas.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````php
function multiplicador(int $factor): callable
{
    return function (int $x) use ($factor): int {
        return $x * $factor;
    };
}

function aplicarA(array $numeros, callable $fn): array
{
    return array_map($fn, $numeros);
}

function filtrarPares(array $numeros): array
{
    return array_values(array_filter($numeros, fn (int $n): bool => $n % 2 === 0));
}

function crearContador(): callable
{
    return function (): int {
        static $n = 0;
        return ++$n;
    };
}
````

</details>