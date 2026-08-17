# Ejercicio 04 — Event loop

- **Nivel:** 5/5
- **Tema:** cola de eventos, `VecDeque`, patrón event-driven
- **Tiempo estimado:** 40 min

## Enunciado

Crea un programa `event_loop.rs` que implemente un pequeño bucle de eventos:

1. `enum Evento { Tecla(char), Temporizador(u32), Click(u32, u32) }`.
2. `struct Loop { cola: VecDeque<Evento>, contador_teclas: u32 }` donde `VecDeque` viene de `std::collections`.
3. Métodos:
   - `nuevo() -> Loop`.
   - `encolar(&mut self, evento: Evento)`.
   - `procesar(&mut self)` que agote la cola con `while let Some(e) = self.cola.pop_front()` y:
     - `Tecla(c)` → imprime la tecla y suma 1 al contador.
     - `Temporizador(ms)` → imprime los ms.
     - `Click(x, y)` → imprime la posición.
4. En `main`, encola varios eventos, llama a `procesar` y muestra el `contador_teclas` final.

Salida esperada (ejemplo):

```
Procesando: Tecla(a)
Procesando: Click(10, 20)
Procesando: Temporizador(1000)
Procesando: Tecla(b)
Teclas procesadas: 2
```

## Requisitos

- [ ] El `enum Evento` tiene las 3 variantes con datos.
- [ ] La cola es un `VecDeque<Evento>`.
- [ ] `procesar` agota la cola con `while let`.
- [ ] El contador de teclas se actualiza dentro de `procesar`.
- [ ] Ejecutarlo localmente con `cargo run` (o `rustc event_loop.rs && ./event_loop`) y verificar la salida.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `use std::collections::VecDeque;`.
- `self.cola.push_back(evento)` encola; `self.cola.pop_front()` desencola.
- `while let Some(e) = self.cola.pop_front() { match e { ... } }`.
- `#[derive(Debug)]` en el enum ayuda a imprimirlo.
- El `contador_teclas` se suma solo en el caso `Tecla`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````rust
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
````

</details>