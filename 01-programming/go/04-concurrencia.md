# 04 — Concurrencia

## Objetivos

- [ ] Entender la diferencia entre concurrencia y paralelismo
- [ ] Crear y usar goroutines con `go`
- [ ] Comunicar goroutines mediante channels
- [ ] Usar channels con buffer y sin buffer
- [ ] Usar `select` para trabajar con múltiples channels
- [ ] Sincronizar goroutines con `sync.WaitGroup` y `sync.Mutex`
- [ ] Reconocer y evitar condiciones de carrera (*race conditions*) y *deadlocks*
- [ ] Aplicar patrones comunes: worker pool y pipeline
- [ ] Conocer el paquete `context` para cancelación y timeouts

## Apuntes

### Concurrencia vs paralelismo

- **Concurrencia**: estructurar un programa como varias tareas que progresan de forma independiente, aunque no necesariamente al mismo tiempo físico. Es sobre *diseño*.
- **Paralelismo**: ejecutar varias tareas literalmente al mismo tiempo, usando varios núcleos de CPU. Es sobre *ejecución*.

Go está diseñado para hacer la concurrencia simple; el runtime de Go decide cómo repartir las goroutines entre los núcleos disponibles, lo que a menudo también produce paralelismo real.

### Goroutines

Una goroutine es una función que se ejecuta de forma concurrente con el resto del programa. Crearla es tan simple como anteponer `go` a una llamada de función:

```go
func saludar(nombre string) {
    fmt.Println("Hola,", nombre)
}

func main() {
    go saludar("Ana")     // se ejecuta en una goroutine aparte
    go saludar("Luis")    // otra goroutine

    time.Sleep(time.Second) // esperar (de forma tosca) a que terminen
    fmt.Println("Fin del programa")
}
```

**Importante**: `main()` no espera automáticamente a que las goroutines terminen. Si `main()` acaba, el programa termina, sin importar si hay goroutines a medias. `time.Sleep` es una forma frágil de sincronizar; en la práctica se usan `sync.WaitGroup` o channels (ver abajo).

Las goroutines son muy baratas comparadas con hilos del sistema operativo: se pueden crear miles o millones sin agotar los recursos, porque Go las multiplexa sobre un número reducido de hilos reales.

### Channels

Un channel es un canal de comunicación tipado entre goroutines. Permiten enviar y recibir valores de forma segura, sin necesidad de bloqueos manuales (mutex) en la mayoría de los casos.

```go
func main() {
    canal := make(chan string) // channel sin buffer, de tipo string

    go func() {
        canal <- "Hola desde la goroutine" // enviar al channel
    }()

    mensaje := <-canal // recibir del channel (bloquea hasta que llegue algo)
    fmt.Println(mensaje)
}
```

**Channels sin buffer** (`make(chan T)`): el envío bloquea hasta que otra goroutine esté lista para recibir, y viceversa. Esto sincroniza automáticamente ambas goroutines.

**Channels con buffer** (`make(chan T, n)`): permiten enviar hasta `n` valores sin que haya un receptor esperando de inmediato. Solo bloquean cuando el buffer está lleno (al enviar) o vacío (al recibir):

```go
canal := make(chan int, 3)
canal <- 1
canal <- 2
canal <- 3
// canal <- 4 // esto bloquearía: el buffer está lleno

fmt.Println(<-canal) // 1
fmt.Println(<-canal) // 2
```

#### Cerrar channels y `range`

Un channel se puede cerrar con `close(canal)` para indicar que no se enviarán más valores. Los receptores pueden detectarlo:

```go
func generarNumeros(canal chan<- int) {
    for i := 1; i <= 5; i++ {
        canal <- i
    }
    close(canal) // avisamos que no habrá más valores
}

func main() {
    canal := make(chan int)
    go generarNumeros(canal)

    // range sobre un channel recibe valores hasta que se cierre
    for numero := range canal {
        fmt.Println(numero)
    }
}
```

Los tipos `chan<- int` (solo-envío) y `<-chan int` (solo-recepción) son formas de restringir un channel a una sola dirección, útiles en firmas de funciones para mayor claridad y seguridad.

Recibir de un channel cerrado devuelve inmediatamente el valor cero del tipo; para distinguir "canal cerrado" de "valor cero real", se usa la forma con dos valores:

```go
valor, ok := <-canal
if !ok {
    fmt.Println("El canal está cerrado")
}
```

