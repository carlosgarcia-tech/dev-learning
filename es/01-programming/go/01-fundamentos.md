# 01 — Fundamentos de Go

## Objetivos

- [ ] Entender qué es Go y por qué es útil
- [ ] Instalar y configurar Go
- [ ] Conocer la estructura de un programa Go
- [ ] Usar variables, constantes y tipos de datos básicos
- [ ] Manejar entrada y salida básica (fmt)
- [ ] Utilizar operadores y condicionales
- [ ] Trabajar con bucles (`for`)
- [ ] Crear funciones básicas

## Apuntes

### ¿Qué es Go?

Go (también llamado Golang) es un lenguaje de programación creado por Google en 2007. Está diseñado para ser:
- **Simple**: Fácil de leer y escribir
- **Rápido**: Compilación rápida y ejecución eficiente
- **Concurrente**: Soporte nativo para programación concurrente con goroutines
- **Seguro**: Manejo de memoria seguro con garbage collector

### Estructura de un programa Go

Todo programa Go sigue esta estructura básica:

```go
package main  // Define el paquete principal

import "fmt"  // Importa el paquete fmt para entrada/salida

func main() { // Función principal, punto de entrada
    fmt.Println("¡Hola, mundo!")
}
```

### Variables y tipos de datos

#### Declaración de variables

En Go, las variables se declaran de varias formas:

```go
// Forma explícita (con tipo)
var nombre string = "Juan"

// Forma inferida (sin tipo, Go deduce el tipo)
var edad = 30

// Forma corta (solo dentro de funciones)
ciudad := "Madrid"

// Múltiples variables
var x, y int = 10, 20
a, b := "hola", true
```

#### Tipos de datos básicos

| Tipo | Descripción | Ejemplo |
|------|-------------|---------|
| `string` | Cadena de texto | `"Hola mundo"` |
| `bool` | Booleano (true/false) | `true` |
| `int` | Entero (depende de la arquitectura) | `42` |
| `int8`, `int16`, `int32`, `int64` | Enteros con tamaño fijo | `int32(100)` |
| `uint`, `uint8`, `uint16`, `uint32`, `uint64` | Enteros sin signo | `uint32(255)` |
| `float32`, `float64` | Números decimales | `3.14` |
| `byte` | Alias de `uint8` | `'A'` |
| `rune` | Alias de `int32` (caracteres Unicode) | `'ñ'` |

#### Constantes

Las constantes se declaran con `const` y no pueden cambiar:

```go
const PI = 3.14159
const (
    Nombre = "Go"
    Version = 1.21
)
```

### Entrada y salida con fmt

El paquete `fmt` proporciona funciones para I/O formateada:

```go
// Salida
fmt.Println("Mensaje con salto de línea")
fmt.Print("Mensaje sin salto de línea")
fmt.Printf("Formateado: %s tiene %d años", "Juan", 30)

// Entrada
var nombre string
fmt.Scanln(&nombre)  // Lee una línea

var edad int
fmt.Scanf("%d", &edad)  // Lee formateado
```

### Operadores

#### Operadores aritméticos
```go
+  // Suma
-  // Resta
*  // Multiplicación
/  // División
%  // Módulo (resto)
```

#### Operadores de comparación
```go
==  // Igual
!=  // Diferente
<   // Menor que
>   // Mayor que
<=  // Menor o igual
>=  // Mayor o igual
```

#### Operadores lógicos
```go
&&  // AND (y)
||  // OR (o)
!   // NOT (no)
```

### Condicionales (if, else if, else)

```go
if edad >= 18 {
    fmt.Println("Mayor de edad")
} else if edad >= 16 {
    fmt.Println("Casi mayor de edad")
} else {
    fmt.Println("Menor de edad")
}
```

**Característica especial de Go**: Puedes declarar variables dentro del `if`:

```go
if resultado := calcular(); resultado > 0 {
    fmt.Println("Positivo:", resultado)
}
```

### Bucles (for)

Go solo tiene un tipo de bucle: `for`. Pero tiene varias formas:

```go
// Bucle clásico (inicialización; condición; incremento)
for i := 0; i < 10; i++ {
    fmt.Println(i)
}

// Bucle while (solo condición)
suma := 0
for suma < 100 {
    suma += 10
}

// Bucle infinito
for {
    // Se ejecuta para siempre hasta que hay un break
}

// Bucle con range (para iterar sobre colecciones)
nums := []int{1, 2, 3, 4, 5}
for indice, valor := range nums {
    fmt.Printf("Índice: %d, Valor: %d\n", indice, valor)
}

// Bucle con range ignorando el índice
for _, valor := range nums {
    fmt.Println(valor)
}
```

### Funciones básicas

Las funciones se declaran con `func`:

```go
// Función sin parámetros y sin retorno
func saludar() {
    fmt.Println("¡Hola!")
}

// Función con parámetros
func sumar(a int, b int) int {
    return a + b
}

// Función con múltiples retornos
func dividir(a, b int) (int, error) {
    if b == 0 {
        return 0, fmt.Errorf("división por cero")
    }
    return a / b, nil
}

// Función con retorno nombrado
func obtenerCoordenadas() (x, y int) {
    x = 10
    y = 20
    return  // Retorna x e y automáticamente
}
```

### Errores comunes en Go

1. **Variables declaradas no usadas**: En Go, todas las variables declaradas deben usarse.
   ```go
   // Esto da error:
   var nombre string
   // `nombre` declarado y no usado
   ```

2. **Importaciones no usadas**: Las importaciones no usadas también dan error.

3. **Falta de `main()`**: Todo programa ejecutable necesita una función `main()` en el paquete `main`.

4. **Uso de `:=` fuera de funciones**: La forma corta solo funciona dentro de funciones.

## Ejemplos de código

### Ejemplo 1: Programa completo

```go
package main

import (
    "fmt"
    "strconv"
)

func main() {
    // Variables
    nombre := "Ana"
    edad := 25
    altura := 1.75
    
    // Entrada
    fmt.Print("¿Cuál es tu ciudad? ")
    var ciudad string
    fmt.Scanln(&ciudad)
    
    // Condicional
    if edad >= 18 {
        fmt.Printf("%s tiene %d años, es mayor de edad\n", nombre, edad)
    } else {
        fmt.Printf("%s tiene %d años, es menor de edad\n", nombre, edad)
    }
    
    // Bucle
    for i := 1; i <= 5; i++ {
        fmt.Printf("Número: %d\n", i)
    }
    
    // Función
    resultado := sumar(10, 20)
    fmt.Println("Resultado:", resultado)
    
    // Manejo de errores
    cociente, err := dividir(10, 0)
    if err != nil {
        fmt.Println("Error:", err)
    } else {
        fmt.Println("Cociente:", cociente)
    }
}

func sumar(a, b int) int {
    return a + b
}

func dividir(a, b int) (int, error) {
    if b == 0 {
        return 0, fmt.Errorf("división por cero")
    }
    return a / b, nil
}
```

### Ejemplo 2: Manejo de strings y conversión

```go
package main

import (
    "fmt"
    "strconv"
    "strings"
)

func main() {
    // Concatenación
    saludo := "Hola, " + "mundo"
    fmt.Println(saludo)
    
    // Conversión de string a número
    str := "123"
    if num, err := strconv.Atoi(str); err == nil {
        fmt.Println("Número:", num)
    }
    
    // Conversión de número a string
    numero := 456
    texto := strconv.Itoa(numero)
    fmt.Println("String:", texto)
    
    // Funciones de string
    nombre := "Juan Pérez"
    fmt.Println(strings.ToUpper(nombre))
    fmt.Println(strings.Contains(nombre, "Pérez"))
    fmt.Println(strings.Split(nombre, " "))
}
```

## Ejercicios relacionados

- [Ejercicio 01: Variables y tipos](./ejercicios/nivel-01-fundamentos/ejercicio-01-variables-y-tipos/)
- [Ejercicio 02: Operadores y condicionales](./ejercicios/nivel-01-fundamentos/ejercicio-02-operadores-y-condicionales/)
- [Ejercicio 03: Bucles](./ejercicios/nivel-01-fundamentos/ejercicio-03-bucles/)
- [Ejercicio 04: Funciones básicas](./ejercicios/nivel-01-fundamentos/ejercicio-04-funciones-basicas/)
- [Ejercicio 05: Arrays y slices](./ejercicios/nivel-01-fundamentos/ejercicio-05-arrays-y-slices/)
- [Ejercicio 06: Maps](./ejercicios/nivel-01-fundamentos/ejercicio-06-maps/)

## Errores comunes

| Error | Solución |
|-------|----------|
| `syntax error: unexpected newline, expecting }` | Revisa que todos los `{` tengan su `}` |
| `undefined: main.main` | Asegúrate de tener `func main()` en el paquete `main` |
| `cannot use "123" (type string) as type int` | Convierte strings a números con `strconv` |
| `declared and not used` | Usa todas las variables declaradas o elimínalas |
| `imported and not used` | Elimina las importaciones no usadas o úsalas |

## Recursos

- [Documentación oficial de Go](https://go.dev/doc/)
- [Tour of Go](https://go.dev/tour/)
- [Go by Example](https://gobyexample.com/)
- [Effective Go](https://go.dev/doc/effective_go)
- [Package fmt documentation](https://pkg.go.dev/fmt)
- [Package strconv documentation](https://pkg.go.dev/strconv)