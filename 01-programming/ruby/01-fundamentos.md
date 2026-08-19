# 01 — Fundamentos de Ruby

## Objetivos

- [ ] Entender qué es Ruby y su filosofía
- [ ] Instalar y configurar Ruby
- [ ] Conocer la estructura de un programa Ruby
- [ ] Usar variables, constantes y tipos de datos
- [ ] Entender la naturaleza dinámica de Ruby
- [ ] Usar operadores y estructuras de control
- [ ] Crear y usar métodos
- [ ] Manejar entrada/salida básica

## Apuntes

### ¿Qué es Ruby?

Ruby es un lenguaje de programación dinámico, reflexivo y orientado a objetos, creado por Yukihiro Matsumoto (Matz) en 1995. Su filosofía principal es **"el programador es el rey"**, priorizando la productividad y la felicidad del desarrollador.

**Características principales:**
- **Orientado a objetos**: Todo en Ruby es un objeto (incluso los números)
- **Dinámico**: No hay compilación, el código se ejecuta directamente
- **Flexible**: Permite modificar clases en tiempo de ejecución
- **Expresivo**: Código que parece lenguaje natural
- **Garbage Collection**: Gestión automática de memoria
- **Ecosistema**: Ruby on Rails (el framework web más popular)

### Instalación

```bash
# Linux/macOS con rbenv
rbenv install 3.2.2
rbenv global 3.2.2

# Verificar
ruby --version
irb # REPL interactivo
```

### Estructura de un programa Ruby

```ruby
# Comentario de línea

=begin
Comentario de bloque
Multi-línea
=end

# 1. Definición de clases y módulos
class Persona
  # Atributos y métodos
end

# 2. Métodos a nivel de objeto
def saludar
  puts "¡Hola!"
end

# 3. Programa principal
if __FILE__ == $0
  saludar
end
```

### Variables y Tipos de Datos

```ruby
# Variables (snake_case)
nombre = "Ana"           # String
edad = 30               # Integer
altura = 1.75           # Float
es_estudiante = true    # Boolean
valor_nulo = nil        # NilClass

# Constantes (UPPER_SNAKE_CASE)
PI = 3.14159
IVA = 0.21

# Símbolos (inmutables, usados como identificadores)
:nombre
:edad
:activar

# Variables de clase (@@)
@@contador = 0

# Variables de instancia (@)
@nombre = "Ana"

# Variables globales ($)
$config = "produccion"

# Variables locales
resultado = "Hola" + " Mundo"
```

### Tipos de datos principales

```ruby
# String - Cadena de texto
nombre = "Ana"
mensaje = 'Hola'
texto = %Q{String con interpolación #{nombre}}
texto_literal = %q{String literal}

# Integer - Números enteros
edad = 30
hex = 0xFF     # 255
bin = 0b1010   # 10
oct = 0o755    # 493

# Float - Números decimales
precio = 19.99
cientifico = 1.5e-10

# Boolean - true/false
verdadero = true
falso = false

# Nil - Ausencia de valor
nada = nil

# Symbol - Identificador inmutable
estado = :activo

# Array - Lista de elementos
numeros = [1, 2, 3, 4, 5]
mixto = [1, "dos", :tres, true]

# Hash - Diccionario clave-valor
persona = { nombre: "Ana", edad: 30 }
persona2 = { "nombre" => "Ana", "edad" => 30 }

# Range - Rango de valores
rango = 1..10           # Inclusive
rango_exclusivo = 1...10 # Exclusivo (1-9)
```

### Entrada y Salida

```ruby
# Salida
puts "Mensaje con salto de línea"
print "Mensaje sin salto de línea"
printf "Formateado: %s tiene %d años", "Ana", 30

# Interpolación
nombre = "Ana"
puts "Hola, #{nombre}!"

# Entrada
print "Ingresa tu nombre: "
nombre = gets.chomp  # Elimina salto de línea

print "Ingresa tu edad: "
edad = gets.to_i     # Convierte a entero
```

### Operadores

```ruby
# Aritméticos
suma = 10 + 3        # 13
resta = 10 - 3       # 7
multiplicacion = 10 * 3  # 30
division = 10 / 3    # 3 (división entera)
modulo = 10 % 3      # 1
potencia = 2 ** 3    # 8

# Comparación
igual = 10 == 10     # true
diferente = 10 != 5  # true
mayor = 10 > 5       # true
menor = 10 < 5       # false
mayor_igual = 10 >= 10 # true
menor_igual = 10 <= 5 # false

# Lógicos
verdadero = true && true  # true
falso = true && false     # false
verdadero = true || false # true
falso = !true            # false

# Comparación en espacios (spaceship)
1 <=> 2  # -1
2 <=> 2  # 0
3 <=> 2  # 1

# Rangos
(1..5).include?(3)  # true
(1...5).include?(5) # false
```

### Estructuras de Control

```ruby
# if-else
edad = 25
if edad >= 18
  puts "Mayor de edad"
elsif edad >= 16
  puts "Casi mayor de edad"
else
  puts "Menor de edad"
end

# if en una línea
puts "Mayor" if edad >= 18

# unless (lo opuesto a if)
unless edad < 18
  puts "Mayor de edad"
end

# case (switch)
dia = 3
case dia
when 1
  puts "Lunes"
when 2
  puts "Martes"
when 3
  puts "Miércoles"
else
  puts "Otro día"
end

# Operador ternario
mensaje = edad >= 18 ? "Mayor" : "Menor"
```

### Bucles

