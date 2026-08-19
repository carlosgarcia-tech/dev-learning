enum Color {
    Rgb(u8, u8, u8),
    Hex(String),
}

fn describir(c: Color) -> String {
    match c {
        Color::Rgb(r, g, b) if r > 200 => format!("Rojo intenso ({}, {}, {})", r, g, b),
        Color::Rgb(r, g, b) => format!("Rgb ({}, {}, {})", r, g, b),
        Color::Hex(h) => format!("Hex #{}", h),
    }
}

fn clasificar_numero(n: i32) -> &'static str {
    match n {
        1..=5 => "está en 1..=5",
        6..=10 => "está en 6..=10",
        _ => "fuera de rango",
    }
}

fn main() {
    println!("{}", describir(Color::Rgb(255, 0, 0)));
    println!("{}", describir(Color::Rgb(10, 10, 10)));
    println!("{}", describir(Color::Hex(String::from("ff0000"))));

    for n in [4, 8] {
        println!("Número {} {}", n, clasificar_numero(n));
    }

    let opcion: Option<i32> = Some(42);
    if let Some(valor) = opcion {
        println!("if let: {}", valor);
    }

    let mut pila = vec![1, 2, 3];
    print!("while let: ");
    while let Some(x) = pila.pop() {
        print!("{}, ", x);
    }
    println!();

    let persona = ("Ana", 30, 1.65);
    let (nombre, edad, altura) = persona;
    println!("Tupla: {}, {}, {}", nombre, edad, altura);
}
#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn describir_rojo_intenso() {
        assert_eq!(describir(Color::Rgb(255, 0, 0)), "Rojo intenso (255, 0, 0)");
    }

    #[test]
    fn describir_rgb_normal() {
        assert_eq!(describir(Color::Rgb(10, 10, 10)), "Rgb (10, 10, 10)");
    }

    #[test]
    fn describir_hex() {
        assert_eq!(describir(Color::Hex(String::from("ff0000"))), "Hex #ff0000");
    }

    #[test]
    fn clasificar_rangos() {
        assert_eq!(clasificar_numero(4), "está en 1..=5");
        assert_eq!(clasificar_numero(8), "está en 6..=10");
        assert_eq!(clasificar_numero(20), "fuera de rango");
    }

    #[test]
    fn if_let_extrae_option() {
        let opcion: Option<i32> = Some(42);
        let mut extraido = 0;
        if let Some(valor) = opcion {
            extraido = valor;
        }
        assert_eq!(extraido, 42);
    }

    #[test]
    fn while_let_agota_la_pila() {
        let mut pila = vec![1, 2, 3];
        let mut suma = 0;
        while let Some(x) = pila.pop() {
            suma += x;
        }
        assert_eq!(suma, 6);
        assert!(pila.is_empty());
    }

    #[test]
    fn destructurar_tupla() {
        let persona = ("Ana", 30, 1.65);
        let (nombre, edad, altura) = persona;
        assert_eq!(nombre, "Ana");
        assert_eq!(edad, 30);
        assert_eq!(altura, 1.65);
    }
}