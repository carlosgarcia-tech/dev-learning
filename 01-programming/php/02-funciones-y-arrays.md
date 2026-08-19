# 02 — Funciones y arrays
## Objetivos

- [ ] Declarar funciones con `function`, parámetros tipados, valores por defecto y tipos de retorno (`: int`, `: void`, `: array`).
- [ ] Explicar cómo `declare(strict_types=1)` cambia la coerción de tipos en los parámetros.
- [ ] Pasar parámetros por valor y por referencia con `&`, y comprender cuándo usar cada uno.
- [ ] Usar parámetros variádicos `...$args` y argumentos con nombre.
- [ ] Entender el ámbito de las variables, `global` y las variables `static`.
- [ ] Crear funciones anónimas (closures), arrow functions `fn()` y capturar variables con `use`.
- [ ] Invocar callables con `call_user_func` y pasar funciones como argumentos.
- [ ] Trabajar con `array_map`, `array_filter` y `array_reduce` para transformar colecciones.
- [ ] Construir arrays indexados, asociativos y multidimensionales.
- [ ] Recorrer arrays con `foreach` clave/valor y `array_walk`.
- [ ] Dominar las funciones de arrays importantes: `array_merge`, `array_keys`, `array_values`, `array_search`, `in_array`, `array_unique`, `array_flip`, `array_slice`, `array_splice`, `array_sum` y las de ordenación.
- [ ] Distinguir las funciones `array_*` que modifican el array de las que devuelven uno nuevo.
- [ ] Devolver varios valores desde una función usando arrays y `list()` / `[...]`.
## Apuntes

### Declaración de funciones
#### Sintaxis básica
Una función es un bloque de código reutilizable con un nombre, cero o más parámetros y opcionalmente un valor de retorno. Se define con la palabra clave `function`:
```php
<?php
declare(strict_types=1);
function saludar(string $nombre): string
{
    return "Hola, $nombre";
}
echo saludar("Ana");   // Hola, Ana
```
Partes de la declaración:

| Parte | Ejemplo | Descripción |
| --- | --- | --- |
| `function` | `function` | Palabra clave |
| Nombre | `saludar` | Identificador (sin `$`) |
| Parámetros | `(string $nombre)` | Entradas con su tipo |
| Tipo de retorno | `: string` | Tipo del valor devuelto |
| Cuerpo | `{ ... }` | Las instrucciones |

