use std::collections::VecDeque;

#[derive(Debug)]
enum Evento {
    Tecla(char),
    Temporizador(u32),
    Click(u32, u32),
}

struct Loop {
    cola: VecDeque<Evento>,
    contador_teclas: u32,
}

impl Loop {
    fn nuevo() -> Loop {
        Loop {
            cola: VecDeque::new(),
            contador_teclas: 0,
        }
    }

    fn encolar(&mut self, evento: Evento) {
        self.cola.push_back(evento);
    }

    fn procesar(&mut self) {
        while let Some(evento) = self.cola.pop_front() {
            match evento {
                Evento::Tecla(c) => {
                    println!("Procesando: Tecla({})", c);
                    self.contador_teclas += 1;
                }
                Evento::Click(x, y) => println!("Procesando: Click({}, {})", x, y),
                Evento::Temporizador(ms) => println!("Procesando: Temporizador({})", ms),
            }
        }
    }
}

fn main() {
    let mut loop_ = Loop::nuevo();

    loop_.encolar(Evento::Tecla('a'));
    loop_.encolar(Evento::Click(10, 20));
    loop_.encolar(Evento::Temporizador(1000));
    loop_.encolar(Evento::Tecla('b'));

    loop_.procesar();

    println!("Teclas procesadas: {}", loop_.contador_teclas);
}
#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn nuevo_empieza_vacio() {
        let loop_ = Loop::nuevo();
        assert!(loop_.cola.is_empty());
        assert_eq!(loop_.contador_teclas, 0);
    }

    #[test]
    fn procesar_agota_la_cola() {
        let mut loop_ = Loop::nuevo();
        loop_.encolar(Evento::Tecla('a'));
        loop_.encolar(Evento::Click(10, 20));
        loop_.encolar(Evento::Temporizador(1000));
        loop_.procesar();
        assert!(loop_.cola.is_empty());
    }

    #[test]
    fn solo_las_teclas_suman_al_contador() {
        let mut loop_ = Loop::nuevo();
        loop_.encolar(Evento::Tecla('a'));
        loop_.encolar(Evento::Click(10, 20));
        loop_.encolar(Evento::Temporizador(1000));
        loop_.encolar(Evento::Tecla('b'));
        loop_.procesar();
        assert_eq!(loop_.contador_teclas, 2);
    }

    #[test]
    fn procesar_sin_eventos_no_cambia_el_contador() {
        let mut loop_ = Loop::nuevo();
        loop_.procesar();
        assert_eq!(loop_.contador_teclas, 0);
    }
}