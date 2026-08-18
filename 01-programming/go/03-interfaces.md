# 03 — Interfaces

## Objetivos

- [ ] Entender qué es una interfaz y para qué sirve
- [ ] Comprender la implementación **implícita** de interfaces en Go
- [ ] Usar la interfaz vacía (`interface{}` / `any`)
- [ ] Aplicar type assertions y type switches
- [ ] Conocer interfaces estándar comunes: `Stringer`, `error`
- [ ] Componer interfaces (interfaces dentro de interfaces)
- [ ] Diseñar interfaces pequeñas y enfocadas (buenas prácticas)
- [ ] Aplicar polimorfismo con interfaces en un ejemplo práctico

## Apuntes

### ¿Qué es una interfaz?

Una interfaz define un **conjunto de métodos** que un tipo debe implementar. No describe *cómo* se hace algo, sino *qué* se puede hacer con algo. En Go, cualquier tipo que implemente todos los métodos de una interfaz, automáticamente "satisface" esa interfaz — **sin necesidad de declararlo explícitamente**.

```go
type Figura interface {
    Area() float64
    Perimetro() float64
}
```

Cualquier tipo (struct u otro) que tenga métodos `Area() float64` y `Perimetro() float64` cumple con `Figura`, sin escribir `implements Figura` en ningún lado.

### Implementación implícita

Esta es la característica más distintiva de las interfaces en Go, comparado con lenguajes como Java o C#:

```go
type Circulo struct {
    Radio float64
}

func (c Circulo) Area() float64 {
    return math.Pi * c.Radio * c.Radio
}

func (c Circulo) Perimetro() float64 {
    return 2 * math.Pi * c.Radio
}

type Rectangulo struct {
    Ancho, Alto float64
}

func (r Rectangulo) Area() float64 {
    return r.Ancho * r.Alto
}

func (r Rectangulo) Perimetro() float64 {
    return 2 * (r.Ancho + r.Alto)
}

func main() {
    var f Figura // variable de tipo interfaz

    f = Circulo{Radio: 5}
    fmt.Println(f.Area()) // 78.53...

    f = Rectangulo{Ancho: 4, Alto: 6}
    fmt.Println(f.Area()) // 24
}
```

Tanto `Circulo` como `Rectangulo` satisfacen `Figura` sin ninguna declaración adicional: **si tiene los métodos, cumple la interfaz**.

### Polimorfismo con interfaces

Gracias a la implementación implícita, puedes escribir funciones que trabajan con cualquier tipo que cumpla una interfaz, sin importar su tipo concreto:

```go
func describir(f Figura) {
    fmt.Printf("Área: %.2f, Perímetro: %.2f\n", f.Area(), f.Perimetro())
}

func main() {
    figuras := []Figura{
        Circulo{Radio: 3},
        Rectangulo{Ancho: 4, Alto: 5},
    }

    for _, f := range figuras {
        describir(f) // funciona igual sin importar el tipo concreto
    }
}
```

Este es el corazón del polimorfismo en Go: un slice de `Figura` puede contener `Circulo`, `Rectangulo`, o cualquier otro tipo que implemente esos dos métodos.

### La interfaz vacía (`interface{}` / `any`)

La interfaz vacía no exige ningún método, por lo que **cualquier valor** la satisface:

```go
func imprimir(valor interface{}) {
    fmt.Println(valor)
}

imprimir(42)
imprimir("hola")
imprimir(true)
imprimir(Circulo{Radio: 2})
```

Desde Go 1.18, `any` es un alias de `interface{}` y se prefiere por legibilidad:

```go
func imprimir(valor any) {
    fmt.Println(valor)
}
```

**Cuidado**: abusar de `interface{}`/`any` elimina la seguridad de tipos en tiempo de compilación. Úsalo solo cuando de verdad necesitas aceptar cualquier tipo (por ejemplo, funciones genéricas de logging o contenedores muy dinámicos); para la mayoría de los casos, una interfaz específica o los *generics* (Go 1.18+) son mejores opciones.

### Type assertions

Cuando tienes un valor de tipo interfaz, a veces necesitas recuperar su tipo concreto. Esto se hace con una **type assertion**:

```go
var f Figura = Circulo{Radio: 5}

// Forma que puede hacer panic si el tipo no coincide
c := f.(Circulo)
fmt.Println(c.Radio)

// Forma segura: retorna un segundo valor booleano
c, ok := f.(Circulo)
if ok {
    fmt.Println("Es un círculo con radio:", c.Radio)
} else {
    fmt.Println("No es un círculo")
}
```

Siempre que sea posible, usa la forma con `ok` para evitar que el programa haga `panic` en tiempo de ejecución.

### Type switch

Un `type switch` permite comprobar el tipo concreto de un valor de interfaz contra varias opciones:

```go
func describirTipo(valor interface{}) {
    switch v := valor.(type) {
    case int:
        fmt.Println("Es un entero:", v)
    case string:
        fmt.Println("Es un string:", v)
    case bool:
        fmt.Println("Es un booleano:", v)
    case Circulo:
        fmt.Println("Es un círculo con radio:", v.Radio)
    default:
        fmt.Println("Tipo desconocido")
    }
}
```

