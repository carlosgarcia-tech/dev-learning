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
#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn insertar_y_obtener_devuelve_valor() {
        let mut cache = CacheLru::nueva(2);
        cache.insertar(String::from("a"), 1);
        assert_eq!(cache.obtener("a"), Some(&1));
    }

    #[test]
    fn obtener_inexistente_devuelve_none() {
        let mut cache = CacheLru::nueva(2);
        cache.insertar(String::from("a"), 1);
        assert_eq!(cache.obtener("b"), None);
    }

    #[test]
    fn insertar_existente_actualiza_sin_duplicar() {
        let mut cache = CacheLru::nueva(2);
        cache.insertar(String::from("a"), 1);
        cache.insertar(String::from("a"), 99);
        assert_eq!(cache.obtener("a"), Some(&99));
        assert_eq!(cache.claves.len(), 1);
    }

    #[test]
    fn desaloja_la_menos_reciente() {
        let mut cache = CacheLru::nueva(3);
        cache.insertar(String::from("a"), 1);
        cache.insertar(String::from("b"), 2);
        cache.insertar(String::from("c"), 3);

        // Se accede a "a", que pasa a ser la más reciente.
        cache.obtener("a");

        // Al insertar "d" se desaloja "b" (la menos reciente).
        cache.insertar(String::from("d"), 4);

        assert_eq!(cache.obtener("b"), None);
        assert_eq!(cache.obtener("a"), Some(&1));
        assert_eq!(cache.obtener("c"), Some(&3));
        assert_eq!(cache.obtener("d"), Some(&4));
        assert_eq!(cache.claves.len(), 3);
    }
}