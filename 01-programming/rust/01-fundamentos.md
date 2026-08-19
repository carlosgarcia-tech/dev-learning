# 01 — Fundamentos de Rust

## Objetivos

- [ ] Escribir un programa ejecutable con `fn main()` y ejecutarlo con `cargo run`.
- [ ] Declarar variables con `let`, la inmutabilidad por defecto, `mut` y el *shadowing*.
- [ ] Declarar constantes con `const` y distinguirlas de `let`.
- [ ] Conocer los tipos numéricos (enteros y flotantes) y sus rangos.
- [ ] Usar `bool`, `char`, tuplas, arrays y *slices*.
- [ ] Aplicar operadores aritméticos, de comparación, lógicos y de bits.
- [ ] Entender la división entera, el operador `%` y el *overflow*.
- [ ] Distinguir `String` de `&str`, crear y modificar `String`.
- [ ] Usar `if` como expresión, y escribir `match` exhaustivo e `if let`.
- [ ] Manejar `loop`, `while` y `for` con etiquetas, `break` y `continue`.
- [ ] Convertir entre tipos con `as` y `.parse()`.
- [ ] Leer la entrada estándar con `std::io` y los argumentos con `std::env`.
- [ ] Definir funciones con retorno usando la última expresión sin `;`.
- [ ] Compilar y verificar un programa completo con `cargo check`.

## Apuntes

### La función main

Todo programa ejecutable comienza en `fn main()`. El punto de entrada es obligatorio: sin él, un binario no compila. Su cuerpo se ejecuta de arriba hacia abajo; casi todo el código vive dentro de funciones.

```rust
fn main() {
    println!("¡Hola, Rust!");
}
```

#### Cargo y el ciclo de trabajo

Cargo es el gestor de proyectos de Rust. Un proyecto nuevo se crea con `cargo new` y las operaciones del ciclo de trabajo son:

| Comando                 | Qué hace                                                       |
|-------------------------|----------------------------------------------------------------|
| `cargo new nombre`      | Crea un proyecto nuevo con la estructura de carpetas.          |
| `cargo check`           | Compila sin generar binario (rápido para ver errores).         |
| `cargo build`           | Compila y genera el binario en `target/`.                      |
| `cargo run`             | Compila y ejecuta el binario en un paso.                       |
| `cargo build --release` | Compila con optimizaciones para producción.                    |
| `cargo fmt`             | Formatea el código según el estilo oficial.                    |
| `cargo clippy`          | Analiza el código con linters extra.                           |

En `Cargo.toml` se declaran las dependencias; `Cargo.lock` fija las versiones exactas. En este nivel solo usamos la biblioteca estándar (`std`), así que no hay dependencias externas. También puedes compilar un archivo suelto con `rustc archivo.rs`.

#### println! y formatos de salida

`println!` imprime una línea con salto de línea final; `print!` no lo añade. Ambos son *macros* (por eso el `!`) y aceptan una cadena de formato:

| Marcador    | Significado                               | Ejemplo                        |
|-------------|-------------------------------------------|--------------------------------|
| `{}`        | Formato por defecto                       | `println!("{}", 42)`           |
| `{:?}`      | Formato de depuración (Debug)             | `println!("{:?}", [1, 2])`     |
| `{:.2}`     | Dos decimales                             | `println!("{:.2}", 3.14159)`   |
| `{:x}`      | Número en hexadecimal                     | `println!("{:x}", 255)`        |
| `{nombre}`  | Argumento con nombre                      | `println!("{nombre}")`         |
| `{0} {1}`   | Argumentos posicionales                   | `println!("{0} y {1}", 1, 2)`  |

```rust
fn main() {
    let nombre = "Ana";
    let pi = 3.14159;
    let lista = [10, 20, 30];
    println!("Hola, {nombre}!");
    println!("Pi con 2 decimales: {:.2}", pi);
    println!("255 en hex: {:x}", 255);
    println!("El arreglo es: {:?}", lista);
}
```

La cadena de formato se verifica **en tiempo de compilación**: un `{}` de más o de menos es un error antes de ejecutar.

### Variables y mutabilidad

Las variables se declaran con `let` y son **inmutables por defecto**. Para reasignarlas hay que declararlas con `mut`.

