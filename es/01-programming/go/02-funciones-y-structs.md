# 02 — Funciones y Structs

## Objetivos

- [ ] Dominar funciones avanzadas: retornos múltiples, variádicas, funciones como valores
- [ ] Entender funciones anónimas y closures
- [ ] Usar `defer` correctamente y conocer su orden de ejecución
- [ ] Definir y usar `structs`
- [ ] Diferenciar entre receptores por valor y por puntero en métodos
- [ ] Trabajar con structs anidados y structs embebidos (composición)
- [ ] Usar `struct tags` para metadatos (introducción)
- [ ] Comparar structs y copiar structs correctamente

## Apuntes

### Funciones avanzadas

#### Retornos múltiples y nombrados

Ya viste en la guía 1 que una función puede devolver más de un valor. Esto es clave en Go, especialmente para el patrón `resultado, err := funcion()`:

```go
func dividir(a, b float64) (float64, error) {
    if b == 0 {
        return 0, fmt.Errorf("no se puede dividir entre cero")
    }
    return a / b, nil
}
```

Los retornos nombrados permiten declarar las variables de salida en la firma:

```go
func minMax(numeros []int) (min, max int) {
    min, max = numeros[0], numeros[0]
    for _, n := range numeros {
        if n < min {
            min = n
        }
        if n > max {
            max = n
        }
    }
    return // retorna min y max automáticamente
}
```

#### Funciones variádicas

Una función variádica acepta un número indefinido de argumentos del mismo tipo, usando `...`:

```go
func sumarTodos(numeros ...int) int {
    total := 0
    for _, n := range numeros {
        total += n
    }
    return total
}

// Se puede llamar con cualquier cantidad de argumentos
sumarTodos(1, 2, 3)          // 6
sumarTodos(1, 2, 3, 4, 5)    // 15
sumarTodos()                 // 0

// También se puede "expandir" un slice existente con ...
numeros := []int{10, 20, 30}
sumarTodos(numeros...)
```

Dentro de la función, `numeros` se comporta como un `[]int` normal.

#### Funciones como valores (first-class functions)

En Go, las funciones son valores: se pueden asignar a variables, pasar como argumentos y devolver desde otras funciones.

```go
// Asignar una función a una variable
var operacion func(int, int) int
operacion = func(a, b int) int {
    return a + b
}
resultado := operacion(3, 4) // 7

// Pasar una función como parámetro
func aplicar(a, b int, op func(int, int) int) int {
    return op(a, b)
}

suma := aplicar(5, 3, func(a, b int) int { return a + b })
resta := aplicar(5, 3, func(a, b int) int { return a - b })
```

#### Closures

Una closure es una función anónima que "recuerda" y puede modificar variables de su entorno externo, incluso después de que ese entorno haya terminado de ejecutarse:

```go
func contador() func() int {
    cuenta := 0
    return func() int {
        cuenta++
        return cuenta
    }
}

siguiente := contador()
fmt.Println(siguiente()) // 1
fmt.Println(siguiente()) // 2
fmt.Println(siguiente()) // 3
```

Cada llamada a `contador()` crea una nueva variable `cuenta` independiente; la closure retenida mantiene su propio estado.

#### `defer`

`defer` pospone la ejecución de una función hasta que la función que la contiene termine (ya sea por `return` normal o por `panic`). Es muy usado para liberar recursos: cerrar archivos, desbloquear mutex, cerrar conexiones, etc.

```go
func leerArchivo(ruta string) error {
    f, err := os.Open(ruta)
    if err != nil {
        return err
    }
    defer f.Close() // se ejecuta al salir de la función, pase lo que pase

    // ... trabajar con el archivo ...
    return nil
}
```

**Regla clave: los `defer` se ejecutan en orden LIFO (último en entrar, primero en salir)**:

```go
func ejemplo() {
    defer fmt.Println("1")
    defer fmt.Println("2")
    defer fmt.Println("3")
    fmt.Println("Función principal")
}
// Salida:
// Función principal
// 3
// 2
// 1
```

Los argumentos de una función diferida se evalúan en el momento del `defer`, no cuando se ejecuta:

```go
func ejemplo() {
    i := 0
    defer fmt.Println("valor diferido:", i) // captura i = 0 en este instante
    i = 100
    fmt.Println("valor final:", i)
}
// Salida:
// valor final: 100
// valor diferido: 0
```

### Structs

Un `struct` agrupa datos relacionados bajo un mismo tipo. Es la forma que tiene Go de crear tipos de datos compuestos (similar a una clase sin herencia).

