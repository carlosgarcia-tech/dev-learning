# 01 — Fundamentos de PHP
## Objetivos

- [ ] Identificar qué es PHP, para qué se usa y cómo se ejecuta un script desde la terminal.
- [ ] Abrir un bloque PHP con `<?php` y cerrarlo con `?>`, entendiendo cuándo es necesario el cierre.
- [ ] Emitir salida con `echo` y `print`, y conocer sus diferencias.
- [ ] Escribir comentarios de una línea (`//`, `#`) y de varias líneas (`/* */`).
- [ ] Declarar variables con `$` y comprender las reglas de nombrado y el tipado dinámico.
- [ ] Inspeccionar valores con `var_dump()`, `gettype()` y `print_r()`.
- [ ] Identificar los tipos escalares (`int`, `float`, `string`, `bool`, `null`) y el tipo `mixed`.
- [ ] Definir constantes con `define()` y `const`, y usar constantes mágicas como `__DIR__` y `__FILE__`.
- [ ] Aplicar operadores aritméticos, de asignación, de comparación, de identidad, lógicos, de bits y de concatenación.
- [ ] Entender la coerción de tipos y aplicar casting explícito `(int)`, `(string)`, `(float)`, `(bool)` y funciones de conversión.
- [ ] Distinguir comillas simples de dobles, interpolar con `{$var}` y usar heredoc y nowdoc.
- [ ] Escribir condicionales `if/elseif/else`, `switch`, ternarios, `??` y la expresión `match`.
- [ ] Usar los bucles `for`, `while`, `do...while` y `foreach`, controlando el flujo con `break` y `continue`.
- [ ] Crear arrays indexados y asociativos con `[]` y manejar funciones básicas como `count`, `implode`, `explode` y `sort`.
- [ ] Leer entrada por consola con `fgets(STDIN)` y acceder a los argumentos del script con `$argv` y `$argc`.
## Apuntes

### Qué es PHP
PHP (originalmente *Personal Home Page*, hoy *PHP: Hypertext Preprocessor*) es un lenguaje interpretado del lado del servidor, orientado principalmente a desarrollo web, pero que también funciona perfectamente desde la línea de comandos (CLI, *Command Line Interface*). Su sintaxis recuerda a C y a Perl, y está integrado con HTML: puedes escribir código PHP dentro de una página web para generar contenido dinámico.
Cuando ejecutas `php archivo.php` desde la terminal, el intérprete lee el archivo, ejecuta cada instrucción de arriba hacia abajo y escribe la salida en la consola. Cada archivo de esta guía se ejecuta con `php archivo.php`. Verifica primero que el intérprete esté instalado:
```bash
php -v
```
Todo el código usa características de PHP 8 (por ejemplo `match` y `str_contains`), así que necesitas al menos la versión 8.0, descargable desde php.net/downloads.
#### La etiqueta `<?php`
Todo código PHP debe estar encerrado en una etiqueta de apertura `<?php`. La etiqueta de cierre `?>` es opcional al final del archivo; de hecho, **se recomienda omitirla** cuando el archivo contiene solo PHP, para evitar enviar espacios o saltos de línea accidentales que rompan la salida.
```php
<?php
echo "Hola";
```
Si mezclas PHP con HTML (en un contexto web), la etiqueta de cierre sí es necesaria para volver a HTML:
```php
<?php
$nombre = "Ana";
?>
<h1>Hola, <?= $nombre ?></h1>
```
`<?=` es la abreviatura de `<?php echo`. Solo sirve para imprimir y es muy cómoda en plantillas. Para la CLI solo usaremos la etiqueta de apertura.
#### `echo` y `print`
Las dos construcciones más simples para mostrar texto. Se parecen pero hay matices:

| Característica | `echo` | `print` |
| --- | --- | --- |
| Es una construcción del lenguaje | Sí | Sí |
| Devuelve un valor (se puede usar en expresiones) | No | Sí, siempre `1` |
| Número de argumentos | Varios separados por comas | Solo uno |
| Uso recomendado | Salida general | Casos muy puntuales |

```php
<?php
echo "Hola, mundo", "\n";   // echo acepta varios argumentos
print "Hola, mundo\n";       // print solo uno, pero se puede usar en expresiones
$ok = print "texto";         // $ok vale 1
var_dump($ok);               // int(1)
```
#### Comentarios
Los comentarios son ignorados por el intérprete. Sirven para explicar el código, desactivar líneas temporalmente o documentar decisiones.

| Sintaxis | Nombre | Ámbito |
| --- | --- | --- |
| `// texto` | Comentario de línea | Hasta el fin de línea |
| `# texto` | Comentario de línea (estilo shell) | Hasta el fin de línea |
| `/* texto */` | Comentario de bloque | Puede ocupar varias líneas |

