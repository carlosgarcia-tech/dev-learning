// TODO: implementa las funciones y comprueba que los tests pasan.
// Este ejercicio se centra en testing: tras implementar cada función,
// ejecuta `cargo test` y verifica que todos los tests pasan.

pub fn suma(a: i32, b: i32) -> i32 {
    todo!("implementar: devolver a + b")
}

pub fn es_par(n: i32) -> bool {
    todo!("implementar: comprobar si n es par")
}

pub fn factorial(n: u64) -> u64 {
    todo!("implementar: factorial recursivo (0! = 1, 1! = 1)")
}

fn main() {
    println!("2 + 3 = {}", suma(2, 3));
    println!("4 es par? {}", es_par(4));
    println!("5! = {}", factorial(5));
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_suma() {
        assert_eq!(suma(2, 3), 5);
        assert_eq!(suma(-1, 1), 0);
    }

    #[test]
    fn test_es_par() {
        assert!(es_par(4));
        assert!(!es_par(7));
    }

    #[test]
    fn test_factorial() {
        assert_eq!(factorial(0), 1);
        assert_eq!(factorial(5), 120);
    }

    #[test]
    #[should_panic]
    fn test_panico_fuera_de_rango() {
        let v = vec![1, 2, 3];
        let _ = v[10];
    }
}