```rust
fn main() {
    let inmutable = 5;
    // inmutable = 6;   // ERROR: cannot assign twice to immutable variable
    let mut contador = 0;
    contador += 1;      // ok: es mutable
    println!("Contador: {contador}");
}
```

El tipo se **infiere** del valor, pero se puede anotar explícitamente:

```rust
fn main() {
    let edad: u32 = 30;      // entero sin signo de 32 bits
    let peso: f64 = 70.5;    // flotante de 64 bits
    let activo: bool = true; // booleano
    println!("{edad} {peso} {activo}");
}
```

#### Shadowing

El *shadowing* declara una variable nueva con el mismo nombre, ocultando a la anterior. A diferencia de `mut`, no modifica el valor: crea una variable nueva y puede cambiar de tipo.

```rust
fn main() {
    let x = 5;
    let x = x + 1;          // oculta a la anterior: ahora vale 6
    let x = x * 2;          // ahora vale 12
    println!("x = {x}");    // 12
    // El shadowing permite cambiar de tipo:
    let texto = "123";
    let texto: u32 = texto.parse().expect("no era número");
    println!("Como número: {texto}");
}
```

#### const

Las constantes se declaran con `const`. Reglas: siempre anotan tipo, su valor se conoce en tiempo de compilación, se escriben en `MAYÚSCULAS` y se copian (inlinan) donde se usan.

```rust
const GRAVEDAD: f64 = 9.81;
const VELOCIDAD_LUZ: u32 = 299_792_458;   // el _ es un separador visual
const MENSAJE: &str = "Soy una constante";
fn main() {
    println!("{GRAVEDAD} {VELOCIDAD_LUZ} {MENSAJE}");
}
```

Las constantes pueden declararse fuera de cualquier función, cosa que `let` no puede. Los `_` en números son solo legibilidad: `299_792_458 == 299792458`.

#### Ámbito y bloques

Un bloque son llaves `{ ... }`. Las variables solo existen dentro del bloque donde se declaran y se destruyen al salir. El bloque también es una **expresión**: devuelve el valor de su última línea.

```rust
fn main() {
    let exterior = 10;
    {
        let interior = 20;
        println!("Dentro: {exterior} y {interior}");   // ok
    }
    // println!("{interior}"); // ERROR: cannot find value `interior`
    let descripcion = {
        if exterior % 2 == 0 { "par" } else { "impar" }
    };
    println!("{exterior} es {descripcion}");
}
```

La última línea del bloque **no lleva `;`**; si lo lleva, devuelve `()` (la unidad, el "valor vacío").

### Tipos de datos

Rust tiene tipado estático y fuerte: el tipo de cada valor se conoce en compilación y mezclar tipos incompatibles no compila.

#### Enteros (tabla de rangos)

Los enteros son con signo (`i`) o sin signo (`u`); el número indica los bits de ancho. Si no se anota, se infiere `i32`.

| Tipo   | Con/Sin signo | Rango                                                |
|--------|---------------|------------------------------------------------------|
| `i8`   | Con signo     | −128 a 127                                           |
| `i16`  | Con signo     | −32 768 a 32 767                                     |
| `i32`  | Con signo     | −2 147 483 648 a 2 147 483 647                       |
| `i64`  | Con signo     | −9 223 372 036 854 775 808 a 9 223 372 036 854 775 807 |
| `i128` | Con signo     | −2¹²⁷ a 2¹²⁷−1                                       |
| `isize`| Con signo     | Depende de la arquitectura (32 o 64 bits)            |
| `u8`   | Sin signo     | 0 a 255                                              |
| `u16`  | Sin signo     | 0 a 65 535                                           |
| `u32`  | Sin signo     | 0 a 4 294 967 295                                    |
| `u64`  | Sin signo     | 0 a 18 446 744 073 709 551 615                       |
| `u128` | Sin signo     | 0 a 2¹²⁸−1                                           |
| `usize`| Sin signo     | Depende de la arquitectura (índices de colecciones)  |

```rust
fn main() {
    let a: i8 = -100;          // con signo, pequeño
    let b: u8 = 255;           // máximo de u8
    let c = 42;                // se infiere i32
    let d: u64 = 18_446_744_073_709_551_615;
    println!("{a} {b} {c} {d}");
}
```