```php
<?php
// Esto es un comentario de una línea
# Esto también es un comentario de una línea (menos común)
/*
 * Este es un comentario de bloque.
 * Puede abarcar varias líneas.
 */
echo "El código sigue funcionando"; // los comentarios no interfieren
```
Los comentarios de bloque no se pueden anidar: un `/*` dentro de otro `/*` provocará un error de sintaxis.
#### La declaración `declare(strict_types=1)`
PHP es de tipado dinámico y, por defecto, **coerciona** (convierte automáticamente) los tipos cuando llamas a una función: si una función espera un `int` y le pasas `"5"`, PHP lo convierte a `5`. Esta flexibilidad causa errores silenciosos difíciles de detectar.
`declare(strict_types=1)` fuerza a PHP a **exigir que los tipos coincidan exactamente**. Debe ser la primera instrucción del archivo (solo puede ir antes el tag `<?php`).
```php
<?php
declare(strict_types=1);
function duplicar(int $n): int
{
    return $n * 2;
}
echo duplicar(4);    // 8
echo duplicar("4");  // TypeError: Argument #1 ($n) must be of type int, string given
```
Con `strict_types=1` el error es inmediato y visible; sin él, `"4"` se convertiría silenciosamente. Todos los ejemplos de esta guía asumen que el primer archivo o bloque ejecutable incluye esta declaración. **Importante:** la declaración se aplica por archivo, no globalmente; cada archivo que quieras estricto debe declararla al principio.
### Variables
#### Sintaxis y reglas de nombrado
Toda variable empieza con el símbolo `$` seguido de un nombre. PHP no requiere declarar el tipo ni la variable antes de usarla: se crea en el momento en que le asignas un valor.
Reglas para los nombres:
- Empiezan por una letra o un guion bajo (`_`), seguido de letras, números y guiones bajos.
- Son **sensibles a mayúsculas**: `$nombre` y `$Nombre` son variables distintas.
- No pueden contener espacios ni caracteres especiales.
- Por convención se usan `camelCase` o `snake_case`; en esta guía usaremos `snake_case`.
```php
<?php
$nombre = "Ana";          // válido
$edad = 30;               // válido
$_privado = true;         // válido (empieza con _)
// $2valido = 1;          // INVÁLIDO: empieza con número
// $mi-variable = 1;      // INVÁLIDO: guion no permitido
$miVariable = 1;          // válido
```
Las variables no declaradas producen un *warning* y valen `null`. En PHP 8, leer `$algoInexistente` lanza `Warning: Undefined variable`, pero el script continúa.
#### Tipado dinámico y débil
PHP es de tipado **dinámico** (el tipo lo decide el valor, no la declaración) y, sin `strict_types`, **débil** (convierte valores automáticamente). Una misma variable puede cambiar de tipo en el tiempo:
```php
<?php
$valor = 10;        // int
$valor = "texto";   // ahora es string
$valor = 3.14;      // ahora es float
$valor = false;     // ahora es bool
```
No necesitas decirle a PHP qué tipo es cada cosa: el intérprete lo deduce. La ventaja es la flexibilidad; la desventaja es que errores sutiles (como comparar `5 == "5"`) pasan desapercibidos.
#### Inspeccionar valores: `var_dump`, `gettype`, `print_r`
Tres herramientas fundamentales para depurar:
- `var_dump($valor)` — muestra el tipo **y** el valor, con detalle (longitud de strings, de arrays, etc.). Es la más informativa.
- `gettype($valor)` — devuelve el nombre del tipo como string (por ejemplo `"integer"`).
- `print_r($valor)` — imprime una representación legible, sobre todo útil con arrays y objetos.
```php
<?php
$edad = 30;
$nombre = "Ana";
$frutas = ["manzana", "pera"];
var_dump($edad);       // int(30)
var_dump($nombre);     // string(3) "Ana"
var_dump($frutas);     // array(2) { [0] => string(8) "manzana" ... }
echo gettype($edad);   // "integer" (el nombre interno del tipo)
print_r($frutas);      // Array ( [0] => manzana [1] => pera )
```
Consejo: cuando algo no funciona como esperas, pon `var_dump()` sobre la variable sospechosa. Te dirá qué tipo tiene realmente, y el 90 % de las veces el problema es que el tipo no es el que creías.
#### Variables variables
PHP permite usar el valor de una variable como nombre de otra: el símbolo `$$`. Es una característica curiosa pero raramente necesaria.
```php
<?php
$animal = "gato";
$$animal = "Felix";   // crea la variable $gato y le asigna "Felix"
echo $gato;       // Felix
echo ${$animal};  // Felix (forma equivalente)
```
Se recomienda evitarlas en código real: los arrays asociativos (`$datos["gato"]`) cumplen el mismo propósito de forma más legible y segura.
#### Ámbito de variables
Las variables creadas fuera de una función viven en el ámbito **global**; las creadas dentro son **locales** y no son visibles fuera (ni las globales dentro de una función). Esto se estudia a fondo en la guía 02; aquí solo lo adelantamos:
```php
<?php
$global = "soy global";
function probar(): void
{
    // $global no existe aquí; acceder daría un warning
    $local = "soy local";
}
```
Para acceder a una variable global desde una función usarías `global $var` o `$GLOBALS['var']`, pero la recomendación es pasar valores como parámetros.
### Tipos de datos
#### Tipos escalares
Un tipo **escalar** es un valor simple y atómico. PHP 8 tiene cuatro tipos escalares y un tipo especial para "nada":

| Tipo | Ejemplos | Descripción |
| --- | --- | --- |
| `int` | `42`, `-7`, `0` | Números enteros (plataforma de 64 bits) |
| `float` | `3.14`, `-0.5`, `1.0e3` | Números con decimales (punto flotante) |
| `string` | `"hola"`, `'adiós'` | Secuencia de caracteres |
| `bool` | `true`, `false` | Lógico verdadero o falso |
| `null` | `null` | Ausencia de valor |

