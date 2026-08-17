# Ejercicio 05 — Strings

- **Nivel:** 1/5
- **Tema:** funciones de strings, `explode`/`implode`, `str_contains`, `str_replace`, `mb_strtolower`
- **Tiempo estimado:** 20 min

## Enunciado

Completa las funciones en `ejercicio-05-strings.php`:

1. `limpiarYCaps(string $texto)`: devuelve el texto sin espacios al inicio/final, en minúsculas y con la primera letra en mayúscula (`trim` + `mb_strtolower` + `ucfirst`).
2. `contarPalabras(string $texto)`: devuelve el número de palabras (usa `explode` por espacios).
3. `revertirPalabras(string $texto)`: devuelve la frase con las palabras en orden inverso (`"hola mundo"` → `"mundo hola"`).
4. `esPalindromo(string $texto)`: devuelve `true` si el texto se lee igual al revés, ignorando espacios, mayúsculas y acentos.
5. `reemplazarVocales(string $texto)`: reemplaza todas las vocales por `"*"` (usa `str_replace` o `preg_replace`).

## Requisitos

- [ ] `limpiarYCaps("  hola mundo  ")` es `"Hola mundo"`.
- [ ] `contarPalabras("hola mundo de php")` es `4`.
- [ ] `revertirPalabras("hola mundo")` es `"mundo hola"`.
- [ ] `esPalindromo("Anita lava la tina")` es `true`; `esPalindromo("hola")` es `false`.
- [ ] `reemplazarVocales("casa")` es `"c*s*"`.
- [ ] Los tests pasan: `php ejercicio-05-strings_test.php`.

> **Nota:** PHP no está instalado en este entorno de aprendizaje. Ejecuta el comando localmente con PHP 8 o superior.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `trim()`, `mb_strtolower()`, `ucfirst()`.
- `explode(" ", $texto)` divide; `count()` cuenta.
- `strrev()` invierte un string, útil para palíndromos.
- Para ignorar espacios: `str_replace(" ", "", $texto)`.
- `str_replace(["a","e","i","o","u"], "*", $texto)` reemplaza todas a la vez.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````php
function limpiarYCaps(string $texto): string
{
    return ucfirst(mb_strtolower(trim($texto)));
}

function contarPalabras(string $texto): int
{
    $texto = trim($texto);
    if ($texto === '') {
        return 0;
    }
    return count(explode(' ', $texto));
}

function revertirPalabras(string $texto): string
{
    $palabras = explode(' ', trim($texto));
    return implode(' ', array_reverse($palabras));
}

function esPalindromo(string $texto): bool
{
    $limpio = mb_strtolower(str_replace(' ', '', trim($texto)));
    return $limpio !== '' && $limpio === strrev($limpio);
}

function reemplazarVocales(string $texto): string
{
    return str_replace(['a', 'e', 'i', 'o', 'u', 'A', 'E', 'I', 'O', 'U'], '*', $texto);
}
````

</details>