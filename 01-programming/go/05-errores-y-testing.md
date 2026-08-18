# 05 — Errores y Testing

## Objetivos

- [ ] Entender la filosofía de manejo de errores de Go (sin excepciones)
- [ ] Crear errores con `errors.New` y `fmt.Errorf`
- [ ] Envolver (`wrap`) errores y desenvolverlos con `errors.Is` y `errors.As`
- [ ] Crear tipos de error personalizados
- [ ] Usar `panic` y `recover` correctamente (y saber cuándo NO usarlos)
- [ ] Escribir pruebas unitarias con el paquete `testing`
- [ ] Aplicar tests basados en tablas (*table-driven tests*) y subtests
- [ ] Medir cobertura de código y escribir benchmarks básicos

## Apuntes

### Filosofía de errores en Go

A diferencia de lenguajes con `try/catch`, Go trata los errores como **valores normales**, no como excepciones. Una función que puede fallar simplemente retorna un `error` como su último valor de retorno:

```go
func dividir(a, b float64) (float64, error) {
    if b == 0 {
        return 0, errors.New("no se puede dividir entre cero")
    }
    return a / b, nil
}
```

El patrón estándar para consumir estos errores es comprobar `err != nil` inmediatamente después de la llamada:

```go
resultado, err := dividir(10, 0)
if err != nil {
    fmt.Println("Error:", err)
    return
}
fmt.Println("Resultado:", resultado)
```

**Ventaja de este enfoque**: el flujo de control es explícito y predecible — no hay saltos "invisibles" como con las excepciones. **Costo**: el código puede volverse repetitivo con muchos `if err != nil`, pero se considera un compromiso aceptable a cambio de claridad.

### Creando errores

#### `errors.New`

Crea un error simple a partir de un string:

```go
import "errors"

var ErrNoEncontrado = errors.New("recurso no encontrado")

func buscar(id int) error {
    if id <= 0 {
        return ErrNoEncontrado
    }
    return nil
}
```

Declarar errores como variables (`ErrNoEncontrado`) a nivel de paquete es una convención común en Go: permite comparar errores directamente con `==` o `errors.Is`.

#### `fmt.Errorf`

Permite crear errores con formato, similar a `Printf`:

```go
func validarEdad(edad int) error {
    if edad < 0 {
        return fmt.Errorf("edad inválida: %d (debe ser positiva)", edad)
    }
    return nil
}
```

### Envolver errores (*error wrapping*)

Cuando un error ocurre en una capa interna y se propaga hacia arriba, suele ser útil añadir contexto sin perder el error original. El verbo `%w` en `fmt.Errorf` envuelve un error, preservando su identidad:

```go
func leerConfiguracion(ruta string) error {
    _, err := os.Open(ruta)
    if err != nil {
        return fmt.Errorf("error al leer configuración: %w", err)
    }
    return nil
}
```

#### `errors.Is`

Comprueba si un error (o alguno de los errores que envuelve) coincide con un error específico:

```go
err := leerConfiguracion("config.json")
if errors.Is(err, os.ErrNotExist) {
    fmt.Println("El archivo de configuración no existe")
}
```

#### `errors.As`

Comprueba si un error (o alguno de los que envuelve) puede convertirse a un tipo de error personalizado, y lo asigna si es así:

```go
type ErrorValidacion struct {
    Campo string
}

func (e *ErrorValidacion) Error() string {
    return fmt.Sprintf("campo inválido: %s", e.Campo)
}

var target *ErrorValidacion
if errors.As(err, &target) {
    fmt.Println("Error de validación en el campo:", target.Campo)
}
```

### Errores personalizados

Cualquier tipo que implemente el método `Error() string` satisface la interfaz `error` (vista en la guía 3). Esto permite adjuntar información adicional al error:

```go
type ErrorHTTP struct {
    Codigo  int
    Mensaje string
}

func (e *ErrorHTTP) Error() string {
    return fmt.Sprintf("HTTP %d: %s", e.Codigo, e.Mensaje)
}

func obtenerRecurso(id int) error {
    if id > 1000 {
        return &ErrorHTTP{Codigo: 404, Mensaje: "recurso no encontrado"}
    }
    return nil
}

func main() {
    err := obtenerRecurso(9999)
    var errHTTP *ErrorHTTP
    if errors.As(err, &errHTTP) {
        fmt.Println("Código de estado:", errHTTP.Codigo)
    }
}
```