Un literal fuera de rango no compila:

```rust
fn main() {
    // let b: u8 = 256;  // ERROR: literal out of range for `u8`
    // let a: i8 = 128;  // ERROR: literal out of range for `i8`
    println!("los literales fuera de rango no compilan");
}
```

#### Flotantes

`f32` (32 bits) y `f64` (64 bits, el inferido por defecto). Admiten valores especiales como infinito y NaN. Los flotantes no deben compararse con `==` exacto; usa una tolerancia.

```rust
fn main() {
    let pi = 3.141592653589793;        // f64
    let pequeno: f32 = 1.5;            // f32 explícito
    let nan = f64::NAN;
    let inf = f64::INFINITY;
    println!("pi={pi}, f32={pequeno}, NaN={nan}, inf={inf}");
    // Comparación con tolerancia:
    let diferencia = ((0.1 + 0.2) - 0.3).abs();
    if diferencia < 1e-9 {
        println!("0.1+0.2 ≈ 0.3 (dentro de tolerancia)");
    }
}
```

#### bool y char

`bool` tiene dos valores: `true` y `false`. Es el único tipo aceptado en condiciones; no hay "valores falsy". `char` es un único carácter Unicode entre comillas simples `'a'` y ocupa 4 bytes.

```rust
fn main() {
    let verdadero: bool = true;
    let letra: char = 'R';
    let emoji: char = '🦀';
    println!("{verdadero} {letra} {emoji}");
    // 'R' es un char; "R" es una cadena &str. No son lo mismo.
}
```

#### Tuplas

Una tupla agrupa valores de tipos posiblemente distintos. Se accede por posición (`.0`, `.1`, ...) o se desestructura.

```rust
fn main() {
    let coordenada: (i32, i32) = (10, 20);
    println!("x = {}, y = {}", coordenada.0, coordenada.1);
    let persona = ("Ana", 28, 1.65);
    let (nombre, edad, altura) = persona;   // desestructuración
    println!("{nombre}, {edad} años, {altura} m");
    let uno = (42,);   // la coma es obligatoria en tuplas de un elemento
    let unidad: () = ();   // "unit": tipo que devuelven las funciones sin retorno
}
```

#### Arrays y slices

Un **array** `[T; N]` es una colección de longitud fija del mismo tipo. Un **slice** `&[T]` es una vista de una parte, sin copiar.

```rust
fn main() {
    let dias = ["lun", "mar", "mié", "jue", "vie"];
    let ceros: [i32; 5] = [0; 5];      // [0, 0, 0, 0, 0]
    let numeros = [10, 20, 30, 40, 50];
    println!("Primero: {}", numeros[0]);
    println!("Total: {}", dias.len());
    let primeros_dos = &numeros[..2];   // [10, 20]
    let del_medio = &numeros[1..4];     // [20, 30, 40]
    let todos = &numeros[..];
    println!("{:?} {:?} {:?}", primeros_dos, del_medio, todos);
}
```

Acceder a un índice inexistente provoca un **panic**. Los arrays y slices se imprimen con `{:?}` porque `{}` no está implementado para ellos.

### Operadores

#### Aritméticos (división entera, resto, overflow)

| Operador | Operación        | Ejemplo    | Resultado        |
|----------|------------------|------------|------------------|
| `+`      | Suma             | `7 + 3`    | `10`             |
| `-`      | Resta            | `7 - 3`    | `4`              |
| `*`      | Multiplicación   | `7 * 3`    | `21`             |
| `/`      | División         | `7 / 2`    | `3` (entera)     |
| `%`      | Resto (módulo)   | `7 % 3`    | `1`              |

La división entre dos enteros es **división entera** (trunca). Para decimales, al menos un operando debe ser flotante.

```rust
fn main() {
    println!("7 / 2 = {}", 7 / 2);      // 3 (división entera)
    println!("7.0 / 2 = {}", 7.0 / 2);  // 3.5
    println!("7 % 2 = {}", 7 % 2);      // 1 (resto)
    println!("-7 % 2 = {}", -7 % 2);    // -1 (hereda el signo del dividendo)
}
```

El **overflow** ocurre cuando el resultado no cabe en el tipo. En modo *debug* (`cargo run`) lanza un panic; en *release* hace *wrap-around*. Rust ofrece versiones explícitas:

```rust
fn main() {
    let a: u8 = 200;
    let checked = a.checked_add(100);    // None si hay overflow
    let wrapping = a.wrapping_add(100);  // 200+100=300 -> 44 (envuelve)
    let sat = a.saturating_add(100);     // se queda en 255
    println!("{:?} {} {}", checked, wrapping, sat);
}
```

#### Comparación

Devuelven siempre `bool`: `==` igual, `!=` distinto, `>` mayor, `<` menor, `>=` mayor o igual, `<=` menor o igual. Las cadenas `&str` se comparan lexicográficamente (orden alfabético): `"manzana" < "pera"` es `true` porque `'m' < 'p'`.

#### Lógicos

| Operador | Nombre   | Regla                                       | Ejemplo                 |
|----------|----------|---------------------------------------------|-------------------------|
| `&&`     | Y        | `true` solo si ambos son `true`             | `true && false` → false |
| `\|\|`   | O        | `true` si al menos uno es `true`            | `true \|\| false` → true |
| `!`      | Negación | Invierte el valor                           | `!true` → false         |

`&&` y `||` hacen **evaluación en cortocircuito**: si el primer operando decide, el segundo no se evalúa. Solo aceptan `bool`.

```rust
fn main() {
    let dia = 3;
    let valido = (1..=7).contains(&dia);
    if valido && dia >= 6 {
        println!("Fin de semana");
    } else if valido {
        println!("Día de semana");
    } else {
        println!("Día inválido");
    }
}
```

#### De bits

| Operador | Nombre                             | Ejemplo binario                    |
|----------|------------------------------------|------------------------------------|
| `&`      | Y bit a bit                        | `0b1100 & 0b1010` → `0b1000`       |
| `\|`     | O bit a bit                        | `0b1100 \| 0b1010` → `0b1110`      |
| `^`      | XOR bit a bit                      | `0b1100 ^ 0b1010` → `0b0110`       |
| `<<`     | Desplazamiento a la izquierda      | `1 << 4` → `16`                    |
| `>>`     | Desplazamiento a la derecha        | `16 >> 2` → `4`                    |
| `!`      | Negación bit a bit                 | `!0u8` → `255`                     |

```rust
fn main() {
    let x = 0b1100;   // 12
    let y = 0b1010;   // 10
    println!("x & y = {:#06b} ({})", x & y, x & y);   // 0b1000 (8)
    println!("x | y = {:#06b} ({})", x | y, x | y);   // 0b1110 (14)
    println!("1 << 4 = {}, 16 >> 2 = {}", 1 << 4, 16 >> 2);
}
```

#### Precedencia

Orden de evaluación (de mayor a menor): unarios y `!` → `*` `/` `%` → `+` `-` → `<<` `>>` → `&` → `^` → `|` → comparaciones → `&&` → `||`. Ante la duda, usa paréntesis.

```rust
fn main() {
    // 14 > 10 && true -> true
    let resultado = 2 + 3 * 4 > 10 && !false;
    println!("{resultado}");
    let claro = ((2 + (3 * 4)) > 10) && (!false);
    println!("{claro}");
}
```

### Strings: String vs &str

| Tipo     | Característica                                          | Uso típico                          |
|----------|---------------------------------------------------------|-------------------------------------|
| `String` | Propia (*owned*), modificable, en el heap               | Texto que se construye o modifica   |
| `&str`   | Vista prestada, tamaño fijo e inmutable                 | Literales y parámetros de solo lectura |

Un literal `"hola"` es un `&str`. Un `String` se crea con `String::from(...)`, `.to_string()` o `.to_owned()`.

```rust
fn main() {
    let literal: &str = "texto inmutable";
    let owned: String = String::from("texto modificable");
    let owned_2 = "otro".to_string();
    println!("{literal} {owned} {owned_2}");
}
```

#### Crear y modificar Strings

Métodos para modificar *in-place*: `push_str` (cadena), `push` (`char`), `insert_str`, `truncate`, `clear`, `to_uppercase`, `to_lowercase`, `replace` (devuelve nueva).

