# 03 — Programación Orientada a Objetos en PHP

## Objetivos

- [ ] Definir clases con `class` y crear objetos con `new`.
- [ ] Declarar propiedades con visibilidad (`public`, `private`, `protected`), tipos y `readonly`.
- [ ] Escribir métodos con visibilidad, `$this` y tipos de retorno, incluidos métodos `static`.
- [ ] Usar `__construct` con promoción de propiedades del constructor (PHP 8).
- [ ] Implementar herencia con `extends`, `parent::`, `protected` y sobrescritura de métodos.
- [ ] Aplicar `final` para impedir herencia o sobrescritura.
- [ ] Definir e implementar interfaces, incluidas varias a la vez.
- [ ] Reutilizar código con traits y resolver conflictos con `insteadof` y `as`.
- [ ] Crear clases abstractas con métodos abstractos.
- [ ] Diferenciar `self`, `static` y `$this`, y entender el late static binding.
- [ ] Usar métodos mágicos como `__get`, `__set`, `__call`, `__toString`, `__invoke` y `__clone`.
- [ ] Organizar el código con namespaces, `use`, alias `as` y `use function`/`use const`.
- [ ] Implementar autoload con `spl_autoload_register` y entender PSR-4 y Composer.
- [ ] Definir enums de PHP 8.1 con casos, valores y métodos.

## Apuntes

### Clases y objetos

Una **clase** es una plantilla que define propiedades (datos) y métodos (comportamiento). Un **objeto** es una instancia concreta, creada con `new`. La analogía clásica: la clase es el plano; el objeto es la construcción.

```php
<?php
declare(strict_types=1);
class Producto
{
    public string $nombre;
    public float $precio;
}
$laptop = new Producto();
$laptop->nombre = "Laptop";
$laptop->precio = 1200.0;
echo $laptop->nombre; // Laptop
```

PHP puede usar una clase antes de que aparezca su definición en el archivo (la carga es diferida). La convención PSR-1 recomienda una clase por archivo.

#### Propiedades y visibilidad

Las propiedades se declaran con visibilidad explícita y, desde PHP 7.4, con tipo. La visibilidad determina el ámbito de acceso:

| Visibilidad | Misma clase | Subclases | Fuera de la clase |
| --- | --- | --- | --- |
| `public` | Sí | Sí | Sí |
| `protected` | Sí | Sí | No |
| `private` | Sí | No | No |

```php
<?php
declare(strict_types=1);
class Cuenta
{
    public string $titular = "Anónimo";   // visible desde cualquier lugar
    protected int $saldo = 0;             // visible en la clase y subclases
    private string $claveSecreta = "";    // solo visible dentro de la clase
}
```

El acceso externo a propiedades `private`/`protected` se hace mediante **getters** y **setters** (métodos que leen y escriben).

#### Tipos de propiedades

PHP 7.4 añadió tipos a las propiedades; PHP 8 amplió el conjunto con `mixed`, uniones (`float|int`) e intersecciones. Reglas: una propiedad **tipada no inicializada** no puede leerse antes de asignarse (`Error: Typed property ... must not be accessed before initialization`); solo las `?Tipo` o `mixed` se inicializan con `null`. PHP 8.3 añadió el atributo `#[\Override]`, que verifica que un método realmente sobrescribe uno del padre.

#### Propiedades `readonly`

Una propiedad `readonly` (PHP 8.1) solo puede asignarse una vez, desde el ámbito de la clase. Ideal para **objetos de valor** y DTOs inmutables:

```php
<?php
declare(strict_types=1);
readonly class Punto
{
    public function __construct(public float $x, public float $y)
    {
    }
    public function distancia(): float
    {
        return sqrt($this->x ** 2 + $this->y ** 2);
    }
}
$p = new Punto(3.0, 4.0);
echo $p->distancia(); // 5
// $p->x = 9.0; // Error: Cannot modify readonly property
```

