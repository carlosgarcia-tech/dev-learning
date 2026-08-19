fn numeros_pares(datos: &[i32]) -> Vec<i32> {
    datos.iter().filter(|&&x| x % 2 == 0).copied().collect()
}

fn numeros_cuadrados(datos: &[i32]) -> Vec<i32> {
    datos.iter().map(|&x| x * x).collect()
}

fn main() {
    let sumar = |a: i32, b: i32| a + b;
    println!("sumar: {}", sumar(2, 3));

    let incremento = 10;
    let con_incremento = |x: i32| x + incremento;
    println!("con incremento: {}", con_incremento(5));

    let mut contador = 0;
    let mut incrementar = || {
        contador += 1;
        contador
    };
    incrementar();
    incrementar();
    println!("contador: {}", contador);

    let texto = String::from("hola");
    let consumir = move || println!("FnOnce: {}", texto);
    consumir();

    let numeros = vec![1, 2, 3, 4, 5, 6];
    println!("pares: {:?}", numeros_pares(&numeros));
    println!("cuadrados: {:?}", numeros_cuadrados(&numeros));
}
#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn closure_suma_basica() {
        let sumar = |a: i32, b: i32| a + b;
        assert_eq!(sumar(2, 3), 5);
    }

    #[test]
    fn closure_captura_entorno() {
        let incremento = 10;
        let con_incremento = |x: i32| x + incremento;
        assert_eq!(con_incremento(5), 15);
    }

    #[test]
    fn closure_fnmut_incrementa_contador() {
        let mut contador = 0;
        let mut incrementar = || {
            contador += 1;
            contador
        };
        incrementar();
        incrementar();
        assert_eq!(contador, 2);
    }

    #[test]
    fn closure_fnonce_consume_captura() {
        let texto = String::from("hola");
        let consumir = move || texto;
        let resultado = consumir();
        assert_eq!(resultado, "hola");
    }

    #[test]
    fn pares_correctos() {
        assert_eq!(numeros_pares(&[1, 2, 3, 4, 5, 6]), vec![2, 4, 6]);
    }

    #[test]
    fn cuadrados_correctos() {
        assert_eq!(numeros_cuadrados(&[1, 2, 3, 4, 5]), vec![1, 4, 9, 16, 25]);
    }
}