Los nombres de funciones no distinguen mayúsculas de minúsculas (`Saludar` y `saludar` son la misma), pero por convención se usa `camelCase` o `snake_case`. No pueden llamarse igual que una función nativa de PHP.
#### Parámetros con tipo
Cada parámetro puede (y debería) declarar su tipo. Con `declare(strict_types=1)`, el tipo debe coincidir exactamente al llamar; sin él, PHP coerciona.
```php
<?php
declare(strict_types=1);
function areaRectangulo(float $base, float $altura): float
{
    return $base * $altura;
}
echo areaRectangulo(5.0, 3.0);   // 15.0
// areaRectangulo("5", "3");     // TypeError (strict)
```
Los tipos de parámetros pueden ser escalares (`int`, `float`, `string`, `bool`), compuestos (`array`, `object`, `callable`) o uniones (`int|string`). Desde PHP 8 también existen los tipos `mixed`, `never` y `static`.
#### Valores por defecto
Si un parámetro no se pasa al llamar, se usa su valor por defecto. Los parámetros con valor por defecto deben ir **después** de los obligatorios.
```php
<?php
declare(strict_types=1);
function crearSaludo(string $nombre, string $saludo = "Hola"): string
{
    return "$saludo, $nombre!";
}
echo crearSaludo("Ana");                 // Hola, Ana!
echo crearSaludo("Ana", "Buenos días");  // Buenos días, Ana!
```
Si un parámetro es opcional pero está **antes** de uno obligatorio, PHP emite un aviso *Deprecated* en PHP 8. Ordena siempre: obligatorios primero, opcionales después.
#### `return` y tipos de retorno
- `return` termina la ejecución de la función y devuelve un valor.
- El tipo de retorno se declara tras los parámetros con `: tipo`.
- Si la función no devuelve nada, usa `: void`.
- Una función con `: void` no puede devolver valores (solo `return;` sin valor).
```php
<?php
declare(strict_types=1);
function sumar(int $a, int $b): int
{
    return $a + $b;
}
function imprimirMensaje(string $msg): void
{
    echo $msg . "\n";
    // no devuelve nada
}
function listaDeFrutas(): array
{
    return ["manzana", "pera", "uva"];
}
var_dump(sumar(2, 3));          // int(5)
imprimirMensaje("hola");        // hola
print_r(listaDeFrutas());
```
El tipo de retorno `: array` es común para funciones que construyen colecciones. PHP valida que lo devuelto coincida con el tipo declarado y lanza `TypeError` si no.
#### `return` temprano
Una función puede tener varios `return`: al primero que se alcance, termina. Esto permite escribir *guard clauses* (validaciones al inicio):
```php
<?php
declare(strict_types=1);
function clasificarEdad(int $edad): string
{
    if ($edad < 0) {
        return "Edad inválida";
    }
    if ($edad < 13) {
        return "niño";
    }
    if ($edad < 18) {
        return "adolescente";
    }
    return "adulto";
}
echo clasificarEdad(25);   // adulto
```
### `strict_types` y coerción de tipos
#### Sin strict_types: coerción silenciosa
Sin la declaración, PHP intenta convertir el argumento al tipo esperado del parámetro. La coerción tiene reglas propias:
- `int` acepta float (truncando) y strings numéricos.
- `float` acepta int y strings numéricos.
- `string` acepta cualquier escalar.
- `bool` acepta cualquier valor.
- `int|float` (unión) acepta ambos.
```php
<?php
// Sin declare(strict_types=1)
function duplicar(int $n): int
{
    return $n * 2;
}
echo duplicar(5);      // 10
echo duplicar("5");    // 10  ("5" se convierte a int)
echo duplicar(5.9);    // 10  (5.9 se TRUNCA a 5)
echo duplicar(true);   // 2   (true se convierte a 1)
```
El caso `5.9` es el más peligroso: pierde el decimal sin ningún aviso.
#### Con strict_types: errores inmediatos
```php
<?php
declare(strict_types=1);
function duplicar(int $n): int
{
    return $n * 2;
}
echo duplicar("5");
// TypeError: duplicar(): Argument #1 ($n) must be of type int, string given
```
`strict_types` no afecta al código de otros archivos incluidos: cada archivo decide su propio modo. En los ejemplos de esta guía lo activamos siempre, salvo cuando queremos demostrar la coerción.
#### Modos de coerción dentro de una función
Aun con `strict_types`, hay casos que PHP sigue permitiendo porque la conversión no pierde información: un `int` se puede pasar a un parámetro `float` y un string a un parámetro `string`. La estrictez afecta a las conversiones de *escala*: string numérico → número, o float → int.
### Parámetros: por valor y por referencia
#### Paso por valor (el predeterminado)
Por defecto, PHP **copia** el argumento dentro de la función: modificarlo dentro no afecta a la variable original. Esto es especialmente importante con arrays, porque copiar un array grande cuesta memoria.
```php
<?php
declare(strict_types=1);
function agregarItem(array $lista, string $item): array
{
    $lista[] = $item;      // modifica la copia
    return $lista;
}
$frutas = ["manzana"];
$nuevas = agregarItem($frutas, "pera");
echo implode(", ", $frutas);  // manzana   (la original NO cambió)
echo implode(", ", $nuevas);  // manzana, pera
```
La regla es: si quieres el resultado, captura lo que devuelve la función; no esperes que la variable de fuera cambie.
#### Paso por referencia `&`
Con el ampersand `&` delante del parámetro, la función recibe la **misma variable**: cualquier cambio se ve fuera. Útil para contadores, acumuladores o cuando no quieres devolver un nuevo valor.
```php
<?php
declare(strict_types=1);
function incrementar(int &$n): void
{
    $n++;
}
$x = 5;
incrementar($x);
echo $x;   // 6  (¡cambió la variable original!)
```
Solo se puede pasar una variable por referencia (no una expresión ni un literal). `incrementar(5);` lanza un error fatal: *Only variables can be passed by reference*.
### Parámetros variádicos `...$args`
El operador `...` en la declaración agrupa todos los argumentos extra en un array dentro de la función.
```php
<?php
declare(strict_types=1);
function sumarTodos(int ...$numeros): int
{
    return array_sum($numeros);
}
echo sumarTodos(1, 2, 3);          // 6
echo sumarTodos(1, 2, 3, 4, 5);    // 15
echo sumarTodos();                 // 0
```
Los variádicos pueden combinarse con parámetros normales, pero deben ser el **último** parámetro:
```php
<?php
declare(strict_types=1);
function construirMensaje(string $prefijo, string ...$partes): string
{
    return $prefijo . ": " . implode(" | ", $partes);
}
echo construirMensaje("Errores", "faltó nombre", "edad inválida");
// Errores: faltó nombre | edad inválida
```
El operador `...` también sirve al **llamar**: expande un array en argumentos individuales (*unpacking*):
```php
<?php
declare(strict_types=1);
function areaTriangulo(float $base, float $altura): float
{
    return ($base * $altura) / 2;
}
$datos = [4.0, 3.0];
echo areaTriangulo(...$datos);   // 6.0
```
### Argumentos con nombre
En PHP 8 puedes pasar argumentos usando el **nombre del parámetro**, en cualquier orden. Esto hace las llamadas autodocumentadas y evita tener que recordar posiciones.
```php
<?php
declare(strict_types=1);
function configurar(string $host, string $user = "root", string $pass = ""): string
{
    return "$user@$host:$pass";
}
echo configurar(host: "localhost", user: "admin", pass: "1234");
// admin@localhost:1234
echo configurar(user: "guest", host: "10.0.0.1");
// guest@10.0.0.1
```
Reglas de los argumentos con nombre:
- No se pueden repetir nombres.
- Un argumento con nombre no puede ir después de uno posicional que "salta" parámetros.
- Mezclar posicionales y con nombre está permitido, pero los posicionales deben ir primero.
```php
<?php
configurar("localhost", pass: "secreto");   // válido
// configurar(pass: "x", "localhost");      // Error: no positional after named
```
### Ámbito de variables, `global` y `static`
#### Ámbito local y global
Las variables creadas dentro de una función son **locales**: no existen fuera. Las creadas fuera son **globales** y, por defecto, tampoco son visibles dentro de la función.
```php
<?php
$iva = 0.21;   // global
function calcularPrecio(float $precio): float
{
    // $iva NO es accesible aquí directamente
    return $precio;
}
```
#### `global` y `$GLOBALS`
Dentro de una función puedes importar una variable global con `global $nombre`, o acceder al array `$GLOBALS`:
```php
<?php
declare(strict_types=1);
$iva = 0.21;
function precioConIva(float $precio): float
{
    global $iva;                 // importa la global
    return $precio * (1 + $iva);
}
function precioConIva2(float $precio): float
{
    return $precio * (1 + $GLOBALS["iva"]);   // otra vía
}
echo precioConIva(100);    // 121
echo precioConIva2(100);   // 121
```
**Recomendación:** evita `global`. Pasa el valor como parámetro: la función queda pura, predecible y fácil de probar.
#### Variables `static`
Una variable `static` dentro de una función **conserva su valor entre llamadas**. Es un "contador de memoria" de la propia función.
```php
<?php
declare(strict_types=1);
function siguienteId(): int
{
    static $contador = 0;
    return ++$contador;
}
echo siguienteId();   // 1
echo siguienteId();   // 2
echo siguienteId();   // 3
```
Sin `static`, `$contador` se reiniciaría a `0` en cada llamada y siempre devolvería `1`. Útil para contadores, cachés dentro de funciones y generadores de secuencias.
### Funciones anónimas (closures) y arrow functions
#### Funciones anónimas
Una función anónima (o *closure*) es una función sin nombre que se asigna a una variable o se pasa como argumento. La variable se invoca como si fuera una función:
```php
<?php
declare(strict_types=1);
$duplicar = function (int $n): int {
    return $n * 2;
};
echo $duplicar(4);   // 8
var_dump($duplicar); // object(Closure)
```
#### Capturar variables con `use`
Una closure no ve las variables del ámbito exterior automáticamente. Para capturarlas se usa `use ($var)`. Con `&$var` captura por referencia (los cambios se ven fuera).
```php
<?php
declare(strict_types=1);
$tasa = 0.21;
$precio = 100;
$conIva = function () use ($tasa, $precio): float {
    return $precio * (1 + $tasa);
};
echo $conIva();   // 121.0
```
Capturar por valor congela el valor en el momento de crear la closure. Si quieres que la closure vea cambios posteriores, captura por referencia:
```php
<?php
declare(strict_types=1);
$contador = 0;
$incrementar = function () use (&$contador): void {
    $contador++;
};
$incrementar();
$incrementar();
echo $contador;   // 2
```
#### Arrow functions `fn()`
Las arrow functions (`fn`) son closures de una sola expresión, introducidas en PHP 7.4. Capturan las variables del ámbito **automáticamente por valor**, sin necesidad de `use`:
```php
<?php
declare(strict_types=1);
$factor = 3;
$multiplicar = fn (int $n): int => $n * $factor;
echo $multiplicar(5);   // 15
```
Diferencias clave con las closures:

