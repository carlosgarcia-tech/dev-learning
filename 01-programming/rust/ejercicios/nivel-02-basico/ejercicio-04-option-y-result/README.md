# Ejercicio 04 — Option y Result

- **Nivel:** 2/5
- **Tema:** `Option<T>`, `Result<T, E>`, `match`, `unwrap_or`
- **Tiempo estimado:** 20 min

## Enunciado

Crea un programa `option.rs` que:

1. Defina `dividir(a: f64, b: f64) -> Result<f64, String>` que devuelva `Err` al dividir entre cero.
2. Defina `buscar(indice: usize, v: &[i32]) -> Option<i32>` que use `v.get(indice)`.
3. Defina `raiz(n: f64) -> Option<f64>` que devuelva `Some` si `n >= 0` y `None` si es negativa.
4. En `main`:
   - Maneje el `Result` con `match` y con `if let`.
   - Maneje el `Option` con `match`.
   - Use `unwrap_or` para dar un valor por defecto.
   - Use `.expect("mensaje")` en un caso que sabes que no falla.

Salida esperada (ejemplo):

```
Resultado: 5
Error capturado: no se puede dividir entre cero
Índice 1: 20
Índice 10: None
Raíz de 9: 3
Raíz de -4: None
Valor por defecto: 0
Raíz de 16 (expect): 4
```

## Requisitos

- [ ] `dividir` y `buscar` tienen las firmas pedidas.
- [ ] Usar `match` para `Result` y para `Option`.
- [ ] Usar `if let` en al menos un caso.
- [ ] Usar `unwrap_or` y `.expect`.
- [ ] Ejecutarlo localmente con `rustc option.rs && ./option` y verificar la salida.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `Result`: `Ok(valor)` / `Err(mensaje)`.
- `if let Ok(r) = resultado { ... } else { ... }`.
- `v.get(i)` no paniquea y devuelve `Option<&i32>`; usa `.copied()` para obtener `Option<i32>`.
- `unwrap_or(0.0)` devuelve el valor o el fallback.
- `.expect("msg")` extrae o paniquea con el mensaje.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````rust
fn dividir(a: f64, b: f64) -> Result<f64, String> {
    if b == 0.0 {
        Err(String::from("no se puede dividir entre cero"))
    } else {
        Ok(a / b)
    }
}

fn buscar(indice: usize, v: &[i32]) -> Option<i32> {
    v.get(indice).copied()
}

fn raiz(n: f64) -> Option<f64> {
    if n >= 0.0 {
        Some(n.sqrt())
    } else {
        None
    }
}

fn main() {
    match dividir(10.0, 2.0) {
        Ok(r) => println!("Resultado: {}", r),
        Err(e) => println!("Error: {}", e),
    }

    if let Err(e) = dividir(10.0, 0.0) {
        println!("Error capturado: {}", e);
    }

    let nums = [10, 20, 30];
    match buscar(1, &nums) {
        Some(n) => println!("Índice 1: {}", n),
        None => println!("Índice 1: None"),
    }
    match buscar(10, &nums) {
        Some(n) => println!("Índice 10: {}", n),
        None => println!("Índice 10: None"),
    }

    match raiz(9.0) {
        Some(r) => println!("Raíz de 9: {}", r),
        None => println!("Raíz de 9: None"),
    }
    match raiz(-4.0) {
        Some(r) => println!("Raíz de -4: {}", r),
        None => println!("Raíz de -4: None"),
    }

    let por_defecto = dividir(10.0, 0.0).unwrap_or(0.0);
    println!("Valor por defecto: {}", por_defecto);

    let segura = raiz(16.0).expect("16 es no negativo");
    println!("Raíz de 16 (expect): {}", segura);
}
````

</details>