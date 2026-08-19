# Ejercicio 01 — Ownership y borrowing

- **Nivel:** 2/5
- **Tema:** movimiento, `Copy`, préstamos
- **Tiempo estimado:** 20 min

## Enunciado

Crea un programa `ownership.rs` que demuestre las reglas del ownership:

1. Mueva un `String` de `s1` a `s2` y luego use `s2` (comenta el uso de `s1` que no compila).
2. Copie un `i32` de `x` a `y` y use ambos (los enteros implementan `Copy`).
3. Pase un `String` a una función `calcular_longitud(s: String) -> usize` que lo consuma.
4. Devuelva el `String` de vuelta con `devolver(s: String) -> String`.
5. Pruebe un clon con `.clone()` para conservar el original.

Salida esperada (ejemplo):

```
s2 = hola
x = 5, y = 5
Longitud: 5
Devolver: mundo
Original tras clone: rust
Copia: rust
```

## Requisitos

- [ ] Comentar la línea `println!("{}", s1);` y dejar constancia de que no compila.
- [ ] Demostrar que `i32` es `Copy` y `String` no lo es.
- [ ] Una función consume el `String` y otra lo devuelve.
- [ ] Usar `.clone()` en al menos un caso.
- [ ] Ejecutarlo localmente con `rustc ownership.rs && ./ownership` y verificar la salida.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `let s2 = s1;` mueve; `s1` queda inválido.
- `let y = x;` con `i32` copia, no mueve.
- `fn calcular_longitud(s: String) -> usize { s.len() }` consume el valor.
- `fn devolver(s: String) -> String { s }` devuelve la propiedad.
- `.clone()` duplica un `String`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````rust
fn calcular_longitud(s: String) -> usize {
    s.len()
}

fn devolver(s: String) -> String {
    s
}

fn main() {
    let s1 = String::from("hola");
    let s2 = s1;
    println!("s2 = {}", s2);
    // println!("s1 = {}", s1); // ERROR: s1 fue movido

    let x = 5;
    let y = x;
    println!("x = {}, y = {}", x, y);

    let texto = String::from("hola");
    let longitud = calcular_longitud(texto);
    println!("Longitud: {}", longitud);

    let devuelto = devolver(String::from("mundo"));
    println!("Devolver: {}", devuelto);

    let original = String::from("rust");
    let copia = original.clone();
    println!("Original tras clone: {}", original);
    println!("Copia: {}", copia);
}
````

</details>