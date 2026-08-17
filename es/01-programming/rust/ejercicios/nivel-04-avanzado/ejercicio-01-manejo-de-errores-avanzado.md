# Ejercicio 01 — Manejo de errores avanzado

- **Nivel:** 4/5
- **Tema:** errores propios, `Display`, `From`, operador `?`
- **Tiempo estimado:** 25 min

## Enunciado

Crea un programa `errores.rs` que:

1. Defina un `enum MiError { Negativo, DemasiadoGrande }`.
2. Implemente `std::fmt::Display` para `MiError` con mensajes en español.
3. Implemente `std::error::Error` para `MiError` (impl vacía).
4. Defina `raiz(n: f64) -> Result<f64, MiError>` que devuelva `Err(Negativo)` si `n < 0` y `Err(DemasiadoGrande)` si `n > 100`.
5. Defina `calcular(n: f64) -> Result<f64, MiError>` que use `?` para propagar el error de `raiz` y luego haga `Ok(raiz + 1.0)`.
6. En `main`, maneje los tres casos (éxito, negativo, demasiado grande) con `match`.

Salida esperada (ejemplo):

```
calcular(81) = Ok(10)
calcular(-4) = Err: el número es negativo
calcular(400) = Err: el número es demasiado grande
```

## Requisitos

- [ ] El enum tiene al menos dos variantes.
- [ ] `Display` y `Error` están implementados para `MiError`.
- [ ] `calcular` usa el operador `?` para propagar.
- [ ] Todos los errores se muestran con `{}` (gracias a `Display`).
- [ ] Ejecutarlo localmente con `rustc errores.rs && ./errores` y verificar la salida.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `use std::fmt;` y `impl fmt::Display for MiError { fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result { ... } }`.
- `impl std::error::Error for MiError {}` (necesita `Debug` en el enum: `#[derive(Debug)]`).
- El operador `?` devuelve el `Ok` o propaga el `Err`.
- `raiz(81.0).map(|r| r + 1.0)` es equivalente a usar `?` en una función que devuelve `Result`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````rust
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
````

</details>