# Ejercicio 02 — Generics

- **Nivel:** 3/5
- **Tema:** funciones y structs genéricos
- **Tiempo estimado:** 20 min

## Enunciado

Crea un programa `generics.rs` que:

1. Defina `mayor<T: PartialOrd>(a: T, b: T) -> T` que devuelva el mayor.
2. Defina `repetir<T: Clone>(valor: T, veces: usize) -> Vec<T>` que repita `valor` `veces` veces.
3. Defina un `struct Caja<T>` con un campo `contenido: T`.
4. Implemente `Caja::nuevo(contenido: T) -> Caja<T>`, `obtener(&self) -> &T` y `cambiar(&mut self, nuevo: T)`.
5. En `main`, use `mayor` con enteros, flotantes y `&str`; y `Caja` con un `i32` y un `String`.

Salida esperada (ejemplo):

```
Mayor: 7
Mayor: 3.5
Mayor: b
Repetido: [7, 7, 7, 7]
Caja de 42
Caja de hola
Caja cambiada: mundo
```

## Requisitos

- [ ] `mayor` usa el bound `T: PartialOrd`.
- [ ] `repetir` usa `T: Clone` y devuelve un `Vec<T>`.
- [ ] `Caja<T>` es genérica y `impl<T>` acompaña al struct.
- [ ] Usar `Caja` con al menos dos tipos distintos.
- [ ] Ejecutarlo localmente con `rustc generics.rs && ./generics` y verificar la salida.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `fn mayor<T: PartialOrd>(a: T, b: T) -> T { if a > b { a } else { b } }`.
- `fn repetir<T: Clone>(valor: T, veces: usize) -> Vec<T> { vec![valor; veces] }` (requiere `Clone` porque `vec![x; n]` clona).
- Struct genérico: `struct Caja<T> { contenido: T }`.
- `impl<T> Caja<T> { fn nuevo(contenido: T) -> Caja<T> { Caja { contenido } } }`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````rust
fn mayor<T: PartialOrd>(a: T, b: T) -> T {
    if a > b { a } else { b }
}

fn repetir<T: Clone>(valor: T, veces: usize) -> Vec<T> {
    vec![valor; veces]
}

struct Caja<T> {
    contenido: T,
}

impl<T> Caja<T> {
    fn nuevo(contenido: T) -> Caja<T> {
        Caja { contenido }
    }

    fn obtener(&self) -> &T {
        &self.contenido
    }

    fn cambiar(&mut self, nuevo: T) {
        self.contenido = nuevo;
    }
}

fn main() {
    println!("Mayor: {}", mayor(3, 7));
    println!("Mayor: {}", mayor(2.1, 3.5));
    println!("Mayor: {}", mayor("a", "b"));

    println!("Repetido: {:?}", repetir(7, 4));

    let caja_numero = Caja::nuevo(42);
    println!("Caja de {}", caja_numero.obtener());

    let mut caja_texto = Caja::nuevo(String::from("hola"));
    println!("Caja de {}", caja_texto.obtener());

    caja_texto.cambiar(String::from("mundo"));
    println!("Caja cambiada: {}", caja_texto.obtener());
}
````

</details>