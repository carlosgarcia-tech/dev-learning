fn construir_vector() -> Vec<i32> {
    vec![10, 20, 30, 40]
}

fn sumar(numeros: &[i32]) -> i32 {
    numeros.iter().sum()
}

fn maximo(numeros: &[i32]) -> Option<i32> {
    numeros.iter().max().copied()
}

fn main() {
    let mut numeros = construir_vector();

    numeros[1] = 20; // ya vale 20, modificación explícita

    println!("Tamaño: {}", numeros.len());

    match numeros.get(1) {
        Some(n) => println!("Segundo: {}", n),
        None => println!("Segundo: no existe"),
    }

    match numeros.first() {
        Some(n) => println!("Primero: {}", n),
        None => println!("Primero: no existe"),
    }

    println!("Suma: {}", sumar(&numeros));

    match maximo(&numeros) {
        Some(n) => println!("Máximo: {}", n),
        None => println!("Máximo: no existe"),
    }

    println!("Vec: {:?}", numeros);

    for n in &numeros {
        print!("{} ", n);
    }
    println!();
}
#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn construir_vector_tiene_los_cuatro_elementos() {
        assert_eq!(construir_vector(), vec![10, 20, 30, 40]);
    }

    #[test]
    fn sumar_acumula_todos_los_elementos() {
        assert_eq!(sumar(&[10, 20, 30, 40]), 100);
        assert_eq!(sumar(&[]), 0);
    }

    #[test]
    fn maximo_devuelve_el_mayor() {
        assert_eq!(maximo(&[10, 20, 30, 40]), Some(40));
    }

    #[test]
    fn maximo_de_vector_vacio_es_none() {
        assert_eq!(maximo(&[]), None);
    }
}