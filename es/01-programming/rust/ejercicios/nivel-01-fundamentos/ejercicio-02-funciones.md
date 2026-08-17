# Ejercicio 02 — Funciones

- **Nivel:** 1/5
- **Tema:** funciones, parámetros, valores de retorno
- **Tiempo estimado:** 15 min

## Enunciado

Crea un programa `funciones.rs` con las siguientes funciones y muéstralas en `main`:

1. `sumar(a: i32, b: i32) -> i32` que devuelva `a + b`.
2. `es_par(n: i32) -> bool` que devuelva `true` si `n` es par.
3. `area_rectangulo(base: f64, alto: f64) -> f64` que devuelva base × alto.
4. `describe(n: i32) -> String` que devuelva `"par"` o `"impar"` (usa `format!`).

Salida esperada (ejemplo):

```
2 + 3 = 5
7 es par? false
El área del rectángulo es 15
El 7 es impar
```

## Requisitos

- [ ] Las 4 funciones tienen tipos explícitos en parámetros y retorno.
- [ ] Usar la expresión final (sin `return`) para devolver el valor.
- [ ] `describe` usa `if` como expresión.
- [ ] Ejecutarlo localmente con `rustc funciones.rs && ./funciones` y verificar la salida.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- En Rust la última expresión de una función es el valor devuelto: `fn sumar(a: i32, b: i32) -> i32 { a + b }`.
- No pongas `;` después de la expresión que devuelves.
- `n % 2 == 0` comprueba paridad.
- `format!("...", valor)` crea un `String`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````rust
fn sumar(a: i32, b: i32) -> i32 {
    a + b
}

fn es_par(n: i32) -> bool {
    n % 2 == 0
}

fn area_rectangulo(base: f64, alto: f64) -> f64 {
    base * alto
}

fn describe(n: i32) -> String {
    if es_par(n) {
        String::from("par")
    } else {
        String::from("impar")
    }
}

fn main() {
    println!("2 + 3 = {}", sumar(2, 3));
    println!("7 es par? {}", es_par(7));
    println!("El área del rectángulo es {}", area_rectangulo(5.0, 3.0));
    println!("El 7 es {}", describe(7));
}
````

</details>