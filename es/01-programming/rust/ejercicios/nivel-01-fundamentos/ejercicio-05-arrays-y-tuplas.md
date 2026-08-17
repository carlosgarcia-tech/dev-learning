# Ejercicio 05 — Arrays y tuplas

- **Nivel:** 1/5
- **Tema:** arrays de tamaño fijo, tuplas, indexación, iteración
- **Tiempo estimado:** 15 min

## Enunciado

Crea un programa `arrays.rs` que:

1. Defina un array `[i32; 5]` con los valores `[10, 20, 30, 40, 50]`.
2. Imprima el primer y el último elemento por índice.
3. Imprima la suma con un bucle `for` y también con `.iter().sum()`.
4. Defina una tupla `("Ana", 30, 1.65)` y la imprima accediendo por `.0`, `.1`, `.2`.
5. Destructure la tupla en variables y las imprima.

Salida esperada (ejemplo):

```
Primero: 10, último: 50
Suma con for: 150
Suma con iter: 150
Ana tiene 30 años y mide 1.65
Destructuring: Ana, 30, 1.65
```

## Requisitos

- [ ] El array tiene tamaño fijo explícito `[i32; 5]`.
- [ ] Acceder a elementos por índice.
- [ ] Sumar con un bucle `for` y con `.iter().sum::<i32>()`.
- [ ] Acceder a los elementos de la tupla por posición y destructurarla.
- [ ] Ejecutarlo localmente con `rustc arrays.rs && ./arrays` y verificar la salida.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Array: `let numeros: [i32; 5] = [10, 20, 30, 40, 50];`.
- Acceso: `numeros[0]`, `numeros[4]`.
- `.iter().sum::<i32>()` necesita la anotación de tipo del acumulado.
- Tupla: `let persona = ("Ana", 30, 1.65);` → `persona.0`.
- Destructurar: `let (nombre, edad, altura) = persona;`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````rust
fn main() {
    let numeros: [i32; 5] = [10, 20, 30, 40, 50];
    println!("Primero: {}, último: {}", numeros[0], numeros[4]);

    let mut suma_for = 0;
    for n in numeros {
        suma_for += n;
    }
    println!("Suma con for: {}", suma_for);

    let suma_iter: i32 = numeros.iter().sum();
    println!("Suma con iter: {}", suma_iter);

    let persona = ("Ana", 30, 1.65);
    println!(
        "{} tiene {} años y mide {}",
        persona.0, persona.1, persona.2
    );

    let (nombre, edad, altura) = persona;
    println!("Destructuring: {}, {}, {}", nombre, edad, altura);
}
````

</details>