Detalles: no se combina con `static`; en PHP 8.1 solo admite visibilidad `public` (desde 8.2 se permiten `protected`/`private`); una clase `readonly class` (PHP 8.2) marca todas sus propiedades `readonly`.

### Métodos

Los métodos son funciones dentro de una clase, con visibilidad, tipos de parámetros y tipos de retorno.

#### `$this`

Dentro de un método no estático, `$this` se refiere a la **instancia actual**:

```php
<?php
declare(strict_types=1);
class Persona
{
    public function __construct(private string $nombre)
    {
    }
    public function presentarse(): string
    {
        return "Hola, soy {$this->nombre}";
    }
}
```

Errores típicos: usar `$this` en un método `static` (`Error: Using $this when not in object context`); omitirlo al referirse a una propiedad (`return $nombre;` busca una variable local); reasignarlo.

#### Tipos de retorno

Todo método declara el tipo devuelto con `: Tipo`. Además de los escalares existen `void` (prohíbe devolver valores), `never` (PHP 8.1: la función termina lanzando una excepción o con `exit()`, por lo que jamás retorna), `self`, `static` y `parent`.

#### Métodos `static`

Los métodos estáticos pertenecen a la **clase**, no a la instancia. Se llaman con `Clase::metodo()` y **no tienen `$this`**:

```php
<?php
declare(strict_types=1);
class Utilidades
{
    public static function slugificar(string $texto): string
    {
        return trim(preg_replace('/[^a-z0-9]+/', '-', strtolower(trim($texto))), '-');
    }
}
echo Utilidades::slugificar("Hola, Mundo PHP!"); // hola-mundo-php
```

Usos habituales: **factories** (`Usuario::crearAdmin($email)`), utilidades sin estado y configuración compartida vía propiedades estáticas (por ejemplo, `self::$total++` dentro de un contador de instancias).

### Constructores y destructores

#### `__construct`

`__construct` se ejecuta automáticamente al crear la instancia con `new`. PHP solo admite **un** constructor por clase (no hay sobrecarga); usa valores por defecto para emular varias firmas: `new Usuario("Ana", "a@b.dev")` usa `activo = false` si el parámetro no se pasa. Si la clase hija define constructor y el padre también, **debes llamar a `parent::__construct()`** explícitamente para que se ejecute la lógica del padre.

#### Promoción de propiedades del constructor (PHP 8)

PHP 8 permite declarar la propiedad y asignarla en **un solo paso** dentro de la firma del constructor. Es la forma idiomática de los DTOs:

```php
<?php
declare(strict_types=1);
class Factura
{
    public function __construct(
        private int $numero,
        public readonly string $cliente,
        private array $lineas = [],
        private ?float $descuento = null,
    ) {
    }
}
```

Equivale a declarar las propiedades arriba y hacer `$this->$prop = $prop` en el cuerpo. Reglas: solo funciona en el constructor; la visibilidad debe ser explícita (es lo que la activa); combina perfectamente con `readonly`.

#### `__destruct`

Se llama al destruirse el objeto (cuando no quedan referencias o al finalizar el script). Sirve para liberar recursos como sockets o archivos:

```php
<?php
declare(strict_types=1);
class RegistroLog
{
    private $manejador;
    public function __construct(private string $archivo)
    {
        $this->manejador = fopen($archivo, "a");
    }
    public function escribir(string $linea): void
    {
        fwrite($this->manejador, $linea . PHP_EOL);
    }
    public function __destruct()
    {
        fclose($this->manejador);
    }
}
```

No se garantiza el momento exacto de la llamada; para liberar recursos de forma determinista se prefieren bloques `try/finally` o `unset($objeto)`.

### Herencia

La herencia permite que una clase **hija** herede propiedades y métodos de una **padre** con `extends`. PHP tiene herencia **simple**: una clase solo extiende de una:

