# Ejercicio 06 — Hashes

- **Nivel:** 1/5
- **Tema:** Fundamentos de Ruby
- **Tiempo estimado:** 20 minutos

## Enunciado

Crea un hash con 5 personas (nombre: edad). Muestra:
- Todas las personas con sus edades
- Edad promedio
- Persona más joven y más mayor

## Requisitos

- [ ] El programa se ejecuta sin errores
- [ ] La lógica pedida en el enunciado está implementada
- [ ] Los tests pasan: `ruby test_main.rb`

## Solución

<details>
<summary>Mostrar solución</summary>

```ruby
personas = {
  "Ana" => 25,
  "Juan" => 30,
  "María" => 22,
  "Carlos" => 35,
  "Luis" => 28
}

puts "Lista de personas:"
personas.each { |nombre, edad| puts "#{nombre}: #{edad} años" }

promedio = personas.values.reduce(:+).to_f / personas.size
puts "Edad promedio: #{promedio.round(2)} años"

mas_joven = personas.min_by { |_, edad| edad }
mas_mayor = personas.max_by { |_, edad| edad }

puts "Persona más joven: #{mas_joven[0]} (#{mas_joven[1]} años)"
puts "Persona más mayor: #{mas_mayor[0]} (#{mas_mayor[1]} años)"
```

</details>
