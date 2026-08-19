# Ejercicio 25 — Gestor de Tareas CLI

- **Nivel:** 5/5
- **Tema:** Experto en Ruby
- **Tiempo estimado:** 60 minutos

## Enunciado

Desarrolla una aplicación CLI para gestionar tareas:
- Agregar tarea
- Listar tareas
- Marcar completada
- Eliminar tarea

## Requisitos

- [ ] El programa se ejecuta sin errores
- [ ] La lógica pedida en el enunciado está implementada
- [ ] Los tests pasan: `ruby test_main.rb`

## Solución

<details>
<summary>Mostrar solución</summary>

```ruby
class Tarea
  attr_accessor :id, :descripcion, :completada

  def initialize(id, descripcion)
    @id = id
    @descripcion = descripcion
    @completada = false
  end

  def completar
    @completada = true
  end

  def to_s
    estado = @completada ? "[x]" : "[ ]"
    "#{estado} #{id}: #{descripcion}"
  end
end

class GestorTareas
  def initialize
    @tareas = []
    @contador = 0
  end

  def agregar(descripcion)
    @contador += 1
    @tareas << Tarea.new(@contador, descripcion)
    puts "Tarea agregada"
  end

  def listar
    if @tareas.empty?
      puts "No hay tareas"
      return
    end
    @tareas.each { |t| puts t }
  end

  def completar(id)
    tarea = @tareas.find { |t| t.id == id }
    if tarea
      tarea.completar
      puts "Tarea completada"
    else
      puts "Tarea no encontrada"
    end
  end

  def eliminar(id)
    tarea = @tareas.find { |t| t.id == id }
    if tarea
      @tareas.delete(tarea)
      puts "Tarea eliminada"
    else
      puts "Tarea no encontrada"
    end
  end
end

if __FILE__ == $0
  gestor = GestorTareas.new
  loop do
    puts "\n=== Gestor de Tareas ==="
    puts "1. Agregar tarea"
    puts "2. Listar tareas"
    puts "3. Completar tarea"
    puts "4. Eliminar tarea"
    puts "5. Salir"
    print "Elige: "

    opcion = gets.to_i
    case opcion
    when 1
      print "Descripción: "
      desc = gets.chomp
      gestor.agregar(desc)
    when 2
      gestor.listar
    when 3
      print "ID de tarea: "
      id = gets.to_i
      gestor.completar(id)
    when 4
      print "ID de tarea: "
      id = gets.to_i
      gestor.eliminar(id)
    when 5
      puts "¡Adiós!"
      break
    end
  end
end
```

</details>