```php
<?php
declare(strict_types=1);
class Animal
{
    public function __construct(protected string $nombre)
    {
    }
    public function sonido(): string
    {
        return "...";
    }
}
class Perro extends Animal
{
    public function sonido(): string
    {
        return "Guau";
    }
}
$perro = new Perro("Rex");
echo $perro->sonido();          // Guau
echo $perro instanceof Animal;  // 1 (true)
```

`instanceof` verifica si un objeto es de una clase, de una subclase o implementa una interfaz.

#### `parent::`

Desde una subclase, `parent::` invoca métodos o el constructor del padre. Indispensable para **extender** el comportamiento en lugar de reemplazarlo:

```php
<?php
declare(strict_types=1);
class Vehiculo
{
    public function __construct(protected string $marca, protected int $ruedas)
    {
    }
    public function describir(): string
    {
        return "Vehículo {$this->marca} con {$this->ruedas} ruedas";
    }
}
class Coche extends Vehiculo
{
    public function __construct(string $marca)
    {
        parent::__construct($marca, 4);
    }
    public function describir(): string
    {
        return parent::describir() . " (turismo)";
    }
}
echo (new Coche("Toyota"))->describir(); // Vehículo Toyota con 4 ruedas (turismo)
```

#### `protected` y sobrescritura

Para que una subclase acceda a propiedades del padre deben ser `protected` o `public` (`private` es inaccesible incluso desde las subclases). Al sobrescribir:

- La visibilidad **no puede reducirse** (una `public` no puede volverse `private`).
- El tipo de retorno debe ser **covariante** (mismo o más específico).
- Los parámetros deben ser **contravariantes** (mismos o más generales).

El ejemplo de `Coche::describir()` de arriba ya muestra ambas cosas: mantiene la visibilidad y usa `parent::`.

#### `final`

`final` tiene dos usos: `final class` impide heredar la clase (`class MiConfig extends ConfiguracionGlobal` da `Error: Class cannot extend final class`), y `final function` impide sobrescribir el método. `final` no acelera el código: es una herramienta de **diseño** que comunica intención y protege comportamientos críticos. Los DTOs y utilidades suelen marcarse `final`.

### Interfaces

Una interfaz define un **contrato**: las firmas de los métodos que las clases que la implementan deben cumplir. No contiene implementación:

```php
<?php
declare(strict_types=1);
interface Almacenable
{
    public function guardar(): void;
    public function eliminar(): void;
}
```

#### `implements` y múltiples interfaces

Una clase puede implementar **varias** interfaces a la vez (a diferencia de la herencia múltiple de clases, que no existe):

```php
<?php
declare(strict_types=1);
interface Nombreable
{
    public function nombre(): string;
}
interface Serializable
{
    public function aArray(): array;
}
class Cliente implements Nombreable, Serializable
{
    public function __construct(private string $id, private string $nombre)
    {
    }
    public function nombre(): string
    {
        return $this->nombre;
    }
    public function aArray(): array
    {
        return ["id" => $this->id, "nombre" => $this->nombre];
    }
}
```

#### Métodos y constantes en interfaces

Los métodos de una interfaz son `public` por definición. También admiten **constantes**:

```php
<?php
declare(strict_types=1);
interface Calculable
{
    public const IVA = 0.21;
    public function totalConIva(): float;
}
class Pedido implements Calculable
{
    public function __construct(private float $subtotal)
    {
    }
    public function totalConIva(): float
    {
        return $this->subtotal * (1 + self::IVA);
    }
}
echo (new Pedido(100.0))->totalConIva(); // 121
```

Las interfaces pueden heredar de otras con `extends` (y una puede extender varias): `interface LeibleEscribible extends Leible, Escribible {}`. Además, `$objeto instanceof Interfaz` permite comprobar que un objeto cumple un contrato sin conocer su clase concreta; es la base del **polimorfismo por interfaz**: una función con parámetro `Leible $elemento` acepta cualquier clase que la implemente.

### Traits