Dentro de cada `case`, la variable `v` ya tiene el tipo concreto correspondiente, sin necesidad de otra type assertion.

### Interfaces estándar comunes

#### `error`

Ya la usaste desde la guía 1. Es, en sí misma, una interfaz definida en el paquete estándar:

```go
type error interface {
    Error() string
}
```

Cualquier tipo que implemente `Error() string` puede usarse como un `error`:

```go
type ErrorValidacion struct {
    Campo   string
    Mensaje string
}

func (e *ErrorValidacion) Error() string {
    return fmt.Sprintf("campo '%s': %s", e.Campo, e.Mensaje)
}

func validarEdad(edad int) error {
    if edad < 0 {
        return &ErrorValidacion{Campo: "edad", Mensaje: "no puede ser negativa"}
    }
    return nil
}
```

Profundizarás en el manejo de errores en la guía 5.

#### `Stringer`

Definida en el paquete `fmt`, permite personalizar cómo se imprime un valor con `Println`, `Printf("%v", ...)`, etc.:

```go
type Stringer interface {
    String() string
}

type Punto struct {
    X, Y int
}

func (p Punto) String() string {
    return fmt.Sprintf("(%d, %d)", p.X, p.Y)
}

func main() {
    p := Punto{3, 4}
    fmt.Println(p) // (3, 4)  — usa String() automáticamente
}
```

### Composición de interfaces

Igual que los structs se pueden componer, las interfaces también:

```go
type Lector interface {
    Leer() string
}

type Escritor interface {
    Escribir(string)
}

// Interfaz compuesta: exige los métodos de ambas
type LectorEscritor interface {
    Lector
    Escritor
}
```

Un tipo que implemente `Leer()` y `Escribir(string)` satisface automáticamente `LectorEscritor`.

### Buenas prácticas: interfaces pequeñas

En Go, se prefieren **interfaces pequeñas y enfocadas** en lugar de interfaces grandes con muchos métodos. Una interfaz de un solo método es extremadamente común y útil:

```go
type Notificador interface {
    Notificar(mensaje string) error
}
```

Esto facilita:
- Implementar la interfaz con cualquier tipo nuevo (menos métodos que cumplir).
- Escribir pruebas con implementaciones falsas (*mocks*) sencillas.
- Combinar interfaces pequeñas cuando se necesite más comportamiento.

Un dicho común en la comunidad Go es: *"Acepta interfaces, retorna structs concretos"* — las funciones deberían recibir el tipo más general posible (una interfaz) pero devolver tipos concretos y específicos.

## Ejemplo de código completo

```go
package main

import (
    "fmt"
    "math"
)

type Figura interface {
    Area() float64
    Perimetro() float64
}

type Circulo struct {
    Radio float64
}

func (c Circulo) Area() float64      { return math.Pi * c.Radio * c.Radio }
func (c Circulo) Perimetro() float64 { return 2 * math.Pi * c.Radio }
func (c Circulo) String() string     { return fmt.Sprintf("Círculo(radio=%.1f)", c.Radio) }

type Rectangulo struct {
    Ancho, Alto float64
}

func (r Rectangulo) Area() float64      { return r.Ancho * r.Alto }
func (r Rectangulo) Perimetro() float64 { return 2 * (r.Ancho + r.Alto) }

func procesarFigura(f Figura) {
    fmt.Printf("Área: %.2f | Perímetro: %.2f\n", f.Area(), f.Perimetro())

    switch v := f.(type) {
    case Circulo:
        fmt.Println("  -> Es un círculo:", v)
    case Rectangulo:
        fmt.Println("  -> Es un rectángulo de", v.Ancho, "x", v.Alto)
    default:
        fmt.Println("  -> Figura desconocida")
    }
}

func main() {
    figuras := []Figura{
        Circulo{Radio: 4},
        Rectangulo{Ancho: 3, Alto: 6},
    }

    for _, f := range figuras {
        procesarFigura(f)
    }
}
```

## Ejercicios relacionados

- [Nivel 3: Intermedio](./ejercicios/nivel-03-intermedio/) — ejercicios de interfaces, switch, slices avanzados, defer/panic, paquetes y funciones anónimas.

## Errores comunes

| Error | Solución |
|-------|----------|
| `panic: interface conversion` | Usa la forma segura de type assertion: `valor, ok := x.(Tipo)` |
| Un tipo "no implementa" la interfaz esperada | Revisa que los nombres, parámetros y tipos de retorno de los métodos coincidan exactamente |
| Interfaz demasiado grande y difícil de implementar | Divide en interfaces más pequeñas y compón según se necesite |
| `nil` de tipo interfaz no es igual a `nil` "puro" | Una interfaz con un puntero nulo dentro no es `== nil`; ten cuidado al comparar errores envueltos en interfaces |

## Recursos

- [Tour of Go — Interfaces](https://go.dev/tour/methods/9)
- [Effective Go — Interfaces](https://go.dev/doc/effective_go#interfaces)
- [Go by Example — Interfaces](https://gobyexample.com/interfaces)
- [Go Proverbs (Rob Pike)](https://go-proverbs.github.io/)