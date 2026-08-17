# Ejercicio 03 — impl y asociados

- **Nivel:** 3/5
- **Tema:** métodos, funciones asociadas, constantes asociadas
- **Tiempo estimado:** 20 min

## Enunciado

Crea un programa `impl.rs` que:

1. Defina un `struct Circulo { radio: f64 }`.
2. En `impl`:
   - Una constante asociada `const PI: f64 = 3.14159;`.
   - Un constructor `nuevo(radio: f64) -> Circulo`.
   - Un método `area(&self) -> f64` (`PI * radio²`).
   - Un método `circunferencia(&self) -> f64` (`2 * PI * radio`).
   - Un método `es_grande(&self) -> bool` (`radio > 10`).
3. En `main`, cree un círculo y muestre área, circunferencia y si es grande.
4. Añada un `impl` adicional con un método `descripcion(&self) -> String`.

Salida esperada (ejemplo):

```
Área: 78.53975
Circunferencia: 31.4159
¿Es grande? false
Descripción: Círculo de radio 5
PI asociado: 3.14159
```

## Requisitos

- [ ] El `impl` incluye la constante asociada `PI`.
- [ ] El constructor `nuevo` es una función asociada (sin `self`).
- [ ] `area` y `circunferencia` usan `&self`.
- [ ] Hay dos bloques `impl` separados para el mismo tipo.
- [ ] Ejecutarlo localmente con `rustc impl.rs && ./impl` y verificar la salida.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Constante asociada: `const PI: f64 = 3.14159;` dentro de `impl Circulo`.
- Se accede como `Circulo::PI`.
- Constructor: `fn nuevo(radio: f64) -> Circulo { Circulo { radio } }`.
- `radio.powi(2)` eleva a la potencia 2.
- Puedes tener varios bloques `impl` para el mismo tipo.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````rust
struct Circulo {
    radio: f64,
}

impl Circulo {
    const PI: f64 = 3.14159;

    fn nuevo(radio: f64) -> Circulo {
        Circulo { radio }
    }

    fn area(&self) -> f64 {
        Circulo::PI * self.radio.powi(2)
    }

    fn circunferencia(&self) -> f64 {
        2.0 * Circulo::PI * self.radio
    }

    fn es_grande(&self) -> bool {
        self.radio > 10.0
    }
}

impl Circulo {
    fn descripcion(&self) -> String {
        format!("Círculo de radio {}", self.radio)
    }
}

fn main() {
    let c = Circulo::nuevo(5.0);
    println!("Área: {}", c.area());
    println!("Circunferencia: {}", c.circunferencia());
    println!("¿Es grande? {}", c.es_grande());
    println!("Descripción: {}", c.descripcion());
    println!("PI asociado: {}", Circulo::PI);
}
````

</details>