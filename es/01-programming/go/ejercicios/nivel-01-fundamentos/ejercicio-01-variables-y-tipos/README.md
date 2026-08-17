# Ejercicio 01 — Variables y tipos

- **Nivel:** 1/5
- **Tema:** Fundamentos de Go
- **Tiempo estimado:** 15 minutos

## Enunciado

Crea un programa en Go que:

1. Declare variables de los siguientes tipos:
   - `string` (nombre de usuario)
   - `int` (edad del usuario)
   - `float64` (altura del usuario en metros)
   - `bool` (¿es estudiante?)

2. Asigna valores a estas variables (pueden ser valores fijos o pedidos por consola).

3. Muestra un mensaje con todos los datos del usuario usando `fmt.Printf`.

## Requisitos

- [ ] El programa compila sin errores
- [ ] Se declaran variables de los tipos `string`, `int`, `float64` y `bool`
- [ ] Se asignan valores a todas las variables
- [ ] Se usa `fmt.Printf` para mostrar la información formateada
- [ ] La salida incluye todos los datos del usuario
- [ ] Los tests pasan: `go test -v ./...`

## Pistas

<details>
<summary>Mostrar pistas</summary>

1. Recuerda que para usar `fmt` necesitas importarlo al inicio del archivo.
2. Puedes usar `fmt.Print` o `fmt.Scan` para pedir datos al usuario.
3. Para formatear strings con `fmt.Printf`:
   - `%s` para strings
   - `%d` para enteros
   - `%f` para floats (puedes usar `%.2f` para 2 decimales)
   - `%t` para booleanos
4. Si usas `fmt.Scanln`, recuerda pasar la dirección de la variable con `&`.
</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```go
package main

import "fmt"

func main() {
    // Declaración de variables
    var nombre string
    var edad int
    var altura float64
    var estudiante bool

    // Solicitar datos al usuario
    fmt.Print("Ingresa tu nombre: ")
    fmt.Scanln(&nombre)

    fmt.Print("Ingresa tu edad: ")
    fmt.Scanln(&edad)

    fmt.Print("Ingresa tu altura en metros: ")
    fmt.Scanln(&altura)

    fmt.Print("¿Eres estudiante? (true/false): ")
    fmt.Scanln(&estudiante)

    // Mostrar la información formateada
    fmt.Printf("Datos del usuario:\n")
    fmt.Printf("  Nombre: %s\n", nombre)
    fmt.Printf("  Edad: %d años\n", edad)
    fmt.Printf("  Altura: %.2f metros\n", altura)
    fmt.Printf("  Estudiante: %t\n", estudiante)
}
```
</details>