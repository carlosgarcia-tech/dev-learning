# Ejercicio 06 — HashMap

- **Nivel:** 2/5
- **Tema:** `HashMap`, `entry`, `or_insert`, iteración
- **Tiempo estimado:** 20 min

## Enunciado

Crea un programa `hashmap.rs` que:

1. Cree un `HashMap<String, u8>` con tres personas y sus edades.
2. Consulte una edad con `get` (manejando `Option`).
3. Actualice la edad de una persona existente.
4. Use `entry(...).or_insert(0)` para añadir una persona nueva con edad inicial 0.
5. Compruebe si existe una clave con `contains_key`.
6. Recorra el mapa e imprima cada `nombre: edad`.

Salida esperada (ejemplo):

```
Ana tiene 30 años
Luis tiene 26 años
Pepe tiene 1 años
¿Existe Pepe? true
Mapa: {"Carmen": 28, "Pepe": 1, "Ana": 30, "Luis": 26}
Recorrido:
Ana: 30
Luis: 26
Carmen: 28
Pepe: 1
```

## Requisitos

- [ ] Insertar con `insert` y consultar con `get`.
- [ ] Actualizar un valor existente.
- [ ] Usar `entry` con `or_insert`.
- [ ] Usar `contains_key`.
- [ ] Recorrer con `for (k, v) in &mapa`.
- [ ] Ejecutarlo localmente con `rustc hashmap.rs && ./hashmap` y verificar la salida.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `use std::collections::HashMap;` al inicio.
- `mapa.insert(String::from("Ana"), 30);`.
- `mapa.get("Ana")` devuelve `Option<&u8>`; usa `.copied()` o `&` en el match.
- `mapa.entry(String::from("Pepe")).or_insert(0);` inserta si no existe.
- `for (nombre, edad) in &mapa` recorre por referencia.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````rust
use std::collections::HashMap;

fn main() {
    let mut edades = HashMap::new();
    edades.insert(String::from("Ana"), 30);
    edades.insert(String::from("Luis"), 25);
    edades.insert(String::from("Carmen"), 28);

    match edades.get("Ana") {
        Some(&edad) => println!("Ana tiene {} años", edad),
        None => println!("Ana no existe"),
    }

    edades.insert(String::from("Luis"), 26);
    println!("Luis tiene {} años", edades.get("Luis").unwrap());

    edades.entry(String::from("Pepe")).or_insert(0);
    edades.entry(String::from("Pepe")).and_modify(|e| *e += 1);
    println!("Pepe tiene {} años", edades.get("Pepe").unwrap());

    println!("¿Existe Pepe? {}", edades.contains_key("Pepe"));
    println!("Mapa: {:?}", edades);

    println!("Recorrido:");
    for (nombre, edad) in &edades {
        println!("{}: {}", nombre, edad);
    }
}
````

</details>