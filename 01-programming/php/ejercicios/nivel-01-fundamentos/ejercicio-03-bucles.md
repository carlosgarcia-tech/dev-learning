# Ejercicio 03 — Bucles

- **Nivel:** 1/5
- **Tema:** `for`, `while`, `do...while`, `foreach`, `break` y `continue`
- **Tiempo estimado:** 20 min

## Enunciado

Completa las funciones en `ejercicio-03-bucles.php`:

1. `sumar1aN(int $n)`: devuelve la suma de 1 hasta `$n` (usa un bucle `for`).
2. `tablaMultiplicar(int $n)`: devuelve un array con las líneas `"7 x 1 = 7"` ... `"7 x 10 = 70"`.
3. `esPrimo(int $n)`: devuelve `true` si `$n` es primo (mayor que 1 y divisible solo por 1 y por sí mismo).
4. `contarVocales(string $texto)`: devuelve un array asociativo con el conteo de `a`, `e`, `i`, `o`, `u` (sin distinguir mayúsculas).
5. `numerosImpares(int $limite)`: devuelve un array con los números impares desde 1 hasta `$limite`, usando `continue` para saltar los pares.

## Requisitos

- [ ] `sumar1aN(5)` es `15`, `sumar1aN(10)` es `55`, `sumar1aN(0)` es `0`.
- [ ] `tablaMultiplicar(7)` devuelve 10 líneas y la primera es `"7 x 1 = 7"`.
- [ ] `esPrimo(2)`, `esPrimo(3)`, `esPrimo(17)` son `true`; `esPrimo(1)`, `esPrimo(4)`, `esPrimo(9)` son `false`.
- [ ] `contarVocales("Hola mundo")` suma 4 vocales y `contarVocales("aaa")['a']` es `3`.
- [ ] `numerosImpares(7)` es `[1, 3, 5, 7]`.
- [ ] Los tests pasan: `php ejercicio-03-bucles_test.php`.

> **Nota:** PHP no está instalado en este entorno de aprendizaje. Ejecuta el comando localmente con PHP 8 o superior.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `for ($i = 1; $i <= $n; $i++)` es el patrón clásico.
- Para los primos basta probar divisores desde 2 hasta `sqrt($n)`.
- Un número es impar si `$i % 2 !== 0`.
- `strtolower($texto)` normaliza; `str_split` divide el string en caracteres.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````php
function sumar1aN(int $n): int
{
    $suma = 0;
    for ($i = 1; $i <= $n; $i++) {
        $suma += $i;
    }
    return $suma;
}

function tablaMultiplicar(int $n): array
{
    $lineas = [];
    for ($i = 1; $i <= 10; $i++) {
        $lineas[] = "{$n} x {$i} = " . ($n * $i);
    }
    return $lineas;
}

function esPrimo(int $n): bool
{
    if ($n < 2) {
        return false;
    }
    for ($i = 2; $i <= (int) sqrt($n); $i++) {
        if ($n % $i === 0) {
            return false;
        }
    }
    return true;
}

function contarVocales(string $texto): array
{
    $conteo = ['a' => 0, 'e' => 0, 'i' => 0, 'o' => 0, 'u' => 0];
    foreach (str_split(strtolower($texto)) as $letra) {
        if (isset($conteo[$letra])) {
            $conteo[$letra]++;
        }
    }
    return $conteo;
}

function numerosImpares(int $limite): array
{
    $resultado = [];
    for ($i = 1; $i <= $limite; $i++) {
        if ($i % 2 === 0) {
            continue;
        }
        $resultado[] = $i;
    }
    return $resultado;
}
````

</details>