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
#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn perro_habla_guau() {
        assert_eq!(Perro.hablar(), "Guau");
    }

    #[test]
    fn gato_habla_miau() {
        assert_eq!(Gato.hablar(), "Miau");
    }

    #[test]
    fn vaca_habla_muu() {
        assert_eq!(Vaca.hablar(), "Muu");
    }

    #[test]
    fn presentar_y_sonar_usan_el_trait() {
        let perro = Perro;
        let gato = Gato;
        let vaca = Vaca;
        presentar(&perro, &gato);
        sonar(&vaca);
    }

    #[test]
    fn todos_implementan_hablar() {
        fn requiere_hablar<T: Hablar>(_x: &T) {}
        requiere_hablar(&Perro);
        requiere_hablar(&Gato);
        requiere_hablar(&Vaca);
    }
}