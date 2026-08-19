# 02 — Ownership

## Objetivos

- [ ] Entender qué es el *ownership* (propiedad) y por qué Rust lo impone como su mecanismo central de seguridad de memoria.
- [ ] Enunciar y aplicar las tres reglas del ownership: un valor solo tiene un dueño a la vez, las referencias prestan sin poseer, y el dueño libera la memoria al salir de su ámbito.
- [ ] Distinguir entre la **pila** (stack) y el **montón** (heap), y saber dónde vive cada tipo.
- [ ] Explicar qué es un **movimiento (move)** y qué consecuencias tiene sobre las variables originales.
- [ ] Diferenciar los tipos con `Copy` (enteros, `bool`, `char`, tuplas simples) de los que se mueven (`String`, `Vec`, `Box`).
- [ ] Usar `clone()` para realizar una copia profunda cuando no se quiere perder el valor original.
- [ ] Crear y usar **referencias inmutables** `&T` para leer datos prestados.
- [ ] Crear y usar **referencias mutables** `&mut T` para modificar datos prestados.
- [ ] Aplicar las reglas de coexistencia de borrows: varios `&`, un único `&mut`, nunca `&` y `&mut` simultáneos sobre el mismo valor.
- [ ] Explicar qué es el *non-lexical lifetime* (NLL) y cuándo termina un préstamo.
- [ ] Trabajar con slices de strings (`&str`) y de arrays (`&[T]`).
- [ ] Entender la *deref coercion* de `&String` a `&str` y por qué es preferible recibir `&str`.
- [ ] Aplicar el ownership en funciones: paso por valor, paso por referencia y retorno de valores.
- [ ] Devolver múltiples valores con tuplas para recuperar la propiedad o varios datos a la vez.
- [ ] Identificar y resolver los errores típicos: `E0382` (uso después de mover), `E0502` (borrow conflictivo), `E0499` (doble préstamo mutable), `E0106` (lifetime faltante).

## Apuntes

### Qué es el ownership

El *ownership* es el sistema con el que Rust garantiza la **seguridad de memoria sin necesidad de un recolector de basura**. Cada valor en memoria tiene una variable que lo **posee** (su *owner* o dueño). Cuando la variable dueña sale de su ámbito (scope), el valor se libera automáticamente.

```rust
fn main() {
    {
        let s = String::from("hola");
        // s es la dueña del String que vive en el heap
        println!("{}", s);
    } // <-- aquí s sale de su ámbito y la memoria se libera
    // println!("{}", s); // ERROR: s ya no existe aquí
}
```

Este comportamiento se llama **RAII** (Resource Acquisition Is Initialization): la adquisición ocurre al inicializar la variable y la liberación al salir de su ámbito. No necesitas `free()` ni `delete()`: Rust lo hace solo, de forma determinista y sin coste de runtime.

El ownership evita tres clases de errores de memoria que plagaron a C y C++ durante décadas:

| Error en C/C++ | Cómo lo evita Rust |
|---|---|
| *Use after free* (usar memoria liberada) | El compilador impide usar un valor cuyo dueño ya no existe o ya fue movido. |
| *Double free* (liberar dos veces) | Solo el dueño libera la memoria, y solo hay un dueño. |
| *Data race* (carreras de datos en hilos) | Las reglas de borrowing impiden leer y escribir a la vez sin sincronización. |

#### Las tres reglas del ownership

1. **Cada valor tiene un único dueño** en cualquier momento.
2. **Cuando el dueño sale del ámbito, el valor se libera.**
3. Se puede **prestar** (borrow) el valor con referencias, siguiendo sus propias reglas.

Si intentas tener dos variables que reclaman ser dueñas del mismo valor, no se compila:

```rust
fn main() {
    let s1 = String::from("hola");
    let s2 = s1; // el valor se MOVIÓ a s2, s1 ya no es dueña
    // println!("{}", s1);
    //   ^^^^^^^^ error[E0382]: use of moved value: `s1`
    println!("{}", s2);
}
```

La regla más importante: **no pueden existir dos dueños simultáneos**. La propiedad se transfiere (move) o se comparte temporalmente (borrow), pero nunca se duplica.

#### La pila y el montón

Rust gestiona la memoria en dos regiones principales:

| Región | Características | Tipos típicos |
|---|---|---|
| **Pila (stack)** | Acceso rapidísimo, tamaño fijo conocido en compilación, orden LIFO. | `i32`, `f64`, `bool`, `char`, tuplas y arrays de tamaño fijo. |
| **Montón (heap)** | Memoria dinámica, tamaño variable o desconocido en compilación. | `String`, `Vec<T>`, `Box<T>` y la familia `std::collections`. |

Un `String` es una estructura de tres campos que vive en la pila: un **puntero** a los datos del heap, la **longitud** actual y la **capacidad** reservada (3 × 8 = 24 bytes en 64 bits).

Cuando haces un *move* de un `String`, solo se copian los 24 bytes de la pila (puntero, longitud, capacidad). Los datos del heap **no se copian**: el puntero simplemente cambia de dueño.

### Movimiento (move)

Un *move* ocurre cuando el valor de una variable se transfiere a otra variable o a una función. Después del movimiento, la variable original queda **invalidada**: el compilador no te dejará usarla. Esto evita el *double free* (dos variables compartiendo un puntero y liberándolo dos veces).

```rust
fn main() {
    let s1 = String::from("hola");
    let s2 = s1;          // move: s1 -> s2
    println!("{}", s2);    // ok, s2 es la dueña
    // println!("{}", s1); // ERROR E0382
}
```

#### Asignación y paso a funciones

El movimiento se produce en dos situaciones: **asignación** (`let s2 = s1;`) y **paso a una función** (pasar el valor por argumento).

```rust
fn consumir(s: String) {
    println!("consumiendo: {}", s);
} // aquí `s` (el parámetro) sale del ámbito y libera la memoria

fn main() {
    let s = String::from("texto");
    consumir(s); // el valor se mueve DENTRO de la función
    // println!("{}", s);
    //   ^^^ error[E0382]: borrow of moved value: `s`
}
```

Este punto confunde a quienes vienen de otros lenguajes: tras `consumir(s)`, la variable `s` del `main` ya no puede usarse. En cambio, los tipos `Copy` no se mueven, se copian (ver *El trait Copy*).

#### El trait Copy

Los tipos que implementan el trait `Copy` **no se mueven**: al asignarlos o pasarlos por valor se hace una **copia bit a bit** (muy barata, son datos pequeños de la pila). La variable original sigue siendo válida.

```rust
fn main() {
    let x = 5;
    let y = x;  // copia, no movimiento
    let z = x;  // otra copia
    println!("{} {} {}", x, y, z);
}
```

| Tipos `Copy` | Tipos NO `Copy` (se mueven) |
|---|---|
| `i8`…`i128`, `u8`…`u128`, `isize`, `usize` | `String` |
| `f32`, `f64` | `Vec<T>` |
| `bool` | `Box<T>` |
| `char` | `&mut T` |
| Tuplas y arrays de tipos `Copy` | `Rc<T>`, `Arc<T>`, `MutexGuard`… |
| Punteros de función `fn() -> T` | Tuplas y estructuras con campos no `Copy` |

Regla práctica: **si el tipo gestiona memoria en el heap, no es `Copy`**; si es un valor pequeño de la pila, probablemente sí. Un `String` contiene un puntero al heap, así que **no** puede ser `Copy`: copiar el puntero sin copiar los datos produciría un *double free*.

```rust
fn main() {
    // Tupla de Copy: se copia entera.
    let t1 = (1, true, 'a');
    let t2 = t1;
    println!("{:?} {:?}", t1, t2);

    // Vec (no Copy): se mueve.
    let v1 = vec![1, 2, 3];
    let v2 = v1;
    // println!("{:?}", v1); // ERROR E0382
    println!("{:?}", v2);
}
```

Puedes implementar `Copy` en tus propias `struct` solo si todos sus campos son `Copy`:

```rust
#[derive(Debug, Clone, Copy)]
struct Punto {
    x: i32,
    y: i32,
}

fn main() {
    let p1 = Punto { x: 1, y: 2 };
    let p2 = p1; // Punto es Copy: se copia
    println!("{:?} {:?}", p1, p2);
}
```

Si la struct contuviera un `String`, el `#[derive(Copy)]` no compilaría:

```rust
#[derive(Clone, Copy)]
struct Nombre {
    valor: String,
}
// error[E0204]: the trait `Copy` may not be implemented for this type
```

#### clone() para copia profunda