```rust
fn main() {
    let mut texto = String::from("Hola");
    texto.push_str(", mundo");     // añade cadena
    texto.push('!');               // añade un char
    println!("{texto}");           // "Hola, mundo!"
    let texto_nuevo = texto.replace("Hola", "Adiós");   // nueva cadena
    println!("{texto_nuevo}");
    println!("Mayúsculas: {}", texto.to_uppercase());
    println!("Longitud en bytes: {}", texto.len());
    println!("¿Vacía? {}", texto.is_empty());
}
```

Concatenación: `x + &y` *mueve* `x` y toma una referencia de `y`.

```rust
fn main() {
    let x = String::from("uno");
    let y = String::from(", dos");
    let z = x + &y;    // x queda movida; y sigue disponible
    println!("{z}");
    println!("y sigue aquí: {y}");
}
```

#### format! y concat

`format!` funciona como `println!` pero devuelve una `String` en lugar de imprimir. Es la forma idiomática de construir cadenas compuestas. La macro `concat!` une literales en tiempo de compilación.

```rust
fn main() {
    let nombre = "Luis";
    let edad = 30;
    let saludo = format!("Hola, {nombre}, tienes {edad} años");
    let area = format!("El área es {:.2} cm²", 12.3456);
    println!("{saludo}");
    println!("{area}");
}
```

#### Iterar caracteres

Las cadenas en Rust son UTF-8 y **no se pueden indexar** con `s[0]` (el índice podría caer dentro de un carácter). Usa `.chars()` o `.bytes()`.

```rust
fn main() {
    let palabra = "naïve 🦀";
    for c in palabra.chars() {
        print!("{c} ");
    }
    println!();
    println!("Caracteres: {}", palabra.chars().count());
    let letras: Vec<char> = palabra.chars().collect();
    println!("Primera letra: {}", letras[0]);
}
```

### Condicionales

#### if como expresión

`if` requiere una condición `bool` y puede devolver un valor; todas las ramas deben devolver el mismo tipo.

```rust
fn main() {
    let nota = 85;
    if nota >= 90 {
        println!("Excelente");
    } else if nota >= 70 {
        println!("Aprobado");
    } else {
        println!("Reprobado");
    }
    // if como expresión:
    let resultado = if nota >= 60 { "aprueba" } else { "reprueba" };
    println!("{resultado}");
}
```

Si las ramas devuelven tipos distintos, no compila:

```rust
fn main() {
    let nota = 50;
    // let x = if nota > 60 { "ok" } else { 0 };
    // ERROR: `if` and `else` have incompatible types
    let x: &str = if nota > 60 { "ok" } else { "no" };
    println!("{x}");
}
```

Recuerda que la condición debe ser `bool`: `if 1 { }` no compila (no hay valores "falsy"); escribe la comparación explícita, `if x != 0 { }`. Esto se repite en Errores comunes.

#### match exhaustivo

`match` compara un valor contra patrones. Es **exhaustivo**: si falta un caso, no compila. El patrón `_` cubre el resto.

```rust
fn main() {
    let dia = 3;
    match dia {
        1 => println!("Lunes"),
        2 => println!("Martes"),
        3 => println!("Miércoles"),
        4 => println!("Jueves"),
        5 => println!("Viernes"),
        6 => println!("Sábado"),
        7 => println!("Domingo"),
        _ => println!("Día inválido"),
    }
}
```

`match` devuelve valores y admite rangos de patrones:

```rust
fn main() {
    let nota = 87;
    let calificacion = match nota {
        90..=100 => "A",
        80..=89 => "B",
        70..=79 => "C",
        60..=69 => "D",
        0..=59 => "F",
        _ => "Fuera de rango",
    };
    println!("Nota {nota} -> {calificacion}");
}
```

Sin el brazo `_`, un `match` sobre `i32` no compila:

```rust
fn main() {
    let n = 3;
    // match n {
    //     1 => println!("uno"),
    //     2 => println!("dos"),
    // }
    // ERROR: non-exhaustive patterns: `i32` not covered
    match n {
        1 => println!("uno"),
        2 => println!("dos"),
        _ => println!("otro"),
    }
}
```

#### if let

`if let` es un `match` abreviado cuando solo interesa un patrón. Es el patrón idiomático para `Option` y `Result`.

