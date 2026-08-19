# Ejercicio 19 — File I/O

- **Nivel:** 4/5
- **Tema:** Avanzado de Ruby
- **Tiempo estimado:** 30 minutos

## Enunciado

1. Escribe un array de números en un archivo
2. Lee el archivo y calcula la suma
3. Maneja errores de archivo

## Requisitos

- [ ] El programa se ejecuta sin errores
- [ ] La lógica pedida en el enunciado está implementada
- [ ] Los tests pasan: `ruby test_main.rb`

## Solución

<details>
<summary>Mostrar solución</summary>

```ruby
numeros = [1, 2, 3, 4, 5]

# Escribir archivo
File.open("numeros.txt", "w") do |file|
  numeros.each { |n| file.puts n }
end

# Leer archivo
begin
  numeros_leidos = File.readlines("numeros.txt").map(&:to_i)
  puts "Suma: #{numeros_leidos.reduce(:+)}"
rescue Errno::ENOENT
  puts "Archivo no encontrado"
end

# Eliminar archivo
File.delete("numeros.txt") if File.exist?("numeros.txt")
```

</details>
