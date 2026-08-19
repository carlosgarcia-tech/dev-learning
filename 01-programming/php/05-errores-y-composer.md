# 05 — Errores y Composer

## Objetivos

- [ ] Diferenciar los fallos que puede sufrir un programa PHP.
- [ ] Comprender la jerarquía `Throwable` con `Error` y `Exception`.
- [ ] Lanzar excepciones con `throw` y decidir cuándo usarlas.
- [ ] Capturarlas con `try/catch/finally` y capturar `Throwable`.
- [ ] Manejar múltiples `catch` respetando el orden específico → general.
- [ ] Crear excepciones propias extendiendo `Exception` y `RuntimeException`.
- [ ] Leer el contexto de un fallo con `getMessage()`, `getCode()`, `getTrace()`.
- [ ] Relanzar excepciones y añadir contexto sin perder la traza original.
- [ ] Configurar el nivel de reporte con `error_reporting()` e `ini_set()`.
- [ ] Instalar controladores de errores y excepciones con `set_error_handler()` y `set_exception_handler()`.
- [ ] Usar `assert()` para pruebas rápidas de desarrollo.
- [ ] Crear un `composer.json` con `require` y autoload PSR-4.
- [ ] Dominar `composer install`, `composer update` y el archivo `composer.lock`.
- [ ] Definir scripts de Composer y crear proyectos con `composer create-project`.
- [ ] Escribir y ejecutar tests con PHPUnit (estructura mínima).

## Apuntes

### ¿Qué es un fallo en PHP?

Cuando un programa PHP se encuentra con una situación anómala —una división entre cero, una función inexistente, un tipo incorrecto o una conexión perdida— el motor debe decidir qué hacer. Hasta PHP 5.0, casi todos estos casos generaban un *error* del motor (`E_WARNING`, `E_NOTICE`, `E_ERROR`…) que se imprimía por pantalla y, en el peor de los casos, detenía el script. A partir de PHP 7, el lenguaje unificó el manejo de fallos bajo un único contrato: la interfaz `Throwable`. La gran idea: **todo** lo que sale mal en tu aplicación puede ser capturado de forma programática con `try/catch`, sin depender de mensajes de texto que se escapan por la consola. Esto permite escribir programas que detectan, registran y responden a los fallos de forma controlada.

### La jerarquía `Throwable`

PHP 8 define una interfaz raíz llamada `Throwable`. Cualquier objeto que pueda lanzarse con `throw` debe implementarla. Las dos ramas principales son `Exception` (problemas de la aplicación) y `Error` (fallos internos del motor).

```
Throwable (interface)
 ├── Error
 │    ├── TypeError
 │    ├── ParseError
 │    ├── DivisionByZeroError
 │    ├── ValueError
 │    ├── ArithmeticError
 │    └── AssertionError
 └── Exception
      ├── RuntimeException
      │    ├── PDOException
      │    ├── DomainException
      │    ├── LogicException
      │    └── OutOfBoundsException ...
      └── InvalidArgumentException ...
```

#### `Exception` vs `Error`

| Criterio | `Exception` | `Error` |
| --- | --- | --- |
| Origen | Tu código o librerías (datos inválidos, red, BD) | El motor de PHP (tipos, sintaxis, división por cero) |
| Ejemplos | `InvalidArgumentException`, `PDOException`, `RuntimeException` | `TypeError`, `ParseError`, `DivisionByZeroError` |
| ¿Se pueden lanzar? | Sí, con `throw` | Sí, con `throw` (no es habitual) |
| ¿Se capturan con `catch`? | Sí | Sí, siempre que captures `Error` o `Throwable` |
| ¿El programa puede recuperarse? | A menudo sí | En general no; casi siempre son bugs |

En la práctica, la distinción te sirve para decidir qué capturar: **`Exception`** cuando el fallo es esperable (datos malos, red caída), **`Error`** cuando quieres convertir un fallo del motor en un mensaje amigable en el punto más alto de la aplicación, y **`Throwable`** en los puntos de salida para no dejar escapar ningún fallo sin registrar.

### Errores del motor en PHP 8

PHP 8 incorporó varios subtipos de `Error` que sustituyen a los antiguos avisos poco informativos:

