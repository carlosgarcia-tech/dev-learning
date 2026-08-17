# Ejercicio 01 — Traits básicos

- **Nivel:** 3/5
- **Tema:** `trait`, `impl Trait for Tipo`
- **Tiempo estimado:** 20 min

## Enunciado

Crea un programa `traits.rs` que:

1. Defina un `trait Hablar` con el método `fn hablar(&self) -> String;`.
2. Implemente el trait para `Perro` (devuelve `"Guau"`), `Gato` (`"Miau"`) y `Vaca` (`"Muu"`).
3. Defina una función `presentar(a: &impl Hablar, b: &impl Hablar)` que imprima ambos sonidos.
4. Defina una función genérica `sonar<T: Hablar>(a: &T)` que imprima el sonido de uno.
5. En `main`, cree los tres animales y use ambas funciones.

Salida esperada (ejemplo):

```
Guau y Miau
Sonido: Muu
Sonido: Guau
Sonido: Miau
```

## Requisitos

- [ ] El trait se define con su método.
- [ ] Tres tipos distintos implementan el mismo trait.
- [ ] Usar `&impl Hablar` y el parámetro genérico `T: Hablar`.
- [ ] Ejecutarlo localmente con `rustc traits.rs && ./traits` y verificar la salida.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `trait Hablar { fn hablar(&self) -> String; }`.
- `impl Hablar for Perro { fn hablar(&self) -> String { String::from("Guau") } }`.
- `fn presentar(a: &impl Hablar, b: &impl Hablar)` acepta cualquier tipo con el trait.
- Genérico: `fn sonar<T: Hablar>(a: &T)`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````rust
trait Hablar {
    fn hablar(&self) -> String;
}

struct Perro;
struct Gato;
struct Vaca;

impl Hablar for Perro {
    fn hablar(&self) -> String {
        String::from("Guau")
    }
}

impl Hablar for Gato {
    fn hablar(&self) -> String {
        String::from("Miau")
    }
}

impl Hablar for Vaca {
    fn hablar(&self) -> String {
        String::from("Muu")
    }
}

fn presentar(a: &impl Hablar, b: &impl Hablar) {
    println!("{} y {}", a.hablar(), b.hablar());
}

fn sonar<T: Hablar>(a: &T) {
    println!("Sonido: {}", a.hablar());
}

fn main() {
    let perro = Perro;
    let gato = Gato;
    let vaca = Vaca;

    presentar(&perro, &gato);
    sonar(&vaca);
    sonar(&perro);
    sonar(&gato);
}
````

</details>