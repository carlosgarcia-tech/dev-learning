# Ejercicio 05 — Arrays Básicos

- **Nivel:** 1/5
- **Tema:** Fundamentos de Ruby
- **Tiempo estimado:** 20 minutos

## Enunciado

Define un array de 5 números. Crea un array de números pares y otro de números mayores a 10. Muestra todo y la suma total.

## Requisitos

- [ ] El programa se ejecuta sin errores
- [ ] La lógica pedida en el enunciado está implementada
- [ ] Los tests pasan: `ruby test_main.rb`

## Solución

<details>
<summary>Mostrar solución</summary>

```ruby
numeros = [5, 12, 3, 18, 7]

pares = numeros.select { |n| n.even? }
mayores = numeros.select { |n| n > 10 }
suma = numeros.reduce(:+)

puts "Array: #{numeros}"
puts "Pares: #{pares}"
puts "Mayores a 10: #{mayores}"
puts "Suma: #{suma}"
```

</details>
