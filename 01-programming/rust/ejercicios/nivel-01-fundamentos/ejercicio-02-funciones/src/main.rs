fn sumar(a: i32, b: i32) -> i32 {
    a + b
}

fn es_par(n: i32) -> bool {
    n % 2 == 0
}

fn area_rectangulo(base: f64, alto: f64) -> f64 {
    base * alto
}

fn describe(n: i32) -> String {
    if es_par(n) {
        String::from("par")
    } else {
        String::from("impar")
    }
}

fn main() {
    println!("2 + 3 = {}", sumar(2, 3));
    println!("7 es par? {}", es_par(7));
    println!("El área del rectángulo es {}", area_rectangulo(5.0, 3.0));
    println!("El 7 es {}", describe(7));
}
#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_sumar() {
        assert_eq!(sumar(2, 3), 5);
        assert_eq!(sumar(-1, 1), 0);
    }

    #[test]
    fn test_es_par() {
        assert!(es_par(4));
        assert!(!es_par(7));
    }

    #[test]
    fn test_area_rectangulo() {
        assert_eq!(area_rectangulo(5.0, 3.0), 15.0);
        assert_eq!(area_rectangulo(2.5, 4.0), 10.0);
    }

    #[test]
    fn test_describe() {
        assert_eq!(describe(4), "par");
        assert_eq!(describe(7), "impar");
    }
}