```php
<?php
$edad = 42;                // int
$precio = 19.99;           // float
$nombre = "Ana";           // string
$activo = true;            // bool
$vacio = null;             // null
var_dump($edad, $precio, $nombre, $activo, $vacio);
```
PHP ignora los guiones bajos dentro de literales numéricos para mejorar la legibilidad: `1_000_000` es lo mismo que `1000000`.
#### El tipo `null`
`null` representa la **ausencia de valor**. Es útil para señalar que algo aún no tiene contenido o que una operación no encontró resultado. Cualquier variable sin valor asignado es `null` de facto.
```php
<?php
$pendiente = null;
var_dump($pendiente);   // NULL
```
Cuidado: `null` no es lo mismo que `0`, que `""` (cadena vacía) ni que `false`. Aunque los tres son "falsy", son tipos distintos.
#### El tipo `mixed`
`mixed` es un tipo que acepta **cualquier** valor (escalares, arrays, objetos, recursos, etc.). Equivale a "no tengo una restricción de tipo". Se usa mucho en funciones genéricas o cuando la entrada es impredecible.
```php
<?php
declare(strict_types=1);
function describir(mixed $valor): string
{
    return "Tipo: " . gettype($valor);
}
echo describir(42);     // Tipo: integer
echo describir("hola"); // Tipo: string
echo describir([1, 2]); // Tipo: array
```
`mixed` es lo contrario de tipar con precisión: úsalo solo cuando realmente no puedes acotar la entrada.
#### Valores *truthy* y *falsy*
En contextos booleanos (condiciones), PHP evalúa cada valor como verdadero o falso. Los valores considerados **falsy** son pocos:

| Valor | ¿Falsy? |
| --- | --- |
| `false`, `0`, `0.0`, `""`, `"0"`, `[]`, `null` | Sí |
| Cualquier otro valor (incluido `"0.0"` y `"false"`) | No |

```php
<?php
var_dump((bool) "hola"); // bool(true)
var_dump((bool) "");     // bool(false)
var_dump((bool) 0);      // bool(false)
var_dump((bool) "0");    // bool(false)
var_dump((bool) "0.0");  // bool(true)  <- sorpresa
```
Este comportamiento explica por qué `if ("0")` no entra en el bloque, y por qué conviene comprobar explícitamente lo que esperas en lugar de fiarte de la verdad implícita.
### Constantes
#### `define()` y `const`
Una constante es un identificador cuyo valor **no puede cambiar** durante la ejecución. Se definen de dos maneras:

| Forma | Sintaxis | Cuándo usarla |
| --- | --- | --- |
| `define()` | `define("NOMBRE", valor)` | Dentro de bloques y condicionales; el nombre es string |
| `const` | `const NOMBRE = valor` | Al nivel de un archivo, siempre; es más rápida |

Por convención las constantes se escriben en MAYÚSCULAS.
```php
<?php
define("PAIS", "Perú");   // con define
const IVA = 0.21;          // con const (PHP 5.3+)
echo PAIS;   // Perú
echo IVA;    // 0.21
echo IVA;    // 0.21 (sigue igual, no puede cambiar)
```
`const` no puede usarse dentro de `if`, bucles ni funciones; en esos casos recurres a `define()`. Desde PHP 8 puedes definir constantes como arrays con ambas formas.
#### Constantes mágicas
PHP ofrece constantes predefinidas cuyo valor cambia según el contexto: las **constantes mágicas**. Se escriben con doble guion bajo.

| Constante | Valor |
| --- | --- |
| `__LINE__` | Número de línea actual del archivo |
| `__FILE__` | Ruta completa y nombre del archivo actual |
| `__DIR__` | Directorio del archivo actual (sin el nombre del archivo) |
| `__FUNCTION__` | Nombre de la función actual |
| `__CLASS__` | Nombre de la clase actual |
| `__METHOD__` | Nombre de la clase y método actual |

```php
<?php
echo __FILE__;   // /ruta/completa/al/archivo.php
echo __DIR__;    // /ruta/completa/al
echo __LINE__;   // 5 (el número de línea donde se escribe)
define("ARCHIVO_CONFIG", __DIR__ . "/config.php");
```
`__DIR__` es imprescindible para construir rutas de archivos relativas sin depender del directorio de trabajo actual.
### Operadores
#### Operadores aritméticos
Realizan operaciones matemáticas sobre números. En PHP, `/` siempre produce `float` (salvo excepciones) y `%` solo funciona con enteros.

| Operador | Nombre | Ejemplo | Resultado |
| --- | --- | --- | --- |
| `+` | Suma | `7 + 2` | `9` |
| `-` | Resta | `7 - 2` | `5` |
| `*` | Multiplicación | `7 * 2` | `14` |
| `/` | División | `7 / 2` | `3.5` (float) |
| `%` | Módulo (resto) | `7 % 2` | `1` |
| `**` | Potencia | `2 ** 10` | `1024` |

```php
<?php
echo 7 + 2, "\n";   // 9
echo 7 / 2, "\n";   // 3.5
echo 7 % 2, "\n";   // 1
echo 2 ** 10, "\n"; // 1024
echo 10 / 4, "\n";  // 2.5
```
Dividir entre cero lanza una excepción `DivisionByZeroError` en PHP 8 (antes era un warning que devolvía `false`).
#### Operadores de asignación
Además de `=` existen operadores que combinan asignación con otra operación:

| Operador | Equivale a |
| --- | --- |
| `+=` | `$a = $a + $b` |
| `-=` | `$a = $a - $b` |
| `*=` | `$a = $a * $b` |
| `/=` | `$a = $a / $b` |
| `.=` | `$a = $a . $b` (concatena) |
| `++` / `--` | Incrementa / decrementa en 1 |

```php
<?php
$total = 100;
$total += 50;    // 150
$total -= 20;    // 130
$total *= 2;     // 260
$total /= 4;     // 65
$nombre = "Ana";
$nombre .= " García";   // "Ana García"
$i = 1;
$i++;   // 2
$i--;   // 1
```
`$i++` (post-incremento) devuelve el valor anterior; `++$i` (pre-incremento) devuelve el nuevo. La diferencia importa cuando se usa dentro de una expresión.
#### Operadores de comparación e identidad
Comparan dos valores y devuelven un `bool`. La regla de oro: **usa siempre `===`** en lugar de `==` salvo que tengas una razón explícita, porque `==` aplica coerción y produce resultados contraintuitivos.

