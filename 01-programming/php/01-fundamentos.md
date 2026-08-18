# 01 — Fundamentos de PHP

## Objetivos

- [ ] Declarar variables con `$` y entender que PHP es débilmente tipado.
- [ ] Identificar los tipos de datos: `string`, `int`, `float`, `bool`, `array`, `null`.
- [ ] Usar `gettype()`, `var_dump()` y `print_r()` para inspeccionar valores.
- [ ] Concatenar cadenas con `.` e interpolar con `"{$variable}"`.
- [ ] Aplicar operadores aritméticos, de comparación y lógicos.
- [ ] Escribir condicionales `if/elseif/else`, ternarios, `match` y `switch`.
- [ ] Usar los bucles `for`, `while`, `do...while` y `foreach`.

## Apuntes

### Variables

Toda variable empieza con `$`. Los nombres distinguen mayúsculas de minúsculas: `$nombre` y `$Nombre` son distintas. No necesitan declararse ni tienen tipo fijo: PHP elige el tipo según el valor asignado.

```php
$nombre = "Ana";     // string
$edad = 30;          // int
$altura = 1.65;      // float
$estudia = true;     // bool
$sinValor = null;    // null
$frutas = ["manzana", "pera"]; // array
```

### Tipos de datos

- `string` — texto. Se escribe con comillas simples `'...'` o dobles `"..."`.
- `int` — números enteros.
- `float` — números decimales.
- `bool` — `true` o `false`.
- `array` — colección de valores (indexada o asociativa).
- `null` — ausencia de valor.
- `object` — instancias de clases.
- `callable` — funciones o métodos invocables.

```php
var_dump($edad);      // int(30)
var_dump("hola");     // string(4) "hola"
print_r($frutas);     // Array ( [0] => manzana ... )
echo gettype($edad);  // "integer"
```

### Cadenas: concatenación e interpolación

- `.` concatena cadenas.
- Las comillas dobles **interpolan** variables; las simples no.
- Con llaves puedes interpolar expresiones dentro de la cadena.

```php
$nombre = "Ana";
$edad = 30;
echo "Hola, " . $nombre . "\n";
echo "Tengo $edad años.\n";          // interpolación simple
echo "Soy {$nombre} y tengo {$edad} años.\n";
echo 'Esto muestra $nombre literal.'; // las comillas simples NO interpolan
```

### Constantes

Se definen con `define()` o `const`. Su valor no puede cambiar.

```php
const IVA = 0.21;
define("PAIS", "Perú");
echo IVA;     // 0.21
echo PAIS;    // Perú
```

### Operadores

- **Aritméticos:** `+ - * / % **`.
- **Comparación:** `== === != !== < > <= >=`. Usa siempre `===` para comparar también el tipo.
- **Lógicos:** `&& || !`.
- **Asignación:** `= += -= *= /= ++ --`.
- **Coalescencia:** `??` devuelve el primer valor que no sea `null`.

```php
echo 7 % 3;        // 1 (resto)
echo 2 ** 10;      // 1024 (potencia)
var_dump(5 === "5"); // false (tipos distintos)
var_dump(5 == "5");  // true (PHP convierte; evítalo)
$valor = $noExiste ?? "por defecto"; // "por defecto"
```

### Condicionales

`if`, `elseif`, `else`. Los valores *falsy* son: `false`, `0`, `0.0`, `""`, `"0"`, `[]` y `null`.

El ternario `condición ? valorSiTrue : valorSiFalse` y el operador Elvis `?:` son expresiones.

```php
$nota = 85;
if ($nota >= 90) {
    $r = "Excelente";
} elseif ($nota >= 70) {
    $r = "Aprobado";
} else {
    $r = "Reprobado";
}
echo $r;

$resultado = $nota >= 60 ? "aprueba" : "reprueba";
```

`match` (PHP 8) es una expresión que devuelve valor y no necesita `break`:

```php
function diaSemana(int $n): string
{
    return match ($n) {
        1 => "Lunes",
        2 => "Martes",
        3 => "Miércoles",
        default => "Otro día",
    };
}
```

### Bucles

- `for` — repetición con contador.
- `while` — repite mientras la condición sea verdadera (revisa antes).
- `do...while` — ejecuta al menos una vez (revisa después).
- `foreach` — recorre arrays (sintaxis recomendada).
- `break` corta el bucle; `continue` salta a la siguiente iteración.

```php
for ($i = 0; $i < 3; $i++) {
    echo "$i ";
}

$n = 0;
while ($n < 3) {
    $n++;
}

$frutas = ["manzana", "pera", "uva"];
foreach ($frutas as $fruta) {
    echo $fruta . " ";
}
```

## Ejemplos de código

```php
// Tabla de multiplicar con interpolación
$numero = 7;
for ($i = 1; $i <= 10; $i++) {
    echo "{$numero} x {$i} = " . ($numero * $i) . PHP_EOL;
}
```

```php
// Clasificador de números
function clasificar(int $n): string
{
    return $n % 2 === 0 ? "$n es par" : "$n es impar";
}
echo clasificar(10); // "10 es par"
echo clasificar(7);  // "7 es impar"
```

## Ejercicios relacionados

- [Ejercicios nivel 01 — Fundamentos](../ejercicios/nivel-01-fundamentos/)

## Errores comunes

- **Olvidar el `$`** en las variables → error de sintaxis.
- **Usar comillas simples esperando interpolación** → el texto sale literal (`'$edad'` no se expande).
- **Usar `==` en vez de `===`** → comparaciones sorprendentes como `"0" == 0`.
- **`match` con `default` fuera de lugar** → debe ser la última rama.
- **Índices inexistentes** → acceder a `$arr[5]` o `$datos["clave"]` sin `isset()` lanza un *warning* y devuelve `null` (PHP 8).
- **Olvidar `break` en `switch`** → en PHP 8 `switch` sigue cayendo al siguiente caso sin `break`.

## Recursos

- [PHP.net — Manual en español](https://www.php.net/manual/es/)
- [PHP.net — Tipos](https://www.php.net/manual/es/language.types.intro.php)
- [PHP.net — Control Structures](https://www.php.net/manual/es/language.control-structures.php)
- [PHP the right way — en español](https://phptherightway.com/es/)
- [PHP.net — Descargar PHP](https://www.php.net/downloads)