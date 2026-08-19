# Ejercicio 02 — Arrays asociativos

- **Nivel:** 2/5
- **Tema:** arrays asociativos, `usort`, `array_map`, agrupación y `isset`
- **Tiempo estimado:** 25 min

## Enunciado

Completa las funciones en `index.php`:

1. `buscarPorEmail(array $usuarios, string $email)`: devuelve el usuario (array) cuyo `email` coincide o `null` si no existe.
2. `ordenarPorPrecio(array $productos)`: devuelve los productos ordenados por `precio` de menor a mayor (usa `usort`).
3. `agruparPorCategoria(array $productos)`: devuelve un array `categoria => [productos]`.
4. `contarFrecuencias(string $texto)`: devuelve `palabra => cantidad` de veces que aparece cada palabra (sin distinguir mayúsculas).

## Requisitos

- [ ] `buscarPorEmail` encuentra al usuario correcto y devuelve `null` para un email inexistente.
- [ ] `ordenarPorPrecio` ordena por precio ascendente y no pierde claves.
- [ ] `agruparPorCategoria` agrupa cada producto bajo su categoría.
- [ ] `contarFrecuencias("hola mundo hola")` tiene `"hola" => 2` y `"mundo" => 1`.
- [ ] Los tests pasan: `php index_test.php`.

> **Nota:** PHP no está instalado en este entorno de aprendizaje. Ejecuta el comando localmente con PHP 8 o superior.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `usort($arr, fn($a, $b) => $a['precio'] <=> $b['precio'])` ordena sin reindexar si usas `uasort`/`usort` con `array_values` si necesitas índices.
- `isset($usuarios[$email])` o recorre con `foreach`.
- Para agrupar: `$grupos[$producto['categoria']][] = $producto`.
- `str_word_count($texto, 1)` devuelve un array de palabras; o `explode` + `array_count_values`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````php
function buscarPorEmail(array $usuarios, string $email): ?array
{
    foreach ($usuarios as $usuario) {
        if ($usuario['email'] === $email) {
            return $usuario;
        }
    }
    return null;
}

function ordenarPorPrecio(array $productos): array
{
    usort($productos, fn ($a, $b) => $a['precio'] <=> $b['precio']);
    return $productos;
}

function agruparPorCategoria(array $productos): array
{
    $grupos = [];
    foreach ($productos as $producto) {
        $grupos[$producto['categoria']][] = $producto;
    }
    return $grupos;
}

function contarFrecuencias(string $texto): array
{
    $palabras = explode(' ', mb_strtolower(trim($texto)));
    $palabras = array_filter($palabras, fn ($p) => $p !== '');
    return array_count_values($palabras);
}
````

</details>