| Aspecto | Closure `function () use (...)` | Arrow `fn ()` |
| --- | --- | --- |
| Captura de variables | Explícita con `use` | Automática por valor |
| Cuerpo | Varias instrucciones | Una sola expresión |
| `return` | Obligatorio y explícito | Implícito (siempre devuelve) |
| Argumentos con nombre | Soporta | No soporta |

Las arrow functions son ideales como argumentos para `array_map`, `array_filter` y `array_reduce`.
### Callables
#### ¿Qué es un callable?
Un **callable** es cualquier cosa que PHP pueda invocar: un nombre de función (string), una closure, un array `[objeto, método]` o `[Clase, métodoEstático]`. Las funciones y métodos que aceptan callables los invocan con los argumentos adecuados.
```php
<?php
declare(strict_types=1);
function enMayusculas(string $texto): string
{
    return strtoupper($texto);
}
// Pasar el nombre de la función como string
$operacion = "enMayusculas";
echo $operacion("hola");   // HOLA
```
#### `call_user_func` y `call_user_func_array`
Las funciones `call_user_func` invocan un callable con argumentos posicionales, y `call_user_func_array` los pasa como array:
```php
<?php
declare(strict_types=1);
function sumar(int $a, int $b): int
{
    return $a + $b;
}
echo call_user_func("sumar", 2, 3);              // 5
echo call_user_func_array("sumar", [2, 3]);      // 5
```
Con closures:
```php
<?php
declare(strict_types=1);
$saludar = fn (string $nombre): string => "Hola, $nombre";
echo call_user_func($saludar, "Ana");   // Hola, Ana
```
En la práctica, `array_map` y el operador `...` hacen que `call_user_func*` sea menos necesaria, pero conviene conocerlas porque aparecen en código legado y en APIs de bibliotecas.
#### `array_map`, `array_filter` y `array_reduce`
Estas tres funciones forman el trío clásico para trabajar con colecciones de forma funcional:
**`array_map`** aplica una función a cada elemento y devuelve un array con los resultados (misma cantidad de elementos). Si pasas varios arrays, la función recibe un elemento de cada uno.
```php
<?php
declare(strict_types=1);
$numeros = [1, 2, 3, 4];
$cuadrados = array_map(fn (int $n): int => $n ** 2, $numeros);
print_r($cuadrados);   // [1, 4, 9, 16]
// Con dos arrays: recibe un elemento de cada uno
$a = [1, 2, 3];
$b = [10, 20, 30];
$sumas = array_map(fn (int $x, int $y): int => $x + $y, $a, $b);
print_r($sumas);       // [11, 22, 33]
```
**`array_filter`** devuelve un array con solo los elementos que hacen verdadera la condición (la función devuelve `true`). **Conserva las claves originales**.
```php
<?php
declare(strict_types=1);
$numeros = [1, 2, 3, 4, 5, 6];
$pares = array_filter($numeros, fn (int $n): bool => $n % 2 === 0);
print_r($pares);   // [1 => 2, 3 => 4, 5 => 6]  (¡claves conservadas!)
```
Para "reindexar" el resultado y volver a claves `0,1,2...`, usa `array_values()`.
**`array_reduce`** acumula todos los elementos en un único valor. El callback recibe el acumulador y el elemento actual, y devuelve el nuevo acumulador. El tercer argumento es el valor inicial.
```php
<?php
declare(strict_types=1);
$numeros = [1, 2, 3, 4];
$total = array_reduce(
    $numeros,
    fn (int $acumulador, int $n): int => $acumulador + $n,
    0
);
echo $total;   // 10
$producto = array_reduce($numeros, fn (int $acc, int $n): int => $acc * $n, 1);
echo $producto;   // 24
```
Tabla resumen:

| Función | Entrada → Salida | Longitud |
| --- | --- | --- |
| `array_map` | n elementos → n elementos (transformados) | Igual |
| `array_filter` | n elementos → m elementos (los que cumplen) | Menor o igual |
| `array_reduce` | n elementos → 1 valor | Uno |

### Arrays en profundidad
#### Indexados
Los arrays indexados usan claves numéricas que PHP asigna automáticamente empezando en `0`. Puedes forzar claves concretas con `=>`.
```php
<?php
declare(strict_types=1);
$colores = ["rojo", "verde", "azul"];
echo $colores[0];   // rojo
echo $colores[2];   // azul
echo count($colores);   // 3
// Claves explícitas
$codigos = [10 => "diez", 20 => "veinte"];
echo $codigos[10];   // diez
```
Añadir elementos con `$arr[] = valor` coloca el siguiente índice numérico disponible. Si mezclas claves, el "siguiente" es el máximo entero + 1.
#### Asociativos
Los arrays asociativos usan claves string, ideales para representar registros o configuraciones:
```php
<?php
declare(strict_types=1);
$producto = [
    "nombre" => "Laptop",
    "precio" => 1200.0,
    "stock" => 5,
];
echo $producto["nombre"];      // Laptop
$producto["stock"] = 4;        // modificar
$producto["marca"] = "Lenovo"; // añadir clave nueva
var_dump(array_key_exists("marca", $producto));   // bool(true)
```
Las claves se convierten según ciertas reglas: `"1"` se convierte al int `1`, `1.5` se trunca a `1`, `true` a `1` y `false` a `0`.
#### Multidimensionales
Un array puede contener otros arrays: matrices, listas de registros, etc.
```php
<?php
declare(strict_types=1);
$matriz = [
    [1, 2, 3],
    [4, 5, 6],
    [7, 8, 9],
];
echo $matriz[1][2];   // 6  (fila 1, columna 2)
// Lista de alumnos (array de arrays asociativos)
$alumnos = [
    ["nombre" => "Ana", "nota" => 8.5],
    ["nombre" => "Luis", "nota" => 6.0],
    ["nombre" => "Eva", "nota" => 9.2],
];
echo $alumnos[0]["nombre"] . ": " . $alumnos[0]["nota"];   // Ana: 8.5
```
Para recorrer un array multidimensional, se anidan `foreach`:
```php
<?php
declare(strict_types=1);
$matriz = [
    [1, 2, 3],
    [4, 5, 6],
];
foreach ($matriz as $fila) {
    foreach ($fila as $celda) {
        echo "$celda ";
    }
    echo "\n";
}
// 1 2 3
// 4 5 6
```
### Recorridos con `foreach` y `array_walk`
#### `foreach` con clave y valor
Ya vimos el bucle; aquí lo combinamos con los tipos de array:
```php
<?php
declare(strict_types=1);
$precios = ["teclado" => 40, "mouse" => 25, "monitor" => 300];
foreach ($precios as $articulo => $precio) {
    printf("%-10s S/ %.2f\n", $articulo, $precio);
}
```
`foreach` itera sobre una **copia** del array por defecto: modificar la variable del bucle no cambia el original. Para modificar en el sitio, recorre por referencia con `&`:
```php
<?php
declare(strict_types=1);
$numeros = [1, 2, 3];
foreach ($numeros as &$n) {
    $n = $n * 10;   // modifica el original
}
unset($n);   // rompe la referencia
print_r($numeros);   // [10, 20, 30]
```
Tras el bucle con referencia hay que hacer `unset($n)` para eliminar la referencia residual; de lo contrario, un `foreach` posterior sobre `$numeros` reutilizaría esa variable y produciría bugs clásicos.
#### `array_walk`
`array_walk` aplica un callable a cada elemento **con su clave como segundo argumento**, y puede modificar el array original si el callback recibe el valor por referencia:
```php
<?php
declare(strict_types=1);
$nombres = ["ana", "luis", "eva"];
array_walk($nombres, function (string &$nombre): void {
    $nombre = ucfirst($nombre);
});
print_r($nombres);   // ["Ana", "Luis", "Eva"]
// Con clave en el callback
$notas = ["Ana" => 8, "Luis" => 6];
array_walk($notas, function (int $nota, string $alumno): void {
    echo "$alumno: $nota\n";
});
```
Diferencia clave con `array_map`: `array_walk` modifica el array pasado (por referencia) y no devuelve uno nuevo; `array_map` devuelve un array nuevo.
### Funciones de arrays importantes
#### `array_merge`
Une dos o más arrays en uno nuevo. Con claves numéricas, los índices se renumeran; con claves string, las del segundo array sobrescriben a las del primero.
```php
<?php
declare(strict_types=1);
$nombres = array_merge(["Ana", "Luis"], ["Eva", "Pablo"]);
print_r($nombres);   // ["Ana", "Luis", "Eva", "Pablo"]
$config = array_merge(
    ["tema" => "claro", "idioma" => "es"],
    ["idioma" => "en"]   // sobrescribe "idioma"
);
print_r($config);   // ["tema" => "claro", "idioma" => "en"]
```
#### `array_keys` y `array_values`
Devuelven, respectivamente, todas las claves o todos los valores de un array:
```php
<?php
declare(strict_types=1);
$producto = ["nombre" => "Laptop", "precio" => 1200.0, "stock" => 5];
$claves = array_keys($producto);      // ["nombre", "precio", "stock"]
$valores = array_values($producto);   // ["Laptop", 1200.0, 5]
print_r($claves);
print_r($valores);
```
`array_values` además **reindexa** de forma continua: muy útil después de `array_filter`.
#### `array_search` e `in_array`
- `in_array($aguja, $pajar)` devuelve `true` si el valor existe.
- `array_search($aguja, $pajar)` devuelve la **clave** del valor (o `false`).
```php
<?php
declare(strict_types=1);
$frutas = ["manzana", "pera", "uva"];
var_dump(in_array("pera", $frutas));    // bool(true)
var_dump(in_array("kiwi", $frutas));    // bool(false)
$posicion = array_search("pera", $frutas);
echo $posicion;   // 1
// Como puede devolver 0, compara siempre con ===
$pos = array_search("manzana", $frutas);
var_dump($pos === false);   // bool(false)  (0 no es false)
var_dump($pos === 0);       // bool(true)
```
`in_array` y `array_search` comparan con `==` por defecto; pasa `true` como tercer argumento para comparación estricta `===`.
#### `array_unique`
Elimina valores duplicados, conservando la **primera** clave de cada valor:
```php
<?php
declare(strict_types=1);
$numeros = [1, 2, 2, 3, 3, 3, 4];
$unicos = array_unique($numeros);
print_r($unicos);   // [0 => 1, 1 => 2, 3 => 3, 6 => 4]
```
#### `array_flip`
Intercambia claves y valores (el valor pasa a ser clave y viceversa). Solo funciona si los valores son `int` o `string`:
```php
<?php
declare(strict_types=1);
$dias = ["lun" => 1, "mar" => 2, "mie" => 3];
$invertido = array_flip($dias);
print_r($invertido);   // [1 => "lun", 2 => "mar", 3 => "mie"]
```
Con esto es fácil saber el nombre del día dado su número: `$invertido[2]` → `"mar"`.
#### `array_slice` y `array_splice`
- `array_slice($arr, $inicio, $longitud)` extrae un trozo y devuelve un **array nuevo** (no modifica el original).
- `array_splice($arr, $inicio, $longitud, $reemplazo)` **elimina** y opcionalmente **reemplaza** un trozo del array original.
```php
<?php
declare(strict_types=1);
$letras = ["a", "b", "c", "d", "e"];
$trozo = array_slice($letras, 1, 3);
print_r($trozo);          // ["b", "c", "d"]
print_r($letras);         // el original NO cambió
array_splice($letras, 2, 2, ["X", "Y"]);
print_r($letras);         // ["a", "b", "X", "Y", "e"]
```
Con índice negativo, `array_slice` cuenta desde el final: `array_slice($letras, -2)` devuelve los dos últimos.
#### `array_sum` y `array_product`
Suma o multiplica todos los valores numéricos de un array:
```php
<?php
declare(strict_types=1);
$notas = [7, 8, 9, 10];
echo array_sum($notas);       // 34
echo array_product($notas);   // 5040
$promedio = array_sum($notas) / count($notas);
echo $promedio;   // 8.5
```
`array_sum` ignora los elementos no numéricos (los suma como `0` o según conversión).
#### Ordenación: `sort`, `rsort`, `asort`, `ksort`
PHP tiene un sistema de ordenación con "familias" que comparten prefijo:

| Función | Orden | ¿Ordena valores? | ¿Conserva claves? |
| --- | --- | --- | --- |
| `sort` | ascendente | Sí | No (reindexa) |
| `rsort` | descendente | Sí | No (reindexa) |
| `asort` | ascendente | Sí | Sí (asociativas) |
| `arsort` | descendente | Sí | Sí (asociativas) |
| `ksort` | ascendente | No (por clave) | Sí |
| `krsort` | descendente | No (por clave) | Sí |

Todas **modifican el array original** y devuelven `bool` (éxito o no).
```php
<?php
declare(strict_types=1);
$frutas = ["pera", "manzana", "uva", "kiwi"];
sort($frutas);
print_r($frutas);   // ["kiwi", "manzana", "pera", "uva"]
rsort($frutas);
print_r($frutas);   // ["uva", "pera", "manzana", "kiwi"]
$edades = ["Ana" => 30, "Luis" => 25, "Eva" => 35];
asort($edades);     // ordena por valor, mantiene claves
print_r($edades);   // ["Luis" => 25, "Ana" => 30, "Eva" => 35]
ksort($edades);     // ordena por clave
print_r($edades);   // ["Ana" => 30, "Eva" => 35, "Luis" => 25]
```
Resumen de cuándo usar cada una:
- `sort`/`rsort`: listas simples de valores.
- `asort`/`arsort`: arrays asociativos que quieres ordenar por valor (p. ej., por nota).
- `ksort`/`krsort`: arrays asociativos que quieres ordenar alfabéticamente por clave.
### `array_*` que modifican vs. que devuelven
Es crucial saber qué hace cada función con el array original. Esta tabla resume el comportamiento de las funciones vistas:

| Función | ¿Modifica el original? | ¿Qué devuelve? |
| --- | --- | --- |
| `sort`, `rsort`, `asort`, `arsort`, `ksort`, `krsort` | Sí | `true`/`false` |
| `array_push`, `array_pop`, `array_shift`, `array_unshift` | Sí | cantidad / valor extraído |
| `array_splice` | Sí | el trozo eliminado |
| `array_walk` | Sí (si callback usa `&`) | `true`/`false` |
| `array_merge`, `array_keys`, `array_values`, `array_unique`, `array_flip`, `array_slice`, `array_map`, `array_filter`, `array_reduce`, `array_sum` | No | un array o un valor nuevo |

```php
<?php
declare(strict_types=1);
$numeros = [5, 3, 8];
// sort modifica y devuelve bool: ¡no asignes su resultado esperando un array!
$ok = sort($numeros);
var_dump($ok);         // bool(true)
print_r($numeros);     // [3, 5, 8]  (ya ordenado en el sitio)
// array_merge devuelve un array nuevo sin tocar el original
$original = [1, 2];
$unidos = array_merge($original, [3]);
print_r($original);    // [1, 2]  (sin cambios)
print_r($unidos);      // [1, 2, 3]
```
El error más típico de PHP: `$ordenado = sort($arr);` — la variable `$ordenado` valdrá `true`, no el array ordenado.
#### Otras funciones útiles de manipulación

| Función | Qué hace |
| --- | --- |
| `array_pop($arr)` | Elimina y devuelve el último elemento |
| `array_shift($arr)` | Elimina y devuelve el primero (reindexa) |
| `array_unshift($arr, $v)` | Añade al inicio |
| `array_key_exists($k, $arr)` | ¿Existe la clave? |
| `array_column($arr, $col)` | Extrae una columna de un array multidimensional |
| `range($a, $b)` | Genera una secuencia de números o letras |

