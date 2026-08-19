fn mayor<T: PartialOrd>(a: T, b: T) -> T {
    if a > b { a } else { b }
}

fn repetir<T: Clone>(valor: T, veces: usize) -> Vec<T> {
    vec![valor; veces]
}

struct Caja<T> {
    contenido: T,
}

impl<T> Caja<T> {
    fn nuevo(contenido: T) -> Caja<T> {
        Caja { contenido }
    }

    fn obtener(&self) -> &T {
        &self.contenido
    }

    fn cambiar(&mut self, nuevo: T) {
        self.contenido = nuevo;
    }
}

fn main() {
    println!("Mayor: {}", mayor(3, 7));
    println!("Mayor: {}", mayor(2.1, 3.5));
    println!("Mayor: {}", mayor("a", "b"));

    println!("Repetido: {:?}", repetir(7, 4));

    let caja_numero = Caja::nuevo(42);
    println!("Caja de {}", caja_numero.obtener());

    let mut caja_texto = Caja::nuevo(String::from("hola"));
    println!("Caja de {}", caja_texto.obtener());

    caja_texto.cambiar(String::from("mundo"));
    println!("Caja cambiada: {}", caja_texto.obtener());
}
#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn mayor_con_enteros() {
        assert_eq!(mayor(3, 7), 7);
    }

    #[test]
    fn mayor_con_flotantes() {
        assert_eq!(mayor(2.1, 3.5), 3.5);
    }

    #[test]
    fn mayor_con_cadenas() {
        assert_eq!(mayor("a", "b"), "b");
    }

    #[test]
    fn repetir_crea_vector() {
        assert_eq!(repetir(7, 4), vec![7, 7, 7, 7]);
    }

    #[test]
    fn caja_nuevo_y_obtener() {
        let caja = Caja::nuevo(42);
        assert_eq!(*caja.obtener(), 42);
    }

    #[test]
    fn caja_cambiar() {
        let mut caja = Caja::nuevo(String::from("hola"));
        caja.cambiar(String::from("mundo"));
        assert_eq!(caja.obtener(), "mundo");
    }
}