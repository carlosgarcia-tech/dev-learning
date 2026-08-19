# Ejercicio 02 — Referencias

- **Nivel:** 2/5
- **Tema:** `&`, `&mut`, reglas del borrowing
- **Tiempo estimado:** 20 min

## Enunciado

Crea un programa `referencias.rs` que:

1. Defina una función `longitud(s: &String) -> usize` que devuelva `s.len()` sin consumir el valor.
2. Defina `agregar_exclamacion(s: &mut String)` que haga `s.push('!')`.
3. Defina `primer_elemento(v: &[i32]) -> Option<&i32>` que devuelva `v.first()`.
4. En `main`:
   - Cree un `String` mutable, imprima su longitud con una referencia inmutable y luego modifíquelo con una referencia mutable.
   - Imprima varias referencias inmutables a la vez sobre un vector.
   - Obtenga el primer elemento de un slice.

Salida esperada (ejemplo):

```
Longitud: 4
Hola!
Primera referencia: 10
Segunda referencia: 10
Primer elemento: 10
```

## Requisitos

- [ ] `longitud` toma `&String` y no mueve el valor.
- [ ] `agregar_exclamacion` toma `&mut String` y modifica el original.
- [ ] Mostrar que varias referencias inmutables pueden coexistir.
- [ ] Explicar en un comentario por qué no se puede mezclar `&` con `&mut` sobre el mismo dato.
- [ ] Ejecutarlo localmente con `rustc referencias.rs && ./referencias` y verificar la salida.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `fn longitud(s: &String) -> usize { s.len() }` presta sin mover.
- Para modificar: `fn agregar_exclamacion(s: &mut String) { s.push('!'); }`.
- Varias referencias inmutables: `let r1 = &v; let r2 = &v;`.
- No mezcles un `&mut` activo con referencias inmutables vivas.
- `v.first()` sobre un slice devuelve `Option<&i32>`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````rust
fn longitud(s: &String) -> usize {
    s.len()
}

fn agregar_exclamacion(s: &mut String) {
    s.push('!');
}

fn primer_elemento(v: &[i32]) -> Option<&i32> {
    v.first()
}

fn main() {
    let mut saludo = String::from("Hola");
    println!("Longitud: {}", longitud(&saludo));

    // Las referencias inmutables terminan antes de pedir la mutable
    agregar_exclamacion(&mut saludo);
    println!("{}", saludo);

    let numeros = [10, 20, 30];
    let r1 = &numeros;
    let r2 = &numeros;
    println!("Primera referencia: {}", r1[0]);
    println!("Segunda referencia: {}", r2[0]);
    // let r3 = &mut numeros; // ERROR: numeros no es mutable y ya hay préstamos

    match primer_elemento(&numeros) {
        Some(n) => println!("Primer elemento: {}", n),
        None => println!("Sin elementos"),
    }
}
````

</details>