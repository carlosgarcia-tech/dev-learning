use std::sync::mpsc;
use std::thread;
use std::time::Duration;

fn producir(cantidad: usize) -> Vec<String> {
    let (tx, rx) = mpsc::channel();

    let tx2 = tx.clone();
    let tx3 = tx.clone();

    thread::spawn(move || {
        for i in 1..=cantidad {
            tx.send(format!("productor 1: {}", i)).unwrap();
        }
    });

    thread::spawn(move || {
        for i in 1..=cantidad {
            tx2.send(format!("productor 2: {}", i)).unwrap();
        }
    });

    thread::spawn(move || {
        thread::sleep(Duration::from_millis(10));
        tx3.send(String::from("fin")).unwrap();
    });

    rx.into_iter().collect()
}

fn contar_mensajes(mensajes: &[String]) -> usize {
    mensajes.len()
}

fn main() {
    let mensajes = producir(5);
    for msg in &mensajes {
        println!("Recibido: {}", msg);
    }

    let total = contar_mensajes(&mensajes);
    println!("Mensajes recibidos: {}", total);
}
#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn se_reciben_dos_productores_mas_fin() {
        // 5 por productor + el mensaje "fin" = 11
        let mensajes = producir(5);
        assert_eq!(mensajes.len(), 11);
    }

    #[test]
    fn total_proporcional_a_la_cantidad() {
        let mensajes = producir(3);
        assert_eq!(mensajes.len(), 7);
    }

    #[test]
    fn los_mensajes_llevan_el_prefijo_del_productor() {
        let mensajes = producir(5);
        assert!(mensajes.iter().any(|m| m.starts_with("productor 1:")));
        assert!(mensajes.iter().any(|m| m.starts_with("productor 2:")));
        assert!(mensajes.iter().any(|m| m == "fin"));
    }

    #[test]
    fn contar_mensajes_devuelve_la_longitud() {
        let mensajes = producir(2);
        assert_eq!(contar_mensajes(&mensajes), 5);
    }
}