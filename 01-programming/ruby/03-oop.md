# 03 — Programación Orientada a Objetos en Ruby

## Objetivos

- [ ] Entender la filosofía OOP de Ruby
- [ ] Crear clases con atributos y métodos
- [ ] Usar getters y setters
- [ ] Implementar constructores y métodos de clase
- [ ] Entender la herencia y el polimorfismo
- [ ] Usar la sobrecarga de operadores
- [ ] Trabajar con módulos (mixins)

## Apuntes

### Clases y Objetos

```ruby
# Definición de clase
class Persona
  # Atributos con getter y setter
  attr_accessor :nombre, :edad
  attr_reader :id
  attr_writer :password

  # Variable de clase
  @@contador = 0

  # Constructor
  def initialize(nombre, edad)
    @nombre = nombre
    @edad = edad
    @id = @@contador += 1
  end

  # Método de instancia
  def saludar
    puts "Hola, soy #{@nombre} y tengo #{@edad} años"
  end

  # Método de clase
  def self.contador
    @@contador
  end

  # Sobrescribir to_s
  def to_s
    "Persona: #{@nombre} (#{@edad})"
  end
end

# Uso
persona = Persona.new("Ana", 30)
persona.nombre = "Ana María"
persona.edad = 31
puts persona.nombre  # "Ana María"
puts persona.id      # 1
persona.saludar
puts Persona.contador # 1
```

### Herencia

```ruby
class Animal
  attr_accessor :nombre, :edad

  def initialize(nombre, edad)
    @nombre = nombre
    @edad = edad
  end

  def hacer_sonido
    puts "El animal hace un sonido"
  end

  def to_s
    "#{@nombre} (#{@edad} años)"
  end
end

class Perro < Animal
  attr_accessor :raza

  def initialize(nombre, edad, raza)
    super(nombre, edad)
    @raza = raza
  end

  # Sobrescritura de método
  def hacer_sonido
    puts "#{@nombre}: ¡Guau!"
  end

  # Método específico
  def ladrar
    puts "¡Guau, guau, guau!"
  end
end

class Gato < Animal
  def hacer_sonido
    puts "#{@nombre}: ¡Miau!"
  end
end

# Uso
perro = Perro.new("Rex", 3, "Labrador")
perro.hacer_sonido  # Rex: ¡Guau!
puts perro.raza      # Labrador
```

### Módulos (Mixins)

```ruby
# Definición de módulo
module Volador
  def volar
    puts "#{self.class} está volando"
  end
end

module Nadador
  def nadar
    puts "#{self.class} está nadando"
  end
end

# Incluir módulos
class Pato
  include Volador
  include Nadador

  def hacer_sonido
    puts "¡Cuac!"
  end
end

class Avion
  include Volador
end

# Uso
pato = Pato.new
pato.volar   # Pato está volando
pato.nadar   # Pato está nadando

avion = Avion.new
avion.volar  # Avion está volando
```

### Polimorfismo

```ruby
class Circulo
  def area
    puts "Área del círculo"
  end
end

class Rectangulo
  def area
    puts "Área del rectángulo"
  end
end

def calcular_area(figura)
  figura.area
end

circulo = Circulo.new
rectangulo = Rectangulo.new

calcular_area(circulo)    # Área del círculo
calcular_area(rectangulo) # Área del rectángulo
```

### Sobrecarga de Operadores

```ruby
class Vector
  attr_accessor :x, :y

  def initialize(x, y)
    @x = x
    @y = y
  end

  # Sobrecarga de +
  def +(other)
    Vector.new(@x + other.x, @y + other.y)
  end

  # Sobrecarga de -
  def -(other)
    Vector.new(@x - other.x, @y - other.y)
  end

  # Sobrecarga de *
  def *(escalar)
    Vector.new(@x * escalar, @y * escalar)
  end

  # Sobrecarga de ==
  def ==(other)
    @x == other.x && @y == other.y
  end

  def to_s
    "(#{@x}, #{@y})"
  end
end

v1 = Vector.new(1, 2)
v2 = Vector.new(3, 4)
v3 = v1 + v2  # (4, 6)
v4 = v1 * 3   # (3, 6)
puts v3, v4
```

### Métodos de Clase y Singleton

```ruby
class Configuracion
  # Método de clase
  def self.cargar
    puts "Cargando configuración..."
  end

  # Método singleton (forma alternativa de definir métodos de clase)
  class << self
    def guardar
      puts "Guardando configuración..."
    end
  end
end

Configuracion.cargar
Configuracion.guardar

# Método singleton en una instancia específica
objeto = "Hola"
def objeto.saludar
  puts "Saludando desde un objeto"
end
objeto.saludar
```

### Atributos y Accesores

```ruby
class Usuario
  # Acceso automático
  attr_accessor :nombre    # getter y setter
  attr_reader :id          # solo getter
  attr_writer :password    # solo setter

  def initialize(nombre)
    @nombre = nombre
    @id = rand(1000)
  end
end

usuario = Usuario.new("Ana")
usuario.nombre = "Ana María"
puts usuario.nombre  # "Ana María"
puts usuario.id
usuario.password = "secreto"
```

## Ejercicios Relacionados

- [Ejercicio 11: Clases Básicas](./ejercicios/nivel-02-basico/ejercicio-05-clases-basicas/)
- [Ejercicio 13: Herencia](./ejercicios/nivel-03-intermedio/ejercicio-01-herencia/)
- [Ejercicio 14: Mixins y Módulos](./ejercicios/nivel-03-intermedio/ejercicio-02-mixins-y-modulos/)
- [Ejercicio 17: Attributes](./ejercicios/nivel-03-intermedio/ejercicio-05-attributes/)
