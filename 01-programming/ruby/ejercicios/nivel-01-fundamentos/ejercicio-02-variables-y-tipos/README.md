# Ejercicio 02 — Variables y Tipos

- **Nivel:** 1/5
- **Tema:** Fundamentos de Ruby
- **Tiempo estimado:** 20 minutos

## Enunciado

Declara variables de los tipos: `String`, `Integer`, `Float`, `Boolean`, `Symbol`, `Array`, `Hash`. Asigna valores y muestra todos los datos con sus tipos.

## Requisitos

- [ ] El programa se ejecuta sin errores
- [ ] La lógica pedida en el enunciado está implementada
- [ ] Los tests pasan: `ruby test_main.rb`

## Solución

<details>
<summary>Mostrar solución</summary>

```ruby
nombre = "Ana"
edad = 30
altura = 1.75
es_estudiante = true
estado = :activo
numeros = [1, 2, 3, 4, 5]
persona = { nombre: "Ana", edad: 30 }

puts "Nombre: #{nombre} (#{nombre.class})"
puts "Edad: #{edad} (#{edad.class})"
puts "Altura: #{altura} (#{altura.class})"
puts "Estudiante: #{es_estudiante} (#{es_estudiante.class})"
puts "Estado: #{estado} (#{estado.class})"
puts "Números: #{numeros} (#{numeros.class})"
puts "Persona: #{persona} (#{persona.class})"
```

</details>
