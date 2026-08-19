struct Circulo {
    radio: f64,
}

impl Circulo {
    const PI: f64 = 3.14159;

    fn nuevo(radio: f64) -> Circulo {
        Circulo { radio }
    }

    fn area(&self) -> f64 {
        Circulo::PI * self.radio.powi(2)
    }

    fn circunferencia(&self) -> f64 {
        2.0 * Circulo::PI * self.radio
    }

    fn es_grande(&self) -> bool {
        self.radio > 10.0
    }
}

impl Circulo {
    fn descripcion(&self) -> String {
        format!("Círculo de radio {}", self.radio)
    }
}

fn main() {
    let c = Circulo::nuevo(5.0);
    println!("Área: {}", c.area());
    println!("Circunferencia: {}", c.circunferencia());
    println!("¿Es grande? {}", c.es_grande());
    println!("Descripción: {}", c.descripcion());
    println!("PI asociado: {}", Circulo::PI);
}
#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn pi_asociada() {
        assert_eq!(Circulo::PI, 3.14159);
    }

    #[test]
    fn area_correcta() {
        let c = Circulo::nuevo(5.0);
        assert!((c.area() - 78.53975).abs() < 1e-10);
    }

    #[test]
    fn circunferencia_correcta() {
        let c = Circulo::nuevo(5.0);
        assert!((c.circunferencia() - 31.4159).abs() < 1e-10);
    }

    #[test]
    fn circulo_pequeno_no_es_grande() {
        let c = Circulo::nuevo(5.0);
        assert!(!c.es_grande());
    }

    #[test]
    fn circulo_grande() {
        let c = Circulo::nuevo(20.0);
        assert!(c.es_grande());
    }

    #[test]
    fn descripcion_ok() {
        let c = Circulo::nuevo(5.0);
        assert_eq!(c.descripcion(), "Círculo de radio 5");
    }
}