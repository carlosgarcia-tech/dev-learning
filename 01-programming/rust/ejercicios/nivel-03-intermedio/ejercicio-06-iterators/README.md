# Ejercicio 06 — Iterators

- **Nivel:** 3/5
- **Tema:** `map`, `filter`, `fold`, `collect`, `flat_map`
- **Tiempo estimado:** 20 min

## Enunciado

Crea un programa `iterators.rs` que, sobre `let datos = vec![1, 2, 3, 4, 5, 6];`:

1. Filtre los pares con `filter` y los recoja con `collect`.
2. Calcule los cuadrados con `map` y los recoja.
3. Calcule la suma con `sum` y el producto con `fold(1, |acc, x| acc * x)`.
4. Encuentre el máximo y el mínimo con `max` y `min`.
5. Use `flat_map` sobre `1..=3` para generar `[n, n * 10]` y recoja el resultado.
6. Cuente cuántos números son mayores que 3 con `filter(...).count()`.

Salida esperada (ejemplo):

```
Pares: [2, 4, 6]
Cuadrados: [1, 4, 9, 16, 25, 36]
Suma: 21
Producto (fold): 720
Máximo: 6, Mínimo: 1
Flat map: [1, 10, 2, 20, 3, 30]
Mayores que 3: 3
```

## Requisitos

- [ ] Usar `filter` + `collect`.
- [ ] Usar `map` + `collect`.
- [ ] Usar `sum` y `fold` con acumulador.
- [ ] Usar `max` y `min` manejando el `Option`.
- [ ] Usar `flat_map` y `count`.
- [ ] Ejecutarlo localmente con `rustc iterators.rs && ./iterators` y verificar la salida.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `numeros.iter().filter(|&&n| n % 2 == 0).copied().collect::<Vec<i32>>()`.
- `fold(1, |acc, x| acc * x)` empieza en 1.
- `max()` y `min()` devuelven `Option<&i32>`; usa `.unwrap()` o `copied()`.
- `flat_map` recibe un closure que devuelve un iterador: `|n| [n, n * 10]`.
- `.count()` cuenta elementos.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````rust
fn numeros_pares(datos: &[i32]) -> Vec<i32> {
    datos.iter().filter(|&&n| n % 2 == 0).copied().collect()
}

fn numeros_cuadrados(datos: &[i32]) -> Vec<i32> {
    datos.iter().map(|&n| n * n).collect()
}

fn suma_y_producto(datos: &[i32]) -> (i32, i32) {
    let suma: i32 = datos.iter().sum();
    let producto: i32 = datos.iter().fold(1, |acc, &n| acc * n);
    (suma, producto)
}

fn mayor_y_menor(datos: &[i32]) -> (i32, i32) {
    let maximo = datos.iter().max().copied().unwrap_or(0);
    let minimo = datos.iter().min().copied().unwrap_or(0);
    (maximo, minimo)
}

fn generar_planos(n: i32) -> Vec<i32> {
    (1..=n).flat_map(|x| [x, x * 10]).collect()
}

fn contar_mayores(datos: &[i32], umbral: i32) -> usize {
    datos.iter().filter(|&&n| n > umbral).count()
}

fn main() {
    let datos = vec![1, 2, 3, 4, 5, 6];

    println!("Pares: {:?}", numeros_pares(&datos));
    println!("Cuadrados: {:?}", numeros_cuadrados(&datos));

    let (suma, producto) = suma_y_producto(&datos);
    println!("Suma: {}", suma);
    println!("Producto (fold): {}", producto);

    let (maximo, minimo) = mayor_y_menor(&datos);
    println!("Máximo: {}, Mínimo: {}", maximo, minimo);

    println!("Flat map: {:?}", generar_planos(3));
    println!("Mayores que 3: {}", contar_mayores(&datos, 3));
}
````

</details>