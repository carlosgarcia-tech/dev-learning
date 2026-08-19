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
#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn area_del_cuadrado() {
        let c = Cuadrado { lado: 4.0 };
        assert_eq!(c.area(), 16.0);
    }

    #[test]
    fn area_del_circulo() {
        let c = Circulo { radio: 2.0 };
        assert_eq!(c.area(), std::f64::consts::PI * 4.0);
    }

    #[test]
    fn nombres_por_defecto() {
        assert_eq!(Cuadrado { lado: 1.0 }.nombre(), "Cuadrado");
        assert_eq!(Circulo { radio: 1.0 }.nombre(), "Círculo");
    }

    #[test]
    fn objeto_dinamico_con_box() {
        let figuras: Vec<Box<dyn Figuras>> = vec![
            Box::new(Cuadrado { lado: 2.0 }),
            Box::new(Circulo { radio: 1.0 }),
        ];
        assert_eq!(figuras[0].area(), 4.0);
        assert_eq!(figuras[1].area(), std::f64::consts::PI);
        assert_eq!(figuras[1].nombre(), "Círculo");
    }

    #[test]
    fn mostrar_funciona_con_referencia_dinamica() {
        let cuadrado = Cuadrado { lado: 3.0 };
        mostrar(&cuadrado);
        let circulo = Circulo { radio: 1.0 };
        mostrar(&circulo);
    }
}