| Operador | Significado |
| --- | --- |
| `==` | Igualdad (con coerción de tipos) |
| `===` | Identidad (igual valor **y** mismo tipo) |
| `!=` | Distinto (con coerción) |
| `!==` | No idéntico (valor o tipo distintos) |
| `<`, `>`, `<=`, `>=` | Comparación de orden |
| `<=>` | Comparación "nave espacial": `-1`, `0` o `1` |

```php
<?php
var_dump(5 == "5");      // bool(true)   <- convierte "5" a 5
var_dump(5 === "5");     // bool(false)  <- int no es string
var_dump(0 == "a");      // bool(false) en PHP 8 (en PHP 7 era true)
var_dump("" == false);   // bool(true)   <- sorprendente
var_dump(1 === 1);       // bool(true)
var_dump(1 <=> 2);       // int(-1)
```
En PHP 8 la comparación de números y strings se comporta de forma más lógica que en versiones antiguas, pero sigue siendo un foco de errores.
#### Operadores lógicos
Combinan condiciones booleanas. `&&` y `and` son equivalentes pero con distinta precedencia (`&&` es más fuerte); en la práctica casi todos usan `&&` y `||`.

| Operador | Palabra clave | Resultado |
| --- | --- | --- |
| `&&` | `and` | `true` solo si ambos son verdaderos |
| `\|\|` | `or` | `true` si al menos uno es verdadero |
| `!` | `not` | Invierte el valor |

```php
<?php
$edad = 25;
$tieneDni = true;
var_dump($edad >= 18 && $tieneDni);  // bool(true)
var_dump($edad < 18 || $tieneDni);   // bool(true)
var_dump(!$tieneDni);                // bool(false)
```
`&&` y `||` hacen *short-circuit*: si el resultado ya está decidido, no evalúan el resto. En `false && algo`, `algo` no se evalúa.
#### Operadores de bits
Trabajan sobre la representación binaria de los números. Son de bajo nivel y se usan sobre todo en banderas, permisos y empaquetado de datos.

| Operador | Nombre | Ejemplo (8 bits) | Resultado |
| --- | --- | --- | --- |
| `&` | AND | `0b1100 & 0b1010` | `0b1000` (8) |
| `\|` | OR | `0b1100 \| 0b1010` | `0b1110` (14) |
| `^` | XOR | `0b1100 ^ 0b1010` | `0b0110` (6) |
| `~` | NOT (negación) | `~0b1` | `-2` (complemento a dos) |
| `<<` | Desplazamiento izquierda | `1 << 4` | `16` (multiplica por 2^n) |
| `>>` | Desplazamiento derecha | `16 >> 2` | `4` (divide por 2^n) |

```php
<?php
var_dump(0b1100 & 0b1010);   // int(8)
var_dump(0b1100 | 0b1010);   // int(14)
var_dump(0b1100 ^ 0b1010);   // int(6)
var_dump(1 << 4);            // int(16)
var_dump(16 >> 2);           // int(4)
```
Un caso de uso típico son los permisos de archivos: `4` (lectura), `2` (escritura), `1` (ejecución). Con `|` combinas permisos y con `&` compruebas si un permiso está activo.
#### Operador de concatenación `.`
El punto `.` une (concatena) cadenas. Es un operador real, no un método, y es una de las cosas que más diferencian a PHP de otros lenguajes.
```php
<?php
$nombre = "Ana";
$saludo = "Hola, " . $nombre . "!";
echo $saludo;   // Hola, Ana!
echo "El valor es " . 42;   // El valor es 42
```
Al concatenar un número con una cadena, PHP convierte el número a string. Si ambos operandos son numéricos, `1 . 1` es `"11"`.
### Coerción y casting
#### Casting explícito
El **casting** convierte un valor a otro tipo de forma explícita y controlada, poniendo el tipo entre paréntesis antes del valor:

| Cast | Convierte a |
| --- | --- |
| `(int)` o `(integer)` | Entero |
| `(float)` o `(double)` | Decimal |
| `(string)` | Cadena |
| `(bool)` o `(boolean)` | Booleano |
| `(array)` | Array |

```php
<?php
$precio = "19.99";
$entero = (int) $precio;      // 19 (trunca los decimales)
$decimal = (float) $precio;   // 19.99
$comoTexto = (string) 42;     // "42"
$logico = (bool) "si";        // true
var_dump($entero, $decimal, $comoTexto, $logico);
```
Reglas de conversión a tener presentes:
- `(int)` de un string numérico con decimales trunca: `(int) "3.99"` es `3`.
- `(int) "3.5 patatas"` convierte el número inicial y descarta el resto.
- `(bool) "0"` y `(bool) ""` son `false`; `(bool) "false"` es `true` (no está en la lista de falsy).
- `(int) null` es `0`; `(string) null` es `""`.
#### Funciones de conversión
PHP también ofrece funciones que convierten tipos. Se comportan igual que el casting para los casos básicos, pero permiten más control (como la base en `intval`).

| Función | Equivale a | Notas |
| --- | --- | --- |
| `intval($v)` | `(int) $v` | Acepta una base como segundo argumento |
| `floatval($v)` | `(float) $v` | — |
| `strval($v)` | `(string) $v` | — |
| `boolval($v)` | `(bool) $v` | — |
| `settype($v, "tipo")` | varias | Modifica la variable en el sitio y devuelve `bool` |

