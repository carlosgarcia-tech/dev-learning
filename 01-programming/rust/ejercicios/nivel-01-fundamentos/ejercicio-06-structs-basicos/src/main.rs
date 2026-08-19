struct Persona {
    nombre: String,
    edad: u8,
    activo: bool,
}

impl Persona {
    fn nueva(nombre: &str, edad: u8) -> Persona {
        Persona {
            nombre: nombre.to_string(),
            edad,
            activo: true,
        }
    }

    fn saludar(&self) {
        println!("Hola, soy {} y tengo {} años.", self.nombre, self.edad);
    }

    fn cumplir_anios(&mut self) {
        self.edad += 1;
    }
}

fn main() {
    let mut persona = Persona::nueva("Ana", 30);
    persona.saludar();
    println!("Activo: {}", persona.activo);
    persona.cumplir_anios();
    println!("¡Feliz cumpleaños! Ana ahora tiene {} años.", persona.edad);
}
#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_constructor_activa_persona() {
        let persona = Persona::nueva("Ana", 30);
        assert_eq!(persona.nombre, "Ana");
        assert_eq!(persona.edad, 30);
        assert!(persona.activo);
    }

    #[test]
    fn test_constructor_convierte_a_string() {
        let persona = Persona::nueva("Luis", 25);
        assert_eq!(persona.nombre, String::from("Luis"));
    }

    #[test]
    fn test_cumplir_anios() {
        let mut persona = Persona::nueva("Ana", 30);
        persona.cumplir_anios();
        assert_eq!(persona.edad, 31);
        persona.cumplir_anios();
        assert_eq!(persona.edad, 32);
    }
}