Un **trait** es un fragmento de código reutilizable que se "inyecta" en una clase con `use`. Comparte las ventajas de la herencia múltiple sin sus peligros: la clase final decide qué métodos usa de cada trait:

```php
<?php
declare(strict_types=1);
trait Timestampable
{
    private string $creadoEn = "";
    public function marcarCreado(): void
    {
        $this->creadoEn = date("Y-m-d H:i:s");
    }
    public function creadoEn(): string
    {
        return $this->creadoEn;
    }
}
class Articulo
{
    use Timestampable;
    public function __construct(private string $titulo)
    {
    }
}
$articulo = new Articulo("Hola");
$articulo->marcarCreado();
echo $articulo->creadoEn(); // 2026-08-19 12:00:00
```

#### Conflicto entre traits: `insteadof` y `as`

Si dos traits definen el mismo método, hay conflicto. Se resuelve con `insteadof` (elijo cuál usar) y `as` (alias con otro nombre o visibilidad):

```php
<?php
declare(strict_types=1);
trait A
{
    public function saludo(): string
    {
        return "Hola desde A";
    }
}
trait B
{
    public function saludo(): string
    {
        return "Hola desde B";
    }
}
class Combinado
{
    use A, B {
        A::saludo insteadof B;        // uso el saludo de A
        B::saludo as saludoDeB;       // el de B queda con alias
        B::saludo as private privado; // además con visibilidad privada
    }
}
$c = new Combinado();
echo $c->saludo();     // Hola desde A
echo $c->saludoDeB();  // Hola desde B
```

#### Propiedades y precedencia

Los traits pueden declarar propiedades. Precedencia: 1) los métodos definidos **en la clase** ganan a los del trait; 2) los métodos del trait ganan a los heredados del padre. Si dos traits declaran la misma propiedad con tipos o visibilidad distintos, se produce error fatal: los traits "funden" su código en la clase.

### Clases abstractas

Una **clase abstracta** no puede instanciarse. Define comportamiento común y declara métodos **abstractos** que las subclases deben implementar:

```php
<?php
declare(strict_types=1);
abstract class Forma
{
    public function __construct(protected string $nombre)
    {
    }
    abstract public function area(): float; // obligatorio en subclases
    public function describe(): string
    {
        return "{$this->nombre}: área = " . $this->area();
    }
}
class Circulo extends Forma
{
    public function __construct(private float $radio)
    {
        parent::__construct("Círculo");
    }
    public function area(): float
    {
        return M_PI * $this->radio ** 2;
    }
}
echo (new Circulo(2.0))->describe(); // Círculo: área = 12.566370614359
```

Diferencias clave entre **interfaz** y **clase abstracta**:

| Criterio | Interfaz | Clase abstracta |
| --- | --- | --- |
| Métodos con cuerpo | No (por diseño) | Sí |
| Propiedades | No (solo constantes) | Sí |
| Una clase puede usar | Varias | Solo una |
| Constructor | No | Sí |
| Cuándo usarla | Contrato de comportamiento | Base compartida con estado |

Una clase puede hacer ambas: `class X extends Y implements A, B`.

### `self` vs `static` vs `$this`

- `$this` — el objeto actual (instancia). Solo en métodos no estáticos.
- `self::` — la clase **donde está escrito el código**, sin importar la subclase que lo llame.
- `static::` — la clase **que se está ejecutando** (resolución en tiempo de ejecución). Esto es el **late static binding**.

```php
<?php
declare(strict_types=1);
class Padre
{
    public static function quienSelf(): string
    {
        return self::clase();    // SIEMPRE "Padre"
    }
    public static function quienStatic(): string
    {
        return static::clase();  // la clase efectiva en ejecución
    }
    protected static function clase(): string
    {
        return "Padre";
    }
}
class Hijo extends Padre
{
    protected static function clase(): string
    {
        return "Hijo";
    }
}
echo Hijo::quienSelf();    // Padre  <- self se queda en la clase del código
echo Hijo::quienStatic();  // Hijo   <- static resuelve la subclase real
```

