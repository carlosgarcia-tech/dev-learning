# Ejercicio 30 — Sistema de Archivos

- **Nivel:** 5/5
- **Tema:** Experto en Ruby
- **Tiempo estimado:** 60 minutos

## Enunciado

Implementa un explorador de archivos simple:
- Listar directorios
- Navegar entre carpetas
- Mostrar información de archivos

## Requisitos

- [ ] El programa se ejecuta sin errores
- [ ] La lógica pedida en el enunciado está implementada
- [ ] Los tests pasan: `ruby test_main.rb`

## Solución

<details>
<summary>Mostrar solución</summary>

```ruby
class ExploradorArchivos
  def initialize
    @directorio_actual = Dir.pwd
  end

  def listar
    puts "Directorio: #{@directorio_actual}"
    puts "-" * 50

    entradas = Dir.entries(@directorio_actual).sort
    entradas.each do |entrada|
      next if entrada == "." || entrada == ".."

      path = File.join(@directorio_actual, entrada)
      if File.directory?(path)
        puts "[DIR]  #{entrada}/"
      else
        tamano = File.size(path)
        puts "[FILE] #{entrada} (#{tamano} bytes)"
      end
    end
  end

  def cambiar_directorio(ruta)
    nueva_ruta = File.expand_path(ruta, @directorio_actual)
    if Dir.exist?(nueva_ruta)
      @directorio_actual = nueva_ruta
      true
    else
      false
    end
  end

  def mostrar_info(archivo)
    path = File.join(@directorio_actual, archivo)
    if File.exist?(path)
      puts "Nombre: #{File.basename(path)}"
      puts "Tamaño: #{File.size(path)} bytes"
      puts "Tipo: #{File.directory?(path) ? 'Directorio' : 'Archivo'}"
      puts "Modificado: #{File.mtime(path)}"
      puts "Permisos: #{File.stat(path).mode.to_s(8)}"
    else
      puts "Archivo no encontrado"
    end
  end
end

if __FILE__ == $0
  explorador = ExploradorArchivos.new
  loop do
    explorador.listar
    print "\nComando (cd, info, salir): "
    comando = gets.chomp.split

    case comando[0]
    when "cd"
      if comando[1]
        if explorador.cambiar_directorio(comando[1])
          puts "Cambiado a #{comando[1]}"
        else
          puts "Directorio no encontrado"
        end
      end
    when "info"
      explorador.mostrar_info(comando[1]) if comando[1]
    when "salir"
      break
    end
  end
end
```

</details>