#### Definición y uso básico

```go
type Persona struct {
    Nombre string
    Edad   int
    Email  string
}

func main() {
    // Crear un struct especificando todos los campos por nombre (recomendado)
    p1 := Persona{
        Nombre: "Ana",
        Edad:   30,
        Email:  "ana@example.com",
    }

    // Crear un struct en orden posicional (frágil ante cambios en la definición)
    p2 := Persona{"Juan", 25, "juan@example.com"}

    // Struct vacío (campos con su valor cero: "", 0, "")
    var p3 Persona

    // Acceder y modificar campos
    fmt.Println(p1.Nombre) // Ana
    p3.Nombre = "Carlos"
    p3.Edad = 40

    fmt.Println(p1, p2, p3)
}
```

#### Structs anidados

Un campo de un struct puede ser, a su vez, otro struct:

```go
type Direccion struct {
    Calle  string
    Ciudad string
    CP     string
}

type Persona struct {
    Nombre    string
    Edad      int
    Direccion Direccion
}

func main() {
    p := Persona{
        Nombre: "Ana",
        Edad:   30,
        Direccion: Direccion{
            Calle:  "Av. Reforma 123",
            Ciudad: "CDMX",
            CP:     "01000",
        },
    }
    fmt.Println(p.Direccion.Ciudad) // CDMX
}
```

#### Structs embebidos (composición)

Go no tiene herencia como en otros lenguajes orientados a objetos, pero permite **composición** mediante campos embebidos (sin nombre explícito). Esto "promueve" los campos y métodos del struct embebido al struct contenedor:

```go
type Animal struct {
    Nombre string
    Edad   int
}

func (a Animal) Describir() string {
    return fmt.Sprintf("%s tiene %d años", a.Nombre, a.Edad)
}

type Perro struct {
    Animal // embebido, sin nombre de campo
    Raza   string
}

func main() {
    p := Perro{
        Animal: Animal{Nombre: "Rex", Edad: 3},
        Raza:   "Labrador",
    }

    // Acceso directo a los campos promovidos
    fmt.Println(p.Nombre)       // Rex (viene de Animal)
    fmt.Println(p.Describir())  // Rex tiene 3 años (método promovido)
    fmt.Println(p.Raza)         // Labrador
}
```

### Métodos

Un método es una función asociada a un tipo mediante un **receptor**. Se define casi igual que una función normal, pero con el receptor entre `func` y el nombre:

```go
type Rectangulo struct {
    Ancho, Alto float64
}

// Receptor por valor: recibe una COPIA del struct
func (r Rectangulo) Area() float64 {
    return r.Ancho * r.Alto
}

// Receptor por puntero: recibe una REFERENCIA al struct original
func (r *Rectangulo) Escalar(factor float64) {
    r.Ancho *= factor
    r.Alto *= factor
}

func main() {
    rect := Rectangulo{Ancho: 10, Alto: 5}
    fmt.Println(rect.Area()) // 50

    rect.Escalar(2) // Go convierte automáticamente rect.Escalar(2) en (&rect).Escalar(2)
    fmt.Println(rect.Area()) // 200 (el struct original SÍ cambió)
}
```

#### ¿Cuándo usar receptor por valor y cuándo por puntero?

| Usa receptor por **valor** cuando... | Usa receptor por **puntero** cuando... |
|---|---|
| El método no necesita modificar el struct | El método necesita modificar el struct |
| El struct es pequeño (pocos campos simples) | El struct es grande (evitas copiarlo en cada llamada) |
| Quieres que el struct sea inmutable desde el método | Quieres consistencia: si un método usa puntero, todos deberían usarlo |

**Regla práctica**: si tienes dudas, y al menos un método de tu tipo necesita modificar el struct, usa receptor por puntero en **todos** los métodos de ese tipo, por consistencia.

#### Constructores (patrón `NewX`)

Go no tiene constructores como tal, pero la convención es crear una función `NewNombreDelTipo` que retorna una instancia lista para usar (frecuentemente como puntero):

```go
type Usuario struct {
    Nombre string
    activo bool // campo no exportado (empieza en minúscula)
}

func NuevoUsuario(nombre string) *Usuario {
    return &Usuario{
        Nombre: nombre,
        activo: true,
    }
}

func main() {
    u := NuevoUsuario("Ana")
    fmt.Println(u.Nombre) // Ana
}
```

