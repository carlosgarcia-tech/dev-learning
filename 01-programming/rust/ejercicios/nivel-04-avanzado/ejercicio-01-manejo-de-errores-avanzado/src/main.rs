use std::fmt;

#[derive(Debug)]
enum MiError {
    Negativo,
    DemasiadoGrande,
}

impl fmt::Display for MiError {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        match self {
            MiError::Negativo => write!(f, "el número es negativo"),
            MiError::DemasiadoGrande => write!(f, "el número es demasiado grande"),
        }
    }
}

impl std::error::Error for MiError {}

fn raiz(n: f64) -> Result<f64, MiError> {
    if n < 0.0 {
        return Err(MiError::Negativo);
    }
    if n > 100.0 {
        return Err(MiError::DemasiadoGrande);
    }
    Ok(n.sqrt())
}

fn calcular(n: f64) -> Result<f64, MiError> {
    let r = raiz(n)?;
    Ok(r + 1.0)
}

fn main() {
    match calcular(81.0) {
        Ok(v) => println!("calcular(81) = Ok({})", v),
        Err(e) => println!("calcular(81) = Err: {}", e),
    }

    match calcular(-4.0) {
        Ok(v) => println!("calcular(-4) = Ok({})", v),
        Err(e) => println!("calcular(-4) = Err: {}", e),
    }

    match calcular(400.0) {
        Ok(v) => println!("calcular(400) = Ok({})", v),
        Err(e) => println!("calcular(400) = Err: {}", e),
    }
}
#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn raiz_valida_devuelve_sqrt() {
        assert_eq!(raiz(81.0).unwrap(), 9.0);
        assert_eq!(raiz(0.0).unwrap(), 0.0);
    }

    #[test]
    fn raiz_negativa_devuelve_error() {
        assert!(matches!(raiz(-4.0), Err(MiError::Negativo)));
    }

    #[test]
    fn raiz_demasiado_grande_devuelve_error() {
        assert!(matches!(raiz(400.0), Err(MiError::DemasiadoGrande)));
    }

    #[test]
    fn calcular_suma_uno() {
        assert_eq!(calcular(81.0).unwrap(), 10.0);
        assert_eq!(calcular(100.0).unwrap(), 11.0);
    }

    #[test]
    fn calcular_propaga_errores() {
        assert!(matches!(calcular(-1.0), Err(MiError::Negativo)));
        assert!(matches!(calcular(101.0), Err(MiError::DemasiadoGrande)));
    }

    #[test]
    fn display_muestra_mensajes_en_espanol() {
        assert_eq!(format!("{}", MiError::Negativo), "el número es negativo");
        assert_eq!(
            format!("{}", MiError::DemasiadoGrande),
            "el número es demasiado grande"
        );
    }
}