```rust
fn main() {
    let opcional: Option<i32> = Some(7);
    match opcional {
        Some(v) => println!("Hay valor: {v}"),
        None => println!("No hay valor"),
    }
    if let Some(v) = opcional {
        println!("El valor es {v}");
    } else {
        println!("No hay valor");
    }
}
```

### Bucles

#### loop con break valor

`loop` repite indefinidamente hasta un `break`. Es el único bucle que devuelve un valor con `break valor`.

```rust
fn main() {
    let mut contador = 0;
    let resultado = loop {
        contador += 1;
        if contador == 10 {
            break contador * 2;   // sale devolviendo 20
        }
    };
    println!("resultado = {resultado}");   // 20
}
```

#### while

`while` repite mientras la condición (que debe ser `bool`) sea verdadera.

```rust
fn main() {
    let mut n = 0;
    while n < 5 {
        println!("n = {n}");
        n += 1;
    }
    println!("Terminado con n = {n}");   // 5
}
```

#### for in

`for` recorre rangos y colecciones. Los rangos `a..b` excluyen `b`; `a..=b` lo incluyen.

```rust
fn main() {
    for i in 1..5 {
        println!("{i}");   // 1, 2, 3, 4
    }
    for i in 1..=3 {
        println!("{i}");   // 1, 2, 3
    }
    for c in "hola".chars() {
        print!("{c} ");
    }
    println!();
}
```

Para iterar sin mover/copiar los valores, recorre por referencia:

```rust
fn main() {
    let numeros = [10, 20, 30];
    for n in &numeros {
        println!("{n}");
    }
}
```

#### Etiquetas, continue, break

`break` corta el bucle; `continue` salta a la siguiente iteración. Las **etiquetas** (`'nombre:`) permiten romper o continuar un bucle exterior.

```rust
fn main() {
    for i in 1..=5 {
        if i % 2 == 0 {
            continue;   // se salta los pares
        }
        println!("impar: {i}");
    }
    'exterior: for i in 0..3 {
        for j in 0..3 {
            if j == 2 && i == 1 {
                break 'exterior;   // rompe el bucle exterior
            }
            println!("i = {i}, j = {j}");
        }
    }
}
```

### Conversiones de tipo

Rust **no convierte implícitamente**: `as` convierte entre numéricos (con *wrap-around* o truncado) y `.parse()` convierte texto a número devolviendo un `Result`.

```rust
fn main() {
    let entero: i32 = 300;
    let flotante = entero as f64;      // i32 -> f64
    let pequeno: u8 = entero as u8;    // 300 envuelve a 44
    let truncado = 2.7 as i32;         // trunca a 2
    println!("{flotante} {pequeno} {truncado}");
    let numero: u32 = "42".parse().expect("no era número");
    println!("{} + 1 = {}", numero, numero + 1);
}
```

`.parse()` falla si el texto no tiene el formato esperado; `.expect()` lanza un panic. Con `match` lo manejas sin panic:

```rust
fn main() {
    let texto = "no soy un número";
    match texto.parse::<u32>() {
        Ok(valor) => println!("Valor: {valor}"),
        Err(e) => println!("Error: {e}"),
    }
    // Con `from`/`into`, conversiones sin pérdida:
    let n: u16 = 300;
    let m: u32 = n.into();
    println!("{m}");
}
```

### Entrada y salida

#### stdin

`std::io::stdin().read_line()` lee una línea. `read_line` **incluye el `\n`**, así que casi siempre usas `.trim()`. Antes del prompt conviene `stdout().flush()`.

```rust
use std::io::{self, Write};
fn main() {
    print!("¿Cómo te llamas? ");
    io::stdout().flush().unwrap();
    let mut nombre = String::new();
    io::stdin().read_line(&mut nombre).expect("error leyendo");
    let nombre = nombre.trim();   // quita el \n final
    println!("Hola, {nombre}!");
}
```

Leer un número:

```rust
use std::io::{self, Write};
fn main() {
    print!("Escribe un número: ");
    io::stdout().flush().unwrap();
    let mut linea = String::new();
    io::stdin().read_line(&mut linea).expect("error de lectura");
    let numero: i32 = linea.trim().parse().expect("eso no era un número");
    println!("El doble es {}", numero * 2);
}
```

#### argumentos de línea de comandos

