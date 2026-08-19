# Ejercicio 05 — Vectores

- **Nivel:** 2/5
- **Tema:** `Vec<T>`, `push`, `get`, iteración
- **Tiempo estimado:** 15 min

## Enunciado

Crea un programa `vectores.rs` que:

1. Cree un `Vec<i32>` vacío con `Vec::new()` y otro con la macro `vec![...]`.
2. Añada elementos con `push` y modifique uno con indexación mutable.
3. Imprima el tamaño con `len()`, el segundo elemento con `get` (sin paniquear) y el primero con `first`.
4. Calcule la suma con `.iter().sum()` y el máximo con `.iter().max()`.
5. Recorra el vector con un bucle `for`.

Salida esperada (ejemplo):

```
Tamaño: 4
Segundo: 20
Primero: 10
Suma: 100
Máximo: 40
Vec: [10, 20, 30, 40]
```

## Requisitos

- [ ] Crear un vector vacío y otro con la macro `vec!`.
- [ ] Usar `push`, `len`, `get`, `first` y `first` sin paniquear.
- [ ] Usar `.iter().sum()` y `.iter().max()`.
- [ ] Modificar un elemento por índice con `v[i] = ...`.
- [ ] Ejecutarlo localmente con `rustc vectores.rs && ./vectores` y verificar la salida.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `Vec::new()` crea un vector vacío; `vec![1, 2, 3]` lo inicializa.
- `v.get(i)` devuelve `Option<&i32>`; `v[i]` paniquea si está fuera de rango.
- `v.first()` devuelve `Option<&i32>`.
- `.iter().sum::<i32>()` y `.iter().max()` necesitan `Option` para max (`.unwrap()`).
- `for n in &v` recorre sin mover el vector.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````rust
fn construir_vector() -> Vec<i32> {
    vec![10, 20, 30, 40]
}

fn sumar(numeros: &[i32]) -> i32 {
    numeros.iter().sum()
}

fn maximo(numeros: &[i32]) -> Option<i32> {
    numeros.iter().max().copied()
}

fn main() {
    let mut numeros = construir_vector();

    numeros[1] = 20; // ya vale 20, modificación explícita

    println!("Tamaño: {}", numeros.len());

    match numeros.get(1) {
        Some(n) => println!("Segundo: {}", n),
        None => println!("Segundo: no existe"),
    }

    match numeros.first() {
        Some(n) => println!("Primero: {}", n),
        None => println!("Primero: no existe"),
    }

    println!("Suma: {}", sumar(&numeros));

    match maximo(&numeros) {
        Some(n) => println!("Máximo: {}", n),
        None => println!("Máximo: no existe"),
    }

    println!("Vec: {:?}", numeros);

    for n in &numeros {
        print!("{} ", n);
    }
    println!();
}
````

</details>