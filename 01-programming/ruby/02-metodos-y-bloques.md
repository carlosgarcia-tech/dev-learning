# 02 — Métodos y Bloques en Ruby

## Objetivos

- [ ] Entender los métodos en Ruby (definición, parámetros, retorno)
- [ ] Usar bloques y sus diferentes sintaxis
- [ ] Trabajar con Procs y Lambdas
- [ ] Entender la diferencia entre Proc y Lambda
- [ ] Usar yield para llamar bloques
- [ ] Implementar iteradores personalizados

## Apuntes

### Métodos Avanzados

```ruby
# Método con parámetros opcionales
def saludar(nombre, saludo = "Hola")
  puts "#{saludo}, #{nombre}"
end

# Método con parámetros por defecto (hash)
def configurar(opciones = {})
  url = opciones[:url] || "localhost"
  port = opciones[:port] || 3000
  puts "URL: #{url}, Port: #{port}"
end

# Método con parámetros nombrados
def configurar_2(url: "localhost", port: 3000)
  puts "URL: #{url}, Port: #{port}"
end

# Método con splat (*) - parámetros variables
def sumar_todos(*numeros)
  numeros.reduce(0, :+)
end

# Método con doble splat (**) - hash variable
def procesar_opciones(**opciones)
  opciones.each { |k, v| puts "#{k}: #{v}" }
end

# Método con bloque implícito (yield)
def ejecutar_bloque
  puts "Antes del bloque"
  yield if block_given?
  puts "Después del bloque"
end

# Método con bloque explícito (&)
def ejecutar_bloque_explicito(&bloque)
  puts "Antes"
  bloque.call if bloque
  puts "Después"
end

# Método con retorno temprano
def dividir(a, b)
  return nil, "División por cero" if b == 0
  return a / b, nil
end
```

### Bloques

```ruby
# Sintaxis con do-end (bloque de múltiples líneas)
[1, 2, 3].each do |numero|
  puts numero * 2
end

# Sintaxis con {} (una sola línea)
[1, 2, 3].each { |numero| puts numero * 2 }

# Bloque con parámetros
(1..5).each_with_index do |numero, indice|
  puts "Índice #{indice}: #{numero}"
end

# Bloque con yield
def mi_metodo
  puts "Inicio"
  yield("Ana") if block_given?
  puts "Fin"
end

mi_metodo { |nombre| puts "Hola, #{nombre}" }

# Bloque como objeto
bloque = Proc.new { |x| x * 2 }
[1, 2, 3].map(&bloque)  # [2, 4, 6]

# Bloque con & en métodos
def mi_metodo_2(&bloque)
  bloque.call if bloque
end

mi_metodo_2 { puts "Hola" }
```

### Procs

```ruby
# Crear un Proc
proc1 = Proc.new { |x| x * 2 }
proc2 = proc { |x| x * 2 }
proc3 = lambda { |x| x * 2 }

# Llamar a un Proc
proc1.call(5)    # 10
proc1[5]         # 10
proc1.(5)        # 10
proc1.call(5)    # 10 (equivalente a proc1 === 5, útil en `case`)

# Proc con múltiples parámetros
suma_proc = Proc.new { |a, b| a + b }
suma_proc.call(3, 5)   # 8
suma_proc.call(3, 5, 7) # 8 (ignora el tercero)

# Lambda (más estricta)
suma_lambda = lambda { |a, b| a + b }
suma_lambda.call(3, 5)   # 8
# suma_lambda.call(3, 5, 7) # Error: wrong number of arguments
```

### Diferencias entre Proc y Lambda

```ruby
# 1. Argumentos
mi_proc = Proc.new { |x, y| [x, y] }
mi_proc.call(1)  # [1, nil] (permite menos argumentos)

mi_lambda = lambda { |x, y| [x, y] }
mi_lambda.call(1, 2)  # [1, 2]
# mi_lambda.call(1)   # Error: wrong number of arguments

# 2. Return
def proc_return
  mi_proc = Proc.new { return "Proc return" }
  mi_proc.call
  "Después del proc"
end

def lambda_return
  mi_lambda = lambda { return "Lambda return" }
  mi_lambda.call
  "Después del lambda"
end

proc_return    # "Proc return" (el return del Proc termina el método)
lambda_return  # "Después del lambda" (el return del lambda solo sale del lambda)

# 3. Uso con & en métodos
def ejecutar(&bloque)
  bloque.call
end

ejecutar { puts "Hola" }
```

> **Nota:** en el ejemplo anterior se evitó usar `proc` y `lambda` como nombres de variable porque son palabras clave/métodos de Kernel; usar esos nombres como variables puede generar confusiones sutiles.

### Iteradores Personalizados

```ruby
# Iterador simple
class Numeros
  def initialize(*numeros)
    @numeros = numeros
  end

  # Iterador que usa yield
  def cada_uno
    @numeros.each do |numero|
      yield numero if block_given?
    end
  end

  # Método que retorna solo los pares
  def pares
    @numeros.select { |n| n.even? }
  end

  # Iterador con bloque y enumerador
  def cada_par
    return enum_for(:cada_par) unless block_given?
    @numeros.each do |numero|
      yield numero if numero.even?
    end
  end
end

numeros = Numeros.new(1, 2, 3, 4, 5, 6)
numeros.cada_uno { |n| puts n }
numeros.cada_par { |n| puts n }

# Enumerador (cuando no se pasa bloque)
enumerador = numeros.cada_par
puts enumerador.class  # Enumerator
puts enumerador.to_a   # [2, 4, 6]
```

## Ejercicios Relacionados

- [Ejercicio 07: Métodos](./ejercicios/nivel-02-basico/ejercicio-01-metodos/)
- [Ejercicio 08: Bloques y Procs](./ejercicios/nivel-02-basico/ejercicio-02-bloques-y-procs/)
- [Ejercicio 09: Iteradores](./ejercicios/nivel-02-basico/ejercicio-03-iteradores/)
- [Ejercicio 16: Lambdas](./ejercicios/nivel-03-intermedio/ejercicio-04-lambdas/)