| Clase | Cuándo se lanza | Ejemplo |
| --- | --- | --- |
| `TypeError` | Un argumento o retorno no cumple el tipo declarado | `function f(int $x) {}` llamado con `f("hola")` |
| `ParseError` | El código no es sintácticamente válido | `eval("echo ;")` o un archivo con un `;` mal puesto |
| `ValueError` | El tipo es correcto pero el valor no es válido | `array_fill(-1, 3, "x")` |
| `DivisionByZeroError` | Se divide o calcula el módulo con `0` y el resultado no es float | `intdiv(10, 0)` |
| `AssertionError` | Una `assert()` falla en el entorno adecuado | `assert(1 === 2)` |

### Errores clásicos: `E_WARNING`, `E_NOTICE`, `E_ERROR`

Además de las excepciones, PHP sigue usando los **niveles de error** clásicos para situaciones que no lanzan excepciones (muchas funciones heredadas, como `file_get_contents()`, siguen emitiendo warnings en lugar de lanzar excepciones):

| Nivel | Constante | Severidad |
| --- | --- | --- |
| Error fatal | `E_ERROR` | Detiene el script |
| Aviso en ejecución | `E_WARNING` | No detiene el script |
| Aviso leve | `E_NOTICE` | Posible bug, no detiene |
| Aviso de deprecación | `E_DEPRECATED` | Se usará algo obsoleto |
| Aviso estricto | `E_STRICT` | Recomendaciones de estilo |
| Error de usuario | `E_USER_ERROR` | Lanzado por tu código con `trigger_error()` |
| Todos | `E_ALL` | Máscara que incluye todos los anteriores |

Estos niveles se controlan con `error_reporting()`, `ini_set()` y `trigger_error()`:

```php
<?php
declare(strict_types=1);

// En desarrollo: mostrar absolutamente todo
error_reporting(E_ALL);

// Emitir un aviso propio
trigger_error("Método antiguo, usa alternativa()", E_USER_DEPRECATED);
```

Reglas prácticas: en **desarrollo**, activa `E_ALL` y `display_errors=1` para ver cada aviso; en **producción**, `display_errors=0` (los detalles van al log) y `log_errors=1`. No ignores `E_NOTICE` ni `E_DEPRECATED`: suelen revelar bugs reales.

### Lanzar excepciones: `throw`

Para lanzar una excepción se usa la palabra reservada `throw` seguida de una instancia de `Throwable`:

```php
<?php
declare(strict_types=1);

function raizCuadrada(float $n): float
{
    if ($n < 0) {
        throw new InvalidArgumentException("No existe la raíz cuadrada de $n");
    }
    return sqrt($n);
}

echo raizCuadrada(9);  // 3
// echo raizCuadrada(-1); // lanza InvalidArgumentException
```

`throw` tiene tres efectos:

1. Detiene la ejecución del método/función actual.
2. Propaga el objeto hacia arriba en la pila de llamadas hasta encontrar un `catch` que lo capture.
3. Si nadie lo captura, PHP lo convierte en un error fatal no capturado (y, si hay un `set_exception_handler`, se lo pasa a él).

### Capturar excepciones: `try/catch/finally`

El bloque `try` envuelve el código que puede fallar; `catch` captura el tipo declarado; `finally` se ejecuta siempre:

```php
<?php
declare(strict_types=1);

function conectar(): void
{
    throw new RuntimeException("Conexión rechazada");
}

try {
    conectar();
    echo "Conectado\n";
} catch (RuntimeException $e) {
    echo "No se pudo conectar: " . $e->getMessage() . "\n";
} finally {
    echo "Siempre paso por aquí\n";
}
// Salida:
// No se pudo conectar: Conexión rechazada
// Siempre paso por aquí
```

#### `finally`: liberar recursos

`finally` se ejecuta **aunque** haya o no excepción y **aunque** el `catch` haga `return` o `throw`. Es el lugar correcto para cerrar archivos, liberar conexiones o restaurar estados:

