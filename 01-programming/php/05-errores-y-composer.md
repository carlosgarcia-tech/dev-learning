# 05 — Errores, excepciones y Composer

## Objetivos

- [ ] Diferenciar errores (`Error`) de excepciones (`Exception`).
- [ ] Lanzar excepciones con `throw`.
- [ ] Capturarlas con `try/catch/finally`.
- [ ] Crear excepciones propias extendiendo `Exception`.
- [ ] Capturar múltiples tipos de excepción en orden.
- [ ] Configurar Composer: `composer.json`, `require`, `autoload` PSR-4.
- [ ] Escribir scripts de tests con aserciones.

## Apuntes

### Errores vs excepciones

En PHP 8, tanto los fallos del motor (`TypeError`, `DivisionByZeroError`, `ParseError`) como las excepciones de la aplicación (`Exception`, `RuntimeException`) descienden de `Throwable`.

- **`Exception`** — problemas que tu código detecta y lanza.
- **`Error`** — fallos internos de PHP (tipos incorrectos, divisiones por cero, etc.).

### Lanzar y capturar

```php
function dividir(int $a, int $b): float
{
    if ($b === 0) {
        throw new InvalidArgumentException("No se puede dividir entre cero");
    }
    return $a / $b;
}

try {
    echo dividir(10, 0);
} catch (InvalidArgumentException $e) {
    echo "Error: " . $e->getMessage();
} finally {
    echo PHP_EOL . "Esto siempre se ejecuta" . PHP_EOL;
}
```

- `catch` captura el tipo indicado; el orden importa: captura primero las más específicas.
- `finally` siempre se ejecuta, haya o no excepción (útil para cerrar recursos).
- `$e->getMessage()`, `getCode()`, `getFile()`, `getLine()` dan contexto.

### Capturar varios tipos

```php
try {
    // ...
} catch (PDOException $e) {
    echo "Problema con la base de datos";
} catch (Exception $e) {
    echo "Error general: " . $e->getMessage();
}
```

### Excepciones propias

```php
class EdadInvalidaException extends Exception
{
}

function validarEdad(int $edad): string
{
    if ($edad < 0 || $edad > 150) {
        throw new EdadInvalidaException("La edad {$edad} no es válida");
    }
    return $edad >= 18 ? "Mayor de edad" : "Menor de edad";
}
```

### Composer

[Composer](https://getcomposer.org/) es el gestor de dependencias de PHP. Un `composer.json` mínimo con autoload PSR-4:

```json
{
    "name": "tu-nombre/mi-proyecto",
    "description": "Un proyecto PHP de ejemplo",
    "require": {
        "php": ">=8.1"
    },
    "autoload": {
        "psr-4": {
            "App\\": "src/"
        }
    }
}
```

Comandos esenciales:

```bash
composer install          # instala las dependencias
composer require vendor/paquete
composer dump-autoload    # regenera el autoloader
php index.php             # ahora App\X carga solo desde src/
```

Con `"App\\": "src/"`, la clase `App\Tienda\Producto` se busca en `src/Tienda/Producto.php` sin ningún `require`.

### Tests con aserciones (CLI)

Sin frameworks, puedes escribir tests con aserciones manuales:

```php
<?php
require __DIR__ . "/mi_codigo.php";

$errores = [];
function check(bool $condicion, string $mensaje): void
{
    global $errores;
    if (!$condicion) {
        $errores[] = $mensaje;
    }
}

check(sumar(2, 3) === 5, "sumar(2, 3) debe ser 5");

if ($errores !== []) {
    fwrite(STDERR, implode(PHP_EOL, $errores) . PHP_EOL);
    exit(1);
}
echo "OK: todas las aserciones pasaron." . PHP_EOL;
exit(0);
```

## Ejemplos de código

```php
// Reintentar una operación que puede fallar
function conReintentos(callable $operacion, int $intentos = 3): mixed
{
    for ($i = 1; $i <= $intentos; $i++) {
        try {
            return $operacion();
        } catch (Exception $e) {
            if ($i === $intentos) {
                throw $e;
            }
        }
    }
    return null;
}
```

```php
// Registrar errores en un archivo de log
function registrar(Throwable $e): void
{
    $linea = "[" . date("Y-m-d H:i:s") . "] " . $e->getMessage() . PHP_EOL;
    file_put_contents(__DIR__ . "/errores.log", $linea, FILE_APPEND);
}
```

## Ejercicios relacionados

- [Ejercicios nivel 02 — Errores y excepciones](../ejercicios/nivel-02-basico/)
- [Ejercicios nivel 03 — Composer](../ejercicios/nivel-03-intermedio/)
- [Ejercicios nivel 04 — Testing](../ejercicios/nivel-04-avanzado/)

## Errores comunes

- **Capturar `Exception` antes de los tipos específicos** → la específica nunca llega a ejecutarse.
- **No usar `finally` para liberar recursos** → deja conexiones y archivos abiertos.
- **Tragarse la excepción con un `catch` vacío** → oculta bugs; al menos registra el error.
- **`throw` sin objeto** → solo se puede lanzar `Throwable` (PHP 7+).
- **Olvidar `composer dump-autoload`** tras cambiar el `autoload` del `composer.json`.

## Recursos

- [PHP.net — Excepciones](https://www.php.net/manual/es/language.exceptions.php)
- [PHP.net — Throwable](https://www.php.net/manual/es/class.throwable.php)
- [Composer — Documentación](https://getcomposer.org/doc/)
- [PHP-FIG — PSR-4](https://www.php-fig.org/psr/psr-4/es/)