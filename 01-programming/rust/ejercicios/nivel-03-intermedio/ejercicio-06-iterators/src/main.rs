fn numeros_pares(datos: &[i32]) -> Vec<i32> {
    datos.iter().filter(|&&n| n % 2 == 0).copied().collect()
}

fn numeros_cuadrados(datos: &[i32]) -> Vec<i32> {
    datos.iter().map(|&n| n * n).collect()
}

fn suma_y_producto(datos: &[i32]) -> (i32, i32) {
    let suma: i32 = datos.iter().sum();
    let producto: i32 = datos.iter().fold(1, |acc, &n| acc * n);
    (suma, producto)
}

fn mayor_y_menor(datos: &[i32]) -> (i32, i32) {
    let maximo = datos.iter().max().copied().unwrap_or(0);
    let minimo = datos.iter().min().copied().unwrap_or(0);
    (maximo, minimo)
}

fn generar_planos(n: i32) -> Vec<i32> {
    (1..=n).flat_map(|x| [x, x * 10]).collect()
}

fn contar_mayores(datos: &[i32], umbral: i32) -> usize {
    datos.iter().filter(|&&n| n > umbral).count()
}

fn main() {
    let datos = vec![1, 2, 3, 4, 5, 6];

    println!("Pares: {:?}", numeros_pares(&datos));
    println!("Cuadrados: {:?}", numeros_cuadrados(&datos));

    let (suma, producto) = suma_y_producto(&datos);
    println!("Suma: {}", suma);
    println!("Producto (fold): {}", producto);

    let (maximo, minimo) = mayor_y_menor(&datos);
    println!("Máximo: {}, Mínimo: {}", maximo, minimo);

    println!("Flat map: {:?}", generar_planos(3));
    println!("Mayores que 3: {}", contar_mayores(&datos, 3));
}
#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn pares_correctos() {
        assert_eq!(numeros_pares(&[1, 2, 3, 4, 5, 6]), vec![2, 4, 6]);
    }

    #[test]
    fn cuadrados_correctos() {
        assert_eq!(numeros_cuadrados(&[1, 2, 3, 4, 5, 6]), vec![1, 4, 9, 16, 25, 36]);
    }

    #[test]
    fn suma_y_producto_correctos() {
        let datos = vec![1, 2, 3, 4, 5, 6];
        assert_eq!(suma_y_producto(&datos), (21, 720));
    }

    #[test]
    fn mayor_y_menor_correctos() {
        let datos = vec![1, 2, 3, 4, 5, 6];
        assert_eq!(mayor_y_menor(&datos), (6, 1));
    }

    #[test]
    fn mayor_y_menor_con_lista_vacia() {
        let datos: Vec<i32> = vec![];
        assert_eq!(mayor_y_menor(&datos), (0, 0));
    }

    #[test]
    fn flat_map_correcto() {
        assert_eq!(generar_planos(3), vec![1, 10, 2, 20, 3, 30]);
    }

    #[test]
    fn contar_mayores_correcto() {
        assert_eq!(contar_mayores(&[1, 2, 3, 4, 5, 6], 3), 3);
    }
}