# 04 — Módulos y Mixins en Ruby

## Objetivos

- [ ] Entender los módulos y su propósito
- [ ] Usar mixins para compartir comportamiento
- [ ] Implementar el módulo Enumerable
- [ ] Trabajar con módulos de namespacing
- [ ] Usar refinements para modificar clases

## Apuntes

### Módulos como Mixins

```ruby
module Utils
  def formatear_fecha(fecha)
    fecha.strftime("%d/%m/%Y")
  end

  def capitalizar_nombre(nombre)
    nombre.split.map(&:capitalize).join(" ")
  end
end

class Persona
  include Utils

  def initialize(nombre, fecha_nacimiento)
    @nombre = nombre
    @fecha_nacimiento = fecha_nacimiento
  end

  def mostrar_info
    puts "Nombre: #{capitalizar_nombre(@nombre)}"
    puts "Fecha: #{formatear_fecha(@fecha_nacimiento)}"
  end
end
```

### Módulo Enumerable

```ruby
class Coleccion
  include Enumerable

  def initialize(*elementos)
    @elementos = elementos
  end

  def each
    @elementos.each { |e| yield(e) }
  end
end

coleccion = Coleccion.new(1, 2, 3, 4, 5)

# Métodos de Enumerable, disponibles gracias a `each`
coleccion.map { |x| x * 2 }        # [2, 4, 6, 8, 10]
coleccion.select { |x| x.even? }   # [2, 4]
coleccion.reduce(:+)               # 15
coleccion.any? { |x| x > 5 }       # false
coleccion.all? { |x| x > 0 }       # true
```

### Módulo Comparable

```ruby
class Persona
  include Comparable

  attr_reader :nombre, :edad

  def initialize(nombre, edad)
    @nombre = nombre
    @edad = edad
  end

  def <=>(other)
    @edad <=> other.edad
  end
end

ana = Persona.new("Ana", 25)
juan = Persona.new("Juan", 30)

ana < juan   # true
ana > juan   # false
ana == juan  # false
```

### Módulos Namespacing

```ruby
module MiEmpresa
  class Empleado
    attr_reader :nombre

    def initialize(nombre)
      @nombre = nombre
    end
  end

  class Departamento
    attr_reader :nombre, :empleados

    def initialize(nombre)
      @nombre = nombre
      @empleados = []
    end

    def agregar_empleado(empleado)
      @empleados << empleado
    end
  end
end

empleado = MiEmpresa::Empleado.new("Ana")
departamento = MiEmpresa::Departamento.new("IT")
departamento.agregar_empleado(empleado)
```

### Refinements

```ruby
# Definir refinamiento
module StringRefinements
  refine String do
    def a_camel_case
      split.map(&:capitalize).join
    end

    def a_snake_case
      gsub(/([A-Z])/, '_\1').downcase
    end
  end
end

# Usar refinamiento (solo dentro del ámbito donde se activa con `using`)
using StringRefinements

class Procesador
  def procesar(texto)
    texto.a_camel_case
  end
end
```

### Módulos de Clase (extend)

```ruby
module FactoryMethods
  def crear_nuevo(attr)
    new(attr)
  end
end

class Producto
  extend FactoryMethods

  attr_reader :nombre

  def initialize(nombre)
    @nombre = nombre
  end
end

producto = Producto.crear_nuevo("Laptop")
```

> **`include` vs `extend`:** `include` agrega los métodos del módulo como métodos de **instancia**; `extend` los agrega como métodos de **clase** (o de un objeto específico).

## Ejercicios Relacionados

- [Ejercicio 14: Mixins y Módulos](./ejercicios/nivel-03-intermedio/ejercicio-02-mixins-y-modulos/)
- [Ejercicio 15: Enumerable](./ejercicios/nivel-03-intermedio/ejercicio-03-enumerable/)
- [Ejercicio 18: Refinements](./ejercicios/nivel-03-intermedio/ejercicio-06-refinements/)
