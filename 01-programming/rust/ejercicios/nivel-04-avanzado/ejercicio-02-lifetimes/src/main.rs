fn elegir_mas_largo<'a>(a: &'a str, b: &'a str) -> &'a str {
    if a.len() >= b.len() { a } else { b }
}

fn primera_palabra<'a>(s: &'a str) -> &'a str {
    match s.find(' ') {
        Some(pos) => &s[..pos],
        None => s,
    }
}

struct Registro<'a> {
    titulo: &'a str,
}

impl<'a> Registro<'a> {
    fn longitud(&self) -> usize {
        self.titulo.len()
    }
}

fn main() {
    let s1 = String::from("rust");
    let s2 = String::from("programación");
    println!("Más largo: {}", elegir_mas_largo(&s1, &s2));

    let frase = String::from("hola mundo rust");
    println!("Primera palabra: {}", primera_palabra(&frase));

    let estatico = Registro { titulo: "Introducción" };
    println!("Título estático: {}", estatico.titulo);

    let titulo_dinamico = String::from("Capítulo 1");
    let dinamico = Registro { titulo: &titulo_dinamico };
    println!("Título dinámico: {}", dinamico.titulo);

    let reg = Registro { titulo: "Rust 2021" };
    println!("Longitud del título: {}", reg.longitud());
}
#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn elegir_mas_largo_devuelve_el_mas_largo() {
        assert_eq!(elegir_mas_largo("rust", "programación"), "programación");
        assert_eq!(elegir_mas_largo("abc", "abcd"), "abcd");
        // Empate: devuelve el primero
        assert_eq!(elegir_mas_largo("abc", "xyz"), "abc");
    }

    #[test]
    fn elegir_mas_largo_con_string() {
        let a = String::from("hola");
        let b = String::from("mundo extenso");
        assert_eq!(elegir_mas_largo(&a, &b), "mundo extenso");
    }

    #[test]
    fn primera_palabra_devuelve_hasta_el_espacio() {
        assert_eq!(primera_palabra("hola mundo"), "hola");
        assert_eq!(primera_palabra("uno dos tres"), "uno");
    }

    #[test]
    fn primera_palabra_sin_espacios_devuelve_todo() {
        assert_eq!(primera_palabra("sola"), "sola");
    }

    #[test]
    fn registro_guarda_referencias() {
        let titulo = String::from("Capítulo 3");
        let reg = Registro { titulo: &titulo };
        assert_eq!(reg.titulo, "Capítulo 3");
    }

    #[test]
    fn registro_longitud() {
        let reg = Registro { titulo: "Rust 2021" };
        assert_eq!(reg.longitud(), 9);
    }
}