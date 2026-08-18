# Ejercicio 04 — Strings y slices

- **Nivel:** 1/5
- **Tema:** `String`, `&str`, slices
- **Tiempo estimado:** 20 min

## Enunciado

Crea un programa `strings.rs` que:

1. Construya un `String` con `String::from("Hola")`.
2. Lo modifique con `push_str(", mundo")` y `push('!')`, e imprímalo.
3. Extraiga un slice `&palabra[0..5]` de un `&str` y lo imprima.
4. Imprima la longitud en bytes (`len()`) y la cantidad de caracteres (`chars().count()`).
5. Cree un `String` nuevo a partir de un `&str` con `.to_string()` y concaténelo con `format!`.

Salida esperada (ejemplo):

```
Hola, mundo!
programación: primeros 5 bytes = progr
longitud en bytes = 13
caracteres = 12
hola mundo => ¡hola mundo!
```

Nota: "programación" tiene 13 bytes en UTF-8 (la ñ y la ó ocupan 2 bytes cada una) pero 12 caracteres.

## Requisitos

- [ ] Usar `push_str` y `push` sobre un `String` mutable.
- [ ] Extraer un slice con índices de bytes que respete límites UTF-8.
- [ ] Comparar `len()` (bytes) con `chars().count()` (caracteres).
- [ ] Usar `.to_string()` y `format!` para crear `String`.
- [ ] Ejecutarlo localmente con `rustc strings.rs && ./strings` y verificar la salida.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Un `String` para modificar debe declararse `let mut s = ...`.
- Los slices de `&str` usan índices de **bytes**: `&palabra[0..5]`.
- Cortar por la mitad de un carácter UTF-8 paniquea; "progr" son 5 bytes ASCII, así que es seguro.
- `palabra.len()` da bytes; `palabra.chars().count()` da caracteres.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````rust
fn main() {
    let mut saludo = String::from("Hola");
    saludo.push_str(", mundo");
    saludo.push('!');
    println!("{}", saludo);

    let palabra = "programación";
    let primeros = &palabra[0..5];
    println!("{}: primeros 5 bytes = {}", palabra, primeros);
    println!("longitud en bytes = {}", palabra.len());
    println!("caracteres = {}", palabra.chars().count());

    let base = String::from("hola mundo");
    let exclamacion = format!("¡{}!", base);
    println!("hola mundo => {}", exclamacion);

    let cadena = "texto".to_string();
    println!("{}", cadena);
}
````

</details>