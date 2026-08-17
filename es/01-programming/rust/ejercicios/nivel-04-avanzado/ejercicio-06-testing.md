# Ejercicio 06 — Testing

- **Nivel:** 4/5
- **Tema:** `#[test]`, `cargo test`, `assert_eq!`, `should_panic`
- **Tiempo estimado:** 25 min

## Enunciado

Crea un proyecto de pruebas en `src/lib.rs` que:

1. Defina una función `suma(a: i32, b: i32) -> i32`.
2. Defina `es_par(n: i32) -> bool`.
3. Defina `factorial(n: u64) -> u64` con recursión (`0! = 1`).
4. Escriba un módulo `tests` con `#[cfg(test)]` que contenga:
   - `test_suma` con `assert_eq!`.
   - `test_es_par` con `assert!` y `assert!(!...)`.
   - `test_factorial` con `assert_eq!` para `factorial(5) == 120`.
   - `test_panico` marcada con `#[should_panic]` que acceda a un índice fuera de rango.

Salida esperada de `cargo test`:

```
running 4 tests
test tests::test_suma ... ok
test tests::test_es_par ... ok
test tests::test_factorial ... ok
test tests::test_panico ... ok
test result: ok. 4 passed; 0 failed; 0 ignored; 0 measured; 0 filtered out
```

## Requisitos

- [ ] Crear el proyecto con `cargo new pruebas --lib` (o manualmente con `Cargo.toml` y `src/lib.rs`).
- [ ] El módulo de tests está detrás de `#[cfg(test)]`.
- [ ] Usar `assert_eq!`, `assert!` y `#[should_panic]`.
- [ ] Ejecutarlo localmente con `cargo test` y verificar que pasan las 4 pruebas.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- En `Cargo.toml` la edición debe ser 2021.
- `use super::*;` dentro del módulo `tests` importa las funciones del archivo.
- `#[should_panic]` espera que la prueba paniquee.
- `assert_eq!(a, b)` compara igualdad.
- `assert!(!es_par(7))` verifica la negación.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````rust
pub fn suma(a: i32, b: i32) -> i32 {
    a + b
}

pub fn es_par(n: i32) -> bool {
    n % 2 == 0
}

pub fn factorial(n: u64) -> u64 {
    match n {
        0 | 1 => 1,
        _ => n * factorial(n - 1),
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_suma() {
        assert_eq!(suma(2, 3), 5);
        assert_eq!(suma(-1, 1), 0);
    }

    #[test]
    fn test_es_par() {
        assert!(es_par(4));
        assert!(!es_par(7));
    }

    #[test]
    fn test_factorial() {
        assert_eq!(factorial(0), 1);
        assert_eq!(factorial(5), 120);
    }

    #[test]
    #[should_panic]
    fn test_panico_fuera_de_rango() {
        let v = vec![1, 2, 3];
        let _ = v[10];
    }
}
````

</details>