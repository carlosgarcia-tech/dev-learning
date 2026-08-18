# Ejercicio 06 — include y require

- **Nivel:** 2/5
- **Tema:** `include`, `require`, `include_once`, `require_once` y `spl_autoload`
- **Tiempo estimado:** 25 min

## Enunciado

Completa las funciones en `ejercicio-06-include-require.php`:

1. `cargarValores(string $ruta)`: ejecuta `include $ruta` y devuelve el valor que retorna el archivo si es un array; si no, `[]`.
2. `invocarIncluido(string $ruta, string $funcion, mixed ...$args)`: hace `require_once $ruta`, verifica que `$funcion` exista (lanza `RuntimeException` si no) y la invoca con `$args`.
3. `incluirMarcador(string $ruta)`: hace `require_once $ruta` y devuelve el valor de la constante `MARCA_INCLUIDA` (lanza `RuntimeException` si no está definida).

## Requisitos

- [ ] `cargarValores` devuelve los valores que el archivo PHP retorna.
- [ ] `invocarIncluido` puede llamar a una función definida en el archivo incluido.
- [ ] `invocarIncluido` lanza `RuntimeException` si la función no existe.
- [ ] `incluirMarcador` devuelve `"incluido"` para el archivo de prueba.
- [ ] Los tests pasan: `php ejercicio-06-include-require_test.php`.

> **Nota:** PHP no está instalado en este entorno de aprendizaje. Ejecuta el comando localmente con PHP 8 o superior. Los tests generan archivos temporales en `sys_get_temp_dir()`.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `include` devuelve el valor que el archivo retorna con `return`.
- `function_exists($funcion)` comprueba si la función está definida.
- `defined('MARCA_INCLUIDA')` comprueba si la constante existe.
- Usa `require_once` para que incluir dos veces no rompa nada.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````php
function cargarValores(string $ruta): array
{
    $valor = include $ruta;
    return is_array($valor) ? $valor : [];
}

function invocarIncluido(string $ruta, string $funcion, mixed ...$args): mixed
{
    require_once $ruta;
    if (!function_exists($funcion)) {
        throw new RuntimeException("La función {$funcion} no existe en el archivo incluido");
    }
    return $funcion(...$args);
}

function incluirMarcador(string $ruta): string
{
    require_once $ruta;
    if (!defined('MARCA_INCLUIDA')) {
        throw new RuntimeException("La constante MARCA_INCLUIDA no está definida");
    }
    return MARCA_INCLUIDA;
}
````

</details>