### `panic` y `recover`

`panic` detiene la ejecución normal del programa de forma abrupta, comenzando a "desenrollar" la pila (ejecutando los `defer` pendientes) hasta que el programa termina o algún `recover` lo detiene.

```go
func dividirEstricto(a, b int) int {
    if b == 0 {
        panic("división entre cero no permitida")
    }
    return a / b
}
```

`recover` solo funciona dentro de una función diferida (`defer`), y permite "atrapar" un `panic` para evitar que el programa termine:

```go
func operacionSegura() (resultado int, err error) {
    defer func() {
        if r := recover(); r != nil {
            err = fmt.Errorf("se recuperó de un panic: %v", r)
        }
    }()

    resultado = dividirEstricto(10, 0) // esto haría panic
    return
}

func main() {
    resultado, err := operacionSegura()
    if err != nil {
        fmt.Println("Error controlado:", err)
    } else {
        fmt.Println("Resultado:", resultado)
    }
}
```

**Regla de oro**: en Go, `panic`/`recover` **no es** el equivalente a `try/catch`. Se reserva para errores realmente excepcionales o irrecuperables (por ejemplo, un índice fuera de rango en una librería, o un estado interno inconsistente que nunca debería ocurrir). Para errores esperables del flujo normal (archivo no encontrado, entrada inválida, etc.), siempre se prefiere retornar un `error`.

### Testing con el paquete `testing`

Go incluye herramientas de pruebas en la biblioteca estándar, sin necesidad de frameworks externos.

#### Estructura básica de un test

- El archivo de test debe llamarse `algo_test.go`.
- Cada función de test debe empezar con `Test` y recibir `t *testing.T`.

```go
// suma.go
package mate

func Sumar(a, b int) int {
    return a + b
}
```

```go
// suma_test.go
package mate

import "testing"

func TestSumar(t *testing.T) {
    resultado := Sumar(2, 3)
    esperado := 5

    if resultado != esperado {
        t.Errorf("Sumar(2, 3) = %d; se esperaba %d", resultado, esperado)
    }
}
```

Ejecutar los tests:

```bash
go test ./...        # ejecuta todos los tests del módulo
go test -v ./...      # modo verboso, muestra cada test individual
go test -run TestSumar # ejecuta solo los tests que coincidan con el patrón
```

#### Table-driven tests (tests basados en tablas)

Es el patrón idiomático en Go para probar múltiples casos con el mismo test, evitando duplicar código:

```go
func TestSumar(t *testing.T) {
    casos := []struct {
        nombre   string
        a, b     int
        esperado int
    }{
        {"positivos", 2, 3, 5},
        {"con cero", 0, 5, 5},
        {"negativos", -2, -3, -5},
        {"mixto", -2, 5, 3},
    }

    for _, c := range casos {
        t.Run(c.nombre, func(t *testing.T) {
            resultado := Sumar(c.a, c.b)
            if resultado != c.esperado {
                t.Errorf("Sumar(%d, %d) = %d; se esperaba %d", c.a, c.b, resultado, c.esperado)
            }
        })
    }
}
```

`t.Run` crea un **subtest** con nombre propio, que se muestra individualmente en la salida (`go test -v`) y puede ejecutarse de forma aislada con `go test -run TestSumar/negativos`.

#### `t.Error` vs `t.Fatal`

- `t.Error` / `t.Errorf`: marca el test como fallido, pero **continúa** ejecutando el resto del test.
- `t.Fatal` / `t.Fatalf`: marca el test como fallido y **detiene inmediatamente** esa función de test (útil cuando un paso posterior no tiene sentido si el anterior falló, por ejemplo, si `err != nil`).

```go
func TestLeerArchivo(t *testing.T) {
    contenido, err := leerArchivo("datos.txt")
    if err != nil {
        t.Fatalf("no se pudo leer el archivo: %v", err) // detiene el test aquí
    }
    if len(contenido) == 0 {
        t.Error("el contenido no debería estar vacío")
    }
}
```

#### Cobertura de código

```bash
go test -cover ./...                 # muestra el % de cobertura
go test -coverprofile=cover.out ./... # genera un reporte
go tool cover -html=cover.out         # abre el reporte en el navegador
```