```php
<?php
declare(strict_types=1);
$cola = ["a", "b", "c"];
$ultimo = array_pop($cola);      // "c"
$primero = array_shift($cola);   // "a"
print_r($cola);                  // ["b"]
$alumnos = [
    ["nombre" => "Ana", "nota" => 8],
    ["nombre" => "Luis", "nota" => 6],
];
$nombres = array_column($alumnos, "nombre");
print_r($nombres);               // ["Ana", "Luis"]
$dias = range(1, 7);
print_r($dias);                  // [1, 2, 3, 4, 5, 6, 7]
```
### Devolver múltiples valores con arrays y `list()`
#### Devolver un array
Una función solo puede devolver **un** valor, pero ese valor puede ser un array con todo lo que necesites:
```php
<?php
declare(strict_types=1);
function dividir(float $a, float $b): array
{
    return [$a / $b, $a % $b, $a + $b];
}
print_r(dividir(10, 3));   // [3.333..., 1, 13]
```
#### Desempaquetar con `list()` y `[...]`
`list($a, $b, ...) = $array` asigna los elementos a variables. Desde PHP 7.1 la sintaxis corta `[...]` es equivalente y preferida:
```php
<?php
declare(strict_types=1);
function dividir(float $a, float $b): array
{
    $cociente = (int) ($a / $b);
    $resto = (int) ($a % $b);
    return [$cociente, $resto];
}
[$cociente, $resto] = dividir(10, 3);
echo "$cociente con resto $resto\n";   // 3 con resto 1
```
Funciona también con arrays asociativos usando claves:
```php
<?php
declare(strict_types=1);
function coordenadas(): array
{
    return ["x" => 10, "y" => 20];
}
["x" => $x, "y" => $y] = coordenadas();
echo "($x, $y)\n";   // (10, 20)
```
Esta técnica es la forma idiomática de "devolver varios valores" en PHP. Es especialmente útil en funciones que necesitan devolver un resultado y un código de error, o pares de datos relacionados.
## Ejemplos de código

```php
<?php
declare(strict_types=1);
// Ejemplo 1: biblioteca de funciones matemáticas
function promedio(float ...$notas): float
{
    if (count($notas) === 0) {
        return 0.0;
    }
    return array_sum($notas) / count($notas);
}
function mayorDe(array $numeros): int
{
    return array_reduce(
        $numeros,
        fn (int $acc, int $n): int => max($acc, $n),
        PHP_INT_MIN
    );
}
echo "Promedio: " . promedio(7, 8, 9, 10) . "\n";        // 8.5
echo "Mayor: " . mayorDe([3, 8, 2, 10, 5]) . "\n";       // 10
```
```php
<?php
declare(strict_types=1);
// Ejemplo 2: gestión de productos con arrays asociativos
$productos = [
    ["nombre" => "Teclado", "precio" => 40.0],
    ["nombre" => "Mouse", "precio" => 25.0],
    ["nombre" => "Monitor", "precio" => 300.0],
];
function aplicarIva(array $productos, float $iva): array
{
    return array_map(
        fn (array $p): array => [
            "nombre" => $p["nombre"],
            "precio" => round($p["precio"] * (1 + $iva), 2),
        ],
        $productos
    );
}
function ordenarPorPrecio(array &$productos): void
{
    usort($productos, fn (array $a, array $b): int => $a["precio"] <=> $b["precio"]);
}
$conIva = aplicarIva($productos, 0.21);
ordenarPorPrecio($conIva);
foreach ($conIva as $p) {
    printf("%-10s S/ %.2f\n", $p["nombre"], $p["precio"]);
}
```
```php
<?php
declare(strict_types=1);
// Ejemplo 3: estadísticas de notas
$notas = [15, 18, 12, 9, 20, 14, 11, 16];
$aprobadas = array_filter($notas, fn (int $n): bool => $n >= 12);
$suspensas = array_filter($notas, fn (int $n): bool => $n < 12);
$clasificadas = array_map(
    fn (int $n): string => match (true) {
        $n >= 18 => "sobresaliente",
        $n >= 14 => "notable",
        $n >= 12 => "aprobado",
        default  => "suspenso",
    },
    $notas
);
echo "Total notas: " . count($notas) . "\n";
echo "Promedio: " . round(array_sum($notas) / count($notas), 2) . "\n";
echo "Aprobadas: " . count($aprobadas) . "\n";
echo "Suspensas: " . count($suspensas) . "\n";
echo "Mejor nota: " . max($notas) . "\n";
echo "Peor nota: " . min($notas) . "\n";
print_r(array_unique($clasificadas));
```
```php
<?php
declare(strict_types=1);
// Ejemplo 4: recorridos con foreach, referencias y array_walk
$ventas = ["ene" => 120, "feb" => 150, "mar" => 90];
$total = 0;
foreach ($ventas as $mes => $monto) {
    $total += $monto;
}
echo "Total anual (trimestre): $total\n";
$conAumento = $ventas;
array_walk($conAumento, function (int &$monto, string $mes): void {
    $monto = (int) ($monto * 1.10);   // +10 %
});
print_r($conAumento);
arsort($ventas);
foreach ($ventas as $mes => $monto) {
    echo "$mes: $monto\n";
}
```
```php
<?php
declare(strict_types=1);
// Ejemplo 5: matriz multidimensional y descomposición con list()
function tablaMultipicar(int $hasta): array
{
    $tabla = [];
    for ($i = 1; $i <= $hasta; $i++) {
        $fila = [];
        for ($j = 1; $j <= $hasta; $j++) {
            $fila[$j] = $i * $j;
        }
        $tabla[$i] = $fila;
    }
    return $tabla;
}
$tabla = tablaMultipicar(5);
echo "3 x 4 = " . $tabla[3][4] . "\n";
foreach ($tabla as $i => $fila) {
    echo "$i: " . implode(" ", $fila) . "\n";
}
function duplicarYTriplicar(int $n): array
{
    return [$n * 2, $n * 3];
}
[$doble, $triple] = duplicarYTriplicar(7);
echo "Doble: $doble, triple: $triple\n";
```
## Ejercicios relacionados