#### Late static binding en la práctica

El caso más útil: una clase base que devuelve instancias de la subclase que la extiende (patrón *factory* simple). PHP 8.0 introdujo el tipo de retorno `static`, que permite `public static function crear(): static { return new static(); }`: al llamar a `NotificadorEmail::crear()` obtienes una instancia real de `NotificadorEmail` (verificable con `get_class()`), no de la clase abstracta.### Métodos mágicos

Los métodos mágicos (empiezan con `__`) se invocan automáticamente ante ciertas operaciones.

#### `__get` y `__set`

Se disparan al leer o escribir una **propiedad inaccesible o inexistente**:

```php
<?php
declare(strict_types=1);
class Config
{
    private array $datos = ["db_host" => "localhost", "debug" => true];
    public function __get(string $nombre): mixed
    {
        return $this->datos[$nombre] ?? null;
    }
    public function __set(string $nombre, mixed $valor): void
    {
        $this->datos[$nombre] = $valor;
    }
}
$config = new Config();
echo $config->db_host;  // localhost
$config->puerto = 3306; // se guarda en $datos
```

`__isset` y `__unset` completan las operaciones `isset()` y `unset()` sobre esas propiedades.

#### `__call` y `__callStatic`

Se invocan al llamar a métodos inaccesibles o inexistentes (de instancia o estáticamente):

```php
<?php
declare(strict_types=1);
class Proxy
{
    public function __call(string $metodo, array $args): string
    {
        return "Llamada a '$metodo' con " . count($args) . " argumentos";
    }
    public static function __callStatic(string $metodo, array $args): string
    {
        return "Llamada estática a '$metodo'";
    }
}
$proxy = new Proxy();
echo $proxy->hacerAlgo(1, 2); // Llamada a 'hacerAlgo' con 2 argumentos
echo Proxy::utilidad();       // Llamada estática a 'utilidad'
```

Sirven para **proxies** y **decoradores**, pero dificultan la detección de typos: úsalos con moderación.

#### `__toString`

Controla la representación del objeto al convertirlo a cadena (`echo`, interpolación). Debe devolver `string`:

```php
<?php
declare(strict_types=1);
class Moneda
{
    public function __construct(private float $cantidad, private string $codigo = "EUR")
    {
    }
    public function __toString(): string
    {
        return number_format($this->cantidad, 2, ",", ".") . " {$this->codigo}";
    }
}
$precio = new Moneda(1250.5);
echo $precio; // 1.250,50 EUR
```

#### `__invoke`

Permite usar un objeto **como si fuera una función** (callable):

```php
<?php
declare(strict_types=1);
class Mayusculas
{
    public function __invoke(string $texto): string
    {
        return strtoupper($texto);
    }
}
$transformar = new Mayusculas();
echo $transformar("hola"); // HOLA
echo is_callable($transformar) ? "sí" : "no"; // sí
```

Útil para estrategias o "funciones con estado" pasadas a `array_map`, `usort`, etc.

#### `__clone`

Se ejecuta al clonar con `clone`. PHP hace una copia **superficial** por defecto (los objetos anidados se comparten); `__clone` permite controlar la copia:

```php
<?php
declare(strict_types=1);
class Pedido
{
    public array $lineas = [];
    public function __clone()
    {
        $this->lineas = array_map(fn (array $l) => [...$l], $this->lineas);
    }
}
$a = new Pedido();
$a->lineas[] = ["sku" => "LAP", "cantidad" => 1];
$b = clone $a;
$b->lineas[0]["cantidad"] = 9;
var_dump($a->lineas[0]["cantidad"]); // int(1) -> copia profunda correcta
```

### Namespaces