```php
<?php
declare(strict_types=1);

$manejador = fopen("/tmp/datos.txt", "r");
try {
    // leer y procesar...
    if (trim((string) stream_get_contents($manejador)) === "") {
        throw new RuntimeException("Archivo vacío");
    }
} catch (RuntimeException $e) {
    error_log($e->getMessage());
} finally {
    fclose($manejador); // se cierra pase lo que pase
}
```

### Capturar varios tipos de excepción

Un `try` puede tener varios bloques `catch`, cada uno para un tipo, desde el más específico al más general:

#### El orden importa

PHP elige el **primer** `catch` cuyo tipo sea compatible. Por eso:

- Captura primero las excepciones **más específicas**.
- Deja las generales (`Exception`, `Throwable`) para el final.
- Un `catch (Throwable $e)` al principio haría inalcanzables todos los demás.

```php
<?php
declare(strict_types=1);

try {
    // operación que puede fallar por distintas razones (BD, tipos, red...)
    $stmt = (new PDO("mysql:host=localhost;dbname=tienda", "root", "clave"))
        ->query("SELECT * FROM productos");
} catch (PDOException $e) {
    echo "Problema de base de datos.\n";
} catch (TypeError $e) {
    echo "El código pasó un tipo incorrecto.\n";
} catch (Throwable $e) {
    echo "Otro fallo: " . $e->getMessage() . "\n";
}

try {
    throw new RuntimeException("¡ups!");
} catch (RuntimeException $e) {        // primero lo específico
    echo "Runtime: " . $e->getMessage() . "\n";
} catch (Exception $e) {               // luego lo general
    echo "Exception: " . $e->getMessage() . "\n";
}
```

#### Capturar `Throwable`

Si quieres estar seguro de que **ningún** fallo (ni `Error` ni `Exception`) salga del bloque, captura `Throwable`:

```php
<?php
declare(strict_types=1);

function procesar(array $datos): void
{
    try {
        // puede lanzar Exception (aplicación) o Error (motor)
        intdiv(10, $datos["divisor"]);
    } catch (Throwable $e) {
        error_log("Fallo capturado: " . $e->getMessage());
        // continúa con la ejecución del programa
    }
}

procesar(["divisor" => 0]); // DivisionByZeroError capturado
echo "El programa sigue vivo.\n";
```

### Excepciones personalizadas

Cuando `InvalidArgumentException` o `RuntimeException` no expresan bien el dominio de tu problema, crea tus propias clases. Basta con extender `Exception` (o una subclase).

#### Extender `Exception`

```php
<?php
declare(strict_types=1);

class EdadInvalidaException extends Exception
{
}

function validarEdad(int $edad): string
{
    if ($edad < 0 || $edad > 150) {
        throw new EdadInvalidaException("La edad $edad no es válida");
    }
    return $edad >= 18 ? "Mayor de edad" : "Menor de edad";
}

try {
    echo validarEdad(-5);
} catch (EdadInvalidaException $e) {
    echo "Validación: " . $e->getMessage() . "\n";
}
```

#### Extender `RuntimeException`

`RuntimeException` representa fallos que solo se detectan *en ejecución* (conexiones, archivos, entradas del usuario). Extenderla te permite seguir capturando todo lo de "tiempo de ejecución" con un único `catch (RuntimeException $e)`:

```php
<?php
declare(strict_types=1);

class ConexionFallidaException extends RuntimeException
{
}

function obtenerConexion(): PDO
{
    try {
        return new PDO("mysql:host=localhost;dbname=tienda", "root", "clave");
    } catch (PDOException $e) {
        throw new ConexionFallidaException(
            "No se pudo conectar con la base de datos",
            previous: $e,
        );
    }
}
```

Fíjate en el argumento nombrado `previous: $e`: así la excepción nueva conserva la causa original (útil para el log).

#### Excepciones con código y propiedades propias

Puedes pasar un código numérico al constructor y añadir propiedades propias para dar más contexto: `throw new SaldoInsuficienteException($saldo, $intento, $cuentaId)` y luego leer `$e->getCode()`, `$e->saldoActual`, `$e->cuentaId`, etc. Así el capturador recibe todo lo necesario sin parsear texto.

### Métodos de las excepciones

Todo objeto `Throwable` ofrece un conjunto de métodos para inspeccionar el fallo:

