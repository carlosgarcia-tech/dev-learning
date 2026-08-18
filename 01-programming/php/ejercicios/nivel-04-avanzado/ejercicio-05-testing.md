# Ejercicio 05 — Testing con aserciones

- **Nivel:** 4/5
- **Tema:** escribir tests con aserciones manuales y códigos de salida
- **Tiempo estimado:** 30 min

## Enunciado

Completa las funciones en `ejercicio-05-testing.php` y verifícalas con el script de tests:

1. `esPalindromo(string $texto)`: `true` si se lee igual al revés ignorando espacios y mayúsculas.
2. `factorial(int $n)`: devuelve `n!` (con `0! = 1`); lanza `InvalidArgumentException` para negativos.
3. `celsiusAFahrenheit(float $c)`: devuelve `(c * 9/5) + 32` redondeado a 1 decimal.
4. `esEmailValido(string $email)`: `true` si contiene `@` y un `.` después de la `@` y no está vacío.

## Requisitos

- [ ] `esPalindromo("reconocer")` es `true`; `esPalindromo("Hola")` es `false`.
- [ ] `factorial(5)` es `120`; `factorial(0)` es `1`; `factorial(-1)` lanza `InvalidArgumentException`.
- [ ] `celsiusAFahrenheit(0)` es `32.0`; `celsiusAFahrenheit(100)` es `212.0`.
- [ ] `esEmailValido("ana@mail.com")` es `true`; `esEmailValido("sin-arroba")` es `false`.
- [ ] El script de tests pasa con `exit(0)`: `php ejercicio-05-testing_test.php`.

> **Nota:** PHP no está instalado en este entorno de aprendizaje. Ejecuta el comando localmente con PHP 8 o superior.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `str_replace(' ', '', mb_strtolower($texto))` para el palíndromo.
- `for` de 2 a `$n` acumulando; `$n < 0` → `throw new InvalidArgumentException`.
- `round($c * 9 / 5 + 32, 1)`.
- Para el email: `$pos = strpos($email, '@')` y comprueba `strpos($email, '.', $pos + 1) !== false`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````php
function esPalindromo(string $texto): bool
{
    $limpio = mb_strtolower(str_replace(' ', '', trim($texto)));
    return $limpio !== '' && $limpio === strrev($limpio);
}

function factorial(int $n): int
{
    if ($n < 0) {
        throw new InvalidArgumentException("El factorial de un negativo no existe");
    }
    $resultado = 1;
    for ($i = 2; $i <= $n; $i++) {
        $resultado *= $i;
    }
    return $resultado;
}

function celsiusAFahrenheit(float $c): float
{
    return round($c * 9 / 5 + 32, 1);
}

function esEmailValido(string $email): bool
{
    $email = trim($email);
    if ($email === '') {
        return false;
    }
    $pos = strpos($email, '@');
    if ($pos === false) {
        return false;
    }
    return strpos($email, '.', $pos + 1) !== false;
}
````

</details>