Cuando necesitas **conservar** el valor original y obtener otro igual, usas el método `clone()`, que duplica los datos del heap. Es una copia **profunda**: se crea un bloque nuevo en el montón con el mismo contenido.

```rust
fn main() {
    let s1 = String::from("hola");
    let s2 = s1.clone(); // copia profunda: s1 y s2 son independientes
    println!("{} {}", s1, s2); // ambos válidos
}
```

| Operación | Resultado | Coste |
|---|---|---|
| `let s2 = s1;` | Move: `s1` inválida | Muy barato (solo copia puntero/len/cap en la pila) |
| `let s2 = s1.clone();` | Copia profunda: ambas válidas | Caro (duplica los datos del heap) |

No abuses de `clone()`: cada llamada copia los datos. La forma idiomática de **compartir** un valor sin copiarlo ni moverlo es el borrowing con referencias.

### Borrowing: referencias

El **borrowing** (préstamo) permite que otro código use un valor **sin convertirse en dueño**. En lugar de mover el valor, pasas una **referencia** `&T` (inmutable) o `&mut T` (mutable). La referencia no posee nada: cuando el prestatario termina, el valor sigue vivo y el dueño lo libera al final.

Una referencia es solo un **puntero a los datos**, del tamaño de un `usize` (8 bytes en 64 bits). Crear referencias es prácticamente gratis.

#### Referencias inmutables &T

Una referencia inmutable `&T` te permite **leer** el valor, pero no modificarlo. Puedes crear **muchas** referencias inmutables a la vez, porque ninguna puede alterar los datos: es seguro compartir.

```rust
fn main() {
    let s = String::from("lectura");
    let a = &s;
    let b = &s;
    let c = &s; // varias inmutables: perfectamente válido
    println!("{} {} {}", a, b, c);
}
```

Pasar `&valor` en vez de `valor` hace que la variable original conserve su propiedad: la función solo presta y devuelve el préstamo al terminar.

#### Referencias mutables &mut T

Una referencia mutable `&mut T` te permite **leer y modificar** el valor prestado. A cambio, solo puede existir **una única** referencia mutable sobre el mismo valor a la vez.

```rust
fn main() {
    let mut texto = String::from("mundo");
    let r = &mut texto;
    r.push_str(" feliz");
    println!("{}", r);
    println!("{}", texto); // ahora texto vale "mundo feliz"
}
```

Para obtener una referencia mutable, la variable debe declararse como `mut` (`let mut texto`). No puedes pedir `&mut` sobre una variable inmutable:

```rust
fn main() {
    let texto = String::from("fijo");
    let r = &mut texto;
    //   ^^^^^^^^ error[E0596]: cannot borrow `texto` as mutable,
    //           as it is not declared as mutable
}
```

Función que modifica a través de `&mut`:

```rust
fn saludar(nombre: &mut String) {
    nombre.push_str(", encantado!");
}

fn main() {
    let mut nombre = String::from("Ana");
    saludar(&mut nombre);
    println!("{}", nombre); // "Ana, encantado!"
}
```

#### Reglas de coexistencia de borrows

1. **Puedes tener tantas referencias inmutables `&T` como quieras** a la vez.
2. **Puedes tener una única referencia mutable `&mut T`** a la vez.
3. **No puedes mezclar** una referencia mutable con referencias inmutables que apunten al mismo valor al mismo tiempo.

| Situación | ¿Compila? | Motivo |
|---|---|---|
| Varios `&` simultáneos | Sí | Todos solo leen, no hay conflicto |
| Un solo `&mut` | Sí | Un único escritor |
| Dos `&mut` simultáneos | **No** (E0499) | Dos escritores competirían |
| Un `&` y un `&mut` simultáneos | **No** (E0502) | Un lector y un escritor a la vez |

Esta regla del único escritor / muchos lectores elimina las **carreras de datos** entre hilos y muchos bugs de aliasing.

```rust
fn main() {
    let mut v = 10;
    let r1 = &v;      // ok: lector
    let r2 = &v;      // ok: otro lector
    // let r3 = &mut v; // ERROR E0502: cannot borrow `v` as mutable
    //                    because it is also borrowed as immutable
    println!("{} {}", r1, r2);
}
```

El doble préstamo mutable (`let r1 = &mut v; let r2 = &mut v;`) produce `error[E0499]: cannot borrow `v` as mutable more than once at a time`.

