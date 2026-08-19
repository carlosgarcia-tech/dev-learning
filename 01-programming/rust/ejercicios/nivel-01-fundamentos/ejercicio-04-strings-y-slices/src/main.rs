fn construir_saludo() -> String {
    let mut saludo = String::from("Hola");
    saludo.push_str(", mundo");
    saludo.push('!');
    saludo
}

fn primeros_5_bytes(palabra: &str) -> &str {
    &palabra[0..5]
}

fn exclamar(base: &str) -> String {
    format!("¡{}!", base)
}

fn main() {
    let saludo = construir_saludo();
    println!("{}", saludo);

    let palabra = "programación";
    let primeros = primeros_5_bytes(palabra);
    println!("{}: primeros 5 bytes = {}", palabra, primeros);
    println!("longitud en bytes = {}", palabra.len());
    println!("caracteres = {}", palabra.chars().count());

    let base = String::from("hola mundo");
    let exclamacion = exclamar(&base);
    println!("hola mundo => {}", exclamacion);

    let cadena = "texto".to_string();
    println!("{}", cadena);
}
#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_construir_saludo() {
        assert_eq!(construir_saludo(), "Hola, mundo!");
    }

    #[test]
    fn test_primeros_5_bytes() {
        assert_eq!(primeros_5_bytes("programación"), "progr");
    }

    #[test]
    fn test_exclamar() {
        assert_eq!(exclamar("hola mundo"), "¡hola mundo!");
    }

    #[test]
    fn test_len_vs_chars() {
        let palabra = "programación";
        assert_eq!(palabra.len(), 13);
        assert_eq!(palabra.chars().count(), 12);
    }
}