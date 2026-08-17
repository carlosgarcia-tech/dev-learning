# Ejercicio 06 — Structs básicos

- **Nivel:** 1/5
- **Tema:** `struct`, `impl`, métodos
- **Tiempo estimado:** 20 min

## Enunciado

Crea un programa `structs.rs` que:

1. Defina un `struct Persona` con los campos `nombre: String`, `edad: u8` y `activo: bool`.
2. Implemente un constructor `Persona::nueva(nombre: &str, edad: u8) -> Persona` que active a la persona.
3. Implemente un método `saludar(&self)` que imprima `Hola, soy <nombre> y tengo <edad> años.`.
4. Implemente un método `cumplir_anios(&mut self)` que incremente la edad en 1.
5. En `main`, cree una persona, salude, cumpla años y muestre la nueva edad.

Salida esperada (ejemplo):

```
Hola, soy Ana y tengo 30 años.
Activo: true
¡Feliz cumpleaños! Ana ahora tiene 31 años.
```

## Requisitos

- [ ] El `struct` tiene los 3 campos pedidos.
- [ ] El constructor es una función asociada llamada `nueva`.
- [ ] `saludar` usa `&self` y `cumplir_anios` usa `&mut self`.
- [ ] Declarar la persona como `let mut`.
- [ ] Ejecutarlo localmente con `rustc structs.rs && ./structs` y verificar la salida.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- El constructor no lleva `self`: `fn nueva(nombre: &str, edad: u8) -> Persona`.
- Para guardar el `&str` como `String` usa `nombre.to_string()`.
- Método que modifica: `fn cumplir_anios(&mut self) { self.edad += 1; }`.
- La variable debe ser `let mut persona = Persona::nueva(...)` para poder llamar al método mutable.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````rust
struct Persona {
    nombre: String,
    edad: u8,
    activo: bool,
}

impl Persona {
    fn nueva(nombre: &str, edad: u8) -> Persona {
        Persona {
            nombre: nombre.to_string(),
            edad,
            activo: true,
        }
    }

    fn saludar(&self) {
        println!("Hola, soy {} y tengo {} años.", self.nombre, self.edad);
    }

    fn cumplir_anios(&mut self) {
        self.edad += 1;
    }
}

fn main() {
    let mut persona = Persona::nueva("Ana", 30);
    persona.saludar();
    println!("Activo: {}", persona.activo);
    persona.cumplir_anios();
    println!("¡Feliz cumpleaños! Ana ahora tiene {} años.", persona.edad);
}
````

</details>