```ruby
# while
contador = 0
while contador < 10
  puts contador
  contador += 1
end

# until (lo opuesto a while)
contador = 0
until contador >= 10
  puts contador
  contador += 1
end

# for
for i in 1..10
  puts i
end

# each (recomendado)
(1..10).each do |i|
  puts i
end

[1, 2, 3, 4, 5].each do |numero|
  puts numero * 2
end

# times
10.times do |i|
  puts i
end

# loop
contador = 0
loop do
  break if contador >= 10
  puts contador
  contador += 1
end

# break, next, redo
(1..10).each do |i|
  break if i > 5
  next if i % 2 == 0
  puts i
end
```

### Métodos

```ruby
# Método simple
def saludar
  puts "¡Hola!"
end

# Con parámetros
def sumar(a, b)
  a + b  # El último valor es el retorno
end

# Con valor por defecto
def saludar_personalizado(nombre, saludo = "Hola")
  puts "#{saludo}, #{nombre}"
end

# Con parámetros opcionales
def configurar(url: "localhost", port: 3000)
  puts "URL: #{url}, Puerto: #{port}"
end

# Con parámetros variables (*)
def sumar_todos(*numeros)
  numeros.reduce(0, :+)
end

# Con doble splat (**) para hashes
def procesar_configuracion(**opciones)
  puts opciones.inspect
end

# Método que retorna múltiples valores
def dividir(a, b)
  return nil, "División por cero" if b == 0
  return a / b, nil
end

# Método con predicado (termina en ?)
def mayor_de_edad?(edad)
  edad >= 18
end

# Método con bang (termina en !, modifica objeto)
def ordenar!(array)
  array.sort!
end

# Método de clase
class Persona
  def self.metodo_de_clase
    puts "Método de clase"
  end
end
```

### Arrays y Hashes (Avanzado)

```ruby
# Arrays
numeros = [1, 2, 3, 4, 5]

# Métodos de array
numeros.push(6)     # [1,2,3,4,5,6]
numeros.pop         # 6
numeros.shift       # 1
numeros.unshift(0)  # [0,2,3,4,5]
numeros.include?(3) # true
numeros.size        # 5
numeros.first       # 1
numeros.last        # 5

# Hashes
persona = { nombre: "Ana", edad: 30, ciudad: "Madrid" }

# Métodos de hash
persona[:nombre]       # "Ana"
persona[:profesion] = "Ingeniero"
persona.delete(:edad)  # Elimina edad
persona.keys           # [:nombre, :ciudad, :profesion]
persona.values          # ["Ana", "Madrid", "Ingeniero"]
persona.has_key?(:nombre) # true
persona.has_value?("Ana") # true
persona.merge(edad: 30) # Combina hashes
```

### Strings (Avanzado)

```ruby
texto = "Hola Mundo"

# Métodos de string
texto.length         # 10
texto.upcase         # "HOLA MUNDO"
texto.downcase       # "hola mundo"
texto.capitalize     # "Hola mundo"
texto.reverse        # "odnuM aloH"
texto.include?("Mun") # true
texto.start_with?("Hol") # true
texto.end_with?("ndo") # true
texto.gsub("Mundo", "Ruby") # "Hola Ruby"
texto.split           # ["Hola", "Mundo"]
texto.strip           # Elimina espacios

# Interpolación
nombre = "Ana"
puts "Hola, #{nombre}!"

# Heredoc
mensaje = <<~TEXT
  Este es un mensaje
  de múltiples líneas
  en Ruby.
TEXT
```

### Tipos y Reflexión

```ruby
# Verificar tipo
"hola".class         # String
123.class            # Integer
1.5.class            # Float
true.class           # TrueClass
nil.class            # NilClass

# Verificar herencia
"hola".is_a?(String)   # true
123.is_a?(Numeric)     # true
"hola".is_a?(Object)   # true

# Convertir tipos
"123".to_i           # 123
"12.34".to_f         # 12.34
123.to_s             # "123"
:simbolo.to_s        # "simbolo"
"simbolo".to_sym     # :simbolo
```

### Errores Comunes

| Error | Causa | Solución |
|-------|-------|----------|
| `uninitialized constant` | Constante no definida | Definir la constante o verificar el nombre |
| `undefined method` | Método no existe | Verificar el nombre del método |
| `NameError` | Variable no definida | Definir la variable |
| `TypeError` | Tipo incorrecto | Convertir al tipo adecuado |
| `NoMethodError` | Método no existe para el tipo | Verificar el tipo del objeto |
| `SyntaxError` | Error de sintaxis | Revisar paréntesis, llaves, etc. |

## Ejercicios Relacionados

- [Ejercicio 01: Hola Mundo](./ejercicios/nivel-01-fundamentos/ejercicio-01-hola-mundo/)
- [Ejercicio 02: Variables y Tipos](./ejercicios/nivel-01-fundamentos/ejercicio-02-variables-y-tipos/)
- [Ejercicio 03: Operadores y Condicionales](./ejercicios/nivel-01-fundamentos/ejercicio-03-operadores-y-condicionales/)
- [Ejercicio 04: Bucles](./ejercicios/nivel-01-fundamentos/ejercicio-04-bucles/)
- [Ejercicio 05: Arrays Básicos](./ejercicios/nivel-01-fundamentos/ejercicio-05-arrays-basicos/)
- [Ejercicio 06: Hashes](./ejercicios/nivel-01-fundamentos/ejercicio-06-hashes/)

## Recursos

- [Documentación oficial de Ruby](https://ruby-doc.org/)
- [Ruby Koans](http://rubykoans.com/)
- [Learn Ruby in Y Minutes](https://learnxinyminutes.com/docs/ruby/)
- [Ruby on Rails Guides](https://guides.rubyonrails.org/)
