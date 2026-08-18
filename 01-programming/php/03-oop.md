# 03 — Programación Orientada a Objetos en PHP

## Objetivos

- [ ] Definir clases con propiedades, métodos, constructor y visibilidad.
- [ ] Usar promoción de propiedades del constructor (PHP 8).
- [ ] Implementar herencia con `extends` y `parent::`.
- [ ] Usar `abstract`, `final` e `instanceof`.
- [ ] Definir e implementar interfaces.
- [ ] Reutilizar código con traits.
- [ ] Organizar el código con namespaces y autoload (PSR-4).

## Apuntes

### Clases y objetos

Una clase es una plantilla; un objeto es una instancia. Las propiedades y métodos tienen visibilidad: `public`, `protected` o `private`.

```php
class Producto
{
    public function __construct(
        private string $nombre,
        private float $precio,
        private int $stock = 0
    ) {
    }

    public function nombre(): string
    {
        return $this->nombre;
    }

    public function precio(): float
    {
        return $this->precio;
    }

    public function hayStock(): bool
    {
        return $this->stock > 0;
    }
}

$laptop = new Producto("Laptop", 1200.0, 5);
echo $laptop->nombre();    // Laptop
echo $laptop->hayStock();  // 1 (true)
```

La **promoción de propiedades** (`private string $nombre` en el constructor) declara y asigna la propiedad en un solo paso (PHP 8).

### Herencia

`extends` permite heredar propiedades y métodos. `parent::` llama al método de la clase padre. `protected` permite el acceso desde las subclases.

```php
class Vehiculo
{
    public function __construct(protected string $marca)
    {
    }

    public function describir(): string
    {
        return "Vehículo de marca {$this->marca}";
    }
}

class Coche extends Vehiculo
{
    public function describir(): string
    {
        return parent::describir() . " con 4 ruedas";
    }
}

$coche = new Coche("Toyota");
echo $coche->describir(); // Vehículo de marca Toyota con 4 ruedas
echo $coche instanceof Vehiculo; // 1
```

- `abstract class` no puede instanciarse; puede declarar métodos abstractos que las subclases deben implementar.
- `final` impide heredar (en clases) o sobrescribir (en métodos).

### Interfaces

Una interfaz define el **contrato** (firmas de métodos) que las clases deben implementar. Una clase puede implementar varias interfaces.

```php
interface Pagable
{
    public function calcularTotal(): float;
}

interface Etiquetable
{
    public function etiqueta(): string;
}

class Factura implements Pagable, Etiquetable
{
    public function __construct(private array $lineas)
    {
    }

    public function calcularTotal(): float
    {
        return array_sum($this->lineas);
    }

    public function etiqueta(): string
    {
        return "Factura";
    }
}
```

### Traits

Un trait es un bloque de código reutilizable que se "inyecta" en una clase con `use`. Permite compartir métodos entre clases que no comparten jerarquía.

```php
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

$articulo = new Articulo("Hola mundo");
$articulo->marcarCreado();
echo $articulo->creadoEn();
```

### Namespaces

Los namespaces evitan colisiones de nombres. Se declaran con `namespace` y se importan con `use`. El separador de namespaces es la barra invertida `\`.

```php
namespace App\Tienda;

use App\Tienda\Models\Producto;         // importar
use App\Tienda\Models\Producto as P;    // alias

$p = new Producto("Laptop", 1000.0);
$q = new P("Mouse", 25.0);
```

Con **autoload PSR-4**, Composer (o un autoloader propio) convierte `App\Tienda\Models\Producto` en la ruta `src/Tienda/Models/Producto.php` automáticamente, sin `require`.

## Ejemplos de código

```php
// Clase anónima
$saludador = new class {
    public function saludar(string $nombre): string
    {
        return "Hola, {$nombre}";
    }
};
echo $saludador->saludar("Ana");
```

```php
// Métodos estáticos
class Calculadora
{
    public static function suma(int $a, int $b): int
    {
        return $a + $b;
    }
}
echo Calculadora::suma(2, 3); // 5
```

## Ejercicios relacionados

- [Ejercicios nivel 03 — Intermedio](../ejercicios/nivel-03-intermedio/)

## Errores comunes

- **Acceder a `private` desde fuera o desde la subclase** → usa `protected` para herencia y getters para lectura externa.
- **Olvidar `parent::__construct()`** en una subclase con constructor propio → el constructor del padre no se ejecuta.
- **Instanciar una clase `abstract`** → `Error: Cannot instantiate abstract class`.
- **Implementar una interfaz sin todos los métodos** → error fatal.
- **Confundir `self` con `static`** → `self` apunta a la clase donde se escribe; `static` a la clase que se está ejecutando (late static binding).

## Recursos

- [PHP.net — Clases y objetos](https://www.php.net/manual/es/language.oop5.php)
- [PHP.net — Interfaces](https://www.php.net/manual/es/language.oop5.interfaces.php)
- [PHP.net — Traits](https://www.php.net/manual/es/language.oop5.traits.php)
- [PHP.net — Namespaces](https://www.php.net/manual/es/language.namespaces.php)
- [PSR-4 — Autoloading](https://www.php-fig.org/psr/psr-4/es/)