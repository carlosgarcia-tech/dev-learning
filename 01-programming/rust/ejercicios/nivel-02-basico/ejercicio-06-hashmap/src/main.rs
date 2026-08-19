use std::collections::HashMap;

fn construir_edades() -> HashMap<String, u8> {
    let mut edades = HashMap::new();
    edades.insert(String::from("Ana"), 30);
    edades.insert(String::from("Luis"), 25);
    edades.insert(String::from("Carmen"), 28);
    edades
}

fn consultar_edad(mapa: &HashMap<String, u8>, nombre: &str) -> Option<u8> {
    mapa.get(nombre).copied()
}

fn existe(mapa: &HashMap<String, u8>, nombre: &str) -> bool {
    mapa.contains_key(nombre)
}

fn main() {
    let mut edades = construir_edades();

    match consultar_edad(&edades, "Ana") {
        Some(edad) => println!("Ana tiene {} años", edad),
        None => println!("Ana no existe"),
    }

    edades.insert(String::from("Luis"), 26);
    println!("Luis tiene {} años", edades.get("Luis").unwrap());

    edades.entry(String::from("Pepe")).or_insert(0);
    edades.entry(String::from("Pepe")).and_modify(|e| *e += 1);
    println!("Pepe tiene {} años", edades.get("Pepe").unwrap());

    println!("¿Existe Pepe? {}", existe(&edades, "Pepe"));
    println!("Mapa: {:?}", edades);

    println!("Recorrido:");
    for (nombre, edad) in &edades {
        println!("{}: {}", nombre, edad);
    }
}
#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn construir_edades_tiene_tres_personas() {
        let edades = construir_edades();
        assert_eq!(edades.len(), 3);
        assert_eq!(edades.get("Ana"), Some(&30));
    }

    #[test]
    fn consultar_edad_devuelve_la_edad() {
        let edades = construir_edades();
        assert_eq!(consultar_edad(&edades, "Ana"), Some(30));
        assert_eq!(consultar_edad(&edades, "Carmen"), Some(28));
    }

    #[test]
    fn consultar_edad_de_persona_inexistente_es_none() {
        let edades = construir_edades();
        assert_eq!(consultar_edad(&edades, "Pepe"), None);
    }

    #[test]
    fn existe_detecta_claves_presentes_y_ausentes() {
        let edades = construir_edades();
        assert!(existe(&edades, "Carmen"));
        assert!(!existe(&edades, "Pepe"));
    }
}