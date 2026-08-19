# Ejercicio 03 — Operadores y Condicionales

- **Nivel:** 1/5
- **Tema:** Fundamentos de Ruby
- **Tiempo estimado:** 20 minutos

## Enunciado

Solicita un número al usuario y determina:
- Si es positivo, negativo o cero
- Si es par o impar
- Si es múltiplo de 3

## Requisitos

- [ ] El programa se ejecuta sin errores
- [ ] La lógica pedida en el enunciado está implementada
- [ ] Los tests pasan: `ruby test_main.rb`

## Solución

<details>
<summary>Mostrar solución</summary>

```ruby
print "Ingresa un número: "
numero = gets.to_i

if numero > 0
  puts "Positivo"
elsif numero < 0
  puts "Negativo"
else
  puts "Cero"
end

if numero.even?
  puts "Par"
else
  puts "Impar"
end

if numero % 3 == 0
  puts "Múltiplo de 3"
else
  puts "No es múltiplo de 3"
end
```

</details>
