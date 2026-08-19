# Ejercicio 04 — Bucles

- **Nivel:** 1/5
- **Tema:** Fundamentos de Ruby
- **Tiempo estimado:** 20 minutos

## Enunciado

Solicita un número `n` y muestra:
- La suma del 1 al n
- El factorial de n
- Los números pares entre 1 y n

## Requisitos

- [ ] El programa se ejecuta sin errores
- [ ] La lógica pedida en el enunciado está implementada
- [ ] Los tests pasan: `ruby test_main.rb`

## Solución

<details>
<summary>Mostrar solución</summary>

```ruby
print "Ingresa un número: "
n = gets.to_i

suma = 0
factorial = 1

(1..n).each do |i|
  suma += i
  factorial *= i
end

puts "Suma: #{suma}"
puts "Factorial: #{factorial}"

print "Pares: "
(2..n).step(2) { |i| print "#{i} " }
puts
```

</details>
