# Ejercicio 02 — Operadores y condicionales

- **Nivel:** 1/5
- **Tema:** operadores aritméticos, comparación, `if/elseif/else`, ternario y `match`
- **Tiempo estimado:** 20 min

## Enunciado

Completa las funciones en `ejercicio-02-operadores-y-condicionales.php`:

1. `esPar(int $n)`: devuelve `true` si el número es par.
2. `clasificarNota(int $nota)`: devuelve `"Excelente"` si ≥ 90, `"Aprobado"` si ≥ 70, `"Reprobado"` en caso contrario.
3. `mayorDeTres(int $a, int $b, int $c)`: devuelve el mayor de los tres.
4. `diaSemana(int $n)`: devuelve el día de la semana (1 = Lunes ... 7 = Domingo) usando `match`; para otros valores devuelve `"Día inválido"`.
5. `descuento(float $precio, bool $esVip)`: aplica 20% de descuento si el cliente es VIP, y además 10% adicional si el precio supera 100. Devuelve el precio final con 2 decimales.

## Requisitos

- [ ] `esPar(4)` es `true`, `esPar(7)` es `false`.
- [ ] `clasificarNota(95)` es `"Excelente"`, `clasificarNota(75)` es `"Aprobado"`, `clasificarNota(50)` es `"Reprobado"`.
- [ ] `mayorDeTres(3, 9, 5)` es `9`.
- [ ] `diaSemana(1)` es `"Lunes"`, `diaSemana(7)` es `"Domingo"`, `diaSemana(9)` es `"Día inválido"`.
- [ ] `descuento(50.0, true)` es `40.0`; `descuento(200.0, false)` es `180.0`.
- [ ] Los tests pasan: `php ejercicio-02-operadores-y-condicionales_test.php`.

> **Nota:** PHP no está instalado en este entorno de aprendizaje. Ejecuta el comando localmente con PHP 8 o superior.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Un número es par si `$n % 2 === 0`.
- El operador módulo es `%`, la potencia es `**`.
- `match` se escribe `match ($n) { 1 => "Lunes", ..., default => "Día inválido" }`.
- Para redondear usa `round($valor, 2)`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````php
function esPar(int $n): bool
{
    return $n % 2 === 0;
}

function clasificarNota(int $nota): string
{
    if ($nota >= 90) {
        return "Excelente";
    }
    if ($nota >= 70) {
        return "Aprobado";
    }
    return "Reprobado";
}

function mayorDeTres(int $a, int $b, int $c): int
{
    $mayor = $a;
    if ($b > $mayor) {
        $mayor = $b;
    }
    if ($c > $mayor) {
        $mayor = $c;
    }
    return $mayor;
}

function diaSemana(int $n): string
{
    return match ($n) {
        1 => "Lunes",
        2 => "Martes",
        3 => "Miércoles",
        4 => "Jueves",
        5 => "Viernes",
        6 => "Sábado",
        7 => "Domingo",
        default => "Día inválido",
    };
}

function descuento(float $precio, bool $esVip): float
{
    $precio = $esVip ? $precio * 0.8 : $precio;
    if ($precio > 100) {
        $precio *= 0.9;
    }
    return round($precio, 2);
}
````

</details>