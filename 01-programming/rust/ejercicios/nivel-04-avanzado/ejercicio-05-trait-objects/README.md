# Ejercicio 05 — Trait objects

- **Nivel:** 4/5
- **Tema:** `dyn Trait`, `Box<dyn Trait>`, polimorfismo dinámico
- **Tiempo estimado:** 25 min

## Enunciado

Crea un programa `trait_objects.rs` que:

1. Defina un `trait Figuras` con el método `fn area(&self) -> f64;` y `fn nombre(&self) -> &str;`.
2. Implemente el trait para `Cuadrado { lado: f64 }` (área = lado²) y `Circulo { radio: f64 }` (área = π·radio², usa `std::f64::consts::PI`).
3. Cree un `Vec<Box<dyn Figuras>>` con un cuadrado y un círculo.
4. Recorra el vector llamando a `area()` y `nombre()` sobre el trait object.
5. Defina una función `mostrar(figura: &dyn Figuras)` que imprima el nombre y el área.

Salida esperada (ejemplo):

```
Cuadrado de lado 4 -> área 16
Círculo de radio 2 -> área 12.566370614359172
Usando la función mostrar:
Cuadrado -> área 16
Círculo -> área 12.566370614359172
```

## Requisitos

- [ ] El trait tiene `area` y `nombre`.
- [ ] Dos structs implementan el trait.
- [ ] Usar `Vec<Box<dyn Figuras>>` para guardar tipos distintos.
- [ ] La función `mostrar` acepta `&dyn Figuras`.
- [ ] Ejecutarlo localmente con `rustc trait_objects.rs && ./trait_objects` y verificar la salida.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `Box::new(Cuadrado { lado: 4.0 })` convierte el valor en un trait object.
- `let figuras: Vec<Box<dyn Figuras>> = vec![...];`.
- `fn mostrar(f: &dyn Figuras)` recibe cualquier tipo que implemente el trait.
- Usa `std::f64::consts::PI` para π.
- Para recorrer: `for f in &figuras { println!("{} -> {}", f.nombre(), f.area()); }`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````rust
trait Figuras {
    fn area(&self) -> f64;
    fn nombre(&self) -> &str;
}

struct Cuadrado {
    lado: f64,
}

impl Figuras for Cuadrado {
    fn area(&self) -> f64 {
        self.lado * self.lado
    }

    fn nombre(&self) -> &str {
        "Cuadrado"
    }
}

struct Circulo {
    radio: f64,
}

impl Figuras for Circulo {
    fn area(&self) -> f64 {
        std::f64::consts::PI * self.radio * self.radio
    }

    fn nombre(&self) -> &str {
        "Círculo"
    }
}

fn mostrar(figura: &dyn Figuras) {
    println!("{} -> área {}", figura.nombre(), figura.area());
}

fn main() {
    let figuras: Vec<Box<dyn Figuras>> = vec![
        Box::new(Cuadrado { lado: 4.0 }),
        Box::new(Circulo { radio: 2.0 }),
    ];

    for f in &figuras {
        println!("{} -> área {}", f.nombre(), f.area());
    }

    println!("Usando la función mostrar:");
    for f in &figuras {
        mostrar(f.as_ref());
    }
}
````

</details>