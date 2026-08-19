fn calcular_longitud(s: String) -> usize {
    s.len()
}

fn devolver(s: String) -> String {
    s
}

fn main() {
    let s1 = String::from("hola");
    let s2 = s1;
    println!("s2 = {}", s2);
    // println!("s1 = {}", s1); // ERROR: s1 fue movido

    let x = 5;
    let y = x;
    println!("x = {}, y = {}", x, y);

    let texto = String::from("hola");
    let longitud = calcular_longitud(texto);
    println!("Longitud: {}", longitud);

    let devuelto = devolver(String::from("mundo"));
    println!("Devolver: {}", devuelto);

    let original = String::from("rust");
    let copia = original.clone();
    println!("Original tras clone: {}", original);
    println!("Copia: {}", copia);
}
#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn calcular_longitud_devuelve_la_longitud() {
        assert_eq!(calcular_longitud(String::from("mundo")), 5);
        assert_eq!(calcular_longitud(String::from("")), 0);
    }

    #[test]
    fn devolver_retorna_el_mismo_string() {
        assert_eq!(devolver(String::from("mundo")), "mundo");
    }
}