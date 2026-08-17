# Ejercicio 04 — Errores y excepciones

- **Nivel:** 2/5
- **Tema:** `throw`, `try/catch/finally`, excepciones propias y `Throwable`
- **Tiempo estimado:** 25 min

## Enunciado

Completa las funciones en `ejercicio-04-errores-y-excepciones.php`:

1. `dividirSeguro(int $a, int $b)`: devuelve `$a / $b`; lanza `InvalidArgumentException` si `$b` es `0`.
2. `validarEdad(int $edad)`: lanza la excepción propia `EdadInvalidaException` si `$edad < 0` o `> 150`; si no, devuelve `"Mayor de edad"` o `"Menor de edad"`.
3. `procesarConSeguridad(callable $fn)`: ejecuta `$fn()` dentro de `try/catch` y devuelve el resultado, o `null` si se lanza cualquier `Throwable`.
4. `conReintentos(callable $operacion, int $intentos = 3)`: intenta `$operacion()` hasta `$intentos` veces; si todas fallan, lanza la última excepción.

Define también la clase `EdadInvalidaException extends Exception`.

## Requisitos

- [ ] `dividirSeguro(10, 2)` es `5.0`.
- [ ] `dividirSeguro(10, 0)` lanza `InvalidArgumentException`.
- [ ] `validarEdad(20)` es `"Mayor de edad"`; `validarEdad(200)` lanza `EdadInvalidaException`.
- [ ] `procesarConSeguridad` devuelve el resultado de la función y `null` si falla.
- [ ] `conReintentos` reintenta y lanza al agotar los intentos.
- [ ] Los tests pasan: `php ejercicio-04-errores-y-excepciones_test.php`.

> **Nota:** PHP no está instalado en este entorno de aprendizaje. Ejecuta el comando localmente con PHP 8 o superior.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `throw new InvalidArgumentException("...")`.
- Una clase de excepción propia: `class EdadInvalidaException extends Exception {}`.
- `catch (Throwable $e)` captura excepciones y errores del motor.
- En `conReintentos`, captura, y si es el último intento vuelve a lanzar.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````php
class EdadInvalidaException extends Exception
{
}

function dividirSeguro(int $a, int $b): float
{
    if ($b === 0) {
        throw new InvalidArgumentException("No se puede dividir entre cero");
    }
    return $a / $b;
}

function validarEdad(int $edad): string
{
    if ($edad < 0 || $edad > 150) {
        throw new EdadInvalidaException("La edad {$edad} no es válida");
    }
    return $edad >= 18 ? "Mayor de edad" : "Menor de edad";
}

function procesarConSeguridad(callable $fn): mixed
{
    try {
        return $fn();
    } catch (Throwable $e) {
        return null;
    }
}

function conReintentos(callable $operacion, int $intentos = 3): mixed
{
    for ($i = 1; $i <= $intentos; $i++) {
        try {
            return $operacion();
        } catch (Throwable $e) {
            if ($i === $intentos) {
                throw $e;
            }
        }
    }
    return null;
}
````

</details>