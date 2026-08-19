fn longitud(s: &String) -> usize {
    s.len()
}

fn agregar_exclamacion(s: &mut String) {
    s.push('!');
}

fn primer_elemento(v: &[i32]) -> Option<&i32> {
    v.first()
}

fn main() {
    let mut saludo = String::from("Hola");
    println!("Longitud: {}", longitud(&saludo));

    // Las referencias inmutables terminan antes de pedir la mutable
    agregar_exclamacion(&mut saludo);
    println!("{}", saludo);

    let numeros = [10, 20, 30];
    let r1 = &numeros;
    let r2 = &numeros;
    println!("Primera referencia: {}", r1[0]);
    println!("Segunda referencia: {}", r2[0]);
    // let r3 = &mut numeros; // ERROR: numeros no es mutable y ya hay préstamos

    match primer_elemento(&numeros) {
        Some(n) => println!("Primer elemento: {}", n),
        None => println!("Sin elementos"),
    }
}
#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn longitud_no_consume_el_string() {
        let saludo = String::from("Hola");
        assert_eq!(longitud(&saludo), 4);
        assert_eq!(longitud(&String::from("")), 0);
    }

    #[test]
    fn agregar_exclamacion_modifica_el_original() {
        let mut saludo = String::from("Hola");
        agregar_exclamacion(&mut saludo);
        assert_eq!(saludo, "Hola!");
    }

    #[test]
    fn primer_elemento_devuelve_el_primero() {
        let v = [10, 20, 30];
        assert_eq!(primer_elemento(&v), Some(&10));
    }

    #[test]
    fn primer_elemento_vacio_es_none() {
        let v: [i32; 0] = [];
        assert_eq!(primer_elemento(&v), None);
    }
}