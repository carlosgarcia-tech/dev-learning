fn clasificar_nota(nota: i32) -> &'static str {
    if nota >= 90 {
        "Excelente"
    } else if nota >= 70 {
        "Aprobado"
    } else {
        "Reprobado"
    }
}

fn nombre_dia(dia: i32) -> &'static str {
    match dia {
        1 => "Lunes",
        2 => "Martes",
        3 => "Miércoles",
        4 => "Jueves",
        5 => "Viernes",
        6 => "Sábado",
        7 => "Domingo",
        _ => "Inválido",
    }
}

fn suma_hasta_superar(limite: i32) -> i32 {
    let mut suma = 0;
    loop {
        suma += 7;
        if suma > limite {
            break suma;
        }
    }
}

fn main() {
    let nota = 85;
    println!("{}", clasificar_nota(nota));

    let dia = 3;
    println!("{}", nombre_dia(dia));

    let numero = 7;
    for i in 1..=10 {
        println!("{} x {} = {}", numero, i, numero * i);
    }

    let mut contador = 0;
    while contador < 5 {
        contador += 1;
    }
    println!("Contador: {}", contador);

    let total = suma_hasta_superar(50);
    println!("Suma final con loop: {}", total);
}
#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_clasificar_nota() {
        assert_eq!(clasificar_nota(95), "Excelente");
        assert_eq!(clasificar_nota(90), "Excelente");
        assert_eq!(clasificar_nota(85), "Aprobado");
        assert_eq!(clasificar_nota(70), "Aprobado");
        assert_eq!(clasificar_nota(60), "Reprobado");
    }

    #[test]
    fn test_nombre_dia() {
        assert_eq!(nombre_dia(1), "Lunes");
        assert_eq!(nombre_dia(3), "Miércoles");
        assert_eq!(nombre_dia(7), "Domingo");
        assert_eq!(nombre_dia(0), "Inválido");
        assert_eq!(nombre_dia(8), "Inválido");
    }

    #[test]
    fn test_suma_hasta_superar() {
        assert_eq!(suma_hasta_superar(50), 56);
        assert_eq!(suma_hasta_superar(0), 7);
        assert_eq!(suma_hasta_superar(100), 105);
    }
}