**Campos exportados vs no exportados**: en Go, la visibilidad se determina por la primera letra del nombre.
- `Nombre` (mayúscula) → exportado, visible desde otros paquetes.
- `activo` (minúscula) → no exportado, solo visible dentro del mismo paquete.

#### Struct tags (introducción)

Los `struct tags` son metadatos asociados a un campo, escritos entre comillas invertidas. Se usan mucho para serialización (JSON, XML, bases de datos):

```go
type Producto struct {
    Nombre string  `json:"nombre"`
    Precio float64 `json:"precio"`
    Stock  int     `json:"stock,omitempty"`
}
```

Estos tags no cambian el comportamiento del struct por sí solos: son leídos por paquetes como `encoding/json` mediante reflexión. Los verás en profundidad cuando trabajes con APIs y persistencia.

#### Comparación y copia de structs

Dos structs son comparables con `==` si todos sus campos son comparables (no contienen slices, maps ni funciones):

```go
type Punto struct {
    X, Y int
}

p1 := Punto{1, 2}
p2 := Punto{1, 2}
fmt.Println(p1 == p2) // true
```

**Importante**: al asignar un struct a otra variable o pasarlo a una función (sin puntero), Go copia todos sus campos:

```go
func modificar(p Punto) {
    p.X = 100 // solo modifica la copia local
}

p := Punto{1, 2}
modificar(p)
fmt.Println(p) // {1 2} — no cambió

func modificarPtr(p *Punto) {
    p.X = 100 // modifica el struct original
}
modificarPtr(&p)
fmt.Println(p) // {100 2} — sí cambió
```

### Errores comunes

1. **Modificar un struct dentro de una función sin usar puntero**: si esperas que los cambios persistan, pasa `*Struct`, no `Struct`.
2. **Mezclar receptores por valor y por puntero en el mismo tipo**: puede generar confusión sobre si un método modifica o no el original. Sé consistente.
3. **Olvidar `defer f.Close()`** al abrir archivos o conexiones, causando fugas de recursos.
4. **Confundir la evaluación de argumentos en `defer`**: los argumentos se capturan al declarar el `defer`, no al ejecutarse.
5. **Struct con campos no exportados usado desde otro paquete**: si necesitas que otro paquete acceda a un campo, debe empezar con mayúscula.

## Ejemplo de código completo

```go
package main

import "fmt"

type Empleado struct {
    Nombre  string
    Salario float64
}

// Receptor por valor: solo lee datos
func (e Empleado) Info() string {
    return fmt.Sprintf("%s gana %.2f", e.Nombre, e.Salario)
}

// Receptor por puntero: modifica el struct original
func (e *Empleado) AumentarSalario(porcentaje float64) {
    e.Salario += e.Salario * (porcentaje / 100)
}

func totalSalarios(empleados ...Empleado) float64 {
    total := 0.0
    for _, e := range empleados {
        total += e.Salario
    }
    return total
}

func main() {
    e1 := Empleado{Nombre: "Ana", Salario: 20000}
    e2 := Empleado{Nombre: "Luis", Salario: 25000}

    fmt.Println(e1.Info())
    fmt.Println(e2.Info())

    e1.AumentarSalario(10) // aumenta el 10%
    fmt.Println(e1.Info())

    total := totalSalarios(e1, e2)
    fmt.Printf("Total de salarios: %.2f\n", total)

    defer fmt.Println("Programa finalizado")
    fmt.Println("Procesando...")
}
```

## Ejercicios relacionados

- [Nivel 2: Básico](./ejercicios/nivel-02-basico/) — ejercicios de structs, métodos, punteros, funciones variádicas, strings y errores básicos.

## Errores comunes

| Error | Solución |
|-------|----------|
| `cannot use p (type Punto) as type *Punto` | Usa `&p` para obtener un puntero al struct |
| Los cambios en un método no persisten | Verifica si el receptor es por valor; cámbialo a puntero (`*Tipo`) |
| `undefined field or method` en un struct embebido | Revisa que el struct esté embebido sin nombre explícito de campo |
| `invalid operation: p1 == p2` | Los structs con slices o maps como campos no son comparables directamente |

## Recursos

- [Tour of Go — Structs](https://go.dev/tour/moretypes/2)
- [Tour of Go — Methods](https://go.dev/tour/methods/1)
- [Effective Go — Embedding](https://go.dev/doc/effective_go#embedding)
- [Go by Example — Variadic Functions](https://gobyexample.com/variadic-functions)
- [Go by Example — Closures](https://gobyexample.com/closures)