| Método | Devuelve | Útil para |
| --- | --- | --- |
| `getMessage()` | Texto del mensaje | Mostrar/loguear el motivo |
| `getCode()` | Código numérico (o el que se pase) | Clasificar errores para una API |
| `getFile()` | Ruta del archivo donde se lanzó | Localizar el origen |
| `getLine()` | Línea exacta donde se lanzó | Localizar el origen |
| `getTrace()` | Array con la pila de llamadas | Depurar en profundidad |
| `getTraceAsString()` | La pila como texto plano | Logs legibles |
| `getPrevious()` | La excepción causante (si la hay) | Cadenas de causa | 

Ejemplo de uso conjunto: `$e->getMessage()` para el log, `$e->getCode()` para clasificar el fallo, y `$e->getTraceAsString()` para la pila completa.

### Relanzar excepciones

A veces capturas una excepción para hacer un registro o una limpieza, pero quieres que el fallo siga propagándose hacia arriba. Se usa `throw $e;` (o `throw;` dentro del `catch`, que relanza la excepción que se está capturando):

```php
<?php
declare(strict_types=1);

function procesarPedido(int $id): void
{
    try {
        // ... lógica que puede lanzar PDOException
    } catch (PDOException $e) {
        error_log("Fallo al procesar pedido $id: " . $e->getMessage());
        throw $e;               // re-lanzar: el llamador decide cómo reaccionar
    }
}
```

#### Relanzar con contexto adicional

Si quieres añadir contexto sin perder la causa original, envuélvela con el parámetro `previous`:

```php
<?php
declare(strict_types=1);

class PedidoFallidoException extends RuntimeException
{
}

function procesarPedido(int $id): void
{
    try {
        throw new PDOException("query fallida");
    } catch (PDOException $e) {
        throw new PedidoFallidoException(
            "No se pudo procesar el pedido $id",
            previous: $e,
        );
    }
}
```

Así, el log de nivel superior ve el mensaje legible y, si se necesita, recupera la causa original con `getPrevious()`.

### Configurar el nivel de errores

El comportamiento ante los errores clásicos se controla con `error_reporting()` (función) y con directivas de `php.ini` que también puedes cambiar en tiempo de ejecución con `ini_set()`. En producción, la combinación segura es `display_errors=0` + `log_errors=1`: el usuario jamás ve rutas ni SQL, y el desarrollador revisa el log del servidor.

```php
<?php
declare(strict_types=1);

// Nivel de errores que se reportan
error_reporting(E_ALL);                                    // todo
// error_reporting(E_ALL & ~E_DEPRECATED & ~E_NOTICE);     // menos ruido

// Mostrar errores en pantalla (SOLO en desarrollo)
ini_set("display_errors", "1");

// Guardar errores en el log (recomendado en producción)
ini_set("log_errors", "1");
ini_set("error_log", __DIR__ . "/logs/php-error.log");
```

### `set_error_handler()` y `set_exception_handler()`

Cuando los errores clásicos no te bastan, PHP permite secuestrar el comportamiento por defecto:

- **`set_error_handler()`** — recibe cualquier `E_WARNING`, `E_NOTICE`, etc. Puedes convertirlos en excepciones y unificar todo el manejo bajo `try/catch`.
- **`set_exception_handler()`** — función que se llama si una excepción **no se captura**. Es el último recurso: ideal para el *front controller* de una aplicación.

```php
<?php
declare(strict_types=1);

// Convertir todos los warnings en excepciones
set_error_handler(
    static function (int $severidad, string $mensaje, string $archivo, int $linea): never {
        throw new ErrorException($mensaje, 0, $severidad, $archivo, $linea);
    },
);

// Capturador global de excepciones no manejadas
set_exception_handler(
    static function (Throwable $e): void {
        error_log("[NO CAPTURADA] " . $e->getMessage());
        http_response_code(500);
        echo "Algo salió mal. Inténtalo de nuevo.\n";
    },
);

// A partir de aquí, incluso los warnings son capturables
try {
    strpos("abc", "x"); // ya no emite warning silencioso
} catch (ErrorException $e) {
    echo "Convertido a excepción: " . $e->getMessage() . "\n";
}
```

### `assert()` para pruebas rápidas

