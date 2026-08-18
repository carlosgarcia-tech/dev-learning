# Ejercicio 03 — Caché LRU

- **Nivel:** 5/5
- **Tema:** `HashMap` + orden de uso, algoritmo LRU
- **Tiempo estimado:** 45 min

## Enunciado

Crea un programa `cache.rs` que implemente una **caché LRU** (Least Recently Used) con `std::collections::HashMap` y un `Vec<String>` que guarde las claves en orden de uso:

1. `struct CacheLru { capacidad: usize, claves: Vec<String>, datos: HashMap<String, i32> }`.
2. `CacheLru::nueva(capacidad: usize)`.
3. `obtener(&mut self, clave: &str) -> Option<&i32>`: si existe, la mueve al final del orden y devuelve su valor.
4. `insertar(&mut self, clave: String, valor: i32)`: si la clave ya existe la actualiza; si el caché está lleno, elimina la clave menos usada recientemente (la primera del `Vec`).
5. `mostrar(&self)` que imprima el contenido.

Prueba: inserta 3 claves (`a`, `b`, `c`) con capacidad 3, accede a `a`, inserta `d` (debe desalojar `b`), y comprueba que `b` ya no existe.

## Requisitos

- [ ] `obtener` reordena la clave accedida al final del `Vec`.
- [ ] `insertar` desaloja la clave menos reciente cuando se supera la capacidad.
- [ ] Insertar una clave existente no duplica su entrada en el orden.
- [ ] `mostrar` imprime el estado del caché.
- [ ] Ejecutarlo localmente con `cargo run` (o `rustc cache.rs && ./cache`) y verificar que `b` se desaloja tras insertar `d`.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Para "mover al final": `let pos = self.claves.iter().position(|c| c == clave).unwrap(); self.claves.remove(pos); self.claves.push(clave.to_string());`.
- Desalojo: si `len >= capacidad`, `let vieja = self.claves.remove(0); self.datos.remove(&vieja);`.
- `position`, `remove` y `push` operan sobre el `Vec`.
- `datos.get(clave)` devuelve `Option<&i32>`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````rust
use std::collections::HashMap;

struct CacheLru {
    capacidad: usize,
    claves: Vec<String>,
    datos: HashMap<String, i32>,
}

impl CacheLru {
    fn nueva(capacidad: usize) -> CacheLru {
        CacheLru {
            capacidad,
            claves: Vec::new(),
            datos: HashMap::new(),
        }
    }

    fn obtener(&mut self, clave: &str) -> Option<&i32> {
        if let Some(pos) = self.claves.iter().position(|c| c == clave) {
            self.claves.remove(pos);
            self.claves.push(clave.to_string());
            self.datos.get(clave)
        } else {
            None
        }
    }

    fn insertar(&mut self, clave: String, valor: i32) {
        if let Some(pos) = self.claves.iter().position(|c| *c == clave) {
            self.claves.remove(pos);
        } else if self.claves.len() >= self.capacidad {
            let vieja = self.claves.remove(0);
            self.datos.remove(&vieja);
        }
        self.claves.push(clave.clone());
        self.datos.insert(clave, valor);
    }

    fn mostrar(&self) {
        for c in &self.claves {
            println!("  {} -> {:?}", c, self.datos.get(c));
        }
    }
}

fn main() {
    let mut cache = CacheLru::nueva(3);

    cache.insertar(String::from("a"), 1);
    cache.insertar(String::from("b"), 2);
    cache.insertar(String::from("c"), 3);

    println!("Acceso a 'a': {:?}", cache.obtener("a"));

    cache.insertar(String::from("d"), 4);

    println!("Después de insertar 'd':");
    cache.mostrar();

    println!(
        "¿Existe 'b'? {}",
        cache.obtener("b").is_some()
    );
}
````

</details>