```php
<?php
echo intval("0x1A", 16);   // 26 (interpreta en base 16)
echo intval("101", 2);     // 5 (interpreta en base 2)
echo strval(3.14);         // "3.14"
echo boolval(0);           // "" (false se imprime vacío)
$n = 5.7;
settype($n, "int");
var_dump($n);   // int(5)  (modificó la variable original)
```
#### Coerción automática
Sin `strict_types`, PHP convierte los tipos automáticamente al llamar funciones o comparar. Esto es la **coerción**. A veces es cómoda y otras veces es la fuente de bugs.
```php
<?php
function suma(int $a, int $b): int
{
    return $a + $b;
}
// Sin strict_types, PHP convierte:
echo suma(3, 4);      // 7
echo suma("3", 4);    // 7   <- "3" se convierte a int
echo suma(3.9, 1);    // 4   <- 3.9 se TRUNCA a 3 (¡ojo!)
```
La coerción de un `float` a `int` **trunca** el valor. Por eso, en cuanto escribas funciones con tipos, activa `strict_types` para eliminar estas sorpresas.
### Strings
#### Comillas simples vs. dobles
El tipo `string` es una secuencia de bytes. Se puede delimitar con comillas simples o dobles, y la diferencia es importante:
- **Comillas dobles** `"..."`: interpolan variables y procesan secuencias de escape (`\n`, `\t`, `\"`, `\\`).
- **Comillas simples** `'...'`: no interpolan nada; solo procesan `\\` y `\'`.
```php
<?php
$nombre = "Ana";
echo "$nombre estudia PHP\n";     // Ana estudia PHP (interpola y \n es salto)
echo '$nombre estudia PHP\n';     // $nombre estudia PHP\n (literal)
```
Regla práctica: si la cadena no tiene variables ni saltos, usa comillas simples (ligeramente más rápido y sin sorpresas). Si necesita interpolación o escapes, usa dobles.
#### Interpolación de variables
Dentro de comillas dobles, `$variable` se sustituye por su valor. Para desambiguar dónde termina el nombre de la variable (o para interpolar expresiones), usa llaves `{$var}`:
```php
<?php
$mes = "enero";
echo "Estamos en $mes\n";         // Estamos en enero
$fruta = "pera";
$precio = 12;
echo "La {$fruta}s están caras\n"; // La peras están caras  (sin {} daría error)
echo "Cuesta {$precio} soles\n";   // Cuesta 12 soles
```
La forma `{$var}` se recomienda siempre que la variable vaya seguida de caracteres que podrían confundirse con su nombre. La forma antigua `${var}` fue eliminada en PHP 8.
#### Heredoc y nowdoc
Para cadenas largas de varias líneas, PHP ofrece dos alternativas que preservan los saltos de línea:
- **Heredoc** (`<<<ETIQUETA`): se comporta como comillas dobles: **interpola** variables.
- **Nowdoc** (`<<<'ETIQUETA'`): se comporta como comillas simples: **no interpola** nada.
```php
<?php
$usuario = "Ana";
$mensaje = <<<TXT
Hola, $usuario.
Esta es una cadena heredoc:
interpola variables y mantiene los saltos.
TXT;
echo $mensaje;
$plantilla = <<<'TXT'
Aquí $usuario NO se interpola.
Sirve para plantillas con texto literal.
TXT;
echo $plantilla;
```
La etiqueta de cierre debe ir al inicio de la línea (sin espacios antes) y terminar con `;`. Heredoc y nowdoc son ideales para generar SQL, HTML o textos largos sin concatenar.
#### Funciones de strings
PHP tiene un catálogo enorme de funciones para strings. Las más útiles al empezar:

| Función | Qué hace |
| --- | --- |
| `strlen($s)` | Longitud en bytes |
| `strtolower($s)` / `strtoupper($s)` | Minúsculas / mayúsculas |
| `ucfirst($s)` / `lcfirst($s)` | Primera letra mayúscula / minúscula |
| `strpos($aguja, $pajar)` | Posición de la primera aparición (o `false`) |
| `substr($s, $inicio, $longitud)` | Extrae un trozo de la cadena |
| `str_replace($b, $n, $s)` | Reemplaza ocurrencias |
| `trim($s)` | Elimina espacios al inicio y al final |
| `str_split($s)` | Divide en array de caracteres |
| `str_repeat($s, $n)` | Repite la cadena `$n` veces |
| `sprintf()` | Formatea texto con marcadores `%s`, `%d`, `%f` |

