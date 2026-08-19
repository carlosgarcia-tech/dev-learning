fn suma_for(numeros: &[i32; 5]) -> i32 {
    let mut suma = 0;
    for n in numeros {
        suma += n;
    }
    suma
}

fn suma_iter(numeros: &[i32; 5]) -> i32 {
    numeros.iter().sum()
}

fn descripcion_persona(persona: (&str, i32, f64)) -> String {
    format!(
        "{} tiene {} años y mide {}",
        persona.0, persona.1, persona.2
    )
}

fn main() {
    let numeros: [i32; 5] = [10, 20, 30, 40, 50];
    println!("Primero: {}, último: {}", numeros[0], numeros[4]);

    println!("Suma con for: {}", suma_for(&numeros));
    println!("Suma con iter: {}", suma_iter(&numeros));

    let persona = ("Ana", 30, 1.65);
    println!("{}", descripcion_persona(persona));

    let (nombre, edad, altura) = persona;
    println!("Destructuring: {}, {}, {}", nombre, edad, altura);
}
#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_suma_for() {
        let numeros = [10, 20, 30, 40, 50];
        assert_eq!(suma_for(&numeros), 150);
    }

    #[test]
    fn test_suma_iter() {
        let numeros = [10, 20, 30, 40, 50];
        assert_eq!(suma_iter(&numeros), 150);
    }

    #[test]
    fn test_descripcion_persona() {
        let persona = ("Ana", 30, 1.65);
        assert_eq!(descripcion_persona(persona), "Ana tiene 30 años y mide 1.65");
    }
}