- [Ejercicios nivel 01 — Funciones básicas](../ejercicios/nivel-01-fundamentos/)
- [Ejercicios nivel 02 — Básico](../ejercicios/nivel-02-basico/)
- [Ejercicios nivel 03 — Intermedio](../ejercicios/nivel-03-intermedio/)
## Errores comunes

- **`$ordenado = sort($arr);`** → `$ordenado` será `true`, no el array. `sort` y compañía modifican en el sitio y devuelven `bool`.
- **Esperar que `array_filter` reindexe** → `array_filter` conserva las claves originales (`[1 => 2, 3 => 4]`). Envuélvelo con `array_values()` si quieres claves `0,1,2...`.
- **Confundir `array_walk` con `array_map`** → `array_walk` modifica el array original (por referencia) y no devuelve uno nuevo; `array_map` devuelve un array nuevo sin tocar el original.
- **Olvidar `strict_types` y recibir conversiones sorpresa** → sin `declare(strict_types=1)`, `f(5.9)` con `int $n` trunca a `5` silenciosamente. Declárala al inicio.
- **`global` en exceso** → usar `global` hace las funciones dependientes del estado externo. Prefiere pasar valores por parámetros.
- **Comparar el resultado de `array_search` con `== false`** → como puede devolver la clave `0`, usa `=== false`.
- **Pasar un literal a un parámetro por referencia** → `incrementar(5)` lanza *Only variables can be passed by reference*. Pasa siempre una variable.
- **Interpolar arrays en cadenas** → `"$arr['clave']"` da error o resultado confuso. Usa `"{$arr['clave']}"` o concatenación.
- **Olvidar `use` en closures** → una closure no ve las variables del ámbito exterior sin `use ($var)`. Las arrow functions `fn` sí las capturan solas.
- **Bucle `foreach` por referencia sin `unset($var)`** → la variable de bucle queda como referencia residual y corrompe `foreach` posteriores. Haz `unset($var)` al terminar.
- **Mezclar argumentos posicionales y con nombre mal ordenados** → `f(pass: "x", "host")` lanza un error. Los posicionales van primero.
- **Devolver `void` y usar `return valor`** → error fatal. Las funciones `: void` solo admiten `return;`.
- **Un parámetro opcional antes de uno obligatorio** → en PHP 8 lanza un *Deprecated*. Ordena los obligatorios primero.
- **Olvidar que `array_merge` reindexa las claves numéricas** → `[1,2]` + `[3]` da `[0,1,2]`, no `[1,2,3]`. Si necesitas conservar claves, usa `+`.
- **Pasar tipos incorrectos a `array_map`** → si el callback espera `int` y el array tiene strings, con `strict_types` se lanza `TypeError`.
- **`array_flip` con valores que no son int/string** → lanza `TypeError` si los valores son arrays u objetos.
- **Usar `array_key_exists` con `isset` de forma intercambiable** → `isset` devuelve `false` si la clave existe pero vale `null`; `array_key_exists` devuelve `true`. Elige según lo que necesites.
- **Recorrer por valor esperando cambiar el original** → `foreach ($arr as $v) { $v++; }` no cambia nada. Usa `&$v` o un índice.
## Recursos

- [PHP.net — Funciones definidas por el usuario](https://www.php.net/manual/es/language.functions.php)
- [PHP.net — Argumentos de funciones](https://www.php.net/manual/es/functions.arguments.php)
- [PHP.net — Funciones anónimas](https://www.php.net/manual/es/functions.anonymous.php)
- [PHP.net — Tipos: callable](https://www.php.net/manual/es/language.types.callable.php)
- [PHP.net — Arrays](https://www.php.net/manual/es/language.types.array.php)
- [PHP.net — Funciones de arrays](https://www.php.net/manual/es/ref.array.php)
- [PHP.net — array_map](https://www.php.net/manual/es/function.array-map.php)
- [PHP.net — array_filter](https://www.php.net/manual/es/function.array-filter.php)
- [PHP.net — array_reduce](https://www.php.net/manual/es/function.array-reduce.php)
- [PHP.net — Ordenación de arrays](https://www.php.net/manual/es/array.sorting.php)
- [PHP the right way — en español](https://phptherightway.com/es/)