### `select`

`select` permite esperar sobre varios channels a la vez, ejecutando el primer `case` que esté listo:

```go
func main() {
    c1 := make(chan string)
    c2 := make(chan string)

    go func() {
        time.Sleep(1 * time.Second)
        c1 <- "resultado de c1"
    }()
    go func() {
        time.Sleep(2 * time.Second)
        c2 <- "resultado de c2"
    }()

    for i := 0; i < 2; i++ {
        select {
        case msg1 := <-c1:
            fmt.Println("Recibido:", msg1)
        case msg2 := <-c2:
            fmt.Println("Recibido:", msg2)
        }
    }
}
```

`select` también admite un `case default` para no bloquear si ningún channel está listo, y se combina con `time.After(...)` para implementar timeouts:

```go
select {
case msg := <-canal:
    fmt.Println("Mensaje:", msg)
case <-time.After(2 * time.Second):
    fmt.Println("Tiempo de espera agotado")
default:
    fmt.Println("Nada disponible por ahora")
}
```

### Sincronización con `sync.WaitGroup`

`WaitGroup` permite esperar a que un grupo de goroutines termine, sin necesidad de channels:

```go
func main() {
    var wg sync.WaitGroup

    for i := 1; i <= 3; i++ {
        wg.Add(1) // incrementa el contador antes de lanzar la goroutine
        go func(id int) {
            defer wg.Done() // decrementa el contador al terminar
            fmt.Println("Trabajador", id, "procesando...")
        }(i) // pasar i como argumento evita capturar la variable de bucle por referencia
    }

    wg.Wait() // bloquea hasta que el contador llegue a 0
    fmt.Println("Todos los trabajadores terminaron")
}
```

### Condiciones de carrera y `sync.Mutex`

Una **condición de carrera** (*race condition*) ocurre cuando dos o más goroutines acceden a la misma variable al mismo tiempo, y al menos una la modifica, sin ninguna sincronización:

```go
// CÓDIGO CON RACE CONDITION — evitar
contador := 0
var wg sync.WaitGroup

for i := 0; i < 1000; i++ {
    wg.Add(1)
    go func() {
        defer wg.Done()
        contador++ // acceso no sincronizado: resultado impredecible
    }()
}
wg.Wait()
fmt.Println(contador) // probablemente NO sea 1000
```

`sync.Mutex` protege una sección crítica para que solo una goroutine a la vez pueda ejecutarla:

```go
var (
    contador int
    mu       sync.Mutex
    wg       sync.WaitGroup
)

for i := 0; i < 1000; i++ {
    wg.Add(1)
    go func() {
        defer wg.Done()
        mu.Lock()
        contador++
        mu.Unlock()
    }()
}
wg.Wait()
fmt.Println(contador) // ahora sí, siempre 1000
```

**Tip**: Go incluye un detector de condiciones de carrera integrado. Ejecuta tus pruebas o tu programa con `go run -race main.go` o `go test -race ./...` para detectarlas automáticamente.

### Deadlocks comunes

Un *deadlock* ocurre cuando un conjunto de goroutines se bloquean esperándose mutuamente para siempre. Casos típicos:

```go
// Deadlock: nadie recibe de este channel sin buffer
canal := make(chan int)
canal <- 1 // bloquea para siempre: no hay otra goroutine leyendo
```

```go
// Deadlock: WaitGroup mal contado
var wg sync.WaitGroup
wg.Add(2) // se espera 2, pero solo se lanza 1 goroutine
go func() {
    defer wg.Done()
}()
wg.Wait() // espera indefinidamente el segundo Done()
```

Go detecta algunos deadlocks triviales en tiempo de ejecución (`fatal error: all goroutines are asleep - deadlock!`), pero muchos otros solo se manifiestan bajo ciertas condiciones de carga.

### Patrón: Worker Pool

Un grupo fijo de goroutines ("workers") procesa tareas desde un channel compartido, útil para limitar la concurrencia:

```go
func trabajador(id int, trabajos <-chan int, resultados chan<- int) {
    for j := range trabajos {
        fmt.Printf("Trabajador %d procesando trabajo %d\n", id, j)
        resultados <- j * 2
    }
}

func main() {
    trabajos := make(chan int, 100)
    resultados := make(chan int, 100)

    // Lanzar 3 workers
    for w := 1; w <= 3; w++ {
        go trabajador(w, trabajos, resultados)
    }

    // Enviar 5 trabajos
    for j := 1; j <= 5; j++ {
        trabajos <- j
    }
    close(trabajos)

    // Recoger los 5 resultados
    for a := 1; a <= 5; a++ {
        fmt.Println(<-resultados)
    }
}
```