En desarrollo, `assert()` es una forma ligera de comprobar invariantes: si la expresión es falsa, lanza `AssertionError`. Para que funcione, las aserciones deben estar activadas (por defecto `zend.assertions=1` en desarrollo y `-1` en producción):

```php
<?php
declare(strict_types=1);

function suma(int $a, int $b): int
{
    return $a + $b;
}

assert(suma(2, 3) === 5, "suma(2, 3) debe ser 5");
assert(suma(-1, 1) === 0, "suma(-1, 1) debe ser 0");
echo "Aserciones de suma OK\n";
```

Advertencia: `assert()` se puede desactivar en producción (`zend.assertions=-1` en `php.ini`), así que **no** lo uses para validar datos reales de tu aplicación: solo para invariantes internas durante el desarrollo. Para validar entrada del usuario usa `throw` con excepciones.

### Composer: el gestor de dependencias

[Composer](https://getcomposer.org/) es el gestor de paquetes y dependencias de PHP (equivalente a `npm` en Node o `pip` en Python): declaras qué necesita el proyecto en `composer.json`, ejecutas `composer install` y Composer descarga, resuelve versiones y genera el autoloader.

#### Instalación de Composer

```bash
# Descargar e instalar de forma local al proyecto
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php composer-setup.php
php -r "unlink('composer-setup.php');"

# Comprobar la versión
composer --version
```

#### `composer.json`: estructura básica

```json
{
    "name": "tu-nombre/mi-proyecto",
    "description": "Un proyecto PHP de ejemplo",
    "type": "project",
    "license": "MIT",
    "require": {
        "php": ">=8.1",
        "monolog/monolog": "^3.0"
    },
    "require-dev": {
        "phpunit/phpunit": "^11.0"
    },
    "autoload": {
        "psr-4": {
            "App\\": "src/"
        }
    },
    "autoload-dev": {
        "psr-4": {
            "App\\Tests\\": "tests/"
        }
    },
    "scripts": {
        "test": "phpunit"
    },
    "config": {
        "sort-packages": true
    }
}
```

Campos principales:

| Campo | Significado |
| --- | --- |
| `name` | `autor/paquete` en minúsculas y con guiones |
| `require` | Dependencias de producción (incluye la versión de PHP) |
| `require-dev` | Dependencias solo para desarrollo (tests, herramientas) |
| `autoload` | Reglas de autoloading del código del proyecto |
| `autoload-dev` | Autoloading de archivos de desarrollo (tests) |
| `scripts` | Comandos útiles ejecutables con `composer run <nombre>` |

#### `composer install` y el archivo `composer.lock`

- **`composer install`** — lee `composer.lock` (si existe) e instala exactamente las versiones ahí fijadas. Es el comando que se ejecuta tras clonar un repositorio y en los despliegues.
- **`composer.lock`** — archivo generado automáticamente que **fija las versiones exactas** instaladas. Se debe subir al control de versiones para que todos (y los servidores) usen exactamente las mismas dependencias.
- **`composer update`** — recalcula las versiones según los rangos de `composer.json` y regenera `composer.lock`. Se usa cuando *quieres* actualizar, no para instalar.

```bash
composer install        # instala lo que ya está en composer.lock
composer update         # actualiza dependencias y regenera el lock
composer update monolog # actualiza solo un paquete
```

#### `composer require`

`composer require` es el atajo para añadir dependencias sin editar el JSON a mano:

```bash
composer require monolog/monolog     # añade a "require" y lo instala
composer require --dev phpunit/phpunit  # añade a "require-dev"
```

#### Versiones y rangos

| Especificación | Significado |
| --- | --- |
| `1.2.3` | Versión exacta |
| `^1.2` | `>= 1.2` y `< 2.0` (compatible con mayores menores) |
| `~1.2` | `>= 1.2` y `< 1.3` (parches y menores, sin mayores) |
| `>= 8.1` | Desde esa versión en adelante |
| `*` | Cualquiera (evita, poco reproducible) |

### Autoload PSR-4

PSR-4 (PHP Standards Recommendation 4) define cómo mapear **namespaces a directorios**: `App\Tienda\Producto` → `src/Tienda/Producto.php`. Composer genera un autoloader que resuelve las clases automáticamente, sin `require` manual.

```json
{
    "autoload": {
        "psr-4": {
            "App\\": "src/"
        }
    }
}
```

Con esa configuración, el autoloader de Composer carga:

- `App\Tienda\Producto` → `src/Tienda/Producto.php`
- `App\Servicios\Carrito` → `src/Servicios/Carrito.php`

El primer segmento del namespace (`App`) se sustituye por el directorio raíz (`src/`) y el resto de segmentos por los subdirectorios y el archivo `NombreClase.php`.

#### `vendor/autoload.php`

`composer install` (o `require`) crea el directorio `vendor/` con todas las dependencias y, entre ellas, el autoloader `vendor/autoload.php`. Todo proyecto debe cargarlo una única vez, normalmente en el punto de entrada:

```php
<?php
declare(strict_types=1);

require __DIR__ . "/vendor/autoload.php";

use App\Tienda\Producto;

$producto = new Producto("Laptop", 1200.0);
echo $producto->nombre . "\n"; // carga App\Tienda\Producto automáticamente
```

Regla de oro: **un solo `require vendor/autoload.php`** en el punto de entrada de tu aplicación.

#### `composer dump-autoload`

Cuando añades clases nuevas, archivos o cambias el mapeo `autoload` en `composer.json`, hay que regenerar el autoloader:

```bash
composer dump-autoload          # regenera el autoloader
composer dump-autoload -o       # optimizado (mapa de clases completo)
```

Es muy común olvidarlo tras crear la primera clase en un proyecto nuevo.

### Scripts de Composer

`composer.json` permite definir comandos propios en `scripts` para no memorizar largas cadenas:

```json
{
    "scripts": {
        "test": "phpunit",
        "test:unit": "phpunit --testsuite unit",
        "lint": "php -l src/",
        "dev": "php -S localhost:8000 -t public"
    }
}
```

Se ejecutan con:

```bash
composer test       # = phpunit
composer run lint   # = php -l src/
composer run dev
```

### `composer create-project`

`create-project` descarga un proyecto completo (normalmente un framework o una plantilla) ya configurado y con sus dependencias instaladas:

```bash
# Descarga Laravel, instala dependencias y deja el proyecto listo
composer create-project laravel/laravel mi-app

# Puedes indicar una versión
composer create-project laravel/laravel mi-app "11.*"
```

### PHPUnit: tests profesionales

Para tests serios se usa [PHPUnit](https://phpunit.de/), el estándar de facto. Se instala como dependencia de desarrollo:

```bash
# Instalar PHPUnit (requiere phpunit/phpunit en require-dev)
composer require --dev phpunit/phpunit

# Generar el archivo de configuración
vendor/bin/phpunit --generate-configuration

# Ejecutar todos los tests
vendor/bin/phpunit
```

#### Estructura mínima de un test

Los tests se escriben en clases que extienden `PHPUnit\Framework\TestCase`. Cada método `test*` es un test; las aserciones se declaran con los métodos `assert*`:

```php
<?php
declare(strict_types=1);

namespace App\Tests;

use PHPUnit\Framework\TestCase;

final class CalculadoraTest extends TestCase
{
    public function testSumaDevuelveLaSumaDeDosNumeros(): void
    {
        $calculadora = new Calculadora();
        $this->assertSame(5, $calculadora->suma(2, 3));
    }

    public function testSumaConNegativos(): void
    {
        $calculadora = new Calculadora();
        $this->assertSame(-4, $calculadora->suma(-1, -3));
    }
}
```

Y el código bajo test:

```php
<?php
declare(strict_types=1);

namespace App;

final class Calculadora
{
    public function suma(int $a, int $b): int
    {
        return $a + $b;
    }
}
```

#### `phpunit.xml` y aserciones comunes

La configuración mínima de PHPUnit va en `phpunit.xml` (carga el autoloader, activa colores y apunta a `tests`):

```xml
<?xml version="1.0" encoding="UTF-8"?>
<phpunit xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         bootstrap="vendor/autoload.php"
         colors="true">
    <testsuites>
        <testsuite name="Unit">
            <directory>tests</directory>
        </testsuite>
    </testsuites>
</phpunit>
```

Las aserciones más usadas son `assertSame()` (igualdad estricta), `assertEquals()` (con conversión), `assertTrue()`/`assertFalse()`, `assertNull()`, `assertCount()`, `assertContains()`, `assertInstanceOf()` y `expectException()`.

Test que verifica una excepción:

```php
<?php
declare(strict_types=1);

namespace App\Tests;

use PHPUnit\Framework\TestCase;
use App\Calculadora;

final class CalculadoraTest extends TestCase
{
    public function testDivisionEntreCeroLanzaExcepcion(): void
    {
        $this->expectException(\InvalidArgumentException::class);
        $this->expectExceptionMessage("No se puede dividir entre cero");

        (new Calculadora())->dividir(10, 0);
    }
}
```

## Ejemplos de código

### Ejemplo 1: manejo centralizado de errores (front controller)

```php
<?php
declare(strict_types=1);

// 1. Convertir todos los avisos clásicos en excepciones
set_error_handler(
    static function (int $sev, string $msg, string $file, int $line): never {
        throw new ErrorException($msg, 0, $sev, $file, $line);
    },
);

// 2. Capturador global para fallos no controlados
set_exception_handler(
    static function (Throwable $e): void {
        error_log(
            "[" . date("c") . "] " . $e::class . ": " . $e->getMessage()
            . " en " . $e->getFile() . ":" . $e->getLine(),
        );
        http_response_code(500);
        echo "Error interno. Revisa el log.\n";
    },
);

// 3. Cualquier fallo termina en el handler anterior
function negocioRiesgoso(): void
{
    $archivo = "/tmp/que-no-existe.txt";
    if (!file_exists($archivo)) {
        throw new RuntimeException("Falta el archivo de configuración");
    }
}

negocioRiesgoso(); // el handler registra y responde 500
```

### Ejemplo 2: retry con reintentos y relanzado

```php
<?php
declare(strict_types=1);

function conReintentos(callable $operacion, int $intentos = 3): mixed
{
    for ($i = 1; $i <= $intentos; $i++) {
        try {
            return $operacion();
        } catch (RuntimeException $e) {
            error_log("Intento $i fallido: " . $e->getMessage());
            if ($i === $intentos) {
                throw $e; // último intento: relanzar
            }
            usleep(200_000); // espera 200 ms antes de reintentar
        }
    }
    return null; // inalcanzable
}

$llamadas = 0;
$resultado = conReintentos(static function () use (&$llamadas): int {
    $llamadas++;
    if ($llamadas < 3) {
        throw new RuntimeException("Servicio no disponible");
    }
    return 42;
});
echo "Resultado: $resultado (tras $llamadas llamadas)\n";
```

### Ejemplo 3: autoload PSR-4 con Composer y PHPUnit

`composer.json`:

```json
{
    "name": "ana/calculadora",
    "require": {
        "php": ">=8.1"
    },
    "require-dev": {
        "phpunit/phpunit": "^11.0"
    },
    "autoload": {
        "psr-4": {
            "App\\": "src/"
        }
    },
    "autoload-dev": {
        "psr-4": {
            "App\\Tests\\": "tests/"
        }
    },
    "scripts": {
        "test": "phpunit"
    }
}
```

`src/Calculadora.php`:

```php
<?php
declare(strict_types=1);

namespace App;

class Calculadora
{
    public function dividir(int $a, int $b): float
    {
        if ($b === 0) {
            throw new \InvalidArgumentException("No se puede dividir entre cero");
        }
        return $a / $b;
    }
}
```

`tests/CalculadoraTest.php`:

```php
<?php
declare(strict_types=1);

namespace App\Tests;

use App\Calculadora;
use InvalidArgumentException;
use PHPUnit\Framework\TestCase;

class CalculadoraTest extends TestCase
{
    public function testDivideNumerosCorrectamente(): void
    {
        $this->assertSame(5.0, (new Calculadora())->dividir(10, 2));
    }

    public function testDivideEntreCeroLanzaExcepcion(): void
    {
        $this->expectException(InvalidArgumentException::class);
        (new Calculadora())->dividir(1, 0);
    }
}
```

```bash
composer install
composer test          # ejecuta vendor/bin/phpunit
```

## Ejercicios relacionados

- [Ejercicios nivel 02 — Errores y excepciones](../ejercicios/nivel-02-basico/)
- [Ejercicios nivel 03 — Composer y autoload](../ejercicios/nivel-03-intermedio/)
- [Ejercicios nivel 04 — Testing](../ejercicios/nivel-04-avanzado/)

## Errores comunes

- **Capturar `Exception` antes que los tipos específicos** → el `catch` específico nunca se ejecuta. Ordena de lo específico a lo general, con `Throwable` al final.
- **Capturar `Exception` cuando se lanza un `Error`** → un `TypeError` o `DivisionByZeroError` no es una `Exception`, así que se escapa. Captura `Throwable` si quieres cubrir todo.
- **Tragarse la excepción con un `catch` vacío** → `catch (Throwable $e) { }` oculta bugs en silencio. Al menos registra con `error_log()`.
- **`throw` sin un objeto `Throwable`** → `throw "mensaje";` falla en PHP 8. Solo se lanzan instancias de `Throwable`: `throw new RuntimeException("...")`.
- **No usar `finally` para liberar recursos** → si el `catch` hace `return` o `throw`, el cierre nunca se ejecuta. Pon `fclose()`, `$pdo = null`, etc. en `finally`.
- **Relanzar sin `throw;` o `throw $e;`** → si "relanzas" creando una excepción nueva sin `previous`, pierdes la traza original.
- **Mostrar `getMessage()` al usuario final** → expone rutas, SQL e IPs. Loguea el detalle y muestra un mensaje genérico.
- **Usar `assert()` para validar entrada de usuario** → `assert()` se desactiva en producción (`zend.assertions=-1`). Valida siempre con `throw`/excepciones.
- **Olvidar `composer install` después de clonar un repo** → el proyecto no tiene `vendor/` hasta que ejecutes `composer install`.
- **Subir `vendor/` al repositorio o no subir `composer.lock`** → `vendor/` se regenera con el lock; el lock garantiza versiones idénticas en todos los entornos. Ignora `vendor/` en `.gitignore` y versiona `composer.lock`.
- **Editar `composer.json` y olvidar `composer dump-autoload`** → las clases nuevas con PSR-4 no cargan hasta regenerar el autoloader.
- **`composer update` cuando solo quieres instalar** → `update` cambia versiones y regenera el lock. Para reproducir un entorno usa `composer install`.
- **Rangos de versión demasiado laxos (`*`)** → instalaciones impredecibles. Usa `^` para permitir solo actualizaciones compatibles.
- **Dos `require vendor/autoload.php` en el mismo proceso** → PHP avisa con un warning "already loaded". Cárgalo una sola vez en el punto de entrada.
- **Asumir que `E_NOTICE` no importa** → en PHP 8 muchos avisos se volvieron `E_WARNING` o excepciones. Ejecuta con `error_reporting(E_ALL)` en desarrollo.
- **Hacer `composer require` sin `--dev` para herramientas** → PHPUnit y similares acaban en `require` (producción) y se instalan en los servidores. Usa `--dev`.

## Recursos

- [PHP.net — Excepciones](https://www.php.net/manual/es/language.exceptions.php)
- [PHP.net — Throwable](https://www.php.net/manual/es/class.throwable.php)
- [PHP.net — Errores y manejo de errores](https://www.php.net/manual/es/book.errorfunc.php)
- [PHP.net — error_reporting](https://www.php.net/manual/es/function.error-reporting.php)
- [PHP.net — set_error_handler](https://www.php.net/manual/es/function.set-error-handler.php)
- [PHP.net — set_exception_handler](https://www.php.net/manual/es/function.set-exception-handler.php)
- [PHP.net — assert](https://www.php.net/manual/es/function.assert.php)
- [Composer — Documentación oficial](https://getcomposer.org/doc/)
- [Composer — composer.json schema](https://getcomposer.org/doc/04-schema.md)
- [PHP-FIG — PSR-4 Autoloader](https://www.php-fig.org/psr/psr-4/es/)
- [PHPUnit — Documentación](https://docs.phpunit.de/)