```php
<?php
$texto = "  Hola Mundo  ";
echo strlen($texto), "\n";              // 14 (bytes, incluye espacios)
echo strtolower($texto), "\n";          // "  hola mundo  "
echo trim($texto), "\n";                // "Hola Mundo"
$pos = strpos($texto, "Mundo");
var_dump($pos);                          // int(7)
echo substr("programación", 0, 6), "\n"; // "progra"
echo str_replace("Mundo", "PHP", $texto), "\n"; // "  Hola PHP  "
echo sprintf("Soy %s y tengo %d años", "Ana", 30), "\n"; // Soy Ana y tengo 30 años
```
`strpos` devuelve `false` si no encuentra la subcadena. Como `0` es una posición válida, **nunca** compares con `== false`: usa `=== false`.
### Condicionales
#### `if`, `elseif`, `else`
La estructura de decisión básica. La condición se evalúa en contexto booleano (se aplican las reglas *truthy*/*falsy* vistas antes).
```php
<?php
$nota = 85;
if ($nota >= 90) {
    $resultado = "Excelente";
} elseif ($nota >= 70) {
    $resultado = "Aprobado";
} else {
    $resultado = "Reprobado";
}
echo $resultado;
```
Detalles importantes:
- `elseif` se escribe en una sola palabra (con `else if` separado también funciona).
- Si solo hay una instrucción, se pueden omitir las llaves, pero **no se recomienda**.
- Los bloques `elseif` se evalúan en orden; al primero que cumpla la condición, los demás se ignoran.
#### `switch`
Sirve para comparar una misma variable contra varios valores concretos. Compara con `==` (comparación floja) por defecto. Cada caso debe terminar con `break`, o el flujo "cae" al siguiente caso.
```php
<?php
$dia = "lun";
switch ($dia) {
    case "lun":
        echo "Lunes";
        break;
    case "mar":
        echo "Martes";
        break;
    case "mie":
        echo "Miércoles";
        break;
    default:
        echo "Día desconocido";
}
```
Si olvidas un `break`, PHP continúa ejecutando los siguientes casos (a veces se usa a propósito para agrupar casos). En la mayoría de situaciones, la expresión `match` de PHP 8 es una alternativa más segura y limpia.
#### Operador ternario y Elvis
El **ternario** es una expresión compacta para elegir entre dos valores:
```php
<?php
$edad = 20;
$mensaje = $edad >= 18 ? "Mayor de edad" : "Menor de edad";
echo $mensaje;   // Mayor de edad
```
El operador **Elvis** `?:` devuelve el operando izquierdo si es *truthy*; si no, el derecho:
```php
<?php
$nombre = "";
$saludo = $nombre ?: "Anónimo";
echo $saludo;   // Anónimo ("" es falsy)
```
Ambos son expresiones: se pueden anidar, pasar como argumentos o asignar. El ternario se evalúa de izquierda a derecha, así que evita encadenar varios en la misma línea sin paréntesis.
#### Null coalescing `??`
El operador `??` devuelve el operando izquierdo si **existe y no es `null`**; si no, el derecho. Es ideal para acceder a índices que quizá no existan, sin warnings:
```php
<?php
$config = ["tema" => "claro"];
$tema = $config["tema"] ?? "oscuro";       // "claro"
$idioma = $config["idioma"] ?? "es";       // "es" (no existe el índice)
$sinDefinir = $variableQueNoExiste ?? "por defecto";
echo $sinDefinir;   // "por defecto" (sin warnings)
```
Puede encadenarse: `$a ?? $b ?? $c`. La diferencia con el Elvis es que `??` solo reacciona ante `null` (o inexistencia), no ante cualquier valor falsy.
#### La expresión `match`
`match` (PHP 8) es la evolución de `switch`: es una **expresión** que devuelve un valor, usa comparación estricta (`===`), no necesita `break` y lanza `UnhandledMatchError` si ningún caso coincide y no hay `default`.
```php
<?php
function nombreDelMes(int $mes): string
{
    return match ($mes) {
        1 => "Enero",
        2 => "Febrero",
        3 => "Marzo",
        4 => "Abril",
        5 => "Mayo",
        6 => "Junio",
        7 => "Julio",
        8 => "Agosto",
        9 => "Septiembre",
        10 => "Octubre",
        11 => "Noviembre",
        12 => "Diciembre",
        default => "Mes inválido",
    };
}
echo nombreDelMes(7);   // Julio
```
Se pueden agrupar varios valores en una rama con coma: `1, 2 => "Inicio de año"`. También puede tener condiciones en la rama:
```php
<?php
$edad = 18;
$tipo = match (true) {
    $edad < 13       => "niño",
    $edad < 18       => "adolescente",
    $edad < 65       => "adulto",
    default          => "senior",
};
echo $tipo;   // adulto
```
`match` solo ejecuta la rama que coincide y **no** tiene *fall-through*: cada caso es independiente.
### Bucles
#### `for`
Repite un bloque un número conocido de veces. Se compone de tres partes: inicialización, condición y actualización.
```php
<?php
for ($i = 0; $i < 5; $i++) {
    echo "$i ";
}
// Salida: 0 1 2 3 4
```
Cualquiera de las tres partes puede estar vacía. Con variables `int`, el incremento `$i++` es lo habitual.
#### `while`
Evalúa la condición **antes** de cada iteración. Si es falsa desde el principio, el bloque nunca se ejecuta.
```php
<?php
$n = 0;
while ($n < 3) {
    echo "Iteración $n\n";
    $n++;
}
```
Si la condición nunca deja de cumplirse, tendrás un bucle infinito. Para que no ocurra, la variable de la condición debe modificarse dentro del bloque.
#### `do...while`
Evalúa la condición **después** de ejecutar el bloque: el cuerpo se ejecuta siempre al menos una vez. Útil para menús, lecturas de entrada o validaciones que deben intentarse primero.
```php
<?php
$intentos = 0;
do {
    $intentos++;
    echo "Intento $intentos\n";
} while ($intentos < 3);
// Salida: Intento 1, 2, 3
```
#### `foreach`
Recorre arrays sin necesidad de contadores ni índices: es la forma recomendada de iterar colecciones.
```php
<?php
$frutas = ["manzana", "pera", "uva"];
foreach ($frutas as $fruta) {
    echo $fruta . " ";
}
// Salida: manzana pera uva
$edades = ["Ana" => 30, "Luis" => 25];
foreach ($edades as $nombre => $edad) {
    echo "$nombre tiene $edad años\n";
}
```
En la sintaxis con clave `foreach ($array as $clave => $valor)`, ambas variables quedan disponibles. `foreach` no incrementa ningún índice automático: simplemente recorre.
#### `break` y `continue`
- `break` interrumpe el bucle actual por completo (y puede aceptar un número para salir de varios bucles anidados: `break 2`).
- `continue` salta a la siguiente iteración, omitiendo el resto del cuerpo.
```php
<?php
for ($i = 1; $i <= 10; $i++) {
    if ($i % 2 === 0) {
        continue;   // salta los pares
    }
    if ($i > 7) {
        break;      // corta en cuanto pasa de 7
    }
    echo "$i ";
}
// Salida: 1 3 5 7
```
### Arrays: introducción
#### Indexados y asociativos
Un array es una colección ordenada de pares clave → valor. En PHP todos los arrays son internamente iguales; la diferencia es estilística:
- **Indexado**: claves numéricas automáticas (`0`, `1`, `2`...).
- **Asociativo**: claves string que tú eliges.
```php
<?php
$frutas = ["manzana", "pera", "uva"];           // indexado
$alumno = ["nombre" => "Ana", "edad" => 30];     // asociativo
echo $frutas[0];           // manzana
echo $alumno["nombre"];    // Ana
```
Los arrays se estudian en profundidad en la guía 02; aquí vemos la base y las funciones imprescindibles.
#### Sintaxis `[]` y `array()`
Desde PHP 5.4 la forma corta `[]` es la estándar; `array()` es la antigua y aún funciona:
```php
<?php
$a = array(1, 2, 3);
$b = [1, 2, 3];        // equivalente, recomendado
```
Se puede mezclar cualquier tipo dentro de un array, e incluso anidar arrays (arrays multidimensionales).
#### Funciones básicas

| Función | Qué hace |
| --- | --- |
| `count($arr)` | Número de elementos |
| `implode($sep, $arr)` | Une los elementos en un string con un separador |
| `explode($sep, $str)` | Divide un string en un array |
| `array_push($arr, $v)` | Añade uno o varios elementos al final |
| `sort($arr)` | Ordena en el sitio (modifica el array), de menor a mayor |
| `rsort($arr)` | Ordena en el sitio, de mayor a menor |
| `in_array($v, $arr)` | Comprueba si un valor existe |

```php
<?php
$nombres = ["Ana", "Luis", "Pablo"];
echo count($nombres), "\n";                  // 3
echo implode(", ", $nombres), "\n";          // Ana, Luis, Pablo
$palabras = explode(" ", "hola mundo php");
print_r($palabras);                          // [0=>"hola",1=>"mundo",2=>"php"]
array_push($nombres, "Elena");
$nombres[] = "Sofía";                        // también añade al final
sort($nombres);
echo implode(", ", $nombres), "\n";          // Ana, Elena, Luis, Pablo, Sofía
```
Recuerda: `sort`, `rsort` y `array_push` **modifican el array original** (operan por referencia) y no devuelven el array ordenado: `sort($x)` devuelve `true/false`.
### Entrada y salida (CLI)
#### Escribir en la consola
Ya conocemos `echo` y `print`. Un detalle útil en la terminal: `PHP_EOL` es la constante de salto de línea del sistema (en Linux, `"\n"`).
```php
<?php
echo "Línea 1" . PHP_EOL;
echo "Línea 2\n";
```
#### Leer entrada: `fgets(STDIN)`
Para leer lo que el usuario escribe en la terminal, usamos `fgets(STDIN)`, que lee una línea completa (incluido el salto de línea final). Normalmente recortamos con `trim()`.
```php
<?php
echo "¿Cómo te llamas? ";
$nombre = trim(fgets(STDIN));
echo "Hola, $nombre!\n";
```
`fgets` devuelve un string; conviene convertir con casting si esperas un número:
```php
<?php
echo "Edad: ";
$edad = (int) trim(fgets(STDIN));
if ($edad >= 18) {
    echo "Mayor de edad\n";
} else {
    echo "Menor de edad\n";
}
```
#### Argumentos: `$argv` y `$argc`
Cuando ejecutas `php script.php arg1 arg2`, PHP pone los argumentos en variables globales automáticas:
- `$argv` — array con todos los argumentos; `$argv[0]` es el nombre del script.
- `$argc` — entero con la cantidad de argumentos.
```php
<?php
// Uso: php saludar.php Ana 30
var_dump($argv);   // array(3) { [0]=>"saludar.php", [1]=>"Ana", [2]=>"30" }
echo "Argumentos: $argc\n";
if ($argc >= 2) {
    $nombre = $argv[1];
    $edad = isset($argv[2]) ? (int) $argv[2] : 0;
    echo "Hola, $nombre";
    if ($edad > 0) {
        echo ", tienes $edad años";
    }
    echo "\n";
}
```
Con `$argv` y `fgets(STDIN)` puedes construir programas interactivos completos desde la terminal, sin necesidad de HTML ni servidor.
## Ejemplos de código

```php
<?php
declare(strict_types=1);
// Ejemplo 1: calculadora de IMC con entrada por consola
echo "=== Calculadora de IMC ===\n";
echo "Peso (kg): ";
$peso = (float) trim(fgets(STDIN));
echo "Altura (m): ";
$altura = (float) trim(fgets(STDIN));
if ($altura <= 0 || $peso <= 0) {
    echo "Datos inválidos.\n";
    exit(1);
}
$imc = $peso / ($altura ** 2);
printf("Tu IMC es %.2f\n", $imc);
$categoria = match (true) {
    $imc < 18.5  => "bajo peso",
    $imc < 25    => "peso normal",
    $imc < 30    => "sobrepeso",
    default      => "obesidad",
};
echo "Categoría: $categoria\n";
```
```php
<?php
declare(strict_types=1);
// Ejemplo 2: tabla de multiplicar con for e interpolación
$numero = 7;
echo "Tabla del $numero:\n";
for ($i = 1; $i <= 10; $i++) {
    echo "{$numero} x {$i} = " . ($numero * $i) . PHP_EOL;
}
```
```php
<?php
declare(strict_types=1);
// Ejemplo 3: analizador de texto
$texto = "PHP es un lenguaje poderoso. PHP se ejecuta en el servidor.";
$palabras = explode(" ", strtolower($texto));
$palabras = array_filter($palabras, fn ($p) => $p !== "");
echo "Longitud: " . strlen($texto) . " caracteres\n";
echo "Palabras: " . count($palabras) . "\n";
echo "Sin signos: " . str_replace(".", "", $texto) . "\n";
echo "Con 'PHP': " . (strpos($texto, "PHP") !== false ? "sí" : "no") . "\n";
```
```php
<?php
declare(strict_types=1);
// Ejemplo 4: menú interactivo con do...while y switch
do {
    echo "\n--- Menú ---\n";
    echo "1) Saludar\n2) Decir la hora\n3) Salir\n";
    echo "Opción: ";
    $opcion = trim(fgets(STDIN));
    switch ($opcion) {
        case "1":
            echo "¡Hola!\n";
            break;
        case "2":
            echo date("H:i:s") . "\n";
            break;
        case "3":
            echo "Adiós.\n";
            break;
        default:
            echo "Opción inválida.\n";
    }
} while ($opcion !== "3");
```
```php
<?php
declare(strict_types=1);
// Ejemplo 5: clasificador de números con match y break/continue
for ($i = 1; $i <= 15; $i++) {
    if ($i === 15) {
        break;
    }
    if ($i % 5 === 0) {
        continue;
    }
    $tipo = match (true) {
        $i % 2 === 0 => "par",
        default      => "impar",
    };
    printf("%d es %s\n", $i, $tipo);
}
```
## Ejercicios relacionados

- [Ejercicios nivel 01 — Fundamentos](../ejercicios/nivel-01-fundamentos/)
- [Proyectos PHP](../ejercicios/proyectos/)
## Errores comunes

- **Olvidar el `$` en las variables** → `echo nombre;` produce `Error: Undefined constant "nombre"`. Todas las variables llevan `$`.
- **Usar comillas simples esperando interpolación** → `'El valor es $x'` muestra literalmente `$x`. Si quieres interpolación, usa comillas dobles.
- **Usar `==` en vez de `===`** → `"0" == 0` es `true` por la coerción, aunque parezca absurdo. Usa `===` para comparar valor y tipo.
- **Comparar `strpos` con `!= false` en vez de `!== false`** → si la posición es `0`, `0 == false` es `true` y pierdes el caso "está al principio".
- **Confundir `&&`/`and` o `||`/`or`** → `$a || $b and $c` no hace lo que parece por la precedencia. Usa `&&` y `||`.
- **Olvidar `break` en `switch`** → en PHP 8 `switch` sigue cayendo al siguiente caso (fall-through). `match`, en cambio, no necesita `break`.
- **Escribir `elseif` mal** → `else if` con espacio también funciona, pero la forma `elseif` es la canónica y evita ambigüedades.
- **`(int)` trunca decimales** → `(int) 3.9` es `3`, no `4`. Si necesitas redondear, usa `round()`.
- **Depender de la coerción en parámetros** → sin `strict_types`, `func(3.9)` convierte a `3`. Declara `declare(strict_types=1)` y exige tipos exactos.
- **Dividir entre cero** → lanza `DivisionByZeroError`. Comprueba el divisor antes de operar.
- **Acceder a un índice inexistente** → `$arr[99]` o `$arr["clave"]` sin `isset()` produce un *warning* y devuelve `null`. Usa `??` para un default limpio.
- **Leer variables sin inicializar** → `echo $x;` dispara `Warning: Undefined variable`. Inicializa siempre con un valor por defecto.
- **`match` sin rama que coincida y sin `default`** → se lanza `UnhandledMatchError`. Añade siempre un `default`.
- **Olvidar la etiqueta de cierre en heredoc al inicio de línea** → `Parse error: syntax error`. La etiqueta de cierre debe estar al principio de la línea, sin espacios.
- **`foreach` sobre una variable que no es array** → si `$datos` es `null`, obtienes un *warning*. Asegúrate de que sea un array antes de iterar.
- **Confundir constantes con variables** → las constantes no llevan `$`, se escriben en mayúsculas y no cambian de valor: `define("MAX", 10)`.
- **Interpolar arrays directamente** → `"$arr[0]"` en comillas dobles puede dar resultados confusos; usa `"{$arr[0]}"` o concatenación con `.`.
- **Olvidar que `sort`, `rsort` y `array_push` modifican el array original** → `$x = sort($arr);` deja `$x` como `true`, no como el array ordenado.
## Recursos

- [PHP.net — Manual en español](https://www.php.net/manual/es/)
- [PHP.net — Tipos](https://www.php.net/manual/es/language.types.intro.php)
- [PHP.net — Control Structures](https://www.php.net/manual/es/language.control-structures.php)
- [PHP.net — Operadores](https://www.php.net/manual/es/language.operators.php)
- [PHP.net — Cadenas](https://www.php.net/manual/es/language.types.string.php)
- [PHP.net — Funciones de strings](https://www.php.net/manual/es/ref.strings.php)
- [PHP.net — match](https://www.php.net/manual/es/control-structures.match.php)
- [PHP.net — Línea de comandos](https://www.php.net/manual/es/features.commandline.php)
- [PHP the right way — en español](https://phptherightway.com/es/)
- [PHP.net — Descargar PHP](https://www.php.net/downloads)
