# 03 — Structs y enums

## Objetivos

- [ ] Definir y construir `struct` (tuplas, campos con nombre y unit).
- [ ] Implementar métodos con `impl` y entender `&self`, `&mut self` y `self`.
- [ ] Usar funciones asociadas (constructores como `::new()`).
- [ ] Definir `enum` con datos asociados.
- [ ] Usar `match` con patrones sobre enums y structs.
- [ ] Combinar structs y enums en datos reales.

## Apuntes

### Definir un `struct`

Un `struct` agrupa datos relacionados bajo un tipo propio. Hay tres formas:

```rust
// Con campos con nombre (la más común)
struct Persona {
    nombre: String,
    edad: u8,
    activo: bool,
}

// Tuple struct
struct Color(u8, u8, u8);

// Unit struct
struct Unidad;
```

Construcción y acceso a campos:

```rust
fn main() {
    let p = Persona {
        nombre: String::from("Ana"),
        edad: 30,
        activo: true,
    };
    println!("{} tiene {} años", p.nombre, p.edad);

    let rojo = Color(255, 0, 0);
    println!("R={} G={} B={}", rojo.0, rojo.1, rojo.2);
}
```

### Métodos con `impl`

Los métodos se definen dentro de `impl`. `&self` presta el struct (lectura), `&mut self` permite modificarlo y `self` lo consume.

```rust
struct Rectangulo {
    ancho: u32,
    alto: u32,
}

impl Rectangulo {
    // Función asociada: constructor
    fn nuevo(ancho: u32, alto: u32) -> Rectangulo {
        Rectangulo { ancho, alto }
    }

    fn area(&self) -> u32 {
        self.ancho * self.alto
    }

    fn escalar(&mut self, factor: u32) {
        self.ancho *= factor;
        self.alto *= factor;
    }
}

fn main() {
    let mut r = Rectangulo::nuevo(4, 3);
    println!("Área: {}", r.area()); // 12
    r.escalar(2);
    println!("Área tras escalar: {}", r.area()); // 48
}
```

### Actualización y destructuración

Puedes construir un struct a partir de otro con `..` y destructurar para extraer campos:

```rust
struct Persona {
    nombre: String,
    edad: u8,
}

fn main() {
    let p1 = Persona { nombre: String::from("Ana"), edad: 30 };
    let p2 = Persona { nombre: String::from("Luis"), ..p1 };
    println!("{} - {}", p2.nombre, p2.edad);

    let Persona { nombre, edad } = p1;
    println!("{} tiene {}", nombre, edad);
}
```

### `enum` con datos

Un `enum` representa un valor que puede ser uno de varios casos. Puede llevar datos asociados.

```rust
enum Mensaje {
    Texto(String),
    Numero(i32),
    Mover { x: i32, y: i32 },
    Salir,
}
```

`match` sobre el enum obliga a tratar todos los casos. El comodín `_` cubre los restantes.

```rust
fn procesar(m: Mensaje) {
    match m {
        Mensaje::Texto(t) => println!("Texto: {}", t),
        Mensaje::Numero(n) => println!("Número: {}", n),
        Mensaje::Mover { x, y } => println!("Mover a ({}, {})", x, y),
        Mensaje::Salir => println!("Saliendo"),
    }
}

fn main() {
    procesar(Mensaje::Texto(String::from("hola")));
    procesar(Mensaje::Mover { x: 5, y: -3 });
    procesar(Mensaje::Salir);
}
```

### `Option` y `match`

`Option<T>` es un enum estándar: `Some(T)` o `None`. `match` es la forma segura de extraer el valor.

```rust
fn mitad(n: i32) -> Option<i32> {
    if n % 2 == 0 { Some(n / 2) } else { None }
}

fn main() {
    match mitad(10) {
        Some(v) => println!("Mitad: {}", v),
        None => println!("No es divisible entre 2"),
    }
}
```

### Métodos dentro de `enum`

También puedes implementar métodos en un enum con `impl`:

```rust
enum Estado {
    Activo,
    Pausado,
    Terminado,
}

impl Estado {
    fn descripcion(&self) -> &str {
        match self {
            Estado::Activo => "en marcha",
            Estado::Pausado => "pausado",
            Estado::Terminado => "terminado",
        }
    }
}
```

## Ejemplos de código

```rust
struct Cuenta {
    titular: String,
    saldo: f64,
}

impl Cuenta {
    fn nueva(titular: &str) -> Cuenta {
        Cuenta { titular: titular.to_string(), saldo: 0.0 }
    }

    fn depositar(&mut self, cantidad: f64) {
        self.saldo += cantidad;
    }

    fn retirar(&mut self, cantidad: f64) -> bool {
        if cantidad <= self.saldo {
            self.saldo -= cantidad;
            true
        } else {
            false
        }
    }
}

fn main() {
    let mut cuenta = Cuenta::nueva("Ana");
    cuenta.depositar(100.0);
    println!("Retiro exitoso: {}", cuenta.retirar(30.0));
    println!("Saldo: {}", cuenta.saldo);
}
```

```rust
enum Animal {
    Perro(String),
    Gato(u8), // años
}

fn describir(a: Animal) -> String {
    match a {
        Animal::Perro(nombre) => format!("Perro llamado {}", nombre),
        Animal::Gato(anios) => format!("Gato de {} años", anios),
    }
}

fn main() {
    println!("{}", describir(Animal::Perro(String::from("Rex"))));
    println!("{}", describir(Animal::Gato(3)));
}
```

## Ejercicios relacionados

- [Ejercicios nivel 02 — Básico](../ejercicios/nivel-02-basico/)
- [Ejercicios nivel 03 — Intermedio](../ejercicios/nivel-03-intermedio/)

## Errores comunes

- **Olvidar el `mut` en el parámetro** → métodos que modifican necesitan `&mut self`, y la variable debe declararse `let mut`.
- **Construir un struct sin todos los campos** → `error[E0063]: missing field`. Inicializa todos los campos o usa `..`.
- **`match` no exhaustivo** → `error[E0004]: non-exhaustive patterns`. Cubre todos los casos o añade `_ => {}`.
- **Acceder a campos de un enum directamente** → debes extraerlos con `match` o `if let`; no puedes hacer `mensaje.texto`.
- **Confundir `String` en el campo con `&str`** → los structs normalmente guardan `String` (owned); usar `&str` requiere lifetimes (se ve en el nivel 04).
- **Método que consume self** → si declaras `fn consumir(self)`, la variable original ya no se puede usar después.

## Recursos

- [The Rust Book — Structs](https://doc.rust-lang.org/book/ch05-00-structs.html)
- [The Rust Book — Enums](https://doc.rust-lang.org/book/ch06-00-enums.html)
- [Rust By Example — structs](https://doc.rust-lang.org/rust-by-example/custom_types/structs.html)
- [Rust By Example — enums](https://doc.rust-lang.org/rust-by-example/custom_types/enum.html)