# Ejercicio 04 — Channels

- **Nivel:** 4/5
- **Tema:** `mpsc`, `Sender`, `Receiver`, `clone`, `recv`
- **Tiempo estimado:** 25 min

## Enunciado

Crea un programa `channels.rs` que:

1. Cree un canal con `mpsc::channel()`.
2. Lance **dos** hilos productores, cada uno enviando 5 mensajes (`productor 1: N` y `productor 2: N`). Para eso clona el `Sender` con `tx.clone()`.
3. En el hilo principal, reciba todos los mensajes con un bucle `for msg in rx` e imprímalos.
4. Cuente cuántos mensajes se recibieron (deben ser 10).
5. Añada un tercer hilo que envíe un mensaje de "fin" al terminar.

Salida esperada (ejemplo):

```
Recibido: productor 1: 1
Recibido: productor 2: 1
...
Recibido: fin
Mensajes recibidos: 11
```

## Requisitos

- [ ] Dos productores usan un `Sender` clonado.
- [ ] El `Receiver` se consume con `for msg in rx`.
- [ ] El conteo final coincide con el total de mensajes enviados.
- [ ] El hilo principal no cierra manualmente; los `Sender` se caen solos.
- [ ] Ejecutarlo localmente con `rustc channels.rs && ./channels` y verificar la salida.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `let (tx, rx) = mpsc::channel();` y `let tx2 = tx.clone();`.
- Cada productor: `thread::spawn(move || { for i in 1..=5 { tx.send(...).unwrap(); } })`.
- El bucle `for msg in rx` termina cuando todos los `Sender` se cierran.
- Añade un contador `let mut total = 0;` que se incrementa en cada mensaje.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````rust
use std::sync::mpsc;
use std::thread;
use std::time::Duration;

fn main() {
    let (tx, rx) = mpsc::channel();

    let tx2 = tx.clone();
    thread::spawn(move || {
        for i in 1..=5 {
            tx.send(format!("productor 1: {}", i)).unwrap();
        }
    });

    thread::spawn(move || {
        for i in 1..=5 {
            tx2.send(format!("productor 2: {}", i)).unwrap();
        }
    });

    let tx3 = tx.clone();
    thread::spawn(move || {
        thread::sleep(Duration::from_millis(10));
        tx3.send(String::from("fin")).unwrap();
    });

    let mut total = 0;
    for msg in rx {
        println!("Recibido: {}", msg);
        total += 1;
    }
    println!("Mensajes recibidos: {}", total);
}
````

</details>