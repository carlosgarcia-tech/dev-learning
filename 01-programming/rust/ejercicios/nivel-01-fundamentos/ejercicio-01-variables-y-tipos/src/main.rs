fn tipo<T>(_: &T) -> &'static str {
    std::any::type_name::<T>()
}

fn main() {
    const CIUDAD: &str = "Lima";
    let nombre: &str = "Ana";
    let mut edad: u32 = 30;
    let programacion: bool = true;

    println!("nombre es de tipo {}", tipo(&nombre));
    println!("ciudad es de tipo {}", tipo(&CIUDAD));
    println!("edad es de tipo {}", tipo(&edad));
    println!("programacion es de tipo {}", tipo(&programacion));

    println!(
        "Soy {}, tengo {} años, nací en {} y es {} que estudio programación.",
        nombre, edad, CIUDAD, programacion
    );
}
#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_tipo_entero() {
        let x: i32 = 42;
        assert_eq!(tipo(&x), "i32");
    }

    #[test]
    fn test_tipo_str() {
        let s: &str = "hola";
        assert_eq!(tipo(&s), "&str");
    }

    #[test]
    fn test_tipo_u32() {
        let n: u32 = 30;
        assert_eq!(tipo(&n), "u32");
    }

    #[test]
    fn test_tipo_bool() {
        let b: bool = true;
        assert_eq!(tipo(&b), "bool");
    }
}