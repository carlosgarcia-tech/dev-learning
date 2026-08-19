enum Mensaje {
    Salir,
    Mover { x: i32, y: i32 },
    Escribir(String),
    CambiarColor(u8, u8, u8),
}

fn describir(m: &Mensaje) -> String {
    match m {
        Mensaje::Salir => String::from("Adiós"),
        Mensaje::Mover { x, y } => format!("Moviendo a ({}, {})", x, y),
        Mensaje::Escribir(texto) => format!("Escribiendo: {}", texto),
        Mensaje::CambiarColor(r, g, b) => format!("Color RGB: {}, {}, {}", r, g, b),
    }
}

fn clasificar(pos: (i32, i32)) -> String {
    match pos {
        (0, 0) => String::from("Origen"),
        (0, y) => format!("Eje X, y = {}", y),
        (x, 0) => format!("Eje Y, x = {}", x),
        (x, y) => format!("Posición ({}, {})", x, y),
    }
}

fn procesar(m: Mensaje) {
    println!("{}", describir(&m));
}

fn main() {
    procesar(Mensaje::Salir);
    procesar(Mensaje::Mover { x: 3, y: -2 });
    procesar(Mensaje::Escribir(String::from("hola")));
    procesar(Mensaje::CambiarColor(255, 0, 0));

    let posiciones = [(0, 0), (0, 5), (7, 0), (2, 3)];
    for pos in posiciones {
        println!("{}", clasificar(pos));
    }
}
#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn describir_salir_devuelve_adios() {
        assert_eq!(describir(&Mensaje::Salir), "Adiós");
    }

    #[test]
    fn describir_mover_formatea_coordenadas() {
        assert_eq!(
            describir(&Mensaje::Mover { x: 3, y: -2 }),
            "Moviendo a (3, -2)"
        );
    }

    #[test]
    fn describir_escribir_formatea_el_texto() {
        assert_eq!(
            describir(&Mensaje::Escribir(String::from("hola"))),
            "Escribiendo: hola"
        );
    }

    #[test]
    fn describir_cambiar_color_formatea_rgb() {
        assert_eq!(
            describir(&Mensaje::CambiarColor(255, 0, 0)),
            "Color RGB: 255, 0, 0"
        );
    }

    #[test]
    fn clasificar_origen() {
        assert_eq!(clasificar((0, 0)), "Origen");
    }

    #[test]
    fn clasificar_eje_x() {
        assert_eq!(clasificar((0, 5)), "Eje X, y = 5");
    }

    #[test]
    fn clasificar_eje_y() {
        assert_eq!(clasificar((7, 0)), "Eje Y, x = 7");
    }

    #[test]
    fn clasificar_posicion() {
        assert_eq!(clasificar((2, 3)), "Posición (2, 3)");
    }
}