#### NLL (non-lexical lifetimes)

Antes de Rust 2018, un préstamo vivía hasta el final del **bloque** donde se creaba. Desde el **NLL** (non-lexical lifetimes), un préstamo se considera activo solo **hasta la última vez que se usa**. Esto permite programas más naturales.

```rust
fn main() {
    let mut v = 10;

    let r = &v;        // préstamo inmutable
    println!("{}", r); // última vez que se usa `r`

    let r2 = &mut v;   // OK con NLL: el préstamo de `r` ya terminó
    *r2 += 1;
    println!("{}", r2);
}
```

Pero **si** vuelves a usar el préstamo inmutable después de modificar el valor, el compilador recupera el error `E0502`:

```rust
fn main() {
    let mut s = String::from("hola");
    let parte = &s[..2];
    println!("{}", parte);
    s.push_str(" mundo");
    //  ^^^^ error[E0502]: cannot borrow `s` as mutable because it is
    //       also borrowed as immutable
    println!("{}", s);
}
```

### Slices

Un **slice** (rebanada) es una referencia a **una parte contigua** de una colección, sin copiarla. Técnicamente es un par (puntero + longitud). No tiene tamaño conocido en compilación, por eso siempre aparece como referencia: `&str` para strings y `&[T]` para colecciones de elementos `T`.

```rust
fn main() {
    let numeros = [10, 20, 30, 40, 50];
    let parte = &numeros[1..4]; // &[i32]: {20, 30, 40}
    println!("{:?}", parte);
    println!("len = {}, primero = {}", parte.len(), parte[0]);
}
```

La sintaxis `[a..b]` corta desde el índice `a` (incluido) hasta el `b` (excluido). `[..b]` desde el principio, `[a..]` hasta el final y `[..]` todo.

#### &str: rebanadas de string

`&str` es el tipo de los string literals y de las rebanadas de un `String`. Es una vista inmutable de una secuencia de bytes UTF-8.

```rust
fn main() {
    let saludo: &str = "hola"; // string literal
    let s = String::from("hola mundo");
    let rebanada = &s[..4]; // "hola"
    println!("{} | {}", saludo, rebanada);
}
```

La gran utilidad de `&str` es que **no posee** los datos: puede prestar una parte del `String` original sin copiar nada.

```rust
fn main() {
    let frase = String::from("aprendiendo rust");
    let primera = &frase[..11]; // "aprendiendo"
    let segunda = &frase[12..]; // "rust"
    println!("{} / {}", primera, segunda);
    println!("{}", frase); // la dueña intacta
}
```

**Cuidado con los índices de bytes:** los `&str` se cortan por índices de **bytes**, no de caracteres. Cortar por la mitad de un carácter UTF-8 paniquea en runtime:

```rust
fn main() {
    let s = "héllo";
    // &s[0..2] cortaría entre 'é' (2 bytes) → panic
    // thread 'main' panicked at 'byte index 2 is not a char boundary'
    // let mal = &s[0..2];
    let bien = &s[0..3]; // "hé"
    println!("{}", bien);
}
```

La solución idiomática para no romper caracteres es usar `find`, `chars` o `get` (que devuelve `Option<&str>` y no paniquea).

#### &[T]: rebanadas de arrays

Para arrays y vectores, el slice es `&[T]`. La sintaxis es idéntica, pero la referencia es a un tipo genérico:

```rust
fn main() {
    let v = vec![100, 200, 300, 400, 500];

    let primeros = &v[..2];    // [100, 200]
    let del_medio = &v[1..4];  // [200, 300, 400]
    let ultimo = &v[4..];      // [500]

    println!("{:?}", primeros);
    println!("{:?}", del_medio);
    println!("{:?}", ultimo);
}
```

También admite el operador `..=` para rangos inclusivos: `&a[1..=3]` incluye el índice 3.

Un slice es un **préstamo**: mientras exista, no puedes modificar la colección de la que se deriva.

```rust
fn main() {
    let mut v = vec![1, 2, 3, 4];
    let s = &v[..2]; // préstamo inmutable de v
    println!("{:?}", s);
    v.push(5);
    //  ^^^^ error[E0502]: cannot borrow `v` as mutable because it is
    //       also borrowed as immutable
}
```

