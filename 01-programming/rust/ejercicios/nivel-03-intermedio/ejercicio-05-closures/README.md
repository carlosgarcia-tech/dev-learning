# Ejercicio 05 — Closures

- **Nivel:** 3/5
- **Tema:** closures, captura, `Fn`/`FnMut`/`FnOnce`
- **Tiempo estimado:** 20 min

## Enunciado

Crea un programa `closures.rs` que:

1. Defina un closure `sumar = |a: i32, b: i32| a + b` y lo use.
2. Defina un closure que capture una variable del entorno (`incremento`) y la sume.
3. Defina un closure `FnMut` con `let mut` que incremente un contador capturado.
4. Use un closure `FnOnce` que consuma un `String` capturado (por ejemplo, formateándolo).
5. Use `filter` y `map` con closures para transformar una lista.

Salida esperada (ejemplo):

```
sumar: 5
con incremento: 15
contador: 2
FnOnce: hola
pares: [2, 4, 6]
cuadrados: [1, 4, 9, 16, 25]
```

## Requisitos

- [ ] Un closure con parámetros anotados.
- [ ] Un closure que capture por referencia el entorno.
- [ ] Un closure `FnMut` declarado como `let mut`.
- [ ] Un closure `FnOnce` que mueva su captura.
- [ ] Closures dentro de `filter` y `map`.
- [ ] Ejecutarlo localmente con `rustc closures.rs && ./closures` y verificar la salida.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Sintaxis: `let sumar = |a: i32, b: i32| a + b;`.
- Capturar entorno: `let incremento = 10; let f = |x: i32| x + incremento;`.
- `FnMut`: `let mut contador = 0; let mut inc = || { contador += 1; };`.
- `FnOnce`: `let texto = String::from("hola"); let f = move || println!("{}", texto);`.
- En `filter` con `iter()` el elemento es `&i32`: `|&&x| x % 2 == 0`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````rust
fn numeros_pares(datos: &[i32]) -> Vec<i32> {
    datos.iter().filter(|&&x| x % 2 == 0).copied().collect()
}

fn numeros_cuadrados(datos: &[i32]) -> Vec<i32> {
    datos.iter().map(|&x| x * x).collect()
}

fn main() {
    let sumar = |a: i32, b: i32| a + b;
    println!("sumar: {}", sumar(2, 3));

    let incremento = 10;
    let con_incremento = |x: i32| x + incremento;
    println!("con incremento: {}", con_incremento(5));

    let mut contador = 0;
    let mut incrementar = || {
        contador += 1;
        contador
    };
    incrementar();
    incrementar();
    println!("contador: {}", contador);

    let texto = String::from("hola");
    let consumir = move || println!("FnOnce: {}", texto);
    consumir();

    let numeros = vec![1, 2, 3, 4, 5, 6];
    println!("pares: {:?}", numeros_pares(&numeros));
    println!("cuadrados: {:?}", numeros_cuadrados(&numeros));
}
````

</details>