### Patrón: Pipeline

Varias etapas conectadas por channels, donde cada etapa transforma los datos y los pasa a la siguiente:

```go
func generar(nums ...int) <-chan int {
    salida := make(chan int)
    go func() {
        defer close(salida)
        for _, n := range nums {
            salida <- n
        }
    }()
    return salida
}

func elevarAlCuadrado(entrada <-chan int) <-chan int {
    salida := make(chan int)
    go func() {
        defer close(salida)
        for n := range entrada {
            salida <- n * n
        }
    }()
    return salida
}

func main() {
    c := generar(1, 2, 3, 4)
    cuadrados := elevarAlCuadrado(c)

    for resultado := range cuadrados {
        fmt.Println(resultado)
    }
}
```

### Introducción al paquete `context`

`context.Context` se usa para propagar cancelación, timeouts y valores a través de goroutines, muy común en servidores y llamadas de red:

```go
func operacionLarga(ctx context.Context) error {
    select {
    case <-time.After(5 * time.Second):
        fmt.Println("Operación completada")
        return nil
    case <-ctx.Done():
        return ctx.Err() // la operación fue cancelada o expiró
    }
}

func main() {
    ctx, cancel := context.WithTimeout(context.Background(), 2*time.Second)
    defer cancel()

    if err := operacionLarga(ctx); err != nil {
        fmt.Println("Error:", err) // context deadline exceeded
    }
}
```

Profundizarás en `context` cuando construyas servidores HTTP y sistemas más avanzados en el nivel experto.

## Ejemplo de código completo

```go
package main

import (
    "fmt"
    "sync"
)

func trabajador(id int, trabajos <-chan int, resultados chan<- int, wg *sync.WaitGroup) {
    defer wg.Done()
    for t := range trabajos {
        resultados <- t * t
        fmt.Printf("Worker %d procesó %d\n", id, t)
    }
}

func main() {
    trabajos := make(chan int, 10)
    resultados := make(chan int, 10)
    var wg sync.WaitGroup

    // 3 workers concurrentes
    for w := 1; w <= 3; w++ {
        wg.Add(1)
        go trabajador(w, trabajos, resultados, &wg)
    }

    // Enviar trabajos
    for i := 1; i <= 6; i++ {
        trabajos <- i
    }
    close(trabajos)

    // Cerrar resultados cuando todos los workers terminen
    go func() {
        wg.Wait()
        close(resultados)
    }()

    // Consumir resultados
    total := 0
    for r := range resultados {
        total += r
    }
    fmt.Println("Suma total de cuadrados:", total)
}
```

## Ejercicios relacionados

- [Nivel 4: Avanzado](./ejercicios/nivel-04-avanzado/) — ejercicios de goroutines, channels, select, channels con buffer, testing y context.

## Errores comunes

| Error | Solución |
|-------|----------|
| `fatal error: all goroutines are asleep - deadlock!` | Revisa que todo `send` tenga un `receive` correspondiente y que el `WaitGroup` esté bien contado |
| Resultados inconsistentes entre ejecuciones | Probablemente hay una condición de carrera; protege el acceso compartido con `sync.Mutex` o usa channels |
| El programa termina antes de que las goroutines acaben | Usa `sync.WaitGroup` (o channels) en vez de `time.Sleep` para sincronizar |
| `send on closed channel` | Nunca envíes a un channel después de cerrarlo; solo el emisor debe cerrar, nunca el receptor |
| Captura incorrecta de variable de bucle en una goroutine | Pasa la variable como argumento a la función anónima: `go func(v int) {...}(v)` |

## Recursos

- [Tour of Go — Concurrency](https://go.dev/tour/concurrency/1)
- [Effective Go — Concurrency](https://go.dev/doc/effective_go#concurrency)
- [Go by Example — Goroutines](https://gobyexample.com/goroutines)
- [Go by Example — Channels](https://gobyexample.com/channels)
- [Go Memory Model](https://go.dev/ref/mem)
- [Package context documentation](https://pkg.go.dev/context)