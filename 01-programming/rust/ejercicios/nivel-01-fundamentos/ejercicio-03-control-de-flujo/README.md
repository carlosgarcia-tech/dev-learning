# Ejercicio 03 — Control de flujo

- **Nivel:** 1/5
- **Tema:** `if`/`else`, `match`, bucles `for`, `while` y `loop`
- **Tiempo estimado:** 20 min

## Enunciado

Crea un programa `control.rs` que:

1. Con `if/else if/else`, clasifique una nota (0-100) en "Excelente" (≥90), "Aprobado" (≥70) o "Reprobado" (<70).
2. Con `match`, convierta un número de día (1-7) en su nombre ("Lunes".."Domingo"); otros valores → "Inválido".
3. Con un bucle `for` sobre `1..=10`, imprima la tabla de multiplicar de un número.
4. Con `while`, cuente desde 0 hasta que una variable llegue a 5.
5. Use `loop` para sumar números hasta que la suma supere 50 (empieza en 0 y suma de 7 en 7), e imprima el resultado.

Salida esperada (ejemplo):

```
Aprobado
Miércoles
7 x 1 = 7
...
7 x 10 = 70
Contador: 5
Suma final con loop: 56
```

## Requisitos

- [ ] Usar los 5 tipos de control de flujo pedidos.
- [ ] `match` tiene un caso comodín `_`.
- [ ] El `loop` sale con `break` y devuelve un valor.
- [ ] Ejecutarlo localmente con `rustc control.rs && ./control` y verificar la salida.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `for i in 1..=10` incluye el 10; `1..10` lo excluye.
- `match` se usa así: `match dia { 1 => println!("Lunes"), ... _ => println!("Inválido") }`.
- `loop { ... break valor; }` devuelve `valor`.
- Recuerda: la condición de `while` y `if` debe ser un `bool`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````rust
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
````

</details>