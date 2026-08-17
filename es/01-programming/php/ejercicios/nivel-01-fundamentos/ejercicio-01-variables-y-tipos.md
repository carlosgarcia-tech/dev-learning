# Ejercicio 01 — Variables y tipos

- **Nivel:** 1/5
- **Tema:** `$` variables, tipos, `gettype()`, interpolación
- **Tiempo estimado:** 15 min

## Enunciado

Completa las funciones en `ejercicio-01-variables-y-tipos.php`:

1. `crearDatos()`: devuelve un array asociativo con `nombre` (string), `ciudad` (string), `edad` (int) y `programacion` (bool).
2. `tipoDe(mixed $valor)`: devuelve el tipo legible del valor usando `gettype()` y traducido a: `string`, `int`, `float`, `bool`, `array`, `null`.
3. `formatearDescripcion(array $datos)`: devuelve la frase `Soy <nombre>, tengo <edad> años, nací en <ciudad> y es <true|false> que estudio programación.` usando interpolación con comillas dobles.

Salida esperada (ejemplo):

```
Soy Ana, tengo 30 años, nací en Lima y es true que estudio programación.
```

## Requisitos

- [ ] `crearDatos()` devuelve un array con las 4 claves y los tipos correctos.
- [ ] `tipoDe(42)` devuelve `"int"`, `tipoDe(3.14)` devuelve `"float"`, `tipoDe("x")` devuelve `"string"`, `tipoDe(true)` devuelve `"bool"`, `tipoDe([1])` devuelve `"array"` y `tipoDe(null)` devuelve `"null"`.
- [ ] `formatearDescripcion()` usa interpolación (comillas dobles) y refleja los datos que recibe.
- [ ] Los tests pasan: `php ejercicio-01-variables-y-tipos_test.php`.

> **Nota:** PHP no está instalado en este entorno de aprendizaje. Ejecuta el comando localmente con PHP 8 o superior.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- En PHP toda variable empieza con `$`: `$nombre = "Ana";`.
- `gettype(42)` devuelve `"integer"`, `gettype(3.14)` devuelve `"double"`, `gettype(true)` devuelve `"boolean"` y `gettype(null)` devuelve `"NULL"`.
- Dentro de comillas dobles puedes interpolar: `"Soy {$datos['nombre']}"`.
- El booleano se muestra como `true` o `false`; conviértelo explícitamente con `$x ? 'true' : 'false'`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````php
function crearDatos(): array
{
    return [
        'nombre' => 'Ana',
        'ciudad' => 'Lima',
        'edad' => 30,
        'programacion' => true,
    ];
}

function tipoDe(mixed $valor): string
{
    return match (gettype($valor)) {
        'integer' => 'int',
        'double' => 'float',
        'boolean' => 'bool',
        'string' => 'string',
        'array' => 'array',
        'NULL' => 'null',
        default => gettype($valor),
    };
}

function formatearDescripcion(array $datos): string
{
    $programa = $datos['programacion'] ? 'true' : 'false';
    return "Soy {$datos['nombre']}, tengo {$datos['edad']} años, nací en {$datos['ciudad']} y es $programa que estudio programación.";
}
````

</details>