Pasar slices a funciones es la forma idiomática de compartir una colección (o parte de ella) sin copiar: `&Vec` se coerciona a `&[T]` automáticamente.

#### Strings y slices

`String` y `&str` están relacionados pero no son lo mismo:

| Aspecto | `String` | `&str` |
|---|---|---|
| Propiedad | Posee los datos del heap | Es un préstamo (referencia) |
| Modificable | Sí (si es `mut`) | No |
| Tamaño | Fijo en la pila (ptr+len+cap) | Par (ptr+len) |
| Creación | `String::from(...)`, `.to_string()` | literales, `&string[..]` |

Conversiones típicas: `&string` o `string.as_str()` producen `&str`; `s.to_string()` o `String::from(s)` producen `String`.

Cuando una función puede recibir tanto `String` como `&str`, **recibe `&str`**: es más flexible (acepta literales, rebanadas y `&String`) y no obliga a quien llama a hacer una copia.

### Deref coercion: &String vs &str

Rust aplica la **deref coercion** automáticamente: si una función espera `&str` y le pasas un `&String`, el compilador lo convierte solo, porque `String` implementa `Deref<Target = str>`.

```rust
fn imprime(texto: &str) {
    println!("{}", texto);
}

fn main() {
    let s = String::from("coercion!");
    imprime(&s);          // &String se coerciona a &str automáticamente
    imprime("literal");   // un &str literal también vale
    imprime(&s[2..6]);    // y una rebanada también
}
```

Es **mejor práctica** escribir funciones con `&str` en vez de `&String`: acepta `&String`, literales `&'static str` y slices por igual, sin obligar a `clone()` ni a `as_str()` por parte del llamador.

```rust
fn longitud(s: &String) -> usize { s.len() } // solo acepta &String

fn longitud2(s: &str) -> usize { s.len() }   // acepta cualquier cosa

fn main() {
    let s = String::from("rust");
    println!("{}", longitud(&s));      // ok
    // println!("{}", longitud("hola"));
    //   ^^^^^^^ error[E0308]: mismatched types
    //           expected `&String`, found `&str`
    println!("{}", longitud2("hola")); // ok
}
```

Regla general: **si una función solo necesita leer un string, pide `&str`; si necesita ser dueña, pide `String`; si necesita modificarlo, pide `&mut String`** (o `&mut str` según el caso).

### Ownership en funciones

Las funciones son el lugar donde el ownership se manifiesta con más claridad. La pregunta clave es: **¿quién es el dueño después de la llamada?**

#### Paso por valor vs por referencia

| Forma de paso | El valor... | ¿El llamador conserva el valor? |
|---|---|---|
| Por valor (`String`) | Se mueve a la función | No |
| Por valor (`i32`, Copy) | Se copia a la función | Sí |
| Por referencia `&T` | Se presta (lectura) | Sí |
| Por referencia `&mut T` | Se presta (lectura+escritura) | Sí |

```rust
fn valor_duplicado(n: i32) -> i32 {
    n * 2
}

fn prestado_lectura(s: &String) -> usize {
    s.len()
}

fn prestado_escritura(s: &mut String) {
    s.push('!');
}

fn por_valor(s: String) -> usize {
    s.len()
}

fn main() {
    let n = 21;
    println!("{}", valor_duplicado(n)); // copia: n sigue válido
    println!("{}", n);

    let mut s = String::from("abc");
    println!("{}", prestado_lectura(&s));  // prestado: s sigue válido
    prestado_escritura(&mut s);            // prestado mutable
    println!("{}", s);                      // "abc!"

    let len = por_valor(s);               // ¡movido!
    // println!("{}", s);                  // ERROR E0382
    println!("{}", len);
}
```

#### Retorno de valores y ownership

Si una función toma posesión de un valor y no lo devuelve, el llamador lo pierde. Puedes **devolver la propiedad** para recuperarla:

```rust
fn anadir_y_devolver(mut s: String) -> String {
    s.push_str("!");
    s // se devuelve la propiedad al llamador
}

fn main() {
    let original = String::from("hola");
    let nuevo = anadir_y_devolver(original);
    // original ya no es válida (fue movida a la función)
    println!("{}", nuevo);
}
```

#### Devolver múltiples valores con tuplas

A veces necesitas recuperar **varios** valores: por ejemplo, el dato modificado y algún resultado derivado. Las tuplas lo permiten:

```rust
fn calcular(s: String) -> (String, usize) {
    let longitud = s.len();
    (s, longitud) // devuelve la propiedad y la longitud
}

fn main() {
    let (texto, len) = calcular(String::from("rust"));
    println!("{} tiene {} letras", texto, len);
}
```

Aunque devolver el valor para recuperar la propiedad existe, en Rust moderno es **más idiomático** prestar con `&mut` y evitar el ida y vuelta: `fn anadir_hola(s: &mut String) { s.push_str(" hola"); }`.

### Ownership en estructuras de datos

El ownership se aplica igual dentro de las `struct`, `enum` y colecciones: cada valor almacenado tiene un dueño (el contenedor). Al mover un valor dentro de una struct, la variable original se invalida:

```rust
#[derive(Debug)]
struct Mascota {
    nombre: String,
}

fn main() {
    let nombre = String::from("Rex");
    let perro = Mascota { nombre }; // nombre se MUEVE a perro.nombre
    // println!("{}", nombre);       // ERROR E0382
    println!("{:?}", perro);
}
```

Lo mismo ocurre al insertar en colecciones: `vec![...]` o `push` mueven el valor al interior del `Vec`, que pasa a ser el dueño. Para **compartir** el contenido de una estructura sin moverlo ni clonarlo, se presta con referencias:

```rust
#[derive(Debug)]
struct Cuenta {
    nombre: String,
    saldo: i64,
}

fn mostrar(cuenta: &Cuenta) {
    println!("{} -> {}", cuenta.nombre, cuenta.saldo);
}

fn depositar(cuenta: &mut Cuenta, cantidad: i64) {
    cuenta.saldo += cantidad;
}

fn main() {
    let mut cuenta = Cuenta {
        nombre: String::from("ana"),
        saldo: 100,
    };
    mostrar(&cuenta);
    depositar(&mut cuenta, 50);
    mostrar(&cuenta);
}
```

### Casos típicos de error y soluciones

#### Dangling references

Una **dangling reference** apunta a memoria ya liberada. Rust lo impide en compilación: no puedes devolver una referencia a un valor local de la función.

```rust
fn dangle() -> &String {
    let s = String::from("hola");
    &s // error[E0106]: missing lifetime specifier
}
```

Solución: devuelve el `String` por valor; el dueño pasa a ser quien recibe.

```rust
fn no_dangle() -> String {
    let s = String::from("hola");
    s // se devuelve la propiedad: no hay referencia colgante
}
```

#### Doble préstamo mutable

Intentar crear dos `&mut` simultáneos produce `E0499`.

```rust
fn main() {
    let mut v = vec![1, 2, 3];
    let a = &mut v;
    // let b = &mut v;
    //   ^^^^^^^^ error[E0499]: cannot borrow `v` as mutable more
    //           than once at a time
    a.push(4);
}
```

Solución: usar los préstamos en secuencia (el primero debe terminar antes de crear el segundo).

```rust
fn main() {
    let mut v = vec![1, 2, 3];
    let a = &mut v;
    a.push(4);
    let b = &mut v; // ok: `a` ya no se usa (NLL)
    b.push(5);
    println!("{:?}", b);
}
```

#### Uso después de mover

El error `E0382` aparece al usar una variable tras mover su valor. Solución: **prestar** con `&` o usar `clone()`.

```rust
fn main() {
    let s = String::from("texto");
    let t = s; // s se mueve a t
    // println!("{}", s); // error[E0382]: borrow of moved value: `s`
    println!("{}", t);
}
```

Corrección prestando con `&`:

```rust
fn main() {
    let s = String::from("texto");
    let t = &s; // préstamo inmutable
    println!("{}", s); // s sigue siendo válida
    println!("{}", t);
}
```

## Ejemplos de código

### Ejemplo 1: la función `primera_palabra` con slices

```rust
fn primera_palabra(s: &str) -> &str {
    match s.find(' ') {
        Some(pos) => &s[..pos],
        None => s,
    }
}

fn main() {
    let frase = String::from("hola mundo rust");
    let primera = primera_palabra(&frase);
    println!("La primera palabra es: {}", primera);

    let frase_sin_espacios = String::from("sola");
    println!("{}", primera_palabra(&frase_sin_espacios));
}
```

