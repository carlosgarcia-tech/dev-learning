# Ejercicio 01 — Variables y tipos

- **Nivel:** 1/5
- **Tema:** `let`/`const`, tipos, mutabilidad
- **Tiempo estimado:** 15 min

## Enunciado

Crea un programa `variables.rs` que:

1. Declare con `const` tu ciudad de nacimiento.
2. Declare con `let` tu nombre (inmutable) y con `let mut` tu edad (número entero sin signo).
3. Declare un booleano que indique si estudias programación.
4. Imprima el tipo de cada variable usando `std::any::type_name`.
5. Imprima una frase final: `Soy <nombre>, tengo <edad> años, nací en <ciudad> y es <true|false> que estudio programación.`

Salida esperada (ejemplo):

```
nombre es de tipo &str
ciudad es de tipo &str
edad es de tipo u32
programacion es de tipo bool
Soy Ana, tengo 30 años, nací en Lima y es true que estudio programación.
```

## Requisitos

- [ ] Usar `const` para la ciudad, `let` para el nombre y `let mut` para la edad.
- [ ] Imprimir los 4 tipos con `std::any::type_name`.
- [ ] La frase final usa la interpolación `{}` de `println!`.
- [ ] Ejecutarlo localmente con `rustc variables.rs && ./variables` y verificar la salida.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Los tipos de los literales se infieren; puedes anotarlos: `let edad: u32 = 30;`.
- `std::any::type_name::<T>()` devuelve el nombre de un tipo como `&str`.
- Escribe una función auxiliar: `fn tipo<T>(_: &T) -> &'static str { std::any::type_name::<T>() }`.
- `println!("{}", valor)` interpola cualquier valor que implemente `Display`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````rust
fn tipo<T>(_: &T) -> &'static str {
    std::any::type_name::<T>()
}

fn main() {
    const CIUDAD: &str = "Lima";
    let nombre: &str = "Ana";
    let mut edad: u32 = 30;
    let programacion: bool = true;

    println!("nombre es de tipo {}", tipo(&nombre));
    println!("ciudad es de tipo {}", tipo(&CIUDAD));
    println!("edad es de tipo {}", tipo(&edad));
    println!("programacion es de tipo {}", tipo(&programacion));

    println!(
        "Soy {}, tengo {} años, nací en {} y es {} que estudio programación.",
        nombre, edad, CIUDAD, programacion
    );
}
````

</details>