fn dividir(a: f64, b: f64) -> Result<f64, String> {
    if b == 0.0 {
        Err(String::from("no se puede dividir entre cero"))
    } else {
        Ok(a / b)
    }
}

fn buscar(indice: usize, v: &[i32]) -> Option<i32> {
    v.get(indice).copied()
}

fn raiz(n: f64) -> Option<f64> {
    if n >= 0.0 {
        Some(n.sqrt())
    } else {
        None
    }
}

fn main() {
    match dividir(10.0, 2.0) {
        Ok(r) => println!("Resultado: {}", r),
        Err(e) => println!("Error: {}", e),
    }

    if let Err(e) = dividir(10.0, 0.0) {
        println!("Error capturado: {}", e);
    }

    let nums = [10, 20, 30];
    match buscar(1, &nums) {
        Some(n) => println!("Índice 1: {}", n),
        None => println!("Índice 1: None"),
    }
    match buscar(10, &nums) {
        Some(n) => println!("Índice 10: {}", n),
        None => println!("Índice 10: None"),
    }

    match raiz(9.0) {
        Some(r) => println!("Raíz de 9: {}", r),
        None => println!("Raíz de 9: None"),
    }
    match raiz(-4.0) {
        Some(r) => println!("Raíz de -4: {}", r),
        None => println!("Raíz de -4: None"),
    }

    let por_defecto = dividir(10.0, 0.0).unwrap_or(0.0);
    println!("Valor por defecto: {}", por_defecto);

    let segura = raiz(16.0).expect("16 es no negativo");
    println!("Raíz de 16 (expect): {}", segura);
}
#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn dividir_ok_devuelve_cociente() {
        assert_eq!(dividir(10.0, 2.0), Ok(5.0));
    }

    #[test]
    fn dividir_entre_cero_devuelve_error() {
        assert_eq!(
            dividir(10.0, 0.0),
            Err("no se puede dividir entre cero".to_string())
        );
    }

    #[test]
    fn buscar_devuelve_el_elemento_del_indice() {
        assert_eq!(buscar(1, &[10, 20, 30]), Some(20));
    }

    #[test]
    fn buscar_fuera_de_rango_devuelve_none() {
        assert_eq!(buscar(10, &[10, 20, 30]), None);
    }

    #[test]
    fn raiz_de_numero_positivo() {
        assert_eq!(raiz(9.0), Some(3.0));
    }

    #[test]
    fn raiz_de_numero_negativo_devuelve_none() {
        assert_eq!(raiz(-4.0), None);
    }
}