Combina borrowing (recibe `&str`), slices (`&s[..pos]`) y el hecho de que el valor prestado sigue vivo mientras se usa.

### Ejemplo 2: simulador de préstamos bancarios con ownership

```rust
#[derive(Debug)]
struct Cuenta {
    titular: String,
    saldo: i64,
}

impl Cuenta {
    fn nuevo(titular: String, saldo_inicial: i64) -> Cuenta {
        Cuenta {
            titular,
            saldo: saldo_inicial,
        }
    }
}

fn depositar(cuenta: &mut Cuenta, cantidad: i64) {
    cuenta.saldo += cantidad;
}

fn retirar(cuenta: &mut Cuenta, cantidad: i64) -> Result<i64, String> {
    if cuenta.saldo >= cantidad {
        cuenta.saldo -= cantidad;
        Ok(cantidad)
    } else {
        Err(format!("saldo insuficiente: {}", cuenta.saldo))
    }
}

fn resumen(cuenta: &Cuenta) -> String {
    format!("{} tiene {}", cuenta.titular, cuenta.saldo)
}

fn main() {
    let mut c = Cuenta::nuevo(String::from("Ana"), 1000);

    depositar(&mut c, 250);
    println!("{}", resumen(&c));

    match retirar(&mut c, 300) {
        Ok(retirado) => println!("Retirado: {}", retirado),
        Err(e) => println!("Error: {}", e),
    }

    match retirar(&mut c, 5000) {
        Ok(retirado) => println!("Retirado: {}", retirado),
        Err(e) => println!("Error: {}", e),
    }

    println!("{}", resumen(&c));
}
```

Observa cómo la misma `Cuenta` se presta de forma mutable (`&mut c`) para `depositar` y `retirar`, e inmutable (`&c`) para `resumen`, siempre de forma secuencial.

### Ejemplo 3: procesar una lista de palabras sin copiarlas

```rust
fn contar_vocales(palabra: &str) -> usize {
    palabra.chars().filter(|c| "aeiouáéíóú".contains(*c)).count()
}

fn mas_vocales(lista: &[String]) -> Option<&String> {
    lista.iter().max_by_key(|p| contar_vocales(p))
}

fn main() {
    let palabras = vec![
        String::from("murciélago"),
        String::from("hola"),
        String::from("árbol"),
        String::from("bcdfghjkl"),
    ];

    let mejor = mas_vocales(&palabras);
    match mejor {
        Some(p) => println!(
            "La palabra con más vocales es '{}' ({} vocales)",
            p,
            contar_vocales(p)
        ),
        None => println!("Lista vacía"),
    }

    let primeras: Vec<&str> = palabras.iter().map(|p| p.as_str()).collect();
    println!("Primeras palabras: {:?}", primeras);
}
```

`mas_vocales` devuelve `Option<&String>`: una referencia prestada a uno de los elementos del vector, sin copiar nada.

## Ejercicios relacionados

- [Ejercicios nivel 02 — Básico](../ejercicios/nivel-02-basico/)

## Errores comunes

A continuación, los errores de compilación más frecuentes con ownership, borrowing y slices, con su mensaje real y la solución.

- **Usar un valor después de moverlo** → `error[E0382]: borrow of moved value: `s``. Solución: pasa una referencia `&s` en lugar del valor, o usa `clone()` si necesitas dos copias.

```rust
fn main() {
    let s = String::from("x");
    let t = s;
    // println!("{}", s); // error[E0382]
}
```

- **Prestar dos veces como mutable** → `error[E0499]: cannot borrow `v` as mutable more than once at a time`. Solución: termina el primer préstamo antes de crear el segundo.

```rust
fn main() {
    let mut v = vec![1];
    let a = &mut v;
    // let b = &mut v; // error[E0499]
    a.push(2);
}
```

- **Combinar `&mut` con un `&` activo** → `error[E0502]: cannot borrow `s` as mutable because it is also borrowed as immutable`. Solución: usa el préstamo inmutable antes de pedir el mutable.

```rust
fn main() {
    let mut s = String::from("a");
    let r = &s;
    // s.push('b'); // error[E0502]
    println!("{}", r);
}
```

- **Devolver una referencia a un valor local** → `error[E0106]: missing lifetime specifier` (dangling reference). Solución: devuelve el valor por propiedad (`String`), no por referencia.

