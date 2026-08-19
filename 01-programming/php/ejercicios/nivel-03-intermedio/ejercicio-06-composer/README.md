# Ejercicio 06 — Composer y autoload PSR-4

- **Nivel:** 3/5
- **Tema:** `composer.json`, autoload PSR-4 y autoloader propio
- **Tiempo estimado:** 30 min

## Enunciado

Completa las funciones en `index.php`:

1. `rutaPsr4(string $clase)`: convierte el nombre de clase `App\Nucleo\Usuario` en la ruta relativa `App/Nucleo/Usuario.php` (reemplaza `\` por `/` y añade `.php`).
2. `autoloadCorrecto(string $jsonComposer)`: decodifica el JSON y devuelve `true` si tiene `autoload.psr-4`.
3. `generarAutoloader(string $raiz)`: devuelve una closure que, dada una clase `$clase`, calcula `$raiz . '/' . rutaPsr4($clase)`; si el archivo existe, lo incluye con `require_once` y devuelve `true`; si no, devuelve `false`.
4. `instalarAutoloader(string $raiz)`: registra el autoloader con `spl_autoload_register` y devuelve la closure.

## Requisitos

- [ ] `rutaPsr4("App\Nucleo\Usuario")` es `"App/Nucleo/Usuario.php"`.
- [ ] `autoloadCorrecto` detecta el bloque `autoload.psr-4` en un JSON válido.
- [ ] `generarAutoloader` carga clases que existen en disco y devuelve `false` para las que no.
- [ ] `instalarAutoloader` permite usar `new` sin `require` manual.
- [ ] Los tests pasan: `php index_test.php`.

> **Nota:** PHP no está instalado en este entorno de aprendizaje. Ejecuta el comando localmente con PHP 8 o superior. Los tests crean árboles de archivos temporales.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `str_replace('\\', '/', $clase) . '.php'`.
- `json_decode($json, true)` y `isset($data['autoload']['psr-4'])`.
- `is_file($ruta)` comprueba antes de `require_once`.
- `spl_autoload_register($closure)` activa el autoloader.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````php
function rutaPsr4(string $clase): string
{
    return str_replace('\\', '/', $clase) . '.php';
}

function autoloadCorrecto(string $jsonComposer): bool
{
    $datos = json_decode($jsonComposer, true);
    if (!is_array($datos)) {
        return false;
    }
    return isset($datos['autoload']['psr-4']);
}

function generarAutoloader(string $raiz): callable
{
    return function (string $clase) use ($raiz): bool {
        $ruta = rtrim($raiz, '/') . '/' . rutaPsr4($clase);
        if (!is_file($ruta)) {
            return false;
        }
        require_once $ruta;
        return true;
    };
}

function instalarAutoloader(string $raiz): callable
{
    $loader = generarAutoloader($raiz);
    spl_autoload_register($loader);
    return $loader;
}
````

</details>