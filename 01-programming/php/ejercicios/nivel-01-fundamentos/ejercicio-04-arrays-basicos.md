# Ejercicio 04 — Arrays básicos

- **Nivel:** 1/5
- **Tema:** arrays indexados, `count`, `[]`, `array_sum`, `array_reverse`, orden
- **Tiempo estimado:** 20 min

## Enunciado

Completa las funciones en `ejercicio-04-arrays-basicos.php`:

1. `duplicar(array $numeros)`: devuelve un array donde cada número está multiplicado por 2.
2. `sumaArray(array $numeros)`: devuelve la suma de todos los elementos (usa `array_sum`).
3. `mayorYMenor(array $numeros)`: devuelve `["mayor" => ..., "menor" => ...]`.
4. `revertir(array $numeros)`: devuelve el array en orden inverso (sin mutar el original).
5. `contarOcurrencias(array $palabras)`: devuelve un array asociativo `palabra => cantidad` de veces que aparece.

## Requisitos

- [ ] `duplicar([1, 2, 3])` es `[2, 4, 6]`.
- [ ] `sumaArray([1, 2, 3, 4])` es `10`; `sumaArray([])` es `0`.
- [ ] `mayorYMenor([3, 9, 1, 7])` es `["mayor" => 9, "menor" => 1]`.
- [ ] `revertir([1, 2, 3])` es `[3, 2, 1]` y no modifica el array original.
- [ ] `contarOcurrencias(["sol", "luna", "sol", "mar"])` tiene `"sol" => 2`, `"luna" => 1`.
- [ ] Los tests pasan: `php ejercicio-04-arrays-basicos_test.php`.

> **Nota:** PHP no está instalado en este entorno de aprendizaje. Ejecuta el comando localmente con PHP 8 o superior.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Puedes añadir al final con `$array[] = $valor`.
- `array_reverse($arr)` no modifica el original.
- `array_count_values($arr)` cuenta ocurrencias; también puedes usar un `foreach`.
- Para el mayor/menor, recorre con `foreach` y compara, o usa `max()`/`min()`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````php
function duplicar(array $numeros): array
{
    $resultado = [];
    foreach ($numeros as $n) {
        $resultado[] = $n * 2;
    }
    return $resultado;
}

function sumaArray(array $numeros): int
{
    return array_sum($numeros);
}

function mayorYMenor(array $numeros): array
{
    return [
        'mayor' => max($numeros),
        'menor' => min($numeros),
    ];
}

function revertir(array $numeros): array
{
    return array_reverse($numeros);
}

function contarOcurrencias(array $palabras): array
{
    return array_count_values($palabras);
}
````

</details>