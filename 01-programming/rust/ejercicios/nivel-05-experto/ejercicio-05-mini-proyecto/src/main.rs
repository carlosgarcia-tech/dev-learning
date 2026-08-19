use std::io::{self, Write};

mod aritmetica {
    pub fn sumar(a: f64, b: f64) -> f64 {
        a + b
    }

    pub fn restar(a: f64, b: f64) -> f64 {
        a - b
    }

    pub fn multiplicar(a: f64, b: f64) -> f64 {
        a * b
    }

    pub fn dividir(a: f64, b: f64) -> Result<f64, String> {
        if b == 0.0 {
            Err(String::from("división entre cero"))
        } else {
            Ok(a / b)
        }
    }
}

mod menu {
    use crate::aritmetica;
    use std::io::{self, Write};

    pub fn ejecutar() {
        loop {
            println!("=== Calculadora ===");
            println!("1. Sumar");
            println!("2. Restar");
            println!("3. Multiplicar");
            println!("4. Dividir");
            println!("5. Salir");
            print!("Elige una opción: ");
            io::stdout().flush().unwrap();

            let mut opcion = String::new();
            io::stdin().read_line(&mut opcion).unwrap();

            match opcion.trim() {
                "5" => {
                    println!("¡Hasta luego!");
                    break;
                }
                "1" | "2" | "3" | "4" => {
                    let a = leer_numero("Primer número: ");
                    let b = leer_numero("Segundo número: ");
                    let resultado = match opcion.trim() {
                        "1" => Ok(aritmetica::sumar(a, b)),
                        "2" => Ok(aritmetica::restar(a, b)),
                        "3" => Ok(aritmetica::multiplicar(a, b)),
                        _ => aritmetica::dividir(a, b),
                    };
                    match resultado {
                        Ok(r) => println!("Resultado: {}", r),
                        Err(e) => println!("Error: {}", e),
                    }
                }
                _ => println!("Opción inválida"),
            }
        }
    }

    fn leer_numero(mensaje: &str) -> f64 {
        loop {
            print!("{}", mensaje);
            io::stdout().flush().unwrap();
            let mut linea = String::new();
            io::stdin().read_line(&mut linea).unwrap();
            match linea.trim().parse::<f64>() {
                Ok(n) => return n,
                Err(_) => println!("Número inválido, intenta de nuevo."),
            }
        }
    }
}

fn main() {
    menu::ejecutar();
}
#[cfg(test)]
mod tests {
    use crate::aritmetica;

    #[test]
    fn sumar() {
        assert_eq!(aritmetica::sumar(2.0, 3.0), 5.0);
    }

    #[test]
    fn restar() {
        assert_eq!(aritmetica::restar(5.0, 3.0), 2.0);
    }

    #[test]
    fn multiplicar() {
        assert_eq!(aritmetica::multiplicar(4.0, 3.0), 12.0);
    }

    #[test]
    fn dividir_devuelve_ok() {
        assert_eq!(aritmetica::dividir(10.0, 2.0), Ok(5.0));
    }

    #[test]
    fn dividir_entre_cero_devuelve_error() {
        assert!(aritmetica::dividir(10.0, 0.0).is_err());
    }
}