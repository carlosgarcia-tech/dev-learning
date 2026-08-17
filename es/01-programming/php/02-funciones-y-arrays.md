# 02 — Funciones y arrays en PHP

## Objetivos

- [ ] Definir funciones con parámetros, valores por defecto y tipos de retorno.
- [ ] Usar parámetros variádicos (`...`) y por referencia (`&`).
- [ ] Entender el ámbito de variables y las variables estáticas.
- [ ] Crear funciones anónimas y arrow functions (`fn`).
- [ ] Trabajar con arrays indexados y asociativos.
- [ ] Aplicar funciones integradas: `count`, `array_map`, `array_filter`, `array_reduce`, `sort`, `in_array`, `explode`/`implode`.

## Apuntes

### Declaración de funciones

Las funciones se definen con `function`. Pueden tener parámetros tipados, valores por defecto y tipo de retorno declarado.

```php
function saludar(string $nombre, string $saludo = "Hola"): string
{
    return "{$saludo}, {$nombre}!";
}

echo saludar("Ana");                 // Hola, Ana!
echo saludar("Ana", "Buenos días");  // Buenos días, Ana!
```

Con `declare(strict_types=1);` al inicio del archivo, PHP exige que los tipos coincidan exactamente (sin coerción automática).

### Parámetros variádicos y por referencia

- `...$numeros` agrupa el resto de argumentos en un array.
- `&$variable` permite modificar la variable original (paso por referencia).

```php
function sumarTodos(int ...$numeros): int
{
    return array_sum($numeros);
}
echo sumarTodos(1, 2, 3, 4); // 10

function incrementar(int &$n): void
{
    $n++;
}
$x = 5;
incrementar($x);
echo $x; // 6
```

### Ámbito de variables

- Las variables declaradas dentro de una función son **locales**.
- Para leer una variable global usa `$GLOBALS` o el parámetro `global`.
- `static $contador` conserva el valor entre llamadas a la misma función.

```php
$iva = 0.21;

function precioConIva(float $precio): float
{
    global $iva; // evita usar `global`: prefiere pasar el valor como parámetro
    return $precio * (1 + $iva);
}

function contador(): int
{
    static $n = 0;
    return ++$n;
}
echo contador(); // 1
echo contador(); // 2
```

### Funciones anónimas y arrow functions

Las funciones anónimas pueden capturar variables con `use`. Las arrow functions (`fn`) capturan automáticamente y son más breves.

```php
$duplicar = function (int $n): int {
    return $n * 2;
};
echo $duplicar(4); // 8

$factor = 3;
$multiplicar = fn (int $n): int => $n * $factor; // captura $factor sola
echo $multiplicar(5); // 15
```

### Arrays indexados

Los arrays indexados usan claves numéricas automáticas.

```php
$numeros = [10, 20, 30];
$numeros[] = 40;        // añade al final
echo count($numeros);   // 4
echo $numeros[0];       // 10
echo array_sum($numeros); // 100
```

### Arrays asociativos

Los arrays asociativos usan claves `string => valor`. En PHP son la base de datos típica (equivalente a objetos en otros lenguajes).

```php
$producto = [
    "nombre" => "Laptop",
    "precio" => 1200.0,
    "stock" => 5,
];

echo $producto["nombre"];   // Laptop
$producto["stock"] = 4;     // modificar

foreach ($producto as $clave => $valor) {
    echo "{$clave}: {$valor}\n";
}
```

### Funciones integradas útiles

```php
$nombres = ["ana", "pablo", "luis"];

sort($nombres);                          // ordena en el sitio
echo implode(", ", $nombres);            // "ana, luis, pablo"

$cuadrados = array_map(fn ($n) => $n ** 2, [1, 2, 3]);      // [1, 4, 9]
$pares = array_filter([1, 2, 3, 4], fn ($n) => $n % 2 === 0); // [1 => 2, 3 => 4]
$total = array_reduce([1, 2, 3], fn ($acc, $n) => $acc + $n, 0); // 6

var_dump(in_array("ana", $nombres));     // true
$claves = array_keys($producto);         // ["nombre", "precio", "stock"]
$valores = array_values($producto);      // ["Laptop", 1200.0, 5]
$unidos = array_merge([1, 2], [3, 4]);   // [1, 2, 3, 4]
```

Con strings: `explode(" ", "hola mundo")` devuelve `["hola", "mundo"]`; `implode` hace lo contrario.

## Ejemplos de código

```php
// Promedio con variádicos
function promedio(float ...$notas): float
{
    return array_sum($notas) / count($notas);
}
echo promedio(8, 9, 7); // 8.0
```

```php
// Transformar un array asociativo con arrow function
$precios = ["teclado" => 40, "mouse" => 25];
$conIva = array_map(fn ($p) => $p * 1.21, $precios);
print_r($conIva); // ["teclado" => 48.4, "mouse" => 30.25]
```

## Ejercicios relacionados

- [Ejercicios nivel 01 — Funciones básicas](../ejercicios/nivel-01-fundamentos/)
- [Ejercicios nivel 02 — Básico](../ejercicios/nivel-02-basico/)

## Errores comunes

- **Llamar a una función antes de declararla** → en PHP las funciones se declaran en tiempo de carga, así que funciona, pero evita depender de ello.
- **Pasar arrays por valor esperando modificarlos** → los arrays se pasan por valor (copia); usa `&` si quieres modificar el original.
- **Confundir `array_filter` con `array_map`** → `filter` reduce, `map` transforma.
- **Interpolar arrays en cadenas** → `"$arr[0]"` da warning; usa `"{$arr[0]}"` o concatenación.
- **Olvidar `use` en funciones anónimas** → la variable no está disponible dentro de la closure.

## Recursos

- [PHP.net — Funciones definidas por el usuario](https://www.php.net/manual/es/language.functions.php)
- [PHP.net — Arrays](https://www.php.net/manual/es/language.types.array.php)
- [PHP.net — Funciones de arrays](https://www.php.net/manual/es/ref.array.php)
- [PHP.net — Funciones anónimas](https://www.php.net/manual/es/functions.anonymous.php)