`std::env::args()` devuelve los argumentos. El índice 0 es la ruta del programa; los reales empiezan en 1. Con cargo se pasan tras `--`: `cargo run -- hola mundo`.

```rust
use std::env;
fn main() {
    let argumentos: Vec<String> = env::args().collect();
    println!("Ruta del programa: {}", argumentos[0]);
    println!("Cantidad de argumentos: {}", argumentos.len() - 1);
    for (i, arg) in argumentos.iter().skip(1).enumerate() {
        println!("Argumento {}: {}", i + 1, arg);
    }
}
```

### Funciones

#### Parámetros y retorno

Cada parámetro anota su tipo; el retorno se indica con `-> Tipo`. Se puede usar `return` explícito o la última expresión sin `;`.

```rust
fn suma(a: i32, b: i32) -> i32 {
    a + b   // última expresión sin ; -> se devuelve
}
fn saluda(nombre: &str) {
    println!("Hola, {nombre}!");   // devuelve ()
}
fn division(a: i32, b: i32) -> i32 {
    if b == 0 {
        return 0;   // salida temprana
    }
    a / b           // retorno final
}
fn main() {
    println!("3 + 4 = {}", suma(3, 4));
    saluda("Ana");
    println!("10/2 = {}, 10/0 = {}", division(10, 2), division(10, 0));
}
```

#### Última expresión sin ;

Esta regla confunde al principio: un bloque devuelve el valor de su última línea **solo si no lleva `;`**. Con `;` devuelve `()`.

```rust
fn correcto() -> i32 {
    let x = 5;
    x               // sin ; -> devuelve 5
}
fn main() {
    println!("{}", correcto());
    // fn mal() -> i32 { let x = 5; x; }
    // ERROR: mismatched types: expected `i32`, found `()`
}
```

Pista: si una función con retorno declarado falla con "expected `i32`, found `()`", casi siempre sobra un `;` al final.

## Ejemplos de código

**Programa 1 — Saludo con nombre y edad (entrada por teclado).**

```rust
use std::io::{self, Write};
fn main() {
    print!("¿Nombre? ");
    io::stdout().flush().unwrap();
    let mut nombre = String::new();
    io::stdin().read_line(&mut nombre).unwrap();
    let nombre = nombre.trim();
    print!("¿Edad? ");
    io::stdout().flush().unwrap();
    let mut edad = String::new();
    io::stdin().read_line(&mut edad).unwrap();
    let edad: u32 = edad.trim().parse().expect("edad inválida");
    println!("Hola {nombre}, el año que viene tendrás {} años.", edad + 1);
}
```

**Programa 2 — Tabla de multiplicar (argumento por línea de comandos).**

```rust
use std::env;
fn main() {
    let argumentos: Vec<String> = env::args().collect();
    if argumentos.len() < 2 {
        eprintln!("Uso: {} <número>", argumentos[0]);
        std::process::exit(1);
    }
    let numero: u32 = argumentos[1].parse().expect("el argumento debe ser un número");
    for i in 1..=10 {
        println!("{numero:2} x {i:2} = {:3}", numero * i);
    }
}
```

**Programa 3 — Calculadora con match.**

```rust
use std::io::{self, Write};
fn main() {
    let a = pedir_numero("Primer número:");
    let b = pedir_numero("Segundo número:");
    print!("Operación (+, -, *, /, %): ");
    io::stdout().flush().unwrap();
    let mut operador = String::new();
    io::stdin().read_line(&mut operador).unwrap();
    let operador = operador.trim();
    let resultado: i32 = match operador {
        "+" => a + b,
        "-" => a - b,
        "*" => a * b,
        "/" => a / b,
        "%" => a % b,
        _ => {
            eprintln!("Operador no válido: {operador}");
            return;
        }
    };
    println!("{a} {operador} {b} = {resultado}");
}
fn pedir_numero(prompt: &str) -> i32 {
    print!("{prompt} ");
    io::stdout().flush().unwrap();
    let mut linea = String::new();
    io::stdin().read_line(&mut linea).unwrap();
    linea.trim().parse().expect("no era un número")
}
```

**Programa 4 — FizzBuzz.**