```rust
fn dangle() -> &String {
    let s = String::from("a");
    &s // error[E0106]: missing lifetime specifier
}
```

- **Devolver una referencia local una vez que ya hay lifetime** → `error[E0515]: cannot return value referencing local variable `s``. Mismo arreglo: devolver por valor.

```rust
fn dangle<'a>(s: &'a String) -> &'a String {
    let local = String::from("x");
    &local // error[E0515]: cannot return value referencing local variable
}
```

- **Pedir `&mut` a una variable no declarada `mut`** → `error[E0596]: cannot borrow `texto` as mutable, as it is not declared as mutable`. Solución: declara `let mut texto`.

- **Confundir `String` con `&str` en una firma** → `error[E0308]: mismatched types, expected `&String`, found `&str``. Solución: prefiere `&str` para aceptar literales y rebanadas (ej.: `f("hola")` con `fn f(s: &String)`).

- **Derivar `Copy` sobre un tipo con campos no `Copy`** → `error[E0204]: the trait `Copy` may not be implemented for this type`. Solución: elimina `Copy` de los derives o cambia el campo a un tipo `Copy` (ej.: `struct S { valor: String }` con `#[derive(Clone, Copy)]`).

- **Mover un valor mientras está prestado** → `error[E0505]: cannot move out of `s` because it is borrowed`. Solución: termina el préstamo (deja de usar la referencia) antes de mover el valor (ej.: `let t = s;` con un `&s` activo).

- **Intentar extraer un valor fuera de un contenedor prestado** → `error[E0507]: cannot move out of ...`. Solución: usa `clone()`, referencias (`&v[0]`) o el método `remove` si es un `Vec`.

```rust
fn main() {
    let v = vec![String::from("a")];
    // let primero = v[0]; // error[E0507]: cannot move out of index
    let primero = &v[0]; // ok: referencia prestada
    println!("{}", primero);
}
```

- **Referencia que sobrevive a su dato** → `error[E0597]: `x` does not live long enough`. Solución: haz que el dato viva tanto (o más) que la referencia que lo presta.

```rust
fn main() {
    let r: &i32;
    {
        let x = 5;
        r = &x; // error[E0597]: `x` does not live long enough
    }
    println!("{}", r);
}
```

- **Guardar una referencia a un temporal** → `error[E0716]: temporary value dropped while borrowed`. Solución: guarda el valor en una variable con nombre antes de referenciarlo.

```rust
fn main() {
    let r = &String::from("temporal"); // error[E0716]
    println!("{}", r);
}
```

Resumen de los códigos de error más frecuentes:

| Código | Significado | Solución rápida |
|---|---|---|
| E0382 | Uso de un valor ya movido | Presta con `&` o clona |
| E0499 | Doble préstamo mutable | Separa los préstamos en el tiempo |
| E0502 | `&mut` mientras hay un `&` | Usa primero los `&`, después el `&mut` |
| E0106 / E0515 | Referencia a un valor local | Devuelve el valor, no la referencia |
| E0596 | `&mut` sobre variable inmutable | Declara `let mut` |
| E0308 | Tipos distintos (`String` vs `&str`) | Usa `&str` en las firmas |
| E0204 | `Copy` sobre tipo no `Copy` | Quita `Copy` del derive |
| E0505 / E0507 | Mover fuera de algo prestado | Clona o usa referencia |
| E0597 | Referencia más longeva que el dato | Ajusta los ámbitos |
| E0716 | Referencia a un temporal | Guarda el valor en una variable |

## Recursos

- [The Rust Book — Understanding Ownership (cap. 4.1)](https://doc.rust-lang.org/book/ch04-01-what-is-ownership.html)
- [The Rust Book — References and Borrowing (cap. 4.2)](https://doc.rust-lang.org/book/ch04-02-references-and-borrowing.html)
- [The Rust Book — The Slice Type (cap. 4.3)](https://doc.rust-lang.org/book/ch04-03-slices.html)
- [Rust By Example — Ownership & move](https://doc.rust-lang.org/rust-by-example/scope/move.html)
- [Rust By Example — Borrowing](https://doc.rust-lang.org/rust-by-example/scope/borrow.html)
- [Rust Reference — Ownership](https://doc.rust-lang.org/reference/ownership.html)
- [std::marker::Copy](https://doc.rust-lang.org/std/marker/trait.Copy.html)
