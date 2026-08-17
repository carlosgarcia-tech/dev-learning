# Ejercicio 02 — Lifetimes

- **Nivel:** 4/5
- **Tema:** lifetimes explícitos, elipsis, structs con referencias
- **Tiempo estimado:** 25 min

## Enunciado

Crea un programa `lifetimes.rs` que:

1. Defina `elegir_mas_largo<'a>(a: &'a str, b: &'a str) -> &'a str` que devuelva el más largo.
2. Defina `primera_palabra<'a>(s: &'a str) -> &'a str` que devuelva el texto hasta el primer espacio.
3. Defina un `struct Registro<'a>` con el campo `titulo: &'a str` y un método `longitud(&self) -> usize`.
4. En `main`:
   - Llame a `elegir_mas_largo` con dos `String`.
   - Use `primera_palabra` sobre una frase.
   - Cree un `Registro` con un literal `&'static str` y otro con un `String` prestado.

Salida esperada (ejemplo):

```
Más largo: programación
Primera palabra: hola
Título estático: Introducción
Título dinámico: Capítulo 1
Longitud del título: 9
```

## Requisitos

- [ ] `elegir_mas_largo` declara el lifetime `'a` en firmas de parámetro y retorno.
- [ ] `primera_palabra` conecta el retorno con la entrada.
- [ ] El `struct Registro<'a>` guarda un `&'a str`.
- [ ] Crear un `Registro` con `'static` y uno con un `String` prestado.
- [ ] Ejecutarlo localmente con `rustc lifetimes.rs && ./lifetimes` y verificar la salida.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `fn elegir_mas_largo<'a>(a: &'a str, b: &'a str) -> &'a str { ... }`.
- `primera_palabra`: `s.find(' ').map_or(s, |i| &s[..i])`.
- Struct: `struct Registro<'a> { titulo: &'a str }` y `impl<'a> Registro<'a> { fn longitud(&self) -> usize { self.titulo.len() } }`.
- Literales de string son `'static`; para prestar un `String` usa `&string`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````rust
fn elegir_mas_largo<'a>(a: &'a str, b: &'a str) -> &'a str {
    if a.len() >= b.len() { a } else { b }
}

fn primera_palabra<'a>(s: &'a str) -> &'a str {
    match s.find(' ') {
        Some(pos) => &s[..pos],
        None => s,
    }
}

struct Registro<'a> {
    titulo: &'a str,
}

impl<'a> Registro<'a> {
    fn longitud(&self) -> usize {
        self.titulo.len()
    }
}

fn main() {
    let s1 = String::from("rust");
    let s2 = String::from("programación");
    println!("Más largo: {}", elegir_mas_largo(&s1, &s2));

    let frase = String::from("hola mundo rust");
    println!("Primera palabra: {}", primera_palabra(&frase));

    let estatico = Registro { titulo: "Introducción" };
    println!("Título estático: {}", estatico.titulo);

    let titulo_dinamico = String::from("Capítulo 1");
    let dinamico = Registro { titulo: &titulo_dinamico };
    println!("Título dinámico: {}", dinamico.titulo);

    let reg = Registro { titulo: "Rust 2021" };
    println!("Longitud del título: {}", reg.longitud());
}
````

</details>