# Ejercicio 06 — Funciones básicas

- **Nivel:** 1/5
- **Tema:** declaración de funciones, parámetros, valores por defecto y tipos de retorno
- **Tiempo estimado:** 20 min

## Enunciado

Completa las funciones en `index.php`:

1. `saludar(string $nombre, string $saludo = "Hola")`: devuelve `"<saludo>, <nombre>!"`.
2. `areaCirculo(float $radio)`: devuelve el área `pi * r²` redondeada a 2 decimales.
3. `esMayorDeEdad(int $edad)`: devuelve `true` si la edad es ≥ 18.
4. `potencia(int $base, int $exponente = 2)`: devuelve `$base ** $exponente`.
5. `clasificarEdad(int $edad)`: devuelve `"Niño"` (< 13), `"Adolescente"` (< 18) o `"Adulto"` (≥ 18).

## Requisitos

- [ ] `saludar("Ana")` es `"Hola, Ana!"`; `saludar("Ana", "Buenos días")` es `"Buenos días, Ana!"`.
- [ ] `areaCirculo(1)` es `3.14`; `areaCirculo(10)` es `314.16`.
- [ ] `esMayorDeEdad(18)` es `true`; `esMayorDeEdad(17)` es `false`.
- [ ] `potencia(3)` es `9`; `potencia(2, 10)` es `1024`.
- [ ] `clasificarEdad(10)` es `"Niño"`, `clasificarEdad(15)` es `"Adolescente"`, `clasificarEdad(30)` es `"Adulto"`.
- [ ] Los tests pasan: `php index_test.php`.

> **Nota:** PHP no está instalado en este entorno de aprendizaje. Ejecuta el comando localmente con PHP 8 o superior.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Los parámetros con valor por defecto van al final: `function saludar(string $nombre, string $saludo = "Hola")`.
- Constante `M_PI` o función `pi()`.
- `round($valor, 2)` redondea.
- Declara siempre el tipo de retorno `: string`, `: float`, `: bool`, `: int`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````php
function saludar(string $nombre, string $saludo = "Hola"): string
{
    return "{$saludo}, {$nombre}!";
}

function areaCirculo(float $radio): float
{
    return round(pi() * $radio ** 2, 2);
}

function esMayorDeEdad(int $edad): bool
{
    return $edad >= 18;
}

function potencia(int $base, int $exponente = 2): int
{
    return $base ** $exponente;
}

function clasificarEdad(int $edad): string
{
    if ($edad < 13) {
        return "Niño";
    }
    if ($edad < 18) {
        return "Adolescente";
    }
    return "Adulto";
}
````

</details>