#### Benchmarks (introducción)

Los benchmarks miden el rendimiento de una función. La función debe empezar con `Benchmark` y recibir `*testing.B`:

```go
func BenchmarkSumar(b *testing.B) {
    for i := 0; i < b.N; i++ {
        Sumar(2, 3)
    }
}
```

Ejecutar benchmarks:

```bash
go test -bench=.
```

`b.N` es ajustado automáticamente por el framework de testing hasta obtener una medición estable.

### Probando código que produce salida (`os.Stdout`)

Cuando una función imprime directamente con `fmt.Println` en lugar de retornar un valor, se puede "capturar" la salida estándar redirigiéndola temporalmente a un pipe, como viste en los ejercicios del nivel 1:

```go
func TestMain(t *testing.T) {
    originalStdout := os.Stdout
    r, w, _ := os.Pipe()
    os.Stdout = w

    main()

    w.Close()
    os.Stdout = originalStdout

    var buf bytes.Buffer
    io.Copy(&buf, r)
    salida := buf.String()

    if !strings.Contains(salida, "esperado") {
        t.Error("la salida no contiene el texto esperado")
    }
}
```

Este patrón es útil para programas CLI sencillos, aunque para código de producción es preferible que las funciones retornen valores (o escriban a un `io.Writer` inyectado) en lugar de imprimir directamente, ya que resulta mucho más fácil de probar.

## Ejemplo de código completo

```go
package main

import (
    "errors"
    "fmt"
)

var ErrSaldoInsuficiente = errors.New("saldo insuficiente")

type Cuenta struct {
    Titular string
    Saldo   float64
}

func (c *Cuenta) Retirar(monto float64) error {
    if monto > c.Saldo {
        return fmt.Errorf("no se pudo retirar %.2f de la cuenta de %s: %w", monto, c.Titular, ErrSaldoInsuficiente)
    }
    c.Saldo -= monto
    return nil
}

func procesarRetiroSeguro(c *Cuenta, monto float64) (err error) {
    defer func() {
        if r := recover(); r != nil {
            err = fmt.Errorf("panic recuperado durante el retiro: %v", r)
        }
    }()

    if monto < 0 {
        panic("el monto no puede ser negativo") // caso realmente excepcional
    }
    return c.Retirar(monto)
}

func main() {
    cuenta := &Cuenta{Titular: "Ana", Saldo: 100}

    if err := procesarRetiroSeguro(cuenta, 150); err != nil {
        if errors.Is(err, ErrSaldoInsuficiente) {
            fmt.Println("Fondos insuficientes:", err)
        } else {
            fmt.Println("Error inesperado:", err)
        }
    }

    if err := procesarRetiroSeguro(cuenta, -10); err != nil {
        fmt.Println("Error controlado:", err)
    }

    fmt.Println("Saldo final:", cuenta.Saldo)
}
```

## Ejercicios relacionados

- [Nivel 5: Experto](./ejercicios/nivel-05-experto/) — proyectos integradores que combinan manejo de errores robusto y suites de tests completas.

## Errores comunes

| Error | Solución |
|-------|----------|
| Ignorar el valor de `err` (`_ = err` sin revisar) | Siempre comprueba `if err != nil` antes de continuar |
| Usar `panic` para errores esperables (entrada inválida, archivo no encontrado) | Retorna un `error` en su lugar; reserva `panic` para estados verdaderamente irrecuperables |
| `recover()` fuera de una función diferida | `recover()` solo tiene efecto dentro de un `defer` |
| Comparar errores envueltos con `==` | Usa `errors.Is` para comparar, ya que `%w` cambia la identidad superficial del error |
| Tests que no usan `t.Run` para casos múltiples | Usa table-driven tests con subtests para mejor organización y reportes claros |

## Recursos

- [Effective Go — Errors](https://go.dev/doc/effective_go#errors)
- [Go Blog — Error handling and Go](https://go.dev/blog/error-handling-and-go)
- [Go Blog — Working with Errors in Go 1.13](https://go.dev/blog/go1.13-errors)
- [Package testing documentation](https://pkg.go.dev/testing)
- [Go by Example — Testing](https://gobyexample.com/testing-and-benchmarking)