```rust
fn main() {
    for i in 1..=30 {
        if i % 15 == 0 {
            println!("FizzBuzz");
        } else if i % 3 == 0 {
            println!("Fizz");
        } else if i % 5 == 0 {
            println!("Buzz");
        } else {
            println!("{i}");
        }
    }
}
```

## Ejercicios relacionados

- [Ejercicios nivel 01 — Fundamentos](../ejercicios/nivel-01-fundamentos/)
  - [ejercicio-01-variables-y-tipos](../ejercicios/nivel-01-fundamentos/ejercicio-01-variables-y-tipos/)
  - [ejercicio-02-funciones](../ejercicios/nivel-01-fundamentos/ejercicio-02-funciones/)
  - [ejercicio-03-control-de-flujo](../ejercicios/nivel-01-fundamentos/ejercicio-03-control-de-flujo/)
  - [ejercicio-04-strings-y-slices](../ejercicios/nivel-01-fundamentos/ejercicio-04-strings-y-slices/)
  - [ejercicio-05-arrays-y-tuplas](../ejercicios/nivel-01-fundamentos/ejercicio-05-arrays-y-tuplas/)
  - [ejercicio-06-structs-basicos](../ejercicios/nivel-01-fundamentos/ejercicio-06-structs-basicos/)

## Errores comunes

1. **Reasignar sin `mut`** → `error[E0384]: cannot assign twice to immutable variable`. `let x = 1; x = 2;` no compila. Solución: `let mut x = 1;`.

2. **Errores con el `;`** → `error[E0308]: mismatched types`. Un `;` de más en el retorno (`fn f() -> i32 { let x = 5; x; }`) devuelve `()`; un `;` que falta en una declaración (`let x = 5`) devuelve integer donde se esperaba `()`. Solución: ajusta el `;` de la última expresión.

3. **`if` con valor no booleano** → `error[E0308]: expected `bool`, found integer`. `if 1 { }` no compila. Solución: `if x != 0 { }`.

4. **Índice fuera de rango** → en compilación: `this operation will panic at runtime`; en ejecución: `index out of bounds`. `a[5]` sobre un array de 3 elementos. Solución: revisa los límites o usa `.get(i)`.

5. **Parsear sin manejar el error** → `panicked at '...': ParseIntError`. Solución: `.expect("mensaje")` o un `match` sobre el `Result`.

6. **Esperar decimales en división entera** → `7 / 2` es `3`, no `3.5`. Solución: `7.0 / 2.0` o `7 as f64 / 2.0`.

7. **Olvidar el `\n` de `read_line`** → `"si\n" != "si"` y la comparación falla silenciosamente. Solución: `.trim()` antes de comparar o parsear.

8. **Overflow de enteros** → `panicked at 'attempt to add with overflow'` en modo debug. Solución: `wrapping_add`, `saturating_add`, `checked_add` o un tipo más grande.

9. **`match` no exhaustivo** → `error[E0004]: non-exhaustive patterns`. Solución: añade el brazo `_ => {}`.

10. **Confundir rangos** → `for i in 1..3` recorre `1, 2` (el 3 no entra). Solución: usa `1..=3` para incluir el final.

11. **Confundir `char` con `&str`** → `'a'` es `char`, `"a"` es cadena; mezclarlos da `error[E0308]`. Solución: revisa comillas simples vs dobles.

12. **Sin `fn main()`** → `error: expected one of `fn` or `extern crate`` en un binario vacío. Solución: todo binario necesita `fn main() { ... }`.

## Recursos

- [The Rust Programming Language — libro oficial](https://doc.rust-lang.org/book/)
- [Capítulo 3: variables, tipos y control de flujo](https://doc.rust-lang.org/book/ch03-00-common-programming-concepts.html)
- [Rust By Example — variables](https://doc.rust-lang.org/rust-by-example/variable_bindings.html)
- [Rust By Example — tipos de datos](https://doc.rust-lang.org/rust-by-example/primitives.html)
- [Rust By Example — control de flujo](https://doc.rust-lang.org/rust-by-example/flow_control.html)
- [Rust Playground — probar en el navegador](https://play.rust-lang.org/)
- [rustup — instalación de Rust](https://rustup.rs/)
- [std::io — documentación](https://doc.rust-lang.org/std/io/index.html)
- [Referencia de operadores](https://doc.rust-lang.org/reference/expressions/operator-expr.html)