Los **namespaces** evitan colisiones entre nombres de clases, funciones y constantes. Se declaran al principio del archivo (tras `<?php` o `declare`) con `namespace App\Tienda\Models;`. Desde fuera se refieren por su nombre completo (`App\Tienda\Models\Producto`). El prefijo `\` indica **raíz global**: `new \DateTime()` usa la clase nativa de PHP, no `App\Tienda\Models\DateTime`.

#### `use`, alias `as`, `use function` y `use const`

`use` importa un nombre al espacio actual para no escribir la ruta completa:

```php
<?php
declare(strict_types=1);
namespace App\Tienda\Controllers;

use App\Tienda\Models\Producto;                   // clase
use App\Tienda\Servicios\EnvioService as Envio;   // alias
use function App\Utilidades\formatear;            // función
use const App\Config\VERSION;                     // constante

$p = new Producto("Mouse");
$envio = new Envio();
echo formatear(3.14) . VERSION;
```

Un `use` puede agrupar varias importaciones del mismo namespace, y el alias resuelve colisiones de nombres:

```php
<?php
declare(strict_types=1);
namespace App;

use App\Models\{Producto, Categoria, Pedido};
use function App\Utilidades\{formatear, validar};
use App\V1\Reporte as ReporteV1;
use App\V2\Reporte as ReporteV2;
```

### Autoload

En proyectos reales no haces `require` manual de cada archivo: PHP **autoloada** las clases la primera vez que se usan. La base es `spl_autoload_register()`:

```php
<?php
declare(strict_types=1);
spl_autoload_register(function (string $clase): void {
    // Convierte "App\Tienda\Models\Producto" en "App/Tienda/Models/Producto.php"
    $ruta = __DIR__ . "/" . str_replace("\\", "/", $clase) . ".php";
    if (file_exists($ruta)) {
        require $ruta;
    }
});
// Sin ningún require, se carga automáticamente:
$p = new \App\Tienda\Models\Producto("Laptop");
```

#### PSR-4 y Composer

**PSR-4** estandariza la correspondencia namespace ↔ directorio: el prefijo `App\` mapea a `src/`, de modo que `App\Tienda\Models\Producto` vive en `src/Tienda/Models/Producto.php`.

**Composer** implementa PSR-4 automáticamente. En `composer.json`:

```json
{
    "autoload": {
        "psr-4": {
            "App\\": "src/"
        }
    }
}
```

Tras `composer dump-autoload`, el proyecto tiene `vendor/autoload.php`, que se incluye una sola vez al arranque con `require __DIR__ . "/vendor/autoload.php";`. Desde entonces, `new Producto()` autoloada la clase bajo demanda según PSR-4, y desaparecen los `require` manuales.

### Enums (PHP 8.1)

Los **enums** modelan conjuntos cerrados de valores con seguridad de tipos. Son clases especiales con casos predefinidos.

#### Enums puros y backed enums

Un enum **puro** solo declara casos: `enum EstadoPedido { case Pendiente; case Pagado; }`. Cada caso tiene la propiedad `name` (`$estado->name` → `"Pagado"`) y las instancias se comparan con `===`. Los enums con valor `int` o `string` son **backed enums** y pueden leerse con `->value` o construirse con `from()` / `tryFrom()`:

Un enum con valor `int` o `string` es un **backed enum** y puede leerse con `->value` o construirse con `from()` / `tryFrom()`:

```php
<?php
declare(strict_types=1);
enum NivelAcceso: int
{
    case Visitante = 1;
    case Usuario  = 2;
    case Admin    = 3;
}
enum EstadoPago: string
{
    case Pendiente = "pendiente";
    case Pagado    = "pagado";
    case Rechazado = "rechazado";
}
echo NivelAcceso::Admin->value;      // 3
echo NivelAcceso::from(2)->name;     // Usuario
var_dump(NivelAcceso::tryFrom(99));  // null (no lanza excepción)
echo EstadoPago::Pagado->value;      // "pagado"
```

`from()` lanza `ValueError` si el valor no existe; `tryFrom()` devuelve `null`.

#### Métodos y constantes en enums

Los enums pueden tener métodos, métodos estáticos, constantes e interfaces. Se comportan como clases finales:

```php
<?php
declare(strict_types=1);
enum EstadoPago: string implements JsonSerializable
{
    case Pendiente = "pendiente";
    case Pagado    = "pagado";
    case Rechazado = "rechazado";
    public function etiqueta(): string
    {
        return match ($this) {
            self::Pendiente => "Pendiente de pago",
            self::Pagado    => "Pago recibido",
            self::Rechazado => "Pago rechazado",
        };
    }
    public function jsonSerialize(): string
    {
        return $this->value;
    }
}
echo EstadoPago::Pagado->etiqueta();     // Pago recibido
foreach (EstadoPago::cases() as $caso) { // iterar todos los casos
    echo $caso->value . PHP_EOL;
}
```

Los enums son ideales para reemplazar cadenas mágicas o constantes sueltas: el compilador verifica que solo usas valores válidos y `match` puede ser exhaustivo.

## Ejemplos de código

```php
<?php
declare(strict_types=1);
// Ejemplo 1: DTO inmutable con readonly + promoción de propiedades
class DireccionEntrega
{
    public function __construct(
        public readonly string $calle,
        public readonly string $codigoPostal,
        public readonly string $ciudad,
    ) {
    }
}
class Cliente
{
    public function __construct(
        private int $id,
        private string $nombre,
        private DireccionEntrega $direccion,
    ) {
    }
    public function resumen(): string
    {
        return "{$this->nombre} — {$this->direccion->ciudad}";
    }
}
$cliente = new Cliente(1, "Ana García", new DireccionEntrega("Av. Sol 12", "28001", "Madrid"));
echo $cliente->resumen() . PHP_EOL; // Ana García — Madrid
```

```php
<?php
declare(strict_types=1);
// Ejemplo 2: sistema de formas con clase abstracta e interfaz
interface Describible
{
    public function describe(): string;
}
abstract class Forma implements Describible
{
    public function __construct(protected string $nombre)
    {
    }
    abstract public function area(): float;
    public function describe(): string
    {
        return "{$this->nombre} (área: " . round($this->area(), 2) . ")";
    }
}
class Rectangulo extends Forma
{
    public function __construct(private float $base, private float $alto)
    {
        parent::__construct("Rectángulo");
    }
    public function area(): float
    {
        return $this->base * $this->alto;
    }
}
foreach ([new Rectangulo(3.0, 4.0)] as $forma) {
    echo $forma->describe() . PHP_EOL; // Rectángulo (área: 12)
}
```

```php
<?php
declare(strict_types=1);
// Ejemplo 3: enum backed con métodos y match exhaustivo
enum EstadoPago: string
{
    case Pendiente = "pendiente";
    case Pagado    = "pagado";
    case Fallido   = "fallido";
    public function color(): string
    {
        return match ($this) {
            self::Pendiente => "amarillo",
            self::Pagado    => "verde",
            self::Fallido   => "rojo",
        };
    }
    public static function desdeCodigo(string $codigo): self
    {
        return self::tryFrom($codigo) ?? throw new InvalidArgumentException("Código desconocido: $codigo");
    }
}
$estado = EstadoPago::desdeCodigo("pagado");
echo "Estado: {$estado->value} (color {$estado->color()})" . PHP_EOL;
foreach (EstadoPago::cases() as $caso) {
    printf("%s => %s\n", $caso->value, $caso->color());
}
```

## Ejercicios relacionados

- [Ejercicios nivel 03 — Intermedio](../ejercicios/nivel-03-intermedio/)
- [Proyectos PHP](../ejercicios/proyectos/)

## Errores comunes

- **Acceder a una propiedad `private` desde fuera o desde una subclase** → `Error: Cannot access private property`. Usa `protected` para herencia y getters/setters para acceso controlado.
- **Olvidar `parent::__construct()` en una subclase** → el constructor del padre no se ejecuta y sus propiedades quedan sin inicializar. Llámalo explícitamente.
- **Instanciar una clase `abstract`** → `Error: Cannot instantiate abstract class Forma`. Las clases abstractas son plantillas, no objetos.
- **Implementar una interfaz sin todos sus métodos** → `Fatal error: Class X contains 1 abstract method and must therefore be declared abstract or implement the remaining methods`. Implementa todos o vuelve la clase abstracta.
- **Reducir la visibilidad al sobrescribir** → `Fatal error: Access level ... must be public (as in class Padre)`. No puedes pasar de `public` a `private`.
- **Confundir `self` con `static`** → `self::` apunta a la clase donde se escribe el código; `static::` a la clase efectiva en ejecución (late static binding). Elige según el contexto.
- **Usar `$this` dentro de un método `static`** → `Error: Using $this when not in object context`. Los métodos estáticos no tienen instancia.
- **Leer una propiedad tipada sin inicializar** → `Error: Typed property X::$y must not be accessed before initialization`. Inicializa con un valor por defecto o en el constructor.
- **Modificar una propiedad `readonly`** → `Error: Cannot modify readonly property`. Asigna solo una vez, normalmente en el constructor.
- **Sobrescribir un método `final`** → `Fatal error: Cannot override final method`. Quita el `final` del padre o no lo sobrescribas.
- **Escribir el cuerpo de un método de interfaz** → `Fatal error: Interface function X() cannot contain body`. Las interfaces solo declaran firmas.
- **Intentar heredar de dos clases** → `Fatal error: Class X cannot extend multiple classes`. PHP no tiene herencia múltiple; usa interfaces, traits o composición.
- **`__toString` sin tipo de retorno `string`** → `Fatal error: Method X::__toString() must return a string`. Declara `: string`.
- **Clonar con `clone` y esperar copia profunda** → los objetos anidados se comparten. Implementa `__clone` para copiar manualmente lo que necesites.
- **Declarar `readonly` con `static`** → `Fatal error: Cannot use readonly property in static`. Las propiedades estáticas no pueden ser `readonly`.
- **Olvidar el `\` global para clases nativas dentro de un namespace** → `new DateTime()` busca `MiNamespace\DateTime`. Usa `new \DateTime()` o importa con `use`.
- **Confundir el `use` de traits con el `use` de namespaces** → dentro de la clase importa traits; al nivel del archivo importa namespaces. Son contextos distintos con la misma sintaxis.

## Recursos

- [PHP.net — Clases y objetos](https://www.php.net/manual/es/language.oop5.php)
- [PHP.net — Propiedades](https://www.php.net/manual/es/language.oop5.properties.php)
- [PHP.net — Constructor y destructor](https://www.php.net/manual/es/language.oop5.decon.php)
- [PHP.net — Interfaces](https://www.php.net/manual/es/language.oop5.interfaces.php)
- [PHP.net — Traits](https://www.php.net/manual/es/language.oop5.traits.php)
- [PHP.net — Clases abstractas](https://www.php.net/manual/es/language.oop5.abstract.php)
- [PHP.net — Métodos mágicos](https://www.php.net/manual/es/language.oop5.magic.php)
- [PHP.net — Late static bindings](https://www.php.net/manual/es/language.oop5.late-static-bindings.php)
- [PHP.net — Namespaces](https://www.php.net/manual/es/language.namespaces.php)
- [PHP.net — Enums](https://www.php.net/manual/es/language.enumerations.php)
- [PHP.net — Propiedades readonly](https://www.php.net/manual/es/language.oop5.properties.php#language.oop5.properties.readonly-properties)
- [PSR-4 — Autoloading](https://www.php-fig.org/psr/psr-4/es/)
- [Composer — Autoloading